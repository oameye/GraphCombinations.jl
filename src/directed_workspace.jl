# --- Reusable production storage for directed canonicalization ---

"""
    DirectedCanonicalizationWorkspace(num_vertices)

Reusable flat scratch storage for repeated exact directed canonicalization at one graph size.
The workspace owns the complete individualization/refinement search scratch, including one color
column per possible search depth, flat refinement signatures, ordering/count buffers, both witness
orientations, and search counters.
"""
mutable struct DirectedCanonicalizationWorkspace
    colors::Vector{Int}
    color_stack::Matrix{Int}
    refined_colors::Vector{Int}
    order::Vector{Int}
    signatures::Vector{Int}
    cell_counts::Vector{Int}
    inverse_mapping::Vector{Int}
    best_inverse_mapping::Vector{Int}
    automorphism_order::Int
    has_best::Bool
    search_nodes::Int
    search_leaves::Int
    refinement_rounds::Int
end

function DirectedCanonicalizationWorkspace(num_vertices::Integer)
    n = Int(num_vertices)
    n >= 0 || throw(ArgumentError("num_vertices must be non-negative."))
    return DirectedCanonicalizationWorkspace(
        Vector{Int}(undef, n),
        Matrix{Int}(undef, n, n + 1),
        Vector{Int}(undef, n),
        Vector{Int}(undef, n),
        Vector{Int}(undef, n * (1 + 2 * n)),
        Vector{Int}(undef, n),
        Vector{Int}(undef, n),
        Vector{Int}(undef, n),
        0,
        false,
        0,
        0,
        0,
    )
end

"""
    DirectedCanonicalizationBuffer(num_vertices)

Reusable output storage for `canonicalize_directed!`. It retains the canonical multiplicity image,
the old-vertex -> canonical-rank witness, the inverse canonical-rank -> old-vertex order, and the
exact color-preserving automorphism order without constructing a fresh result object graph.
"""
mutable struct DirectedCanonicalizationBuffer
    canonical_multiplicities::Vector{Int}
    old_to_canonical::Vector{Int}
    canonical_to_old::Vector{Int}
    automorphism_order::Int
end

function DirectedCanonicalizationBuffer(num_vertices::Integer)
    n = Int(num_vertices)
    n >= 0 || throw(ArgumentError("num_vertices must be non-negative."))
    return DirectedCanonicalizationBuffer(
        Vector{Int}(undef, n * n), Vector{Int}(undef, n), Vector{Int}(undef, n), 0
    )
end

@inline function _check_directed_workspace_size(
    buffer::DirectedCanonicalizationBuffer,
    workspace::DirectedCanonicalizationWorkspace,
    graph::DirectedGCGraph,
)::Nothing
    n = graph.num_vertices
    length(workspace.colors) == n ||
        throw(DimensionMismatch("directed canonicalization workspace has the wrong size"))
    size(workspace.color_stack) == (n, n + 1) ||
        throw(DimensionMismatch("directed canonicalization workspace has the wrong size"))
    length(workspace.refined_colors) == n ||
        throw(DimensionMismatch("directed canonicalization workspace has the wrong size"))
    length(workspace.order) == n ||
        throw(DimensionMismatch("directed canonicalization workspace has the wrong size"))
    length(workspace.signatures) == n * (1 + 2 * n) ||
        throw(DimensionMismatch("directed canonicalization workspace has the wrong size"))
    length(workspace.cell_counts) == n ||
        throw(DimensionMismatch("directed canonicalization workspace has the wrong size"))
    length(workspace.inverse_mapping) == n ||
        throw(DimensionMismatch("directed canonicalization workspace has the wrong size"))
    length(workspace.best_inverse_mapping) == n ||
        throw(DimensionMismatch("directed canonicalization workspace has the wrong size"))
    length(buffer.old_to_canonical) == n ||
        throw(DimensionMismatch("directed canonicalization buffer has the wrong size"))
    length(buffer.canonical_to_old) == n ||
        throw(DimensionMismatch("directed canonicalization buffer has the wrong size"))
    length(buffer.canonical_multiplicities) == n * n ||
        throw(DimensionMismatch("directed canonicalization buffer has the wrong size"))
    return nothing
end

@inline function _directed_workspace_signature_less(
    workspace::DirectedCanonicalizationWorkspace,
    left_vertex::Int,
    right_vertex::Int,
    signature_length::Int,
    stride::Int,
)::Bool
    left_offset = (left_vertex - 1) * stride
    right_offset = (right_vertex - 1) * stride
    @inbounds for coordinate in 1:signature_length
        left = workspace.signatures[left_offset + coordinate]
        right = workspace.signatures[right_offset + coordinate]
        left == right && continue
        return left < right
    end
    return false
