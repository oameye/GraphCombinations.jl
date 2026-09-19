# --- Word-sized native relation canonicalization ---

"""
    PackedDirectedRelationCanonicalizationWorkspace(vertex_capacity, relation_capacity)

Reusable exact search storage for simple native directed relation graphs with at most 64 vertices.
Each fixed relation owns packed UInt64 in/out rows. Equitable-refinement signatures are stored as
UInt8 coordinates and ordered by stable counting/radix passes, avoiding both heap-allocated
signature objects and overflow-prone mixed-radix integer packing.

Search uses the same recursive stabilizer/orbit policy as the one-relation production kernel.
"""
mutable struct PackedDirectedRelationCanonicalizationWorkspace
    vertex_capacity::Int
    relation_capacity::Int
    signature_stride::Int
    colors::Vector{Int}
    color_stack::Matrix{UInt8}
    refined_colors::Vector{UInt8}
    signatures::Vector{UInt8}
    order::Vector{Int}
    scratch_order::Vector{Int}
    histogram::Vector{Int}
    cell_masks::Vector{UInt64}
    cell_counts::Vector{Int}
    out_rows::Vector{UInt64}
    in_rows::Vector{UInt64}
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
    search_nodes::Int
    search_leaves::Int
    refinement_rounds::Int
    total_orbit_skips::Int
    total_orbit_merges::Int
    total_automorphisms::Int
end

function PackedDirectedRelationCanonicalizationWorkspace(
    vertex_capacity::Integer, relation_capacity::Integer
)
    n = Int(vertex_capacity)
    nr = Int(relation_capacity)
    0 <= n <= 64 || throw(ArgumentError("packed relation kernel requires capacity <= 64"))
    nr >= 0 || throw(ArgumentError("relation_capacity must be non-negative"))
    stride = Base.Checked.checked_add(1, Base.Checked.checked_mul(2 * n, nr))
    depth_capacity = n + 1
    flat_depth = Base.Checked.checked_mul(max(n, 1), depth_capacity)
    flat_rows = Base.Checked.checked_mul(n, nr)
    return PackedDirectedRelationCanonicalizationWorkspace(
        n,
        nr,
        stride,
        Vector{Int}(undef, n),
        Matrix{UInt8}(undef, n, depth_capacity),
        Vector{UInt8}(undef, n),
        Vector{UInt8}(undef, Base.Checked.checked_mul(n, stride)),
        Vector{Int}(undef, n),
        Vector{Int}(undef, n),
        zeros(Int, 65),
        zeros(UInt64, n),
        zeros(Int, n),
        zeros(UInt64, flat_rows),
        zeros(UInt64, flat_rows),
        Vector{Int}(undef, flat_depth),
        Vector{Int}(undef, flat_depth),
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
        0,
        0,
        0,
    )
end

@inline _packed_relation_bit(vertex::Int)::UInt64 = UInt64(1) << (vertex - 1)

@inline function _packed_relation_row_slot(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    relation::Int,
    vertex::Int,
)::Int
    return (relation - 1) * workspace.vertex_capacity + vertex
end

@inline function _packed_relation_depth_slot(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    depth::Int,
    vertex::Int,
)::Int
    return (depth - 1) * max(workspace.vertex_capacity, 1) + vertex
end

function _prepare_packed_relation_rows!(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
)::Bool
    n = graph.num_vertices
    nr = graph.num_relations
    n <= workspace.vertex_capacity || return false
    n <= 64 || return false
    nr <= workspace.relation_capacity || return false

    @inbounds for relation in 1:nr, vertex in 1:n
        slot = _packed_relation_row_slot(workspace, relation, vertex)
        workspace.out_rows[slot] = 0
        workspace.in_rows[slot] = 0
    end
    @inbounds for relation in 1:nr, source in 1:n, target in 1:n
        multiplicity = _directed_relation_multiplicity(graph, relation, source, target)
        multiplicity <= 1 || return false
        iszero(multiplicity) && continue
        source_slot = _packed_relation_row_slot(workspace, relation, source)
        target_slot = _packed_relation_row_slot(workspace, relation, target)
        workspace.out_rows[source_slot] |= _packed_relation_bit(target)
        workspace.in_rows[target_slot] |= _packed_relation_bit(source)
    end
    return true
end

