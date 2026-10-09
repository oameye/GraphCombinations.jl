# --- Reusable production storage for directed canonicalization ---

"""
    DirectedCanonicalizationWorkspace(capacity)

Reusable flat scratch storage for repeated exact directed canonicalization of graphs with at most
`capacity` vertices. The workspace owns the complete individualization/refinement search scratch,
including one color column per possible search depth, flat refinement signatures,
ordering/count buffers, both witness orientations, and search counters.
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

function DirectedCanonicalizationWorkspace(capacity::Integer)
    n = Int(capacity)
    n >= 0 || throw(ArgumentError("capacity must be non-negative."))
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
    DirectedCanonicalizationBuffer(capacity)

Reusable output storage for `canonicalize_directed!` on graphs with at most `capacity` vertices.
It retains the active canonical multiplicity image, the old-vertex -> canonical-rank witness, the
inverse canonical-rank -> old-vertex order, and the exact color-preserving automorphism order
without constructing a fresh result object graph.
"""
mutable struct DirectedCanonicalizationBuffer
    canonical_multiplicities::Vector{Int}
    old_to_canonical::Vector{Int}
    canonical_to_old::Vector{Int}
    automorphism_order::Int
    num_vertices::Int
end

function DirectedCanonicalizationBuffer(capacity::Integer)
    n = Int(capacity)
    n >= 0 || throw(ArgumentError("capacity must be non-negative."))
    return DirectedCanonicalizationBuffer(
        Vector{Int}(undef, n * n), Vector{Int}(undef, n), Vector{Int}(undef, n), 0, n
    )
end

@inline function _check_directed_workspace_capacity(
    buffer::DirectedCanonicalizationBuffer,
    workspace::DirectedCanonicalizationWorkspace,
    graph::DirectedGCGraph,
)::Nothing
    n = graph.num_vertices
    length(workspace.colors) >= n || throw(
        DimensionMismatch("directed canonicalization workspace capacity is too small")
    )
    size(workspace.color_stack, 1) >= n && size(workspace.color_stack, 2) >= n + 1 || throw(
        DimensionMismatch("directed canonicalization workspace capacity is too small")
    )
    length(workspace.refined_colors) >= n || throw(
        DimensionMismatch("directed canonicalization workspace capacity is too small")
    )
    length(workspace.order) >= n || throw(
        DimensionMismatch("directed canonicalization workspace capacity is too small")
    )
    length(workspace.signatures) >= n * (1 + 2 * n) || throw(
        DimensionMismatch("directed canonicalization workspace capacity is too small")
    )
    length(workspace.cell_counts) >= n || throw(
        DimensionMismatch("directed canonicalization workspace capacity is too small")
    )
    length(workspace.inverse_mapping) >= n || throw(
        DimensionMismatch("directed canonicalization workspace capacity is too small")
    )
    length(workspace.best_inverse_mapping) >= n || throw(
        DimensionMismatch("directed canonicalization workspace capacity is too small")
    )
    length(buffer.old_to_canonical) >= n ||
        throw(DimensionMismatch("directed canonicalization buffer capacity is too small"))
    length(buffer.canonical_to_old) >= n ||
        throw(DimensionMismatch("directed canonicalization buffer capacity is too small"))
    length(buffer.canonical_multiplicities) >= n * n ||
        throw(DimensionMismatch("directed canonicalization buffer capacity is too small"))
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
    workspace::DirectedCanonicalizationWorkspace, n::Int
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
        workspace.color_stack[vertex, 1] = next_color
    end
    return nothing
end

function _directed_workspace_refine_once!(
    workspace::DirectedCanonicalizationWorkspace, graph::DirectedGCGraph, depth::Int
)::Bool
    n = graph.num_vertices
    iszero(n) && return true

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
    @inbounds for color in 1:n
        workspace.cell_counts[color] = 0
    end
    num_colors = 0
    @inbounds for vertex in 1:n
        color = workspace.color_stack[vertex, depth]
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

@inline function _directed_workspace_exact_twins(
    graph::DirectedGCGraph, left::Int, right::Int
)::Bool
    left == right && return true
    n = graph.num_vertices
    multiplicities = graph.multiplicities
    @inbounds begin
        multiplicities[_directed_slot(left, left, n)] ==
        multiplicities[_directed_slot(right, right, n)] || return false
        multiplicities[_directed_slot(left, right, n)] ==
        multiplicities[_directed_slot(right, left, n)] || return false
        for other in 1:n
            (other == left || other == right) && continue
            multiplicities[_directed_slot(left, other, n)] ==
            multiplicities[_directed_slot(right, other, n)] || return false
            multiplicities[_directed_slot(other, left, n)] ==
            multiplicities[_directed_slot(other, right, n)] || return false
        end
    end
    return true
end