end

function _directed_workspace_sort_signatures!(
    workspace::DirectedCanonicalizationWorkspace, n::Int, signature_length::Int, stride::Int
)::Nothing
    @inbounds for vertex in 1:n
        workspace.order[vertex] = vertex
    end
    @inbounds for index in 2:n
        vertex = workspace.order[index]
        position = index - 1
        while position >= 1 && _directed_workspace_signature_less(
            workspace, vertex, workspace.order[position], signature_length, stride
        )
            workspace.order[position + 1] = workspace.order[position]
            position -= 1
        end
        workspace.order[position + 1] = vertex
    end
    return nothing
end

function _directed_workspace_initialize_colors!(
    workspace::DirectedCanonicalizationWorkspace
)::Nothing
    n = length(workspace.colors)
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
        workspace.color_stack[vertex, 1] = next_color
    end
    return nothing
end

function _directed_workspace_refine_once!(
    workspace::DirectedCanonicalizationWorkspace, graph::DirectedGCGraph, depth::Int
)::Bool
    n = graph.num_vertices
    isempty(workspace.colors) && return true

    num_colors = 0
    @inbounds for vertex in 1:n
        num_colors = max(num_colors, workspace.color_stack[vertex, depth])
    end
    stride = 1 + 2 * n
    signature_length = 1 + 2 * num_colors

    @inbounds for vertex in 1:n
        offset = (vertex - 1) * stride
        for coordinate in 1:signature_length
            workspace.signatures[offset + coordinate] = 0
        end
        workspace.signatures[offset + 1] = workspace.color_stack[vertex, depth]
    end

    @inbounds for vertex in 1:n
        offset = (vertex - 1) * stride
        for other in 1:n
            cell = workspace.color_stack[other, depth]
            workspace.signatures[offset + 2 * cell] += graph.multiplicities[_directed_slot(
                vertex, other, n
            )]
            workspace.signatures[offset + 2 * cell + 1] += graph.multiplicities[_directed_slot(
                other, vertex, n
            )]
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

function _directed_workspace_refine!(
    workspace::DirectedCanonicalizationWorkspace, graph::DirectedGCGraph, depth::Int
)::Nothing
    while !_directed_workspace_refine_once!(workspace, graph, depth)
    end
    return nothing
end

function _directed_workspace_target_color!(
    workspace::DirectedCanonicalizationWorkspace, graph::DirectedGCGraph, depth::Int
)::Int
    n = graph.num_vertices
    fill!(workspace.cell_counts, 0)
    num_colors = 0
    @inbounds for vertex in 1:n
        color = workspace.color_stack[vertex, depth]
        workspace.cell_counts[color] += 1
        num_colors = max(num_colors, color)
    end

    target_color = 0
    target_size = 1
    @inbounds for color in 1:num_colors
        count = workspace.cell_counts[color]
        if count > target_size
            target_color = color
            target_size = count
        end
    end
    return target_color
end

function _record_directed_workspace_candidate!(
    workspace::DirectedCanonicalizationWorkspace, graph::DirectedGCGraph
)::Nothing
    if !workspace.has_best
        copyto!(workspace.best_inverse_mapping, workspace.inverse_mapping)
        workspace.automorphism_order = 1
        workspace.has_best = true
        return nothing
    end

    comparison = _compare_directed_inverse_mappings(
        graph, workspace.inverse_mapping, workspace.best_inverse_mapping
    )
    if comparison < 0
        copyto!(workspace.best_inverse_mapping, workspace.inverse_mapping)
        workspace.automorphism_order = 1
    elseif iszero(comparison)
        workspace.automorphism_order = _checked_increment(workspace.automorphism_order)
    end
    return nothing
end

function _record_directed_workspace_leaf!(
    workspace::DirectedCanonicalizationWorkspace, graph::DirectedGCGraph, depth::Int
)::Nothing
    n = graph.num_vertices
    @inbounds for vertex in 1:n
        canonical_vertex = workspace.color_stack[vertex, depth]
        workspace.inverse_mapping[canonical_vertex] = vertex
    end
    workspace.search_leaves += 1
    _record_directed_workspace_candidate!(workspace, graph)
    return nothing
end

