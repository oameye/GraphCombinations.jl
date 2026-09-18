using BenchmarkTools
import GraphCombinations as GC

mutable struct Depth2StabilizerWorkspace
    packed::GC.PackedDirectedCanonicalizationWorkspace
    orbit_parent::Vector{Int}
    target_mask::UInt64
    explored_mask::UInt64
    current_vertex::Int
    best_vertex::Int
    branch_order::Int
    best_stabilizer_order::Int
    orbit_skips::Int
    orbit_merges::Int
    automorphisms::Int
    active::Bool
end

function Depth2StabilizerWorkspace(capacity::Integer)
    n = Int(capacity)
    return Depth2StabilizerWorkspace(
        GC.PackedDirectedCanonicalizationWorkspace(n),
        Vector{Int}(undef, min(n, 64)),
        UInt64(0),
        UInt64(0),
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        false,
    )
end

@inline bit(vertex::Int)::UInt64 = UInt64(1) << (vertex - 1)

@inline function orbit_find(candidate::Depth2StabilizerWorkspace, vertex::Int)::Int
    root = vertex
    @inbounds while candidate.orbit_parent[root] != root
        root = candidate.orbit_parent[root]
    end
    return root
end

function orbit_union!(candidate::Depth2StabilizerWorkspace, left::Int, right::Int)::Nothing
    left_root = orbit_find(candidate, left)
    right_root = orbit_find(candidate, right)
    left_root == right_root && return nothing
    @inbounds candidate.orbit_parent[right_root] = left_root
    candidate.orbit_merges += 1
    return nothing
end

function seed_chosen_twins!(
    candidate::Depth2StabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    chosen_vertex::Int,
    target_mask::UInt64,
)::Nothing
    members = target_mask
    @inbounds while !iszero(members)
        other = trailing_zeros(members) + 1
        members &= members - UInt64(1)
        other > chosen_vertex || continue
        if GC._directed_workspace_exact_twins(graph, chosen_vertex, other)
            orbit_union!(candidate, chosen_vertex, other)
        end
    end
    return nothing
end

function candidate_explored(
    candidate::Depth2StabilizerWorkspace, chosen_vertex::Int
)::Bool
    chosen_root = orbit_find(candidate, chosen_vertex)
    explored = candidate.explored_mask
    @inbounds while !iszero(explored)
        earlier = trailing_zeros(explored) + 1
        if orbit_find(candidate, earlier) == chosen_root
            return true
        end
        explored &= explored - UInt64(1)
    end
    return false
end

function orbit_size(candidate::Depth2StabilizerWorkspace, vertex::Int)::Int
    root = orbit_find(candidate, vertex)
    count = 0
    members = candidate.target_mask
    @inbounds while !iszero(members)
        other = trailing_zeros(members) + 1
        count += orbit_find(candidate, other) == root
        members &= members - UInt64(1)
    end
    return count
end

function record_automorphism!(candidate::Depth2StabilizerWorkspace, n::Int)::Nothing
    packed = candidate.packed
    workspace = packed.workspace
    fixes_root = true

    @inbounds for canonical_vertex in 1:n
        best_vertex = workspace.best_inverse_mapping[canonical_vertex]
        current_vertex = workspace.inverse_mapping[canonical_vertex]

        if !iszero(packed.root_target_mask & bit(best_vertex))
            GC._packed_directed_orbit_union!(packed, best_vertex, current_vertex)
        end

        if best_vertex == packed.root_current_vertex && current_vertex != packed.root_current_vertex
            fixes_root = false
        end
    end
    packed.root_automorphisms += 1

    if candidate.active && fixes_root
        @inbounds for canonical_vertex in 1:n
            best_vertex = workspace.best_inverse_mapping[canonical_vertex]
            current_vertex = workspace.inverse_mapping[canonical_vertex]
            if !iszero(candidate.target_mask & bit(best_vertex)) &&
               !iszero(candidate.target_mask & bit(current_vertex))
                orbit_union!(candidate, best_vertex, current_vertex)
            end
        end
        candidate.automorphisms += 1
    end
    return nothing
end

