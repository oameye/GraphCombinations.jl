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
    end

    @testset "loops and parallel edges" begin
        problem = TypedMultigraphProblem(fill(2, 3), fill(1, 3))
        mappings = GC._typed_problem_relabelings(problem)
        graph = [1 => 1, 2 => 3, 2 => 3]

        result = @inferred GC._canonicalize_under_mappings(graph, mappings)
        oracle_graph, oracle_automorphisms = _oracle_canonicalization(graph, mappings)

        @test result.canonical == oracle_graph
        @test result.automorphism_order == oracle_automorphisms == 2
    end
end
