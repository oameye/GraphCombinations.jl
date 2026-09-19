import GraphCombinations as GC

mutable struct PackedRecursiveStabilizerWorkspace
    packed::GC.PackedDirectedCanonicalizationWorkspace
    word_capacity::Int
    depth_capacity::Int
    orbit_parent::Vector{Int}
    best_inverse::Vector{Int}
    target_masks::Vector{UInt64}
    explored_masks::Vector{UInt64}
    best_vertices::Vector{Int}
    best_child_orders::Vector{Int}
    has_best::Vector{Bool}
    orbit_skips::Vector{Int}
    orbit_merges::Vector{Int}
    automorphisms::Vector{Int}
    total_orbit_skips::Int
    total_orbit_merges::Int
    total_automorphisms::Int
end

function PackedRecursiveStabilizerWorkspace(capacity::Integer)
    n = Int(capacity)
    n >= 0 || throw(ArgumentError("capacity must be non-negative"))
    word_capacity = min(n, 64)
    depth_capacity = n + 1
    flat_capacity = word_capacity * depth_capacity
    return PackedRecursiveStabilizerWorkspace(
        GC.PackedDirectedCanonicalizationWorkspace(n),
        word_capacity,
        depth_capacity,
        Vector{Int}(undef, flat_capacity),
        Vector{Int}(undef, flat_capacity),
        zeros(UInt64, depth_capacity),
        zeros(UInt64, depth_capacity),
        zeros(Int, depth_capacity),
        zeros(Int, depth_capacity),
        falses(depth_capacity),
        zeros(Int, depth_capacity),
        zeros(Int, depth_capacity),
        zeros(Int, depth_capacity),
        0,
        0,
        0,
    )
end

@inline recursive_bit(vertex::Int)::UInt64 = UInt64(1) << (vertex - 1)

@inline function recursive_slot(
    candidate::PackedRecursiveStabilizerWorkspace, depth::Int, vertex::Int
)::Int
    return (depth - 1) * candidate.word_capacity + vertex
end

@inline function recursive_orbit_find(
    candidate::PackedRecursiveStabilizerWorkspace, depth::Int, vertex::Int
)::Int
    root = vertex
    @inbounds while true
        parent = candidate.orbit_parent[recursive_slot(candidate, depth, root)]
        parent == root && return root
        root = parent
    end
end

function recursive_orbit_union!(
    candidate::PackedRecursiveStabilizerWorkspace, depth::Int, left::Int, right::Int
)::Nothing
    left_root = recursive_orbit_find(candidate, depth, left)
    right_root = recursive_orbit_find(candidate, depth, right)
    left_root == right_root && return nothing
    @inbounds candidate.orbit_parent[recursive_slot(candidate, depth, right_root)] = left_root
    candidate.orbit_merges[depth] += 1
    candidate.total_orbit_merges += 1
    return nothing
end

function recursive_initialize_node!(
    candidate::PackedRecursiveStabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    target_color::Int,
)::UInt64
    workspace = candidate.packed.workspace
    n = graph.num_vertices
    target_mask = UInt64(0)
    @inbounds for vertex in 1:n
        if workspace.color_stack[vertex, depth] == target_color
            target_mask |= recursive_bit(vertex)
        end
        candidate.orbit_parent[recursive_slot(candidate, depth, vertex)] = vertex
    end
    candidate.target_masks[depth] = target_mask
    candidate.explored_masks[depth] = 0
    candidate.best_vertices[depth] = 0
    candidate.best_child_orders[depth] = 0
    candidate.has_best[depth] = false
    candidate.orbit_skips[depth] = 0
    candidate.orbit_merges[depth] = 0
    candidate.automorphisms[depth] = 0
    return target_mask
end

function recursive_seed_chosen_twins!(
    candidate::PackedRecursiveStabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    chosen_vertex::Int,
    target_mask::UInt64,
)::Nothing
    members = target_mask
    @inbounds while !iszero(members)
        other = trailing_zeros(members) + 1
        members &= members - UInt64(1)
        other > chosen_vertex || continue
        if GC._directed_workspace_exact_twins(graph, chosen_vertex, other)
            recursive_orbit_union!(candidate, depth, chosen_vertex, other)
        end
    end
    return nothing
end