function record_candidate!(
    candidate::Depth2StabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    multiplicity::Int,
)::Nothing
    packed = candidate.packed
    workspace = packed.workspace
    n = graph.num_vertices

    if !workspace.has_best
        iszero(n) || copyto!(workspace.best_inverse_mapping, 1, workspace.inverse_mapping, 1, n)
        workspace.automorphism_order = multiplicity
        workspace.has_best = true
        if packed.root_orbit_active
            packed.root_best_vertex = packed.root_current_vertex
            packed.root_branch_order = multiplicity
        end
        if candidate.active
            candidate.best_vertex = candidate.current_vertex
            candidate.branch_order = multiplicity
        end
        return nothing
    end

    comparison = GC._compare_directed_inverse_mappings(
        graph, workspace.inverse_mapping, workspace.best_inverse_mapping
    )
    if comparison < 0
        iszero(n) || copyto!(workspace.best_inverse_mapping, 1, workspace.inverse_mapping, 1, n)
        workspace.automorphism_order = multiplicity
        if packed.root_orbit_active
            packed.root_best_vertex = packed.root_current_vertex
            packed.root_branch_order = multiplicity
        end
        if candidate.active
            candidate.best_vertex = candidate.current_vertex
            candidate.branch_order = multiplicity
        end
    elseif iszero(comparison)
        workspace.automorphism_order = Base.Checked.checked_add(
            workspace.automorphism_order, multiplicity
        )
        if packed.root_orbit_active
            packed.root_branch_order = Base.Checked.checked_add(
                packed.root_branch_order, multiplicity
            )
        end
        if candidate.active && candidate.current_vertex == candidate.best_vertex
            candidate.branch_order = Base.Checked.checked_add(
                candidate.branch_order, multiplicity
            )
        end
        record_automorphism!(candidate, n)
    end
    return nothing
end

function record_leaf!(
    candidate::Depth2StabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    multiplicity::Int,
)::Nothing
    workspace = candidate.packed.workspace
    n = graph.num_vertices
    @inbounds for vertex in 1:n
        canonical_vertex = workspace.color_stack[vertex, depth]
        workspace.inverse_mapping[canonical_vertex] = vertex
    end
    workspace.search_leaves += 1
    record_candidate!(candidate, graph, multiplicity)
    return nothing
end

function search_root!(
    candidate::Depth2StabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    target_color::Int,
)::Nothing
    packed = candidate.packed
    workspace = packed.workspace
    n = graph.num_vertices
    child_depth = 2
    target_mask = UInt64(0)

    @inbounds for vertex in 1:n
        if workspace.color_stack[vertex, 1] == target_color
            target_mask |= bit(vertex)
        end
        packed.orbit_parent[vertex] = vertex
    end

    packed.root_target_mask = target_mask
    packed.root_explored_mask = 0
    packed.root_current_vertex = 0
    packed.root_best_vertex = 0
    packed.root_branch_order = 0
    packed.root_best_stabilizer_order = 0
    packed.root_orbit_active = true

    @inbounds for chosen_vertex in 1:n
        iszero(target_mask & bit(chosen_vertex)) && continue
        if GC._packed_directed_root_candidate_explored(packed, chosen_vertex)
            packed.root_orbit_skips += 1
            continue
        end

        GC._packed_directed_seed_chosen_root_twins!(packed, graph, chosen_vertex, target_mask)
        packed.root_current_vertex = chosen_vertex
        packed.root_branch_order = 0
        packed.root_explored_mask |= bit(chosen_vertex)

        for vertex in 1:n
            color = workspace.color_stack[vertex, 1]
            workspace.color_stack[vertex, child_depth] = if color < target_color
                color
            elseif color > target_color
                color + 1
            elseif vertex == chosen_vertex
                target_color
            else
                target_color + 1
            end
        end
        search_partition!(candidate, graph, child_depth, 1)
        if packed.root_best_vertex == chosen_vertex
            packed.root_best_stabilizer_order = packed.root_branch_order
        end
    end

    packed.root_orbit_active = false
    root_orbit_size = GC._packed_directed_root_orbit_size(packed, packed.root_best_vertex)
    workspace.automorphism_order = Base.Checked.checked_mul(
        root_orbit_size, packed.root_best_stabilizer_order
    )
    return nothing
end

