# --- Native colored directed whole-graph canonical relabeling ---

"""
    DirectedGCGraph(edges, num_vertices)

GraphCombinations-owned directed multigraph representation for whole-graph canonicalization.
Each input pair is interpreted as `source => target`; orientation, self-loops, and parallel-edge
multiplicity are preserved exactly.
"""
struct DirectedGCGraph
    num_vertices::Int
    multiplicities::Vector{Int}
end

@inline _directed_slot(source::Int, target::Int, num_vertices::Int)::Int =
    (source - 1) * num_vertices + target

function DirectedGCGraph(
    edges::AbstractVector{<:Pair{<:Integer,<:Integer}}, num_vertices::Integer
)::DirectedGCGraph
    n = Int(num_vertices)
    n >= 0 || throw(ArgumentError("num_vertices must be non-negative."))
    multiplicities = zeros(Int, n * n)
    @inbounds for edge in edges
        source = Int(first(edge))
        target = Int(last(edge))
        1 <= source <= n || throw(ArgumentError("Source vertex $source is outside 1:$n."))
        1 <= target <= n || throw(ArgumentError("Target vertex $target is outside 1:$n."))
        multiplicities[_directed_slot(source, target, n)] += 1
    end
    return DirectedGCGraph(n, multiplicities)
end

function DirectedGCGraph(
    edges::AbstractVector{<:Pair{<:Integer,<:Integer}}
)::DirectedGCGraph
    n = if isempty(edges)
        0
    else
        maximum(max(Int(first(edge)), Int(last(edge))) for edge in edges)
    end
    return DirectedGCGraph(edges, n)
end

function Base.isequal(a::DirectedGCGraph, b::DirectedGCGraph)
    return a.num_vertices == b.num_vertices && isequal(a.multiplicities, b.multiplicities)
end
Base.:(==)(a::DirectedGCGraph, b::DirectedGCGraph) = isequal(a, b)
function Base.hash(graph::DirectedGCGraph, h::UInt)
    h = hash(DirectedGCGraph, h)
    h = hash(graph.num_vertices, h)
    return hash(graph.multiplicities, h)
end

"""
    VertexRelabeling(mapping)

Deterministic old-vertex to new-vertex relabeling witness. Use `vertex_mapping` to obtain a copy of
the mapping.
"""
struct VertexRelabeling
    _mapping::Vector{Int}

    function VertexRelabeling(mapping::AbstractVector{<:Integer})
        normalized = collect(Int, mapping)
        n = length(normalized)
        sort(normalized) == collect(1:n) ||
            throw(ArgumentError("Vertex relabeling must be a permutation of 1:n."))
        return new(normalized)
    end
end

"""Return a copy of the old-vertex to new-vertex mapping."""
vertex_mapping(relabeling::VertexRelabeling)::Vector{Int} = copy(relabeling._mapping)

function Base.isequal(a::VertexRelabeling, b::VertexRelabeling)
    return isequal(a._mapping, b._mapping)
end
Base.:(==)(a::VertexRelabeling, b::VertexRelabeling) = isequal(a, b)
function Base.hash(relabeling::VertexRelabeling, h::UInt)
    return hash(relabeling._mapping, hash(VertexRelabeling, h))
end

"""
Exact result of colored directed whole-graph canonicalization.

`canonical_graph` is the deterministic exact representative, `canonical_relabeling` maps old
vertices to their canonical labels, and `canonical_automorphism_order` is the exact stabilizer
order inside the color-preserving relabeling group.
"""
struct DirectedCanonicalizationResult
    _canonical::DirectedGCGraph
    _relabeling::VertexRelabeling
    _automorphism_order::Int
end

canonical_graph(result::DirectedCanonicalizationResult)::DirectedGCGraph = result._canonical
canonical_relabeling(result::DirectedCanonicalizationResult)::VertexRelabeling =
    result._relabeling
canonical_automorphism_order(result::DirectedCanonicalizationResult)::Int =
    result._automorphism_order

struct _AcceptAllRelabelings end
@inline (::_AcceptAllRelabelings)(::Vector{Int})::Bool = true

# Exhaustive helper retained as an independent small-graph oracle for the refined search.
function _directed_relabelings(vertex_colors::Vector{Int})::Vector{Vector{Int}}
    return _problem_relabelings(vertex_colors, 0, _AcceptAllRelabelings())
end

function _directed_coordinate_action(mapping::Vector{Int}, num_vertices::Int)::Vector{Int}
    length(mapping) == num_vertices ||
        error("Internal error: directed relabeling has the wrong size.")
    inverse_mapping = Vector{Int}(undef, num_vertices)
    _write_inverse_permutation!(inverse_mapping, mapping, 1)

    action = Vector{Int}(undef, num_vertices * num_vertices)
    @inbounds for new_source in 1:num_vertices
        old_source = inverse_mapping[new_source]
        for new_target in 1:num_vertices
            old_target = inverse_mapping[new_target]
            action[_directed_slot(new_source, new_target, num_vertices)] = _directed_slot(
                old_source, old_target, num_vertices
            )
        end
    end
    return action
end

function _relabel_directed_graph(
    graph::DirectedGCGraph, mapping::Vector{Int}
)::DirectedGCGraph
    action = _directed_coordinate_action(mapping, graph.num_vertices)
    multiplicities = similar(graph.multiplicities)
    _write_coordinate_action!(multiplicities, graph.multiplicities, action)
    return DirectedGCGraph(graph.num_vertices, multiplicities)
end

mutable struct _DirectedCanonicalSearchState
    graph::DirectedGCGraph
    cells::Vector{Vector{Int}}
    inverse_mapping::Vector{Int}
    best_inverse_mapping::Vector{Int}
    automorphism_order::Int
    has_best::Bool