function _search_directed_partition_workspace!(
    workspace::DirectedCanonicalizationWorkspace, graph::DirectedGCGraph, depth::Int
)::Nothing
    workspace.search_nodes += 1
    _directed_workspace_refine!(workspace, graph, depth)
    target_color = _directed_workspace_target_color!(workspace, graph, depth)
    if iszero(target_color)
        _record_directed_workspace_leaf!(workspace, graph, depth)
        return nothing
    end

    n = graph.num_vertices
    child_depth = depth + 1
    @inbounds for chosen_vertex in 1:n
        workspace.color_stack[chosen_vertex, depth] == target_color || continue
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
        _search_directed_partition_workspace!(workspace, graph, child_depth)
    end
    return nothing
end

function _reset_directed_workspace_search!(
    workspace::DirectedCanonicalizationWorkspace
)::Nothing
    workspace.automorphism_order = 0
    workspace.has_best = false
    workspace.search_nodes = 0
    workspace.search_leaves = 0
    workspace.refinement_rounds = 0
    return nothing
end

function _write_directed_buffer!(
    buffer::DirectedCanonicalizationBuffer,
    graph::DirectedGCGraph,
    best_inverse_mapping::Vector{Int},
    automorphism_order::Int,
)::Nothing
    n = graph.num_vertices
    copyto!(buffer.canonical_to_old, best_inverse_mapping)
    @inbounds for canonical_vertex in 1:n
        old_vertex = best_inverse_mapping[canonical_vertex]
        buffer.old_to_canonical[old_vertex] = canonical_vertex
    end
    @inbounds for canonical_source in 1:n
        old_source = best_inverse_mapping[canonical_source]
        for canonical_target in 1:n
            old_target = best_inverse_mapping[canonical_target]
            buffer.canonical_multiplicities[_directed_slot(canonical_source, canonical_target, n)] = graph.multiplicities[_directed_slot(
                old_source, old_target, n
            )]
        end
    end
    buffer.automorphism_order = automorphism_order
    return nothing
end

"""
    canonicalize_directed!(buffer, workspace, graph, vertex_colors)

Canonicalize `graph` using reusable flat output and search storage. For a prepared workspace of the
correct graph size the successful hot path performs refinement, individualization, leaf comparison,
and witness construction without creating per-search vectors or canonical graph objects.
"""
function canonicalize_directed!(
    buffer::DirectedCanonicalizationBuffer,
    workspace::DirectedCanonicalizationWorkspace,
    graph::DirectedGCGraph,
    vertex_colors::AbstractVector{<:Integer},
)::DirectedCanonicalizationBuffer
    length(vertex_colors) == graph.num_vertices ||
        throw(ArgumentError("vertex_colors must have one entry per vertex."))
    _check_directed_workspace_size(buffer, workspace, graph)
    @inbounds for vertex in eachindex(workspace.colors)
        workspace.colors[vertex] = Int(vertex_colors[vertex])
    end

    _reset_directed_workspace_search!(workspace)
    _directed_workspace_initialize_colors!(workspace)
    _search_directed_partition_workspace!(workspace, graph, 1)
    workspace.has_best ||
        error("Internal error: directed canonical search produced no candidate.")
    _write_directed_buffer!(
        buffer, graph, workspace.best_inverse_mapping, workspace.automorphism_order
    )
    return buffer
end

function canonicalize_directed!(
    buffer::DirectedCanonicalizationBuffer,
    workspace::DirectedCanonicalizationWorkspace,
    graph::DirectedGCGraph,
)::DirectedCanonicalizationBuffer
    _check_directed_workspace_size(buffer, workspace, graph)
    fill!(workspace.colors, 1)
    _reset_directed_workspace_search!(workspace)
    _directed_workspace_initialize_colors!(workspace)
    _search_directed_partition_workspace!(workspace, graph, 1)
    workspace.has_best ||
        error("Internal error: directed canonical search produced no candidate.")
    _write_directed_buffer!(
        buffer, graph, workspace.best_inverse_mapping, workspace.automorphism_order
    )
    return buffer
end

"""Return the canonical rank of one old vertex from an in-place result buffer."""
@inline function canonical_rank(
    buffer::DirectedCanonicalizationBuffer, old_vertex::Integer
)::Int
    return buffer.old_to_canonical[Int(old_vertex)]
end

"""Return the old vertex occupying one canonical rank from an in-place result buffer."""
@inline function original_vertex(
    buffer::DirectedCanonicalizationBuffer, canonical_vertex::Integer
)::Int
    return buffer.canonical_to_old[Int(canonical_vertex)]
end

function canonical_graph(buffer::DirectedCanonicalizationBuffer)::DirectedGCGraph
    n = length(buffer.old_to_canonical)
    return DirectedGCGraph(n, copy(buffer.canonical_multiplicities))
end

canonical_automorphism_order(buffer::DirectedCanonicalizationBuffer)::Int =
    buffer.automorphism_order