function _packed_relation_initialize_colors!(
    workspace::PackedDirectedRelationCanonicalizationWorkspace, n::Int
)::Nothing
    @inbounds for vertex in 1:n
        workspace.order[vertex] = vertex
    end
    @inbounds for index in 2:n
        vertex = workspace.order[index]
        value = workspace.colors[vertex]
        position = index - 1
        while position >= 1 && value < workspace.colors[workspace.order[position]]
            workspace.order[position + 1] = workspace.order[position]
            position -= 1
        end
        workspace.order[position + 1] = vertex
    end
    next_color = 0
    previous_value = 0
    @inbounds for index in 1:n
        vertex = workspace.order[index]
        value = workspace.colors[vertex]
        if index == 1 || value != previous_value
            next_color += 1
            previous_value = value
        end
        workspace.color_stack[vertex, 1] = UInt8(next_color)
    end
    return nothing
end

function _packed_relation_build_signatures!(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    depth::Int,
)::Int
    n = graph.num_vertices
    nr = graph.num_relations
    num_colors = 0
    @inbounds for cell in 1:n
        workspace.cell_masks[cell] = 0
    end
    @inbounds for vertex in 1:n
        color = Int(workspace.color_stack[vertex, depth])
        num_colors = max(num_colors, color)
        workspace.cell_masks[color] |= _packed_relation_bit(vertex)
    end

    signature_length = 1 + 2 * nr * num_colors
    stride = workspace.signature_stride
    @inbounds for vertex in 1:n
        offset = (vertex - 1) * stride
        workspace.signatures[offset + 1] = workspace.color_stack[vertex, depth]
        for relation in 1:nr
            row_slot = _packed_relation_row_slot(workspace, relation, vertex)
            out_row = workspace.out_rows[row_slot]
            in_row = workspace.in_rows[row_slot]
            for cell in 1:num_colors
                base = offset + 2 + 2 * ((relation - 1) * num_colors + cell - 1)
                mask = workspace.cell_masks[cell]
                workspace.signatures[base] = UInt8(count_ones(out_row & mask))
                workspace.signatures[base + 1] = UInt8(count_ones(in_row & mask))
            end
        end
    end
    return signature_length
end

function _packed_relation_radix_sort!(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    n::Int,
    signature_length::Int,
)::Nothing
    stride = workspace.signature_stride
    @inbounds for vertex in 1:n
        workspace.order[vertex] = vertex
    end
    @inbounds for coordinate in signature_length:-1:1
        for bucket in 1:65
            workspace.histogram[bucket] = 0
        end
        for index in 1:n
            vertex = workspace.order[index]
            value = Int(workspace.signatures[(vertex - 1) * stride + coordinate]) + 1
            workspace.histogram[value] += 1
        end
        position = 1
        for bucket in 1:65
            count = workspace.histogram[bucket]
            workspace.histogram[bucket] = position
            position += count
        end
        for index in 1:n
            vertex = workspace.order[index]
            value = Int(workspace.signatures[(vertex - 1) * stride + coordinate]) + 1
            destination = workspace.histogram[value]
            workspace.scratch_order[destination] = vertex
            workspace.histogram[value] = destination + 1
        end
        workspace.order, workspace.scratch_order = workspace.scratch_order, workspace.order
    end
    return nothing
end

@inline function _packed_relation_signatures_equal(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    left::Int,
    right::Int,
    signature_length::Int,
)::Bool
    stride = workspace.signature_stride
    left_offset = (left - 1) * stride
    right_offset = (right - 1) * stride
    @inbounds for coordinate in 1:signature_length
        workspace.signatures[left_offset + coordinate] ==
            workspace.signatures[right_offset + coordinate] || return false
    end
    return true
end

function _packed_relation_refine_once!(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    depth::Int,
)::Bool
    n = graph.num_vertices
    iszero(n) && return true
    signature_length = _packed_relation_build_signatures!(workspace, graph, depth)
    _packed_relation_radix_sort!(workspace, n, signature_length)

    next_color = 0
    previous_vertex = 0
    @inbounds for index in 1:n
        vertex = workspace.order[index]
        if iszero(previous_vertex) || !_packed_relation_signatures_equal(
            workspace, previous_vertex, vertex, signature_length
        )
            next_color += 1
        end
        workspace.refined_colors[vertex] = UInt8(next_color)
        previous_vertex = vertex
    end

    stable = true
    @inbounds for vertex in 1:n
        refined = workspace.refined_colors[vertex]
        stable &= refined == workspace.color_stack[vertex, depth]
        workspace.color_stack[vertex, depth] = refined
    end
    workspace.refinement_rounds += 1
    return stable
