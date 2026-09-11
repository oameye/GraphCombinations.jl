# --- Partition-aware Canonical Keys ---

struct PartitionCanonicalizationResult
    key::GraphRep
    automorphism_order::Int
    permutation_count::Int
end

@inline function _lexless_int_vectors(a::Vector{Int}, b::Vector{Int})::Bool
    @inbounds for i in eachindex(a, b)
        ai = a[i]
        bi = b[i]
        ai < bi && return true
        bi < ai && return false
    end
    return length(a) < length(b)
end

function _graph_multiplicity_matrix(graph::GraphRep, num_vertices::Int)::Matrix{Int}
    matrix = zeros(Int, num_vertices, num_vertices)
    for edge in graph
        u, v = edge.first, edge.second
        matrix[u, v] += 1
        u == v || (matrix[v, u] += 1)
    end
    return matrix
end

function _assign_partition_colors(signatures::Vector{Vector{Int}})::Vector{Int}
    isempty(signatures) && return Int[]

    order = collect(eachindex(signatures))
    sort!(order; lt=(i, j) -> _lexless_int_vectors(signatures[i], signatures[j]))

    colors = Vector{Int}(undef, length(signatures))
    color = 0
    previous = 0
    for index in order
        if iszero(previous) || signatures[index] != signatures[previous]
            color += 1
        end
        colors[index] = color
        previous = index
    end
    return colors
end

function _partition_cells(colors::Vector{Int}, internal_vertices::Vector{Int})
    isempty(colors) && return Vector{Vector{Int}}()

    cells = [Int[] for _ in 1:maximum(colors)]
    for (index, vertex) in pairs(internal_vertices)
        push!(cells[colors[index]], vertex)
    end
    return cells
end

function _initial_partition_colors(
    matrix::Matrix{Int},
    degrees::Vector{Int},
    internal_vertices::Vector{Int},
    num_external::Int,
)::Vector{Int}
    signatures = Vector{Vector{Int}}(undef, length(internal_vertices))
    for (index, vertex) in pairs(internal_vertices)
        signature = Vector{Int}(undef, 2 + num_external)
        signature[1] = degrees[vertex]
        signature[2] = matrix[vertex, vertex]
        @inbounds for external in 1:num_external
            signature[2 + external] = matrix[vertex, external]
        end
        signatures[index] = signature
    end
    return _assign_partition_colors(signatures)
end

function _refined_partition_signatures(
    matrix::Matrix{Int},
    colors::Vector{Int},
    internal_vertices::Vector{Int},
    num_external::Int,
)::Vector{Vector{Int}}
    cells = _partition_cells(colors, internal_vertices)
    signature_length = 2 + num_external + length(internal_vertices) - 1
    signatures = Vector{Vector{Int}}(undef, length(internal_vertices))

    for (index, vertex) in pairs(internal_vertices)
        signature = Vector{Int}(undef, signature_length)
        signature[1] = colors[index]
        signature[2] = matrix[vertex, vertex]

        position = 3
        @inbounds for external in 1:num_external
            signature[position] = matrix[vertex, external]
            position += 1
        end

        for cell in cells
            multiplicities = Int[]
            sizehint!(multiplicities, length(cell))
            for neighbor in cell
                neighbor == vertex && continue
                push!(multiplicities, matrix[vertex, neighbor])
            end
            sort!(multiplicities)
            for multiplicity in multiplicities
                signature[position] = multiplicity
                position += 1
            end
        end
        signatures[index] = signature
    end
    return signatures
end

function _stable_partition_cells(
    matrix::Matrix{Int},
    degrees::Vector{Int},
    internal_vertices::Vector{Int},
    num_external::Int,
)::Vector{Vector{Int}}
    colors = _initial_partition_colors(matrix, degrees, internal_vertices, num_external)
    while true
        signatures = _refined_partition_signatures(
            matrix, colors, internal_vertices, num_external
        )
        refined = _assign_partition_colors(signatures)
        refined == colors && return _partition_cells(refined, internal_vertices)
        colors = refined
    end
end

