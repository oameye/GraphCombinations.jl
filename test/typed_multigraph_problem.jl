using Test
using GraphCombinations

const GCTyped = GraphCombinations

function _test_permutations(values::Vector{Int})::Vector{Vector{Int}}
    isempty(values) && return [Int[]]
    result = Vector{Vector{Int}}()
    for index in eachindex(values)
        head = values[index]
        rest = [values[j] for j in eachindex(values) if j != index]
        for tail in _test_permutations(rest)
            push!(result, [head; tail])
        end
    end
    return result
end

function _brute_typed_mappings(
    degrees::Vector{Int}, colors::Vector{Int}, allowed::BitMatrix, num_fixed::Int
)::Vector{Vector{Int}}
    n = length(colors)
    movable = collect((num_fixed + 1):n)
    mappings = Vector{Vector{Int}}()
    for permutation in _test_permutations(movable)
        mapping = collect(1:n)
        @inbounds for i in eachindex(movable)
            mapping[movable[i]] = permutation[i]
        end
        all(colors[v] == colors[mapping[v]] for v in movable) || continue
        all(degrees[v] == degrees[mapping[v]] for v in movable) || continue
        all(allowed[u, v] == allowed[mapping[u], mapping[v]] for u in 1:n for v in 1:n) ||
            continue
        push!(mappings, mapping)
    end
    return mappings
end

function _brute_mapped_graph(
    graph::Vector{Pair{Int,Int}}, mapping::Vector{Int}
)::Vector{Pair{Int,Int}}
    mapped = Pair{Int,Int}[]
    sizehint!(mapped, length(graph))
    for edge in graph
        u, v = minmax(mapping[edge.first], mapping[edge.second])
        push!(mapped, u => v)
    end
    sort!(mapped)
    return mapped
end

function _test_graph_less(a::Vector{Pair{Int,Int}}, b::Vector{Pair{Int,Int}})::Bool
    @inbounds for i in eachindex(a, b)
        a[i] == b[i] && continue
        return isless(a[i], b[i])
    end
    return length(a) < length(b)
end

function _brute_edge_factor(graph::Vector{Pair{Int,Int}})::BigInt
    multiplicities = Dict{Pair{Int,Int},Int}()
    for edge in graph
        multiplicities[edge] = get(multiplicities, edge, 0) + 1
    end
    factor = big(1)
    for (edge, multiplicity) in multiplicities
        factor *= factorial(big(multiplicity))
        edge.first == edge.second && (factor *= big(2)^multiplicity)
    end
    return factor
end

function _brute_typed_results(problem::TypedMultigraphProblem)
    degrees = vertex_degrees(problem)
    colors = vertex_colors(problem)
    allowed = edge_admissibility(problem)
    mappings = _brute_typed_mappings(degrees, colors, allowed, fixed_vertex_count(problem))
    topologies = Dict{Vector{Pair{Int,Int}},Int}()

    GCTyped._foreach_labeled_multigraph(degrees) do graph
        all(allowed[edge.first, edge.second] for edge in graph) || return nothing
        candidates = [_brute_mapped_graph(graph, mapping) for mapping in mappings]
        best = first(candidates)
        for candidate in @view candidates[2:end]
            _test_graph_less(candidate, best) && (best = candidate)
        end
        automorphism_order = count(==(best), candidates)
        if haskey(topologies, best)
            @test topologies[best] == automorphism_order
        else
            topologies[best] = automorphism_order
        end
        return nothing
    end

    results = Tuple{Vector{Pair{Int,Int}},BigInt}[]
    for (graph, automorphism_order) in topologies
        push!(results, (graph, big(automorphism_order) * _brute_edge_factor(graph)))
    end
    sort!(results; by=first)
    return results
end

