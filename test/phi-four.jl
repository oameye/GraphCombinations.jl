using GraphCombinations, Graphs, Test
import GraphCombinations as GC

n1 = [2, 0, 0, 1]
topologies_order1 = allgraphs(n1)
@test length(topologies_order1) == 1
for (graph, _) in topologies_order1
    g = build_graph(graph)
    @test is_connected(g)
end

n2 = [2, 0, 0, 2]
topologies_order2 = allgraphs(n2)
@test length(topologies_order2) == 3
for (graph, _) in topologies_order2
    g = build_graph(graph)
    @test is_connected(g)
end

n3 = [2, 0, 0, 3]
topologies_order3 = allgraphs(n3)
@test length(topologies_order3) == 10
for (graph, _) in topologies_order3
    g = build_graph(graph)
    @test is_connected(g)
end
