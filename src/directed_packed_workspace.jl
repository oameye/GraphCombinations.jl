# --- Packed one-word candidate for small simple directed graphs ---

"""
    PackedDirectedCanonicalizationWorkspace(capacity)

Research/production-candidate storage for exact directed canonicalization. It reuses the certified
`DirectedCanonicalizationWorkspace` search state and adds packed outgoing/incoming adjacency rows,
packed color-cell masks, reusable active-splitter scratch, and root-level automorphism-orbit state.
Graphs with at most 64 vertices and edge multiplicities in `0:1` use the packed `UInt64`
refinement kernel; all other graphs fall back exactly to the existing general directed workspace.
"""
mutable struct PackedDirectedCanonicalizationWorkspace
    workspace::DirectedCanonicalizationWorkspace
    out_rows::Vector{UInt64}
    in_rows::Vector{UInt64}
    cell_masks::Vector{UInt64}
    active_masks::Vector{UInt64}
    next_active_masks::Vector{UInt64}
    splitter_keys::Vector{Int}
    orbit_parent::Vector{Int}
    root_target_mask::UInt64
    root_explored_mask::UInt64
    root_current_vertex::Int
    root_best_vertex::Int
    root_branch_order::Int
    root_best_stabilizer_order::Int
    root_orbit_skips::Int
    root_orbit_merges::Int
    root_automorphisms::Int
    root_orbit_active::Bool
    active_splitter_steps::Int
    active_cell_splits::Int
end

function PackedDirectedCanonicalizationWorkspace(capacity::Integer)
    n = Int(capacity)
    n >= 0 || throw(ArgumentError("capacity must be non-negative."))
    word_capacity = min(n, 64)
    return PackedDirectedCanonicalizationWorkspace(
        DirectedCanonicalizationWorkspace(n),
        zeros(UInt64, word_capacity),
        zeros(UInt64, word_capacity),
        zeros(UInt64, word_capacity),
        zeros(UInt64, word_capacity),
        zeros(UInt64, word_capacity),
        Vector{Int}(undef, word_capacity),
        Vector{Int}(undef, word_capacity),
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
        0,
        0,
    )
end

@inline _packed_directed_vertex_bit(vertex::Int)::UInt64 = UInt64(1) << (vertex - 1)

function _prepare_packed_directed_rows!(
    packed::PackedDirectedCanonicalizationWorkspace, graph::DirectedGCGraph
)::Bool
    n = graph.num_vertices
    n <= 64 || return false
    length(packed.out_rows) >= n || return false

    @inbounds for vertex in 1:n
        packed.out_rows[vertex] = 0
        packed.in_rows[vertex] = 0
    end

    @inbounds for source in 1:n
        for target in 1:n
            multiplicity = graph.multiplicities[_directed_slot(source, target, n)]
            iszero(multiplicity) && continue
            multiplicity == 1 || return false
            packed.out_rows[source] |= _packed_directed_vertex_bit(target)
            packed.in_rows[target] |= _packed_directed_vertex_bit(source)
        end
    end
    return true
end

function _packed_directed_workspace_build_cell_masks!(
    packed::PackedDirectedCanonicalizationWorkspace, graph::DirectedGCGraph, depth::Int
)::Int
    workspace = packed.workspace
    n = graph.num_vertices
    num_colors = 0
    @inbounds for vertex in 1:n
        num_colors = max(num_colors, workspace.color_stack[vertex, depth])
    end
    @inbounds for color in 1:num_colors
        packed.cell_masks[color] = 0
    end
    @inbounds for vertex in 1:n
        color = workspace.color_stack[vertex, depth]
        packed.cell_masks[color] |= _packed_directed_vertex_bit(vertex)
    end
    return num_colors
end

@inline function _packed_directed_splitter_key(
    packed::PackedDirectedCanonicalizationWorkspace,
    vertex::Int,
    splitter_mask::UInt64,
    n::Int,
)::Int
    out_count = count_ones(packed.out_rows[vertex] & splitter_mask)
    in_count = count_ones(packed.in_rows[vertex] & splitter_mask)
    return out_count * (n + 1) + in_count