end

function _packed_relation_refine!(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    depth::Int,
)::Nothing
    while !_packed_relation_refine_once!(workspace, graph, depth)
    end
    return nothing
end

function _packed_relation_target_color!(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    depth::Int,
)::Int
    n = graph.num_vertices
    @inbounds for color in 1:n
        workspace.cell_counts[color] = 0
    end
    num_colors = 0
    @inbounds for vertex in 1:n
        color = Int(workspace.color_stack[vertex, depth])
        workspace.cell_counts[color] += 1
        num_colors = max(num_colors, color)
    end
    target_color = 0
    target_size = typemax(Int)
    @inbounds for color in 1:num_colors
        count = workspace.cell_counts[color]
        if 1 < count < target_size
            target_color = color
            target_size = count
        end
    end
    return target_color
end

@inline function _packed_relation_orbit_find(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    depth::Int,
    vertex::Int,
)::Int
    root = vertex
    @inbounds while true
        parent = workspace.orbit_parent[_packed_relation_depth_slot(workspace, depth, root)]
        parent == root && return root
        root = parent
    end
end

function _packed_relation_orbit_union!(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    depth::Int,
    left::Int,
    right::Int,
)::Nothing
    left_root = _packed_relation_orbit_find(workspace, depth, left)
    right_root = _packed_relation_orbit_find(workspace, depth, right)
    left_root == right_root && return nothing
    @inbounds workspace.orbit_parent[
        _packed_relation_depth_slot(workspace, depth, right_root)
    ] = left_root
    workspace.orbit_merges[depth] += 1
    workspace.total_orbit_merges += 1
    return nothing
end

function _packed_relation_initialize_node!(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    depth::Int,
    target_color::Int,
)::UInt64
    n = graph.num_vertices
    target_mask = UInt64(0)
    @inbounds for vertex in 1:n
        if Int(workspace.color_stack[vertex, depth]) == target_color
            target_mask |= _packed_relation_bit(vertex)
        end
        workspace.orbit_parent[_packed_relation_depth_slot(workspace, depth, vertex)] = vertex
    end
    workspace.target_masks[depth] = target_mask
    workspace.explored_masks[depth] = 0
    workspace.best_vertices[depth] = 0
    workspace.best_child_orders[depth] = 0
    workspace.has_best[depth] = false
    workspace.orbit_skips[depth] = 0
    workspace.orbit_merges[depth] = 0
    workspace.automorphisms[depth] = 0
    return target_mask
end

function _packed_relation_seed_twins!(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    depth::Int,
    chosen_vertex::Int,
    target_mask::UInt64,
)::Nothing
    members = target_mask
    @inbounds while !iszero(members)
        other = trailing_zeros(members) + 1
        members &= members - UInt64(1)
        other > chosen_vertex || continue
        if _relation_exact_twins(graph, chosen_vertex, other)
            _packed_relation_orbit_union!(workspace, depth, chosen_vertex, other)
        end
    end
    return nothing
end

function _packed_relation_candidate_explored(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    depth::Int,
    chosen_vertex::Int,
)::Bool
    chosen_root = _packed_relation_orbit_find(workspace, depth, chosen_vertex)
    explored = workspace.explored_masks[depth]
    @inbounds while !iszero(explored)
        earlier = trailing_zeros(explored) + 1
        if _packed_relation_orbit_find(workspace, depth, earlier) == chosen_root
            return true
        end
        explored &= explored - UInt64(1)
    end
    return false
end

function _packed_relation_orbit_size(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    depth::Int,
    vertex::Int,
)::Int
    root = _packed_relation_orbit_find(workspace, depth, vertex)
    count = 0
    members = workspace.target_masks[depth]
    @inbounds while !iszero(members)
        other = trailing_zeros(members) + 1
        count += _packed_relation_orbit_find(workspace, depth, other) == root
        members &= members - UInt64(1)
    end
    return count
end

function _packed_relation_copy_leaf!(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    depth::Int,
)::Nothing
    n = graph.num_vertices
    @inbounds for vertex in 1:n
        canonical_vertex = Int(workspace.color_stack[vertex, depth])
        workspace.best_inverse[
            _packed_relation_depth_slot(workspace, depth, canonical_vertex)
        ] = vertex
    end
    workspace.search_leaves += 1
    workspace.has_best[depth] = true
    return nothing
end