mutable struct _PartitionSearchState
    best::GraphRep
    candidate::GraphRep
    automorphism_order::Int
    permutation_count::Int
end

function _write_mapped_graph!(
    candidate::GraphRep, graph::GraphRep, mapping::Vector{Int}
)::Nothing
    @inbounds for index in eachindex(graph)
        edge = graph[index]
        u = mapping[edge.first]
        v = mapping[edge.second]
        candidate[index] = Edge(minmax(u, v)...)
    end
    sort!(candidate)
    return nothing
end

function _partition_search!(
    state::_PartitionSearchState,
    graph::GraphRep,
    cells::Vector{Vector{Int}},
    target_cells::Vector{Vector{Int}},
    mapping::Vector{Int},
    cell_index::Int,
)::Nothing
    if cell_index > length(cells)
        _write_mapped_graph!(state.candidate, graph, mapping)
        state.permutation_count += 1

        if state.permutation_count == 1
            copyto!(state.best, state.candidate)
            state.automorphism_order = 1
            return nothing
        end

        comparison = _compare_graph_reps(state.candidate, state.best)
        if comparison < 0
            copyto!(state.best, state.candidate)
            state.automorphism_order = 1
        elseif iszero(comparison)
            state.automorphism_order += 1
        end
        return nothing
    end

    cell = cells[cell_index]
    permutation = copy(target_cells[cell_index])
    while true
        @inbounds for index in eachindex(cell)
            mapping[cell[index]] = permutation[index]
        end
        _partition_search!(state, graph, cells, target_cells, mapping, cell_index + 1)
        _next_permutation!(permutation) || break
    end
    return nothing
end

"""
    _partition_canonicalize(graph, degrees, num_external)

Construct an internal isomorphism key from an exact, labeling-independent partition of the internal
vertices. The initial partition uses degree, self-loop multiplicity, and multiplicities to each fixed
external vertex. It is then refined by sorted edge-multiplicity signatures to every current cell until
stable. Only permutations within unresolved cells are explored.

The returned `key` is intended for internal topology deduplication and is deliberately distinct from
the public `canonical_form` contract. Public canonical representatives continue to use the legacy
lexicographic minimum over all internal labels. Because every automorphism preserves every refinement
cell, the multiplicity of the minimum within the residual search is the exact internal automorphism
order.
"""
function _partition_canonicalize(
    graph::GraphRep, degrees::Vector{Int}, num_external::Int
)::PartitionCanonicalizationResult
    num_vertices = length(degrees)
    0 <= num_external <= num_vertices ||
        throw(ArgumentError("num_external must lie in 0:num_vertices."))

    internal_vertices = collect((num_external + 1):num_vertices)
    if length(internal_vertices) < 2
        return PartitionCanonicalizationResult(sort_graph_edges(graph), 1, 1)
    end

    matrix = _graph_multiplicity_matrix(graph, num_vertices)
    cells = _stable_partition_cells(matrix, degrees, internal_vertices, num_external)

    mapping = collect(1:num_vertices)
    search_cells = Vector{Vector{Int}}()
    target_cells = Vector{Vector{Int}}()
    sizehint!(search_cells, length(cells))
    sizehint!(target_cells, length(cells))

    next_label = num_external + 1
    for cell in cells
        cell_length = length(cell)
        if cell_length == 1
            mapping[only(cell)] = next_label
        else
            push!(search_cells, cell)
            push!(target_cells, collect(next_label:(next_label + cell_length - 1)))
        end
        next_label += cell_length
    end

    if isempty(search_cells)
        key = similar(graph)
        _write_mapped_graph!(key, graph, mapping)
        return PartitionCanonicalizationResult(key, 1, 1)
    end

    state = _PartitionSearchState(similar(graph), similar(graph), 0, 0)
    _partition_search!(state, graph, search_cells, target_cells, mapping, 1)

    state.automorphism_order > 0 ||
        error("Internal error: partition-canonical orbit has no representative.")
    return PartitionCanonicalizationResult(
        state.best, state.automorphism_order, state.permutation_count
    )
end