function recursive_candidate_explored(
    candidate::PackedRecursiveStabilizerWorkspace, depth::Int, chosen_vertex::Int
)::Bool
    chosen_root = recursive_orbit_find(candidate, depth, chosen_vertex)
    explored = candidate.explored_masks[depth]
    @inbounds while !iszero(explored)
        earlier = trailing_zeros(explored) + 1
        if recursive_orbit_find(candidate, depth, earlier) == chosen_root
            return true
        end
        explored &= explored - UInt64(1)
    end
    return false
end

function recursive_orbit_size(
    candidate::PackedRecursiveStabilizerWorkspace, depth::Int, vertex::Int
)::Int
    root = recursive_orbit_find(candidate, depth, vertex)
    count = 0
    members = candidate.target_masks[depth]
    @inbounds while !iszero(members)
        other = trailing_zeros(members) + 1
        count += recursive_orbit_find(candidate, depth, other) == root
        members &= members - UInt64(1)
    end
    return count
end

function recursive_copy_leaf!(
    candidate::PackedRecursiveStabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
)::Nothing
    workspace = candidate.packed.workspace
    n = graph.num_vertices
    @inbounds for vertex in 1:n
        canonical_vertex = workspace.color_stack[vertex, depth]
        workspace.inverse_mapping[canonical_vertex] = vertex
    end
    @inbounds for canonical_vertex in 1:n
        candidate.best_inverse[recursive_slot(candidate, depth, canonical_vertex)] =
            workspace.inverse_mapping[canonical_vertex]
    end
    workspace.search_leaves += 1
    candidate.has_best[depth] = true
    return nothing
end

function recursive_copy_child_best!(
    candidate::PackedRecursiveStabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    parent_depth::Int,
    child_depth::Int,
)::Nothing
    n = graph.num_vertices
    @inbounds for canonical_vertex in 1:n
        candidate.best_inverse[recursive_slot(candidate, parent_depth, canonical_vertex)] =
            candidate.best_inverse[recursive_slot(candidate, child_depth, canonical_vertex)]
    end
    return nothing
end

function recursive_compare_child_to_best(
    candidate::PackedRecursiveStabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    parent_depth::Int,
    child_depth::Int,
)::Int
    n = graph.num_vertices
    multiplicities = graph.multiplicities
    @inbounds for canonical_source in 1:n
        child_source = candidate.best_inverse[
            recursive_slot(candidate, child_depth, canonical_source)
        ]
        best_source = candidate.best_inverse[
            recursive_slot(candidate, parent_depth, canonical_source)
        ]
        for canonical_target in 1:n
            child_target = candidate.best_inverse[
                recursive_slot(candidate, child_depth, canonical_target)
            ]
            best_target = candidate.best_inverse[
                recursive_slot(candidate, parent_depth, canonical_target)
            ]
            child_value = multiplicities[GC._directed_slot(child_source, child_target, n)]
            best_value = multiplicities[GC._directed_slot(best_source, best_target, n)]
            child_value == best_value && continue
            return child_value < best_value ? -1 : 1
        end
    end
    return 0
end

function recursive_record_automorphism!(
    candidate::PackedRecursiveStabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    child_depth::Int,
)::Nothing
    n = graph.num_vertices
    target_mask = candidate.target_masks[depth]
    @inbounds for canonical_vertex in 1:n
        best_vertex = candidate.best_inverse[
            recursive_slot(candidate, depth, canonical_vertex)
        ]
        child_vertex = candidate.best_inverse[
            recursive_slot(candidate, child_depth, canonical_vertex)
        ]
        iszero(target_mask & recursive_bit(best_vertex)) && continue
        iszero(target_mask & recursive_bit(child_vertex)) &&
            error("stabilizer automorphism left the active target cell")
        recursive_orbit_union!(candidate, depth, best_vertex, child_vertex)
    end
    candidate.automorphisms[depth] += 1
    candidate.total_automorphisms += 1
    return nothing
end

function recursive_individualize!(
    candidate::PackedRecursiveStabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    child_depth::Int,
    target_color::Int,
    chosen_vertex::Int,
)::Nothing
    workspace = candidate.packed.workspace
    n = graph.num_vertices
    @inbounds for vertex in 1:n
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
    return nothing
end

