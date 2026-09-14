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

"""
    canonicalize_directed(graph::DirectedGCGraph, vertex_colors)

Canonicalize an exact directed multigraph under all vertex relabelings preserving `vertex_colors`.
Equal color values denote interchangeable vertices; singleton color classes are therefore fixed
individually. The returned witness uses the explicit old-vertex to new-vertex convention.

The current implementation deliberately enumerates the exact color-preserving relabeling group.
This is the small, auditable reference/production candidate required by current downstream diagram
workloads; refinement is added only if measurements justify it.
"""
function canonicalize_directed(
    graph::DirectedGCGraph, vertex_colors::AbstractVector{<:Integer}
)::DirectedCanonicalizationResult
    length(vertex_colors) == graph.num_vertices ||
        throw(ArgumentError("vertex_colors must have one entry per vertex."))
    colors = collect(Int, vertex_colors)
    mappings = _directed_relabelings(colors)
    isempty(mappings) && error("Internal error: directed relabeling group is empty.")

    best_mapping_index = 1
    best_action = _directed_coordinate_action(first(mappings), graph.num_vertices)
    automorphism_order = 1

    @inbounds for mapping_index in 2:length(mappings)
        candidate_action = _directed_coordinate_action(
            mappings[mapping_index], graph.num_vertices
        )
        comparison = _compare_coordinate_actions(
            graph.multiplicities, candidate_action, best_action, Val(false)
        )
        if comparison < 0
            best_mapping_index = mapping_index
            best_action = candidate_action
            automorphism_order = 1
        elseif iszero(comparison)
            automorphism_order = _checked_increment(automorphism_order)
        end
    end

    canonical_multiplicities = similar(graph.multiplicities)
    _write_coordinate_action!(canonical_multiplicities, graph.multiplicities, best_action)
    canonical = DirectedGCGraph(graph.num_vertices, canonical_multiplicities)
    relabeling = VertexRelabeling(mappings[best_mapping_index])
    return DirectedCanonicalizationResult(canonical, relabeling, automorphism_order)
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