end

@inline function _packed_directed_touched_vertices(
    packed::PackedDirectedCanonicalizationWorkspace, splitter_mask::UInt64
)::UInt64
    touched = UInt64(0)
    remaining = splitter_mask
    @inbounds while !iszero(remaining)
        vertex = trailing_zeros(remaining) + 1
        touched |= packed.in_rows[vertex] | packed.out_rows[vertex]
        remaining &= remaining - UInt64(1)
    end
    return touched
end

@inline function _packed_directed_cached_key(
    packed::PackedDirectedCanonicalizationWorkspace, vertex::Int, touched_vertices::UInt64
)::Int
    return if iszero(_packed_directed_vertex_bit(vertex) & touched_vertices)
        0
    else
        packed.splitter_keys[vertex]
    end
end

function _packed_directed_workspace_refine_splitter!(
    packed::PackedDirectedCanonicalizationWorkspace,
    graph::DirectedGCGraph,
    depth::Int,
    splitter_mask::UInt64,
    num_colors::Int,
)::Tuple{UInt64,Int}
    workspace = packed.workspace
    n = graph.num_vertices
    packed.active_splitter_steps += 1

    touched_vertices = _packed_directed_touched_vertices(packed, splitter_mask)
    iszero(touched_vertices) && return UInt64(0), num_colors

    remaining = touched_vertices
    @inbounds while !iszero(remaining)
        vertex = trailing_zeros(remaining) + 1
        packed.splitter_keys[vertex] = _packed_directed_splitter_key(
            packed, vertex, splitter_mask, n
        )
        remaining &= remaining - UInt64(1)
    end

    split_members = UInt64(0)
    @inbounds for color in 1:num_colors
        cell_mask = packed.cell_masks[color]
        touched_cell = cell_mask & touched_vertices
        iszero(touched_cell) && continue

        first_key = if touched_cell == cell_mask
            first_vertex = trailing_zeros(touched_cell) + 1
            packed.splitter_keys[first_vertex]
        else
            0
        end

        differs = false
        members = touched_cell
        while !iszero(members)
            vertex = trailing_zeros(members) + 1
            if packed.splitter_keys[vertex] != first_key
                differs = true
                break
            end
            members &= members - UInt64(1)
        end
        differs || continue

        split_members |= cell_mask
        workspace.signatures[color] = 1
        packed.active_cell_splits += 1
    end
    iszero(split_members) && return UInt64(0), num_colors

    next_color = 0
    @inbounds for color in 1:num_colors
        cell_mask = packed.cell_masks[color]
        if iszero(cell_mask & split_members)
            next_color += 1
            packed.next_active_masks[next_color] = cell_mask
            members = cell_mask
            while !iszero(members)
                vertex = trailing_zeros(members) + 1
                workspace.refined_colors[vertex] = next_color
                members &= members - UInt64(1)
            end
            continue
        end

        count = 0
        members = cell_mask
        while !iszero(members)
            vertex = trailing_zeros(members) + 1
            count += 1
            workspace.order[count] = vertex
            members &= members - UInt64(1)
        end

        for index in 2:count
            vertex = workspace.order[index]
            key = _packed_directed_cached_key(packed, vertex, touched_vertices)
            position = index - 1
            while position >= 1 &&
                  key < _packed_directed_cached_key(
                packed, workspace.order[position], touched_vertices
            )
                workspace.order[position + 1] = workspace.order[position]
                position -= 1
            end
            workspace.order[position + 1] = vertex
        end

        previous_key = -1
        for index in 1:count
            vertex = workspace.order[index]
            key = _packed_directed_cached_key(packed, vertex, touched_vertices)
            if index == 1 || key != previous_key
                next_color += 1
                packed.next_active_masks[next_color] = 0
                previous_key = key
            end
            workspace.refined_colors[vertex] = next_color
            packed.next_active_masks[next_color] |= _packed_directed_vertex_bit(vertex)
        end
    end

    @inbounds for vertex in 1:n
        workspace.color_stack[vertex, depth] = workspace.refined_colors[vertex]
    end
    @inbounds for color in 1:next_color
        packed.cell_masks[color] = packed.next_active_masks[color]
    end
    return split_members, next_color
