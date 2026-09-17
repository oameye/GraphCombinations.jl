# --- Packed one-word candidate for small simple directed graphs ---

"""
    PackedDirectedCanonicalizationWorkspace(capacity)

Research/production-candidate storage for exact directed canonicalization. It reuses the certified
`DirectedCanonicalizationWorkspace` search state and adds packed outgoing/incoming adjacency rows
plus one packed mask per active color cell. Graphs with at most 64 vertices and edge multiplicities
in `0:1` use the packed `UInt64` refinement kernel; all other graphs fall back exactly to the
existing general directed workspace.
"""
mutable struct PackedDirectedCanonicalizationWorkspace
    workspace::DirectedCanonicalizationWorkspace
    out_rows::Vector{UInt64}
    in_rows::Vector{UInt64}
    cell_masks::Vector{UInt64}
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

function _packed_directed_workspace_refine_once!(
    packed::PackedDirectedCanonicalizationWorkspace, graph::DirectedGCGraph, depth::Int
)::Bool
    workspace = packed.workspace
    n = graph.num_vertices
    iszero(n) && return true

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

    stride = 1 + 2 * n
    signature_length = 1 + 2 * num_colors
    @inbounds for vertex in 1:n
        offset = (vertex - 1) * stride
        workspace.signatures[offset + 1] = workspace.color_stack[vertex, depth]
        out_row = packed.out_rows[vertex]
        in_row = packed.in_rows[vertex]
        for color in 1:num_colors
            mask = packed.cell_masks[color]
            workspace.signatures[offset + 2 * color] = count_ones(out_row & mask)
            workspace.signatures[offset + 2 * color + 1] = count_ones(in_row & mask)
        end
    end

    _directed_workspace_sort_signatures!(workspace, n, signature_length, stride)
    next_color = 0
    previous_vertex = 0
    @inbounds for index in 1:n
        vertex = workspace.order[index]
        if iszero(previous_vertex) || _directed_workspace_signature_less(
            workspace, previous_vertex, vertex, signature_length, stride
        )
            next_color += 1
        end
        workspace.refined_colors[vertex] = next_color
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

function _packed_directed_workspace_refine!(
    packed::PackedDirectedCanonicalizationWorkspace, graph::DirectedGCGraph, depth::Int
)::Nothing
    while !_packed_directed_workspace_refine_once!(packed, graph, depth)
    end
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
        _record_directed_workspace_leaf!(workspace, graph, depth, multiplicity)
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
