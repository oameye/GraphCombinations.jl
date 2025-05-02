
using GraphCombinatorics, Graphs, Test
import GraphCombinatorics as GC

n1 = [2, 0, 0, 1]
topologies_order1 = allgraphs(n1)
map(topologies_order1) do (graph, _)
    g = GC.build_graph(graph)
    @test degree(g) == [1, 1, 4]
end

n2 = [2, 0, 0, 2]
topologies_order2 = allgraphs(n2)
map(topologies_order2) do (graph, _)
    g = GC.build_graph(graph)
    @test degree(g) == [1, 1, 4, 4]
end

n3 = [2, 0, 0, 3]
topologies_order3 = allgraphs(n3)
map(topologies_order3) do (graph, _)
    g = GC.build_graph(graph)
    @test degree(g) == [1, 1, 4, 4, 4]
end