end

function _packed_directed_workspace_refine!(
    packed::PackedDirectedCanonicalizationWorkspace, graph::DirectedGCGraph, depth::Int
)::Nothing
    workspace = packed.workspace
    n = graph.num_vertices
    iszero(n) && return nothing

    num_colors = _packed_directed_workspace_build_cell_masks!(packed, graph, depth)
    active_count = num_colors
    @inbounds for index in 1:active_count
        packed.active_masks[index] = packed.cell_masks[index]
    end

    while active_count > 0
        split_members = UInt64(0)
        @inbounds for index in 1:active_count
            split, num_colors = _packed_directed_workspace_refine_splitter!(
                packed, graph, depth, packed.active_masks[index], num_colors
            )
            split_members |= split
        end
        workspace.refinement_rounds += 1
        iszero(split_members) && break

        next_count = 0
        @inbounds for color in 1:num_colors
            mask = packed.cell_masks[color]
            iszero(mask & split_members) && continue
            next_count += 1
            packed.next_active_masks[next_count] = mask
        end
        active_count = next_count
        @inbounds for index in 1:active_count
            packed.active_masks[index] = packed.next_active_masks[index]
        end
    end
    return nothing
end

@inline function _packed_directed_orbit_find(
    packed::PackedDirectedCanonicalizationWorkspace, vertex::Int
)::Int
    root = vertex
    @inbounds while packed.orbit_parent[root] != root
        root = packed.orbit_parent[root]
    end
    return root
end

function _packed_directed_orbit_union!(
    packed::PackedDirectedCanonicalizationWorkspace, left::Int, right::Int
)::Nothing
    left_root = _packed_directed_orbit_find(packed, left)
    right_root = _packed_directed_orbit_find(packed, right)
    left_root == right_root && return nothing
    @inbounds packed.orbit_parent[right_root] = left_root
    packed.root_orbit_merges += 1
    return nothing
end

function _packed_directed_record_automorphism!(
    packed::PackedDirectedCanonicalizationWorkspace, n::Int
)::Nothing
    workspace = packed.workspace
    @inbounds for canonical_vertex in 1:n
        best_vertex = workspace.best_inverse_mapping[canonical_vertex]
        iszero(packed.root_target_mask & _packed_directed_vertex_bit(best_vertex)) &&
            continue
        candidate_vertex = workspace.inverse_mapping[canonical_vertex]
        _packed_directed_orbit_union!(packed, best_vertex, candidate_vertex)
    end
    packed.root_automorphisms += 1
    return nothing
end

function _record_packed_directed_candidate!(
    packed::PackedDirectedCanonicalizationWorkspace,
    graph::DirectedGCGraph,
    multiplicity::Int,
)::Nothing
    workspace = packed.workspace
    n = graph.num_vertices
    if !workspace.has_best
        iszero(n) ||
            copyto!(workspace.best_inverse_mapping, 1, workspace.inverse_mapping, 1, n)
        workspace.automorphism_order = multiplicity
        workspace.has_best = true
        if packed.root_orbit_active
            packed.root_best_vertex = packed.root_current_vertex
            packed.root_branch_order = multiplicity
        end
        return nothing
    end

    comparison = _compare_directed_inverse_mappings(
        graph, workspace.inverse_mapping, workspace.best_inverse_mapping
    )
    if comparison < 0
        iszero(n) ||
            copyto!(workspace.best_inverse_mapping, 1, workspace.inverse_mapping, 1, n)
        workspace.automorphism_order = multiplicity
        if packed.root_orbit_active
            packed.root_best_vertex = packed.root_current_vertex
            packed.root_branch_order = multiplicity
        end
    elseif iszero(comparison)
        workspace.automorphism_order = Base.Checked.checked_add(
            workspace.automorphism_order, multiplicity
        )
        if packed.root_orbit_active
            packed.root_branch_order = Base.Checked.checked_add(
                packed.root_branch_order, multiplicity
            )
            _packed_directed_record_automorphism!(packed, n)
        end
    end
    return nothing