@testset "TypedMultigraphProblem" begin
    @testset "construction and ownership" begin
        degrees = [1, 1]
        colors = [1, 2]
        allowed = trues(2, 2)
        problem = @inferred TypedMultigraphProblem(degrees, colors; allowed)
        @test isconcretetype(typeof(problem))
        @test vertex_degrees(problem) == [1, 1]
        @test vertex_colors(problem) == [1, 2]
        @test edge_admissibility(problem) == allowed

        degrees[1] = 9
        colors[1] = 9
        allowed[1, 2] = false
        @test vertex_degrees(problem) == [1, 1]
        @test vertex_colors(problem) == [1, 2]
        @test all(edge_admissibility(problem))

        @test_throws ArgumentError TypedMultigraphProblem([1, -1], [1, 1])
        @test_throws ArgumentError TypedMultigraphProblem([1, 1], [1])
        @test_throws ArgumentError TypedMultigraphProblem([1, 1], [1, 1]; num_fixed=3)
        @test_throws ArgumentError TypedMultigraphProblem(
            [1, 1], [1, 1]; allowed=Bool[true true; false true]
        )
    end

    @testset "unrestricted compatibility path" begin
        typed = TypedMultigraphProblem([1, 1, 2, 2], fill(1, 4); num_fixed=2)
        scalar = DegreeSequenceProblem([1, 1, 2, 2]; num_fixed=2)
        @test @inferred(generate_multigraphs(typed)) == generate_multigraphs(scalar)
        @test generate_multigraphs(typed; connected=false) ==
            generate_multigraphs(scalar; connected=false)
    end

    @testset "vertex colors, degrees, and fixed identity restrict symmetry" begin
        split = TypedMultigraphProblem([1, 1], [1, 2])
        @test generate_multigraphs(split) == [([1 => 2], big(1))]

        fixed = TypedMultigraphProblem([1, 1], [1, 1]; num_fixed=1)
        @test generate_multigraphs(fixed) == [([1 => 2], big(1))]

        allowed = BitMatrix([true true true; true false true; true true false])
        degree_split = TypedMultigraphProblem([1, 2, 1], [1, 1, 2]; allowed)
        mappings = GCTyped._typed_problem_relabelings(degree_split)
        @test all(
            vertex_degrees(degree_split)[v] == vertex_degrees(degree_split)[mapping[v]] for
            mapping in mappings for v in eachindex(vertex_degrees(degree_split))
        )
    end

    @testset "admissibility is enforced during generation" begin
        no_edge = BitMatrix([true false; false true])
        @test isempty(
            generate_multigraphs(TypedMultigraphProblem([1, 1], [1, 2]; allowed=no_edge))
        )

        no_loop = falses(1, 1)
        @test isempty(
            generate_multigraphs(TypedMultigraphProblem([2], [1]; allowed=no_loop))
        )
        @test generate_multigraphs(TypedMultigraphProblem([2], [1])) == [([1 => 1], big(2))]

        distinguished = BitMatrix([true true; true false])
        problem = TypedMultigraphProblem([1, 1], [1, 1]; allowed=distinguished)
        @test generate_multigraphs(problem) == [([1 => 2], big(1))]
    end

    @testset "parallel edges retain exact edge factors" begin
        offdiagonal_only = BitMatrix([false true; true false])
        split = TypedMultigraphProblem([2, 2], [1, 2]; allowed=offdiagonal_only)
        @test generate_multigraphs(split) == [([1 => 2, 1 => 2], big(2))]

        symmetric = TypedMultigraphProblem([2, 2], [1, 1]; allowed=offdiagonal_only)
        @test generate_multigraphs(symmetric) == [([1 => 2, 1 => 2], big(4))]
    end

    @testset "independent constrained oracle" begin
        allowed = BitMatrix([
            true true false;
            true false true;
            false true true
        ])
        problem = TypedMultigraphProblem([2, 2, 2], [1, 1, 2]; allowed)
        @test generate_multigraphs(problem; connected=false) ==
            _brute_typed_results(problem)
    end

    @testset "isolated vertices and connectedness" begin
        problem = TypedMultigraphProblem([0, 0], [1, 2])
        @test isempty(generate_multigraphs(problem))
        @test generate_multigraphs(problem; connected=false) == [([], big(1))]
        @test isempty(generate_multigraphs(TypedMultigraphProblem([1], [1])))
    end

    @testset "nonfixed input order is normalized" begin
        degrees = [1, 2, 1]
        colors = [2, 1, 2]
        allowed = BitMatrix([true true false; true false false; false false true])
        original = TypedMultigraphProblem(degrees, colors; allowed)

        order = [2, 3, 1]
        permuted = TypedMultigraphProblem(
            degrees[order], colors[order]; allowed=allowed[order, order]
        )
        @test vertex_degrees(permuted) == vertex_degrees(original)
        @test vertex_colors(permuted) == vertex_colors(original)
        @test edge_admissibility(permuted) == edge_admissibility(original)
        @test generate_multigraphs(permuted; connected=false) ==
            generate_multigraphs(original; connected=false)

        same_color_degrees = [2, 1, 2]
        same_colors = [1, 1, 1]
        constrained = BitMatrix([false true true; true true false; true false false])
        a = TypedMultigraphProblem(same_color_degrees, same_colors; allowed=constrained)
        order2 = [3, 1, 2]
        b = TypedMultigraphProblem(
            same_color_degrees[order2],
            same_colors[order2];
            allowed=constrained[order2, order2],
        )
        @test vertex_degrees(a) == vertex_degrees(b)
        @test edge_admissibility(a) == edge_admissibility(b)
        @test generate_multigraphs(a; connected=false) ==
            generate_multigraphs(b; connected=false)
    end
end
