using Test
import GraphCombinations as GC

function _oracle_mapped_graph(graph::Vector{Pair{Int,Int}}, mapping::Vector{Int})
    mapped = Pair{Int,Int}[]
    sizehint!(mapped, length(graph))
    for edge in graph
        u, v = minmax(mapping[edge.first], mapping[edge.second])
        push!(mapped, u => v)
    end
    sort!(mapped)
    return mapped
end

function _oracle_graph_less(a::Vector{Pair{Int,Int}}, b::Vector{Pair{Int,Int}})::Bool
    @inbounds for i in eachindex(a, b)
        a[i] == b[i] && continue
        return isless(a[i], b[i])
    end
    return length(a) < length(b)
end

function _oracle_canonicalization(graph, mappings)
    candidates = [_oracle_mapped_graph(graph, mapping) for mapping in mappings]
    best = first(candidates)
    for candidate in @view candidates[2:end]
        _oracle_graph_less(candidate, best) && (best = candidate)
    end
    return best, count(==(best), candidates)
end

function _check_triangular_canonicalization(graph, problem)
    mappings = GC._typed_problem_relabelings(problem)
    actions = GC._triangular_relabeling_actions(mappings, length(problem._degrees))
    matrix_result = GC._canonicalize_under_mappings(graph, mappings)
    triangular_result = @inferred GC._canonicalize_under_triangular_actions(
        graph, actions, length(problem._degrees)
    )
    @test triangular_result.canonical == matrix_result.canonical
    @test triangular_result.automorphism_order == matrix_result.automorphism_order
    return triangular_result
end

@testset "typed multiplicity-matrix canonicalization" begin
    @testset "cycle orbit" begin
        allowed = trues(4, 4)
        @inbounds for vertex in axes(allowed, 1)
            allowed[vertex, vertex] = false
        end
        problem = TypedMultigraphProblem(fill(2, 4), fill(1, 4); allowed)
        mappings = GC._typed_problem_relabelings(problem)
        graph = [1 => 2, 2 => 3, 3 => 4, 1 => 4]

        result = @inferred GC._canonicalize_under_mappings(graph, mappings)
        oracle_graph, oracle_automorphisms = _oracle_canonicalization(graph, mappings)

        @test result.canonical == oracle_graph
        @test result.automorphism_order == oracle_automorphisms == 8
        triangular = _check_triangular_canonicalization(graph, problem)
        @test triangular.canonical == oracle_graph
        @test triangular.automorphism_order == 8
    end

    @testset "loops and parallel edges" begin
        problem = TypedMultigraphProblem(fill(2, 3), fill(1, 3))
        mappings = GC._typed_problem_relabelings(problem)
        graph = [1 => 1, 2 => 3, 2 => 3]

        result = @inferred GC._canonicalize_under_mappings(graph, mappings)
        oracle_graph, oracle_automorphisms = _oracle_canonicalization(graph, mappings)

        @test result.canonical == oracle_graph
        @test result.automorphism_order == oracle_automorphisms == 2
        triangular = _check_triangular_canonicalization(graph, problem)
        @test triangular.canonical == oracle_graph
        @test triangular.automorphism_order == 2
    end

    @testset "typed restrictions" begin
        allowed = falses(6, 6)
        @inbounds for u in 1:3, v in 4:6
            allowed[u, v] = true
            allowed[v, u] = true
        end
        problem = TypedMultigraphProblem(fill(2, 6), [1, 1, 1, 2, 2, 2]; allowed)
        graphs = (
            [1 => 4, 1 => 5, 2 => 4, 2 => 6, 3 => 5, 3 => 6],
            [1 => 4, 1 => 4, 2 => 5, 2 => 5, 3 => 6, 3 => 6],
        )
        for graph in graphs
            _check_triangular_canonicalization(graph, problem)
        end
    end
end