end

function _record_packed_directed_leaf!(
    packed::PackedDirectedCanonicalizationWorkspace,
    graph::DirectedGCGraph,
    depth::Int,
    multiplicity::Int,
)::Nothing
    workspace = packed.workspace
    n = graph.num_vertices
    @inbounds for vertex in 1:n
        canonical_vertex = workspace.color_stack[vertex, depth]
        workspace.inverse_mapping[canonical_vertex] = vertex
    end
    workspace.search_leaves += 1
    _record_packed_directed_candidate!(packed, graph, multiplicity)
    return nothing
end

function _packed_directed_seed_chosen_root_twins!(
    packed::PackedDirectedCanonicalizationWorkspace,
    graph::DirectedGCGraph,
    chosen_vertex::Int,
    target_mask::UInt64,
)::Nothing
    members = target_mask
    @inbounds while !iszero(members)
        candidate = trailing_zeros(members) + 1
        members &= members - UInt64(1)
        candidate > chosen_vertex || continue
        if _directed_workspace_exact_twins(graph, chosen_vertex, candidate)
            _packed_directed_orbit_union!(packed, chosen_vertex, candidate)
        end
    end
    return nothing
end

function _packed_directed_root_candidate_explored(
    packed::PackedDirectedCanonicalizationWorkspace, chosen_vertex::Int
)::Bool
    chosen_root = _packed_directed_orbit_find(packed, chosen_vertex)
    explored = packed.root_explored_mask
    @inbounds while !iszero(explored)
        earlier = trailing_zeros(explored) + 1
        if _packed_directed_orbit_find(packed, earlier) == chosen_root
            return true
        end
        explored &= explored - UInt64(1)
    end
    return false
end

function _packed_directed_root_orbit_size(
    packed::PackedDirectedCanonicalizationWorkspace, vertex::Int
)::Int
    root = _packed_directed_orbit_find(packed, vertex)
    count = 0
    members = packed.root_target_mask
    @inbounds while !iszero(members)
        candidate = trailing_zeros(members) + 1
        count += _packed_directed_orbit_find(packed, candidate) == root
        members &= members - UInt64(1)
    end
    return count
end

function _search_packed_directed_root_workspace!(
    packed::PackedDirectedCanonicalizationWorkspace,
    graph::DirectedGCGraph,
    target_color::Int,
)::Nothing
    workspace = packed.workspace
    n = graph.num_vertices
    child_depth = 2
    target_mask = UInt64(0)
    @inbounds for vertex in 1:n
        if workspace.color_stack[vertex, 1] == target_color
            target_mask |= _packed_directed_vertex_bit(vertex)
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
        iszero(target_mask & _packed_directed_vertex_bit(chosen_vertex)) && continue
        if _packed_directed_root_candidate_explored(packed, chosen_vertex)
            packed.root_orbit_skips += 1
            continue
        end

        _packed_directed_seed_chosen_root_twins!(
            packed, graph, chosen_vertex, target_mask
        )
        packed.root_current_vertex = chosen_vertex
        packed.root_branch_order = 0
        packed.root_explored_mask |= _packed_directed_vertex_bit(chosen_vertex)

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
        _search_packed_directed_partition_workspace!(packed, graph, child_depth, 1)
        if packed.root_best_vertex == chosen_vertex
            packed.root_best_stabilizer_order = packed.root_branch_order
        end
    end

    packed.root_orbit_active = false
    orbit_size = _packed_directed_root_orbit_size(packed, packed.root_best_vertex)
    workspace.automorphism_order = Base.Checked.checked_mul(
        orbit_size, packed.root_best_stabilizer_order
    )
    return nothing
end

