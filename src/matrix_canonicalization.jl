# --- Multiplicity-Matrix Canonical Comparison ---

@inline function _inverse_mapped_vertex(
    vertex::Int, inverse_permutation::Vector{Int}, first_internal::Int, last_internal::Int
)::Int
    return if first_internal <= vertex <= last_internal
        inverse_permutation[vertex - first_internal + 1]
    else
        vertex
    end
end

function _write_inverse_permutation!(
    inverse_permutation::Vector{Int}, permutation::Vector{Int}, first_internal::Int
)::Nothing
    @inbounds for index in eachindex(permutation)
        inverse_permutation[permutation[index] - first_internal + 1] =
            first_internal + index - 1
    end
    return nothing
end

function _mapped_multiplicity_is_lexless(
    matrix::Matrix{Int},
    candidate_inverse::Vector{Int},
    best_inverse::Vector{Int},
    first_internal::Int,
    last_internal::Int,
)::Bool
    num_vertices = size(matrix, 1)

    # A sorted GraphRep is the edge-pair sequence
    #
    #   (1,1), (1,2), ..., (2,2), ...
    #
    # with each pair repeated by its multiplicity. All labelings have the same total edge count.
    # Therefore, at the first pair whose multiplicity differs, the labeling with *more* copies of
    # that earlier pair has the lexicographically smaller sorted edge list.
    @inbounds for u in 1:num_vertices
        candidate_u = _inverse_mapped_vertex(
            u, candidate_inverse, first_internal, last_internal
        )
        best_u = _inverse_mapped_vertex(u, best_inverse, first_internal, last_internal)
        for v in u:num_vertices
            candidate_v = _inverse_mapped_vertex(
                v, candidate_inverse, first_internal, last_internal
            )
            best_v = _inverse_mapped_vertex(v, best_inverse, first_internal, last_internal)
            candidate_multiplicity = matrix[candidate_u, candidate_v]
            best_multiplicity = matrix[best_u, best_v]
            candidate_multiplicity == best_multiplicity && continue
            return candidate_multiplicity > best_multiplicity
        end
    end
    return false
end

function _materialize_mapped_graph(
    matrix::Matrix{Int},
    inverse_permutation::Vector{Int},
    first_internal::Int,
    last_internal::Int,
    num_edges::Int,
)::GraphRep
    graph = Vector{Edge}(undef, num_edges)
    edge_index = 1
    num_vertices = size(matrix, 1)

    @inbounds for u in 1:num_vertices
        source_u = _inverse_mapped_vertex(
            u, inverse_permutation, first_internal, last_internal
        )
        for v in u:num_vertices
            source_v = _inverse_mapped_vertex(
                v, inverse_permutation, first_internal, last_internal
            )
            multiplicity = matrix[source_u, source_v]
            for _ in 1:multiplicity
                graph[edge_index] = Edge(u, v)
                edge_index += 1
            end
        end
    end

    edge_index == num_edges + 1 ||
        error("Internal error: multiplicity matrix changed the graph edge count.")
    return graph
end

"""
    _canonical_form_multiplicity_permutations(graph, internal_indices)

Exact internal canonicalizer that traverses the same complete internal-label permutation orbit as
`_canonical_form_inplace_permutations`, but compares mapped multigraphs directly through one
multiplicity matrix instead of rebuilding and sorting an edge vector for every permutation. The
winning sorted `GraphRep` is materialized only once after the exhaustive search.

The row-state generator uses this helper for its final conversion to the package's existing public
canonical-label convention. Public `canonical_form` and `_allgraphs_direct` deliberately retain the
independent in-place edge-list implementation.
"""
function _canonical_form_multiplicity_permutations(
    graph::GraphRep, internal_indices::UnitRange{Int}
)::GraphRep
    length(internal_indices) < 2 && return sort_graph_edges(graph)

    first_internal = first(internal_indices)
    last_internal = last(internal_indices)
    max_graph_vertex =
        isempty(graph) ? 0 : maximum(max(edge.first, edge.second) for edge in graph)
    num_vertices = max(last_internal, max_graph_vertex)
    matrix = _graph_multiplicity_matrix(graph, num_vertices)

    permutation = collect(internal_indices)
    inverse_permutation = copy(permutation)
    best_inverse_permutation = copy(inverse_permutation)

    while _next_permutation!(permutation)
        _write_inverse_permutation!(inverse_permutation, permutation, first_internal)
        if _mapped_multiplicity_is_lexless(
            matrix,
            inverse_permutation,
            best_inverse_permutation,
            first_internal,
            last_internal,
        )
            copyto!(best_inverse_permutation, inverse_permutation)
        end
    end

    return _materialize_mapped_graph(
        matrix, best_inverse_permutation, first_internal, last_internal, length(graph)
    )
end