function search_depth2!(
    candidate::Depth2StabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    multiplicity::Int,
    target_color::Int,
)::Nothing
    packed = candidate.packed
    workspace = packed.workspace
    n = graph.num_vertices
    child_depth = depth + 1
    target_mask = UInt64(0)

    @inbounds for vertex in 1:n
        if workspace.color_stack[vertex, depth] == target_color
            target_mask |= bit(vertex)
        end
        candidate.orbit_parent[vertex] = vertex
    end

    candidate.target_mask = target_mask
    candidate.explored_mask = 0
    candidate.current_vertex = 0
    candidate.best_vertex = 0
    candidate.branch_order = 0
    candidate.best_stabilizer_order = 0
    candidate.active = true

    @inbounds for chosen_vertex in 1:n
        iszero(target_mask & bit(chosen_vertex)) && continue
        if candidate_explored(candidate, chosen_vertex)
            candidate.orbit_skips += 1
            continue
        end

        seed_chosen_twins!(candidate, graph, chosen_vertex, target_mask)
        candidate.current_vertex = chosen_vertex
        candidate.branch_order = 0
        candidate.explored_mask |= bit(chosen_vertex)

        for vertex in 1:n
            color = workspace.color_stack[vertex, depth]
            workspace.color_stack[vertex, child_depth] = if color < target_color
                color
            elseif color > target_color
                color + 1
            elseif vertex == chosen_vertex
                target_color
            else
                target_color + 1
            end
        end
        search_partition!(candidate, graph, child_depth, multiplicity)
        if candidate.best_vertex == chosen_vertex
            candidate.best_stabilizer_order = candidate.branch_order
        end
    end

    candidate.active = false
    if packed.root_best_vertex == packed.root_current_vertex && !iszero(candidate.best_vertex)
        local_orbit_size = orbit_size(candidate, candidate.best_vertex)
        packed.root_branch_order = Base.Checked.checked_mul(
            local_orbit_size, candidate.best_stabilizer_order
        )
    end
    return nothing
end

function search_partition!(
    candidate::Depth2StabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    multiplicity::Int,
)::Nothing
    packed = candidate.packed
    workspace = packed.workspace
    workspace.search_nodes += 1
    GC._packed_directed_workspace_refine!(packed, graph, depth)
    target_color = GC._directed_workspace_target_color!(workspace, graph, depth)
    if iszero(target_color)
        record_leaf!(candidate, graph, depth, multiplicity)
        return nothing
    end

    if depth == 1
        search_root!(candidate, graph, target_color)
        return nothing
    elseif depth == 2
        search_depth2!(candidate, graph, depth, multiplicity, target_color)
        return nothing
    end

    n = graph.num_vertices
    child_depth = depth + 1
    @inbounds for chosen_vertex in 1:n
        workspace.color_stack[chosen_vertex, depth] == target_color || continue

        has_earlier_twin = false
        for earlier_vertex in 1:(chosen_vertex - 1)
            workspace.color_stack[earlier_vertex, depth] == target_color || continue
            if GC._directed_workspace_exact_twins(graph, chosen_vertex, earlier_vertex)
                has_earlier_twin = true
                break
            end
        end
        has_earlier_twin && continue

        twin_class_size = 1
        for later_vertex in (chosen_vertex + 1):n
            workspace.color_stack[later_vertex, depth] == target_color || continue
            if GC._directed_workspace_exact_twins(graph, chosen_vertex, later_vertex)
                twin_class_size += 1
            end
        end
        child_multiplicity = Base.Checked.checked_mul(multiplicity, twin_class_size)

        for vertex in 1:n
            color = workspace.color_stack[vertex, depth]
            workspace.color_stack[vertex, child_depth] = if color < target_color
                color
            elseif color > target_color
                color + 1
            elseif vertex == chosen_vertex
                target_color
            else
                target_color + 1
            end
        end
        search_partition!(candidate, graph, child_depth, child_multiplicity)
    end
    return nothing
end

function canonicalize_depth2!(
    buffer::GC.DirectedCanonicalizationBuffer,
    candidate::Depth2StabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    vertex_colors::AbstractVector{<:Integer},
)::GC.DirectedCanonicalizationBuffer
    packed = candidate.packed
    workspace = packed.workspace
    n = graph.num_vertices
    length(vertex_colors) == n || error("vertex_colors must have one entry per vertex")
    GC._check_directed_workspace_capacity(buffer, workspace, graph)
    GC._prepare_packed_directed_rows!(packed, graph) || error("research candidate requires simple n <= 64 graph")

    @inbounds for vertex in 1:n
        workspace.colors[vertex] = Int(vertex_colors[vertex])
    end

    GC._reset_directed_workspace_search!(workspace)
    packed.root_target_mask = 0
    packed.root_explored_mask = 0
    packed.root_current_vertex = 0
    packed.root_best_vertex = 0
    packed.root_branch_order = 0
    packed.root_best_stabilizer_order = 0
    packed.root_orbit_skips = 0
    packed.root_orbit_merges = 0
    packed.root_automorphisms = 0
    packed.root_orbit_active = false
    packed.active_splitter_steps = 0
    packed.active_cell_splits = 0
    candidate.target_mask = 0
    candidate.explored_mask = 0
    candidate.current_vertex = 0
    candidate.best_vertex = 0
    candidate.branch_order = 0
    candidate.best_stabilizer_order = 0
    candidate.orbit_skips = 0
    candidate.orbit_merges = 0
    candidate.automorphisms = 0
    candidate.active = false

    GC._directed_workspace_initialize_colors!(workspace, n)
    search_partition!(candidate, graph, 1, 1)
    workspace.has_best || error("depth-2 research search produced no candidate")
    GC._write_directed_buffer!(
        buffer, graph, workspace.best_inverse_mapping, workspace.automorphism_order
    )
    return buffer
