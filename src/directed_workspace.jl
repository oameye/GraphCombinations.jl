# --- Reusable production storage for directed canonicalization ---

"""
    DirectedCanonicalizationWorkspace(num_vertices)

Reusable scratch storage for repeated exact directed canonicalization at one graph size. The
workspace owns search colors and witness buffers; callers may reuse it across graphs with the same
number of vertices.
"""
mutable struct DirectedCanonicalizationWorkspace
    colors::Vector{Int}
    inverse_mapping::Vector{Int}
    best_inverse_mapping::Vector{Int}
end

function DirectedCanonicalizationWorkspace(num_vertices::Integer)
    n = Int(num_vertices)
    n >= 0 || throw(ArgumentError("num_vertices must be non-negative."))
    return DirectedCanonicalizationWorkspace(
        Vector{Int}(undef, n), Vector{Int}(undef, n), Vector{Int}(undef, n)
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

Canonicalize `graph` using reusable output and scratch storage. This entry point preserves the
same exact canonical convention as `canonicalize_directed`; subsequent #156 work moves refinement
and recursive-search scratch into the workspace so the warmed kernel can become allocation-free.
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

    state = _DirectedCanonicalSearchState(
        graph, workspace.inverse_mapping, workspace.best_inverse_mapping, 0, false
    )
    _search_directed_partition!(state, workspace.colors)
    state.has_best ||
        error("Internal error: directed canonical search produced no candidate.")
    _write_directed_buffer!(
        buffer, graph, state.best_inverse_mapping, state.automorphism_order
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
    state = _DirectedCanonicalSearchState(
        graph, workspace.inverse_mapping, workspace.best_inverse_mapping, 0, false
    )
    _search_directed_partition!(state, workspace.colors)
    state.has_best ||
        error("Internal error: directed canonical search produced no candidate.")
    _write_directed_buffer!(
        buffer, graph, state.best_inverse_mapping, state.automorphism_order
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