end

@inline function _compare_directed_inverse_mappings(
    graph::DirectedGCGraph, candidate::Vector{Int}, best::Vector{Int}
)::Int
    n = graph.num_vertices
    @inbounds for new_source in 1:n
        candidate_source = candidate[new_source]
        best_source = best[new_source]
        for new_target in 1:n
            candidate_value = graph.multiplicities[_directed_slot(
                candidate_source, candidate[new_target], n
            )]
            best_value = graph.multiplicities[_directed_slot(
                best_source, best[new_target], n
            )]
            candidate_value == best_value && continue
            return candidate_value < best_value ? -1 : 1
        end
    end
    return 0
end

function _record_directed_candidate!(state::_DirectedCanonicalSearchState)::Nothing
    if !state.has_best
        copyto!(state.best_inverse_mapping, state.inverse_mapping)
        state.automorphism_order = 1
        state.has_best = true
        return nothing
    end

    comparison = _compare_directed_inverse_mappings(
        state.graph, state.inverse_mapping, state.best_inverse_mapping
    )
    if comparison < 0
        copyto!(state.best_inverse_mapping, state.inverse_mapping)
        state.automorphism_order = 1
    elseif iszero(comparison)
        state.automorphism_order = _checked_increment(state.automorphism_order)
    end
    return nothing
end

function _enumerate_directed_cell!(
    state::_DirectedCanonicalSearchState,
    cell_index::Int,
    target_start::Int,
    depth::Int,
)::Nothing
    cell = state.cells[cell_index]
    if depth > length(cell)
        _search_directed_cells!(state, cell_index + 1, target_start + length(cell))
        return nothing
    end

    target = target_start + depth - 1
    @inbounds for swap_index in depth:length(cell)
        cell[depth], cell[swap_index] = cell[swap_index], cell[depth]
        state.inverse_mapping[target] = cell[depth]
        _enumerate_directed_cell!(state, cell_index, target_start, depth + 1)
        cell[depth], cell[swap_index] = cell[swap_index], cell[depth]
    end
    return nothing
end

function _search_directed_cells!(
    state::_DirectedCanonicalSearchState, cell_index::Int, target_start::Int
)::Nothing
    if cell_index > length(state.cells)
        _record_directed_candidate!(state)
        return nothing
    end

    cell = state.cells[cell_index]
    if length(cell) == 1
        state.inverse_mapping[target_start] = first(cell)
        _search_directed_cells!(state, cell_index + 1, target_start + 1)
    else
        _enumerate_directed_cell!(state, cell_index, target_start, 1)
    end
    return nothing
end

function _directed_mapping_from_inverse(inverse_mapping::Vector{Int})::Vector{Int}
    mapping = similar(inverse_mapping)
    @inbounds for new_vertex in eachindex(inverse_mapping)
        mapping[inverse_mapping[new_vertex]] = new_vertex
    end
    return mapping
end

function _directed_graph_from_inverse(
    graph::DirectedGCGraph, inverse_mapping::Vector{Int}
)::DirectedGCGraph
    n = graph.num_vertices
    multiplicities = similar(graph.multiplicities)
    @inbounds for new_source in 1:n
        old_source = inverse_mapping[new_source]
        for new_target in 1:n
            old_target = inverse_mapping[new_target]
            multiplicities[_directed_slot(new_source, new_target, n)] =
                graph.multiplicities[_directed_slot(old_source, old_target, n)]
        end
    end
    return DirectedGCGraph(n, multiplicities)
end

"""
    canonicalize_directed(graph::DirectedGCGraph, vertex_colors)

Canonicalize an exact directed multigraph under all vertex relabelings preserving `vertex_colors`.
Equal color values denote interchangeable vertices. The returned witness uses the explicit
old-vertex to canonical-vertex convention.

The search first computes the stable directed weighted equitable refinement of the input colors.
The refined cells are placed in deterministic canonical blocks and only unresolved permutations
inside those cells are enumerated. Residual candidates are streamed: the full relabeling group is
never materialized. Because every color-preserving automorphism preserves the stable refinement,
the number of residual mappings producing the canonical image is the exact automorphism order.
"""
function canonicalize_directed(
    graph::DirectedGCGraph, vertex_colors::AbstractVector{<:Integer}
)::DirectedCanonicalizationResult
    length(vertex_colors) == graph.num_vertices ||
        throw(ArgumentError("vertex_colors must have one entry per vertex."))
    colors = collect(Int, vertex_colors)
    cells = _directed_refined_cells(graph, colors)
    inverse_mapping = Vector{Int}(undef, graph.num_vertices)
    best_inverse_mapping = similar(inverse_mapping)
    state = _DirectedCanonicalSearchState(
        graph, cells, inverse_mapping, best_inverse_mapping, 0, false
    )
    _search_directed_cells!(state, 1, 1)
    state.has_best || error("Internal error: directed canonical search produced no candidate.")

    canonical = _directed_graph_from_inverse(graph, state.best_inverse_mapping)
    mapping = _directed_mapping_from_inverse(state.best_inverse_mapping)
    relabeling = VertexRelabeling(mapping)
    return DirectedCanonicalizationResult(canonical, relabeling, state.automorphism_order)
end

function canonicalize_directed(graph::DirectedGCGraph)::DirectedCanonicalizationResult
    return canonicalize_directed(graph, ones(Int, graph.num_vertices))
end

function canonical_relabeling(
    graph::DirectedGCGraph, vertex_colors::AbstractVector{<:Integer}
)::VertexRelabeling
    return canonical_relabeling(canonicalize_directed(graph, vertex_colors))
end

function canonical_relabeling(graph::DirectedGCGraph)::VertexRelabeling
    return canonical_relabeling(canonicalize_directed(graph))
end