function _packed_relation_copy_child_best!(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    parent_depth::Int,
    child_depth::Int,
)::Nothing
    n = graph.num_vertices
    @inbounds for canonical_vertex in 1:n
        workspace.best_inverse[
            _packed_relation_depth_slot(workspace, parent_depth, canonical_vertex)
        ] = workspace.best_inverse[
            _packed_relation_depth_slot(workspace, child_depth, canonical_vertex)
        ]
    end
    return nothing
end

function _packed_relation_compare_child(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    parent_depth::Int,
    child_depth::Int,
)::Int
    n = graph.num_vertices
    @inbounds for relation in 1:(graph.num_relations), canonical_source in 1:n
        child_source = workspace.best_inverse[
            _packed_relation_depth_slot(workspace, child_depth, canonical_source)
        ]
        best_source = workspace.best_inverse[
            _packed_relation_depth_slot(workspace, parent_depth, canonical_source)
        ]
        for canonical_target in 1:n
            child_target = workspace.best_inverse[
                _packed_relation_depth_slot(workspace, child_depth, canonical_target)
            ]
            best_target = workspace.best_inverse[
                _packed_relation_depth_slot(workspace, parent_depth, canonical_target)
            ]
            child_value = _directed_relation_multiplicity(
                graph, relation, child_source, child_target
            )
            best_value = _directed_relation_multiplicity(
                graph, relation, best_source, best_target
            )
            child_value == best_value && continue
            return child_value < best_value ? -1 : 1
        end
    end
    return 0
end

function _packed_relation_record_automorphism!(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    depth::Int,
    child_depth::Int,
)::Nothing
    n = graph.num_vertices
    target_mask = workspace.target_masks[depth]
    @inbounds for canonical_vertex in 1:n
        best_vertex = workspace.best_inverse[
            _packed_relation_depth_slot(workspace, depth, canonical_vertex)
        ]
        child_vertex = workspace.best_inverse[
            _packed_relation_depth_slot(workspace, child_depth, canonical_vertex)
        ]
        iszero(target_mask & _packed_relation_bit(best_vertex)) && continue
        iszero(target_mask & _packed_relation_bit(child_vertex)) &&
            error("relation stabilizer automorphism left the active target cell")
        _packed_relation_orbit_union!(workspace, depth, best_vertex, child_vertex)
    end
    workspace.automorphisms[depth] += 1
    workspace.total_automorphisms += 1
    return nothing
end

function _packed_relation_individualize!(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    depth::Int,
    child_depth::Int,
    target_color::Int,
    chosen_vertex::Int,
)::Nothing
    n = graph.num_vertices
    @inbounds for vertex in 1:n
        color = Int(workspace.color_stack[vertex, depth])
        workspace.color_stack[vertex, child_depth] = UInt8(if color < target_color
            color
        elseif color > target_color
            color + 1
        elseif vertex == chosen_vertex
            target_color
        else
            target_color + 1
        end)
    end
    return nothing
end

function _packed_relation_search!(
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    depth::Int,
)::Int
    workspace.search_nodes += 1
    _packed_relation_refine!(workspace, graph, depth)
    target_color = _packed_relation_target_color!(workspace, graph, depth)
    if iszero(target_color)
        _packed_relation_copy_leaf!(workspace, graph, depth)
        return 1
    end

    target_mask = _packed_relation_initialize_node!(workspace, graph, depth, target_color)
    child_depth = depth + 1
    n = graph.num_vertices
    @inbounds for chosen_vertex in 1:n
        iszero(target_mask & _packed_relation_bit(chosen_vertex)) && continue
        if _packed_relation_candidate_explored(workspace, depth, chosen_vertex)
            workspace.orbit_skips[depth] += 1
            workspace.total_orbit_skips += 1
            continue
        end

        _packed_relation_seed_twins!(workspace, graph, depth, chosen_vertex, target_mask)
        workspace.explored_masks[depth] |= _packed_relation_bit(chosen_vertex)
        _packed_relation_individualize!(
            workspace, graph, depth, child_depth, target_color, chosen_vertex
        )
        child_order = _packed_relation_search!(workspace, graph, child_depth)

        if !workspace.has_best[depth]
            _packed_relation_copy_child_best!(workspace, graph, depth, child_depth)
            workspace.best_vertices[depth] = chosen_vertex
            workspace.best_child_orders[depth] = child_order
            workspace.has_best[depth] = true
            continue
        end

        comparison = _packed_relation_compare_child(
            workspace, graph, depth, child_depth
        )
        if comparison < 0
            _packed_relation_copy_child_best!(workspace, graph, depth, child_depth)
            workspace.best_vertices[depth] = chosen_vertex
            workspace.best_child_orders[depth] = child_order
        elseif iszero(comparison)
            child_order == workspace.best_child_orders[depth] ||
                error("equal relation child branches have unequal stabilizer orders")
            _packed_relation_record_automorphism!(workspace, graph, depth, child_depth)
        end
    end

    workspace.has_best[depth] || error("packed relation search produced no child")
    best_vertex = workspace.best_vertices[depth]
    orbit_size = _packed_relation_orbit_size(workspace, depth, best_vertex)
    return Base.Checked.checked_mul(orbit_size, workspace.best_child_orders[depth])