function recursive_search!(
    candidate::PackedRecursiveStabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
)::Int
    packed = candidate.packed
    workspace = packed.workspace
    workspace.search_nodes += 1
    GC._packed_directed_workspace_refine!(packed, graph, depth)
    target_color = GC._directed_workspace_target_color!(workspace, graph, depth)

    if iszero(target_color)
        recursive_copy_leaf!(candidate, graph, depth)
        return 1
    end

    depth < candidate.depth_capacity || error("recursive stabilizer depth capacity exhausted")
    target_mask = recursive_initialize_node!(candidate, graph, depth, target_color)
    child_depth = depth + 1
    n = graph.num_vertices

    @inbounds for chosen_vertex in 1:n
        iszero(target_mask & recursive_bit(chosen_vertex)) && continue
        if recursive_candidate_explored(candidate, depth, chosen_vertex)
            candidate.orbit_skips[depth] += 1
            candidate.total_orbit_skips += 1
            continue
        end

        recursive_seed_chosen_twins!(candidate, graph, depth, chosen_vertex, target_mask)
        candidate.explored_masks[depth] |= recursive_bit(chosen_vertex)
        recursive_individualize!(
            candidate, graph, depth, child_depth, target_color, chosen_vertex
        )
        child_order = recursive_search!(candidate, graph, child_depth)

        if !candidate.has_best[depth]
            recursive_copy_child_best!(candidate, graph, depth, child_depth)
            candidate.best_vertices[depth] = chosen_vertex
            candidate.best_child_orders[depth] = child_order
            candidate.has_best[depth] = true
            continue
        end

        comparison = recursive_compare_child_to_best(
            candidate, graph, depth, child_depth
        )
        if comparison < 0
            recursive_copy_child_best!(candidate, graph, depth, child_depth)
            candidate.best_vertices[depth] = chosen_vertex
            candidate.best_child_orders[depth] = child_order
        elseif iszero(comparison)
            child_order == candidate.best_child_orders[depth] ||
                error("equal canonical child branches have unequal stabilizer orders")
            recursive_record_automorphism!(candidate, graph, depth, child_depth)
        end
    end

    candidate.has_best[depth] || error("recursive stabilizer search produced no child")
    best_vertex = candidate.best_vertices[depth]
    orbit_size = recursive_orbit_size(candidate, depth, best_vertex)
    return Base.Checked.checked_mul(orbit_size, candidate.best_child_orders[depth])
end

function reset_recursive_stabilizer_stats!(
    candidate::PackedRecursiveStabilizerWorkspace,
)::Nothing
    fill!(candidate.target_masks, 0)
    fill!(candidate.explored_masks, 0)
    fill!(candidate.best_vertices, 0)
    fill!(candidate.best_child_orders, 0)
    fill!(candidate.has_best, false)
    fill!(candidate.orbit_skips, 0)
    fill!(candidate.orbit_merges, 0)
    fill!(candidate.automorphisms, 0)
    candidate.total_orbit_skips = 0
    candidate.total_orbit_merges = 0
    candidate.total_automorphisms = 0
    return nothing
end

function canonicalize_recursive_stabilizers!(
    buffer::GC.DirectedCanonicalizationBuffer,
    candidate::PackedRecursiveStabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    vertex_colors::AbstractVector{<:Integer},
)::GC.DirectedCanonicalizationBuffer
    packed = candidate.packed
    workspace = packed.workspace
    n = graph.num_vertices
    length(vertex_colors) == n ||
        throw(ArgumentError("vertex_colors must have one entry per vertex"))
    GC._check_directed_workspace_capacity(buffer, workspace, graph)
    GC._prepare_packed_directed_rows!(packed, graph) ||
        throw(ArgumentError("recursive stabilizer kernel requires a simple directed graph with n <= 64"))

    @inbounds for vertex in 1:n
        workspace.colors[vertex] = Int(vertex_colors[vertex])
    end

    GC._reset_directed_workspace_search!(workspace)
    packed.active_splitter_steps = 0
    packed.active_cell_splits = 0
    reset_recursive_stabilizer_stats!(candidate)

    GC._directed_workspace_initialize_colors!(workspace, n)
    automorphism_order = recursive_search!(candidate, graph, 1)
    candidate.has_best[1] || error("recursive stabilizer search produced no canonical leaf")

    @inbounds for canonical_vertex in 1:n
        workspace.best_inverse_mapping[canonical_vertex] =
            candidate.best_inverse[recursive_slot(candidate, 1, canonical_vertex)]
    end
    workspace.automorphism_order = automorphism_order
    workspace.has_best = true
    GC._write_directed_buffer!(
        buffer, graph, workspace.best_inverse_mapping, workspace.automorphism_order
    )
    return buffer
end

function recursive_total(values::Vector{Int}, n::Int)::Int
    total = 0
    @inbounds for depth in 1:min(n, length(values))
        total += values[depth]
    end
    return total
end
