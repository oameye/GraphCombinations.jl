"""
    DegreeSequenceProblem(degrees; num_fixed=0)

Concrete undirected multigraph-generation problem with one prescribed degree per vertex.

`degrees[v]` is the degree of vertex `v`. The first `num_fixed` vertices are individually fixed
under canonical relabeling; all remaining vertices are quotient-labeled. The input vector is copied,
so later caller mutation cannot change the problem.
"""
struct DegreeSequenceProblem
    _degrees::Vector{Int}
    num_fixed::Int
end

function DegreeSequenceProblem(
    degrees::AbstractVector{<:Integer}; num_fixed::Integer=0
)::DegreeSequenceProblem
    normalized = collect(Int, degrees)
    any(x -> x < 0, normalized) &&
        throw(ArgumentError("Vertex degrees must be non-negative integers."))

    fixed = Int(num_fixed)
    0 <= fixed <= length(normalized) ||
        throw(ArgumentError("num_fixed must lie in 0:length(degrees)."))
    return DegreeSequenceProblem(normalized, fixed)
end

"""Return a copy of the prescribed vertex degrees."""
vertex_degrees(problem::DegreeSequenceProblem)::Vector{Int} = copy(problem._degrees)

"""Return the number of individually fixed prefix vertices."""
fixed_vertex_count(problem::DegreeSequenceProblem)::Int = problem.num_fixed

function _generate_degree_sequence(
    degrees::Vector{Int}, num_fixed::Int, connected::Bool
)::Vector{Tuple{GraphRep,BigInt}}
    isempty(degrees) && return Vector{Tuple{GraphRep,BigInt}}()
    isodd(sum(degrees)) && return Vector{Tuple{GraphRep,BigInt}}()

    num_internal = length(degrees) - num_fixed
    use_partition = num_internal >= _PARTITION_CANONICALIZATION_MIN_INTERNAL
    topologies = if use_partition
        _collect_topologies_partitioned(degrees, num_fixed, connected)
    else
        _collect_topologies_exhaustive(degrees, num_fixed, connected)
    end

    results = Vector{Tuple{GraphRep,BigInt}}()
    sizehint!(results, length(topologies))
    for (graph, automorphism_order) in topologies
        symmetry_denominator = big(automorphism_order) * _edge_symmetry_factor(graph)
        push!(results, (graph, symmetry_denominator))
    end
    sort!(results; by=first)
    return results
end

"""
    generate_multigraphs(problem::DegreeSequenceProblem; connected=true)

Generate the exact non-isomorphic undirected multigraphs satisfying `problem`.

Parallel edges and self-loops are supported. Results are deterministic `(edges, S)` pairs with the
same canonical `GraphRep` representation used by [`allgraphs`](@ref), and `S::BigInt` is the exact
symmetry denominator `|Aut(G)| * edge_factor(G)` under relabelings that keep the fixed prefix
vertices unchanged.
"""
function generate_multigraphs(
    problem::DegreeSequenceProblem; connected::Bool=true
)::Vector{Tuple{GraphRep,BigInt}}
    return _generate_degree_sequence(problem._degrees, problem.num_fixed, connected)
end