end

function directed_cycle(n::Int)
    return GC.DirectedGCGraph([v => mod1(v + 1, n) for v in 1:n], n), ones(Int, n)
end

function bidirectional_cycle(n::Int)
    edges = Pair{Int,Int}[]
    for v in 1:n
        w = mod1(v + 1, n)
        push!(edges, v => w)
        push!(edges, w => v)
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function circulant(n::Int, offsets::Tuple{Vararg{Int}})
    edges = Pair{Int,Int}[]
    for source in 1:n, offset in offsets
        push!(edges, source => mod1(source + offset, n))
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function fixed_star(n::Int)
    edges = Pair{Int,Int}[]
    for leaf in 2:n
        push!(edges, 1 => leaf)
        push!(edges, leaf => 1)
    end
    colors = ones(Int, n)
    colors[1] = 2
    return GC.DirectedGCGraph(edges, n), colors
end

function paired_color_cycle(num_cells::Int)
    n = 2 * num_cells
    edges = Pair{Int,Int}[]
    for cell in 1:num_cells
        next_cell = mod1(cell + 1, num_cells)
        current = (2 * cell - 1, 2 * cell)
        following = (2 * next_cell - 1, 2 * next_cell)
        for source in current, target in following
            push!(edges, source => target)
        end
    end
    colors = repeat(collect(1:num_cells); inner=2)
    return GC.DirectedGCGraph(edges, n), colors
end

function almost_discrete(n::Int)
    graph, _ = circulant(n, (1, 5, 11))
    colors = collect(1:n)
    colors[n - 1] = n - 1
    colors[n] = n - 1
    return graph, colors
end

function benchmark_fixture(name::String, graph::GC.DirectedGCGraph, colors::Vector{Int})
    n = graph.num_vertices
    base_workspace = GC.PackedDirectedCanonicalizationWorkspace(n)
    base_buffer = GC.DirectedCanonicalizationBuffer(n)
    candidate = Depth2StabilizerWorkspace(n)
    candidate_buffer = GC.DirectedCanonicalizationBuffer(n)

    GC.canonicalize_directed_packed!(base_buffer, base_workspace, graph, colors)
    canonicalize_depth2!(candidate_buffer, candidate, graph, colors)

    base_image = @view base_buffer.canonical_multiplicities[1:(n * n)]
    candidate_image = @view candidate_buffer.canonical_multiplicities[1:(n * n)]
    base_witness = @view base_buffer.old_to_canonical[1:n]
    candidate_witness = @view candidate_buffer.old_to_canonical[1:n]
    base_image == candidate_image || error("canonical image mismatch for $name")
    base_witness == candidate_witness || error("canonical witness mismatch for $name")
    base_buffer.automorphism_order == candidate_buffer.automorphism_order ||
        error("automorphism-order mismatch for $name")

    base_trial = @benchmark GC.canonicalize_directed_packed!(
        $base_buffer, $base_workspace, $graph, $colors
    ) samples = 180 seconds = 1 evals = 1
    candidate_trial = @benchmark canonicalize_depth2!(
        $candidate_buffer, $candidate, $graph, $colors
    ) samples = 180 seconds = 1 evals = 1

    base_estimate = minimum(base_trial)
    candidate_estimate = minimum(candidate_trial)
    println(
        "RESULT|",
        name,
        "|",
        candidate_estimate.time / base_estimate.time,
        "|",
        base_workspace.workspace.search_nodes,
        "|",
        candidate.packed.workspace.search_nodes,
        "|",
        base_workspace.workspace.search_leaves,
        "|",
        candidate.packed.workspace.search_leaves,
        "|",
        candidate.orbit_skips,
        "|",
        candidate.orbit_merges,
        "|",
        candidate.automorphisms,
        "|",
        candidate_estimate.memory,
        "|",
        candidate_estimate.allocs,
    )
    return nothing
end

fixtures = (
    ("cycle-15", directed_cycle(15)...),
    ("bidirectional-cycle-15", bidirectional_cycle(15)...),
    ("fixed-star-12", fixed_star(12)...),
    ("paired-color-cycle-12", paired_color_cycle(6)...),
    ("paired-color-cycle-24", paired_color_cycle(12)...),
    ("circulant-24", circulant(24, (1, 5, 7))...),
    ("circulant-40", circulant(40, (1, 7, 13))...),
    ("almost-discrete-40", almost_discrete(40)...),
)

for (name, graph, colors) in fixtures
    benchmark_fixture(name, graph, colors)
end
