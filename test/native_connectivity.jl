using Graphs
using Test
import GraphCombinations as GC

@testset "native GraphRep connectivity matches Graphs.jl" begin
    for num_vertices in 1:5
        possible_edges = Pair{Int,Int}[]
        for u in 1:num_vertices
            for v in (u + 1):num_vertices
                push!(possible_edges, u => v)
            end
        end

        for mask in 0:(UInt(1) << length(possible_edges)) - 1
            graph = Pair{Int,Int}[]
            for (index, edge) in pairs(possible_edges)
                !iszero(mask & (UInt(1) << (index - 1))) && push!(graph, edge)
            end
            expected = is_connected(GC.build_internal_graph(graph, num_vertices))
            @test GC._is_connected_graph_rep(graph, num_vertices) == expected
        end
    end
end

@testset "loops and parallel edges do not alter native connectivity" begin
    cases = (
        (Pair{Int,Int}[1 => 1], 2),
        (Pair{Int,Int}[1 => 2, 1 => 2], 2),
        (Pair{Int,Int}[1 => 2, 1 => 2, 2 => 2], 3),
        (Pair{Int,Int}[1 => 2, 2 => 3, 2 => 3, 3 => 3], 3),
    )
    for (graph, num_vertices) in cases
        expected = is_connected(GC.build_internal_graph(graph, num_vertices))
        @test GC._is_connected_graph_rep(graph, num_vertices) == expected
    end
end

@testset "large native connectivity fallback" begin
    num_vertices = 65
    path = Pair{Int,Int}[vertex => vertex + 1 for vertex in 1:(num_vertices - 1)]
    @test GC._is_connected_graph_rep(path, num_vertices)

    pop!(path)
    @test !GC._is_connected_graph_rep(path, num_vertices)
end
