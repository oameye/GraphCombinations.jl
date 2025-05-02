using GraphCombinations, Graphs, Test

@testset "first order ϕ⁴" begin
    n = [2, 0, 0, 1]
    topologies = allgraphs(n; connected=false)
    @test length(topologies) == 2

    graph, _ = topologies[2]
    @test !is_connected(build_graph(graph))
end
