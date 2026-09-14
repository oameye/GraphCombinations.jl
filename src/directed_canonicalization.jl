# --- Native directed whole-graph canonical relabeling ---

"""
    DirectedGCGraph(edges, num_vertices)

GraphCombinations-owned directed multigraph representation for whole-graph canonical relabeling.
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
        1 <= source <= n ||
            throw(ArgumentError("Source vertex $source is outside 1:$n."))
        1 <= target <= n ||
            throw(ArgumentError("Target vertex $target is outside 1:$n."))
        multiplicities[_directed_slot(source, target, n)] += 1
    end
    return DirectedGCGraph(n, multiplicities)
end

function DirectedGCGraph(edges::AbstractVector{<:Pair{<:Integer,<:Integer}})::DirectedGCGraph
    n = isempty(edges) ? 0 : maximum(max(Int(first(edge)), Int(last(edge))) for edge in edges)
    return DirectedGCGraph(edges, n)
end

function Base.isequal(a::DirectedGCGraph, b::DirectedGCGraph)
    return a.num_vertices == b.num_vertices && isequal(a.multiplicities, b.multiplicities)
end
Base.:(==)(a::DirectedGCGraph, b::DirectedGCGraph) = isequal(a, b)

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

struct _AcceptAllRelabelings end
@inline (::_AcceptAllRelabelings)(::Vector{Int})::Bool = true

function _fixed_vertex_colors(num_vertices::Int, fixed_vertices::Vector{Int})::Vector{Int}
    fixed = falses(num_vertices)
    @inbounds for vertex in fixed_vertices
        1 <= vertex <= num_vertices ||
            throw(ArgumentError("Fixed vertex $vertex is outside 1:$num_vertices."))
        fixed[vertex] && throw(ArgumentError("Fixed vertices must be unique."))
        fixed[vertex] = true
    end

    colors = ones(Int, num_vertices)
    unique_color = 2
    @inbounds for vertex in 1:num_vertices
        fixed[vertex] || continue
        colors[vertex] = unique_color
        unique_color += 1
    end
    return colors
end

function _directed_relabelings(
    num_vertices::Int, fixed_vertices::Vector{Int}
)::Vector{Vector{Int}}
    colors = _fixed_vertex_colors(num_vertices, fixed_vertices)
    return _problem_relabelings(colors, 0, _AcceptAllRelabelings())
end

function _directed_coordinate_action(
    mapping::Vector{Int}, num_vertices::Int
)::Vector{Int}
    length(mapping) == num_vertices ||
        error("Internal error: directed relabeling has the wrong size.")
    inverse_mapping = Vector{Int}(undef, num_vertices)
    _write_inverse_permutation!(inverse_mapping, mapping, 1)

    action = Vector{Int}(undef, num_vertices * num_vertices)
    @inbounds for new_source in 1:num_vertices
        old_source = inverse_mapping[new_source]
        for new_target in 1:num_vertices
            old_target = inverse_mapping[new_target]
            action[_directed_slot(new_source, new_target, num_vertices)] =
                _directed_slot(old_source, old_target, num_vertices)
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
    canonical_relabeling(graph::DirectedGCGraph[, fixed_vertices]) -> VertexRelabeling

Return the deterministic exact relabeling that maps `graph` to the lexicographically minimal
native directed multiplicity representation while keeping every vertex in `fixed_vertices`
individually fixed. All other vertices are interchangeable.

This intentionally supplies only the whole-graph relabeling capability required by current diagram
consumers; it is not a general graph-isomorphism API.
"""
function canonical_relabeling(
    graph::DirectedGCGraph, fixed_vertices::AbstractVector{<:Integer}
)::VertexRelabeling
    fixed = collect(Int, fixed_vertices)
    mappings = _directed_relabelings(graph.num_vertices, fixed)
    isempty(mappings) && error("Internal error: directed relabeling group is empty.")

    best_mapping_index = 1
    best_action = _directed_coordinate_action(first(mappings), graph.num_vertices)
    for mapping_index in 2:length(mappings)
        candidate_action = _directed_coordinate_action(mappings[mapping_index], graph.num_vertices)
        if _compare_coordinate_actions(
            graph.multiplicities, candidate_action, best_action, Val(false)
        ) < 0
            best_mapping_index = mapping_index
            best_action = candidate_action
        end
    end
    return VertexRelabeling(mappings[best_mapping_index])
end

function canonical_relabeling(graph::DirectedGCGraph)::VertexRelabeling
    return canonical_relabeling(graph, Int[])
end
