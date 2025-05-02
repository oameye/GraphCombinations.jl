
using GraphCombinatorics, Multigraphs, Graphs
import GraphCombinatorics as GC

using CairoMakie, GraphMakie
import GraphMakie.NetworkLayout as NL
arrow_show=false
layout=NL.Align(NL.Spring())

g = Multigraph(3)
add_edge!(g, 1, 2, 1) # one edge
add_edge!(g, 2, 3, 2) # two edges
add_edge!(g, 3, 1, 3) # three edges

gwrap1 = GC.MultigraphWrap(g)
graphplot(
    gwrap1; layout, curve_distance=GC.gen_distances(gwrap1), curve_distance_usage=true
)

is_directed(gwrap1) # false

g = Multigraph(4)
add_edge!(g, 1, 2, 1) # one edge
add_edge!(g, 2, 3, 3) # two edges
add_edge!(g, 3, 4, 1) # three edges

gwrap2 = GC.MultigraphWrap(g)
graphplot(
    gwrap2; layout, curve_distance=GC.gen_distances(gwrap2), curve_distance_usage=true
)

n1 = [2, 0, 0, 1]
edges, _ = first(allgraphs(n1))
gwrap2 = GC.build_graph(edges)

graphplot(
    gwrap2; layout, curve_distance=GC.gen_distances(gwrap2), curve_distance_usage=true
)