end

function _reset_packed_relation_search!(
    workspace::PackedDirectedRelationCanonicalizationWorkspace
)::Nothing
    fill!(workspace.target_masks, 0)
    fill!(workspace.explored_masks, 0)
    fill!(workspace.best_vertices, 0)
    fill!(workspace.best_child_orders, 0)
    fill!(workspace.has_best, false)
    fill!(workspace.orbit_skips, 0)
    fill!(workspace.orbit_merges, 0)
    fill!(workspace.automorphisms, 0)
    workspace.search_nodes = 0
    workspace.search_leaves = 0
    workspace.refinement_rounds = 0
    workspace.total_orbit_skips = 0
    workspace.total_orbit_merges = 0
    workspace.total_automorphisms = 0
    return nothing
end

function _check_packed_relation_capacity(
    buffer::DirectedRelationCanonicalizationBuffer,
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
)::Nothing
    n = graph.num_vertices
    nr = graph.num_relations
    n <= workspace.vertex_capacity ||
        throw(DimensionMismatch("packed relation workspace vertex capacity is too small"))
    nr <= workspace.relation_capacity ||
        throw(DimensionMismatch("packed relation workspace relation capacity is too small"))
    n <= buffer.vertex_capacity ||
        throw(DimensionMismatch("directed relation result vertex capacity is too small"))
    nr <= buffer.relation_capacity ||
        throw(DimensionMismatch("directed relation result relation capacity is too small"))
    return nothing
end

function canonicalize_directed_relations!(
    buffer::DirectedRelationCanonicalizationBuffer,
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    vertex_colors::AbstractVector{<:Integer},
)::DirectedRelationCanonicalizationBuffer
    n = graph.num_vertices
    length(vertex_colors) == n ||
        throw(ArgumentError("vertex_colors must have one entry per vertex."))
    _check_packed_relation_capacity(buffer, workspace, graph)
    _prepare_packed_relation_rows!(workspace, graph) || throw(
        ArgumentError(
            "packed relation kernel requires a simple native relation graph with n <= 64",
        ),
    )
    @inbounds for vertex in 1:n
        workspace.colors[vertex] = Int(vertex_colors[vertex])
    end
    _reset_packed_relation_search!(workspace)
    _packed_relation_initialize_colors!(workspace, n)
    automorphism_order = _packed_relation_search!(workspace, graph, 1)
    workspace.has_best[1] || error("packed relation search produced no canonical leaf")
    @inbounds for canonical_vertex in 1:n
        workspace.order[canonical_vertex] = workspace.best_inverse[
            _packed_relation_depth_slot(workspace, 1, canonical_vertex)
        ]
    end
    _write_relation_buffer!(buffer, graph, workspace.order, automorphism_order)
    return buffer
end

function canonicalize_directed_relations!(
    buffer::DirectedRelationCanonicalizationBuffer,
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
)::DirectedRelationCanonicalizationBuffer
    n = graph.num_vertices
    @inbounds for vertex in 1:n
        workspace.colors[vertex] = 1
    end
    return canonicalize_directed_relations!(
        buffer, workspace, graph, @view(workspace.colors[1:n])
    )
end

function canonicalize_directed_relations!(
    buffer::DirectedRelationCanonicalizationBuffer,
    workspace::PackedDirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraphBuffer,
    vertex_colors::AbstractVector{<:Integer},
)::DirectedRelationCanonicalizationBuffer
    n = graph.num_vertices
    length(vertex_colors) >= n ||
        throw(ArgumentError("vertex_colors must cover every active vertex."))
    return canonicalize_directed_relations!(
        buffer,
        workspace,
        _directed_relation_graph_view(graph),
        @view(vertex_colors[1:n]),
    )
end
