module GraphsExt

using Graphs
import GraphCombinations as GC
import GraphCombinations: build_graph, gen_distances

struct GraphsGraph <: Graphs.AbstractGraph{Int}
    graph::GC.GCGraph
end

Base.eltype(::GraphsGraph) = Int
Graphs.edgetype(::GraphsGraph) = Graphs.SimpleEdge{Int}
Graphs.nv(graph::GraphsGraph) = graph.graph.num_vertices
Graphs.ne(graph::GraphsGraph) = GC._gcgraph_num_edges(graph.graph)
Graphs.vertices(graph::GraphsGraph) = Base.OneTo(graph.graph.num_vertices)
Graphs.is_directed(::GraphsGraph) = false
Graphs.is_directed(::Type{GraphsGraph}) = false
function Graphs.has_vertex(graph::GraphsGraph, vertex::Integer)
    return 1 <= vertex <= graph.graph.num_vertices
end
function Graphs.has_edge(graph::GraphsGraph, u::Integer, v::Integer)
    return GC._gcgraph_multiplicity(graph.graph, Int(u), Int(v)) > 0
end
function Graphs.inneighbors(graph::GraphsGraph, vertex::Integer)
    return GC._gcgraph_neighbors(graph.graph, Int(vertex))
end
function Graphs.outneighbors(graph::GraphsGraph, vertex::Integer)
    return GC._gcgraph_neighbors(graph.graph, Int(vertex))
end
Graphs.is_connected(graph::GraphsGraph) = GC._is_connected_gcgraph(graph.graph)

function Graphs.edges(graph::GraphsGraph)
    edges = Graphs.SimpleEdge{Int}[]
    sizehint!(edges, Graphs.ne(graph))
    native = graph.graph
    slot = 1
    @inbounds for u in 1:native.num_vertices
        for v in u:native.num_vertices
            for _ in 1:native.multiplicities[slot]
                push!(edges, Graphs.SimpleEdge(u, v))
            end
            slot += 1
        end
    end
    return edges
end

"""Build a Graphs.jl-compatible adapter while preserving loops and parallel edges."""
function build_graph(graph_rep::GC.GraphRep, num_vertices::Int)::GraphsGraph
    return GraphsGraph(GC.GCGraph(graph_rep, num_vertices))
end

function build_graph(graph_rep::GC.GraphRep)::GraphsGraph
    return GraphsGraph(GC.GCGraph(graph_rep))
end

gen_distances(graph::GraphsGraph; inc=0.25) = GC.gen_distances(graph.graph; inc)

end
