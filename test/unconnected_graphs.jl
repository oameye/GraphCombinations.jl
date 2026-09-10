using GraphCombinations, Graphs, Test

@testset "first order ϕ⁴" begin
    n = [2, 0, 0, 1]
    topologies = allgraphs(n; connected=false)
    @test length(topologies) == 2
    @test count(t -> is_connected(build_graph(t[1])), topologies) == 1
end