function _record_directed_workspace_candidate!(
    workspace::DirectedCanonicalizationWorkspace, graph::DirectedGCGraph, multiplicity::Int
)::Nothing
    n = graph.num_vertices
    if !workspace.has_best
        iszero(n) ||
            copyto!(workspace.best_inverse_mapping, 1, workspace.inverse_mapping, 1, n)
        workspace.automorphism_order = multiplicity
        workspace.has_best = true
        return nothing
    end

    comparison = _compare_directed_inverse_mappings(
        graph, workspace.inverse_mapping, workspace.best_inverse_mapping
    )
    if comparison < 0
        iszero(n) ||
            copyto!(workspace.best_inverse_mapping, 1, workspace.inverse_mapping, 1, n)
        workspace.automorphism_order = multiplicity
    elseif iszero(comparison)
        workspace.automorphism_order = Base.Checked.checked_add(
            workspace.automorphism_order, multiplicity
        )
    end
    return nothing
end

function _record_directed_workspace_leaf!(
    workspace::DirectedCanonicalizationWorkspace,
    graph::DirectedGCGraph,
    depth::Int,
    multiplicity::Int,
)::Nothing
    n = graph.num_vertices
    @inbounds for vertex in 1:n
        canonical_vertex = workspace.color_stack[vertex, depth]
        workspace.inverse_mapping[canonical_vertex] = vertex
    end
    workspace.search_leaves += 1
    _record_directed_workspace_candidate!(workspace, graph, multiplicity)
    return nothing
end

function _search_directed_partition_workspace!(
    workspace::DirectedCanonicalizationWorkspace,
    graph::DirectedGCGraph,
    depth::Int,
    multiplicity::Int,
)::Nothing
    workspace.search_nodes += 1
    _directed_workspace_refine!(workspace, graph, depth)
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
        _search_directed_partition_workspace!(
            workspace, graph, child_depth, child_multiplicity
        )
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
    iszero(n) || copyto!(buffer.canonical_to_old, 1, best_inverse_mapping, 1, n)
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
    buffer.num_vertices = n
    return nothing
end

"""
    canonicalize_directed!(buffer, workspace, graph, vertex_colors)

Canonicalize `graph` using reusable flat output and search storage. The buffer and workspace may
have greater capacity than the active graph. Once prepared, refinement, individualization, leaf
comparison, and witness construction do not create per-search vectors or canonical graph objects.
"""
function canonicalize_directed!(
    buffer::DirectedCanonicalizationBuffer,
    workspace::DirectedCanonicalizationWorkspace,
    graph::DirectedGCGraph,
    vertex_colors::AbstractVector{<:Integer},
)::DirectedCanonicalizationBuffer
    n = graph.num_vertices
    length(vertex_colors) == n ||
        throw(ArgumentError("vertex_colors must have one entry per vertex."))
    _check_directed_workspace_capacity(buffer, workspace, graph)
    @inbounds for vertex in 1:n
        workspace.colors[vertex] = Int(vertex_colors[vertex])
    end

    _reset_directed_workspace_search!(workspace)
    _directed_workspace_initialize_colors!(workspace, n)
    _search_directed_partition_workspace!(workspace, graph, 1, 1)
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
    n = graph.num_vertices
    _check_directed_workspace_capacity(buffer, workspace, graph)
    @inbounds for vertex in 1:n
        workspace.colors[vertex] = 1
    end
    _reset_directed_workspace_search!(workspace)
    _directed_workspace_initialize_colors!(workspace, n)
    _search_directed_partition_workspace!(workspace, graph, 1, 1)
    workspace.has_best ||
        error("Internal error: directed canonical search produced no candidate.")
    _write_directed_buffer!(
        buffer, graph, workspace.best_inverse_mapping, workspace.automorphism_order
    )
    return buffer
end

"""Return the canonical rank of one old vertex from the active in-place result."""
@inline function canonical_rank(
    buffer::DirectedCanonicalizationBuffer, old_vertex::Integer
)::Int
    vertex = Int(old_vertex)
    1 <= vertex <= buffer.num_vertices ||
        throw(BoundsError(buffer.old_to_canonical, vertex))
    return buffer.old_to_canonical[vertex]
end

"""Return the old vertex occupying one canonical rank from the active in-place result."""
@inline function original_vertex(
    buffer::DirectedCanonicalizationBuffer, canonical_vertex::Integer
)::Int
    vertex = Int(canonical_vertex)
    1 <= vertex <= buffer.num_vertices ||
        throw(BoundsError(buffer.canonical_to_old, vertex))
    return buffer.canonical_to_old[vertex]
end

function canonical_graph(buffer::DirectedCanonicalizationBuffer)::DirectedGCGraph
    n = buffer.num_vertices
    multiplicities = Vector{Int}(undef, n * n)
    iszero(n) || copyto!(multiplicities, 1, buffer.canonical_multiplicities, 1, n * n)
    return DirectedGCGraph(n, multiplicities)
end

canonical_automorphism_order(buffer::DirectedCanonicalizationBuffer)::Int =
    buffer.automorphism_order