function _search_packed_directed_partition_workspace!(
    packed::PackedDirectedCanonicalizationWorkspace,
    graph::DirectedGCGraph,
    depth::Int,
    multiplicity::Int,
)::Nothing
    workspace = packed.workspace
    workspace.search_nodes += 1
    _packed_directed_workspace_refine!(packed, graph, depth)
    target_color = _directed_workspace_target_color!(workspace, graph, depth)
    if iszero(target_color)
        _record_packed_directed_leaf!(packed, graph, depth, multiplicity)
        return nothing
    end

    if depth == 1
        _search_packed_directed_root_workspace!(packed, graph, target_color)
        return nothing
    end

    n = graph.num_vertices
    child_depth = depth + 1
    @inbounds for chosen_vertex in 1:n
        workspace.color_stack[chosen_vertex, depth] == target_color || continue

        has_earlier_twin = false
        for earlier_vertex in 1:(chosen_vertex - 1)
            workspace.color_stack[earlier_vertex, depth] == target_color || continue
            if _directed_workspace_exact_twins(graph, chosen_vertex, earlier_vertex)
                has_earlier_twin = true
                break
            end
        end
        has_earlier_twin && continue

        twin_class_size = 1
        for later_vertex in (chosen_vertex + 1):n
            workspace.color_stack[later_vertex, depth] == target_color || continue
            if _directed_workspace_exact_twins(graph, chosen_vertex, later_vertex)
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
        _search_packed_directed_partition_workspace!(
            packed, graph, child_depth, child_multiplicity
        )
    end
    return nothing
end

function _canonicalize_directed_packed_prepared!(
    buffer::DirectedCanonicalizationBuffer,
    packed::PackedDirectedCanonicalizationWorkspace,
    graph::DirectedGCGraph,
    vertex_colors::AbstractVector{<:Integer},
)::DirectedCanonicalizationBuffer
    workspace = packed.workspace
    n = graph.num_vertices
    length(vertex_colors) == n ||
        throw(ArgumentError("vertex_colors must have one entry per vertex."))
    _check_directed_workspace_capacity(buffer, workspace, graph)
    @inbounds for vertex in 1:n
        workspace.colors[vertex] = Int(vertex_colors[vertex])
    end

    _reset_directed_workspace_search!(workspace)
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
    _directed_workspace_initialize_colors!(workspace, n)
    _search_packed_directed_partition_workspace!(packed, graph, 1, 1)
    workspace.has_best ||
        error("Internal error: packed directed canonical search produced no candidate.")
    _write_directed_buffer!(
        buffer, graph, workspace.best_inverse_mapping, workspace.automorphism_order
    )
    return buffer
end

"""
    canonicalize_directed_packed!(buffer, workspace, graph, vertex_colors)

Canonicalize with the packed one-word kernel when `graph` is simple and has at most 64 vertices.
Otherwise fall back exactly to `canonicalize_directed!` using the embedded general workspace.
"""
function canonicalize_directed_packed!(
    buffer::DirectedCanonicalizationBuffer,
    packed::PackedDirectedCanonicalizationWorkspace,
    graph::DirectedGCGraph,
    vertex_colors::AbstractVector{<:Integer},
)::DirectedCanonicalizationBuffer
    if _prepare_packed_directed_rows!(packed, graph)
        return _canonicalize_directed_packed_prepared!(buffer, packed, graph, vertex_colors)
    end
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
    return canonicalize_directed!(buffer, packed.workspace, graph, vertex_colors)
end

function canonicalize_directed_packed!(
    buffer::DirectedCanonicalizationBuffer,
    packed::PackedDirectedCanonicalizationWorkspace,
    graph::DirectedGCGraphBuffer,
    vertex_colors::AbstractVector{<:Integer},
)::DirectedCanonicalizationBuffer
    n = graph.num_vertices
    length(vertex_colors) >= n ||
        throw(ArgumentError("vertex_colors must cover every active vertex."))
    active_colors = @view vertex_colors[1:n]
    return canonicalize_directed_packed!(
        buffer, packed, _directed_graph_view(graph), active_colors
    )
end
