# --- Native undirected multigraph value ---

"""
    GCGraph(graph_rep, num_vertices)
    GCGraph(graph_rep)

Compact GraphCombinations-owned undirected multigraph representation. Edge multiplicities are
stored once in upper-triangular row-major order; parallel edges and self-loops are preserved.
"""
struct GCGraph
    num_vertices::Int
    multiplicities::Vector{Int}
end

struct _GraphRepView
    graph::GraphRep
    num_vertices::Int
end

@inline function _gcgraph_slot(u::Int, v::Int, num_vertices::Int)::Int
    a, b = minmax(u, v)
    return ((a - 1) * (2 * num_vertices - a + 2)) ÷ 2 + (b - a + 1)
end

function GCGraph(graph_rep::GraphRep, num_vertices::Int)
    num_vertices >= 0 || throw(ArgumentError("num_vertices must be non-negative."))
    multiplicities = zeros(Int, (num_vertices * (num_vertices + 1)) ÷ 2)
    @inbounds for edge in graph_rep
        u = edge.first
        v = edge.second
        1 <= u <= num_vertices ||
            throw(ArgumentError("Vertex label $u is outside 1:$num_vertices."))
        1 <= v <= num_vertices ||
            throw(ArgumentError("Vertex label $v is outside 1:$num_vertices."))
        multiplicities[_gcgraph_slot(u, v, num_vertices)] += 1
    end
    return GCGraph(num_vertices, multiplicities)
end

function GCGraph(graph_rep::GraphRep)
    num_vertices =
        isempty(graph_rep) ? 0 : maximum(max(edge.first, edge.second) for edge in graph_rep)
    return GCGraph(graph_rep, num_vertices)
end

@inline function _gcgraph_multiplicity(graph::GCGraph, u::Int, v::Int)::Int
    1 <= u <= graph.num_vertices || return 0
    1 <= v <= graph.num_vertices || return 0
    return graph.multiplicities[_gcgraph_slot(u, v, graph.num_vertices)]
end

_gcgraph_num_edges(graph::GCGraph)::Int = sum(graph.multiplicities)

function _gcgraph_edges(graph::GCGraph)::GraphRep
    edges = Edge[]
    sizehint!(edges, _gcgraph_num_edges(graph))
    slot = 1
    @inbounds for u in 1:graph.num_vertices
        for v in u:graph.num_vertices
            for _ in 1:graph.multiplicities[slot]
                push!(edges, Edge(u, v))
            end
            slot += 1
        end
    end
    return edges
end

function _gcgraph_neighbors(graph::GCGraph, vertex::Int)::Vector{Int}
    1 <= vertex <= graph.num_vertices || return Int[]
    neighbors = Int[]
    sizehint!(neighbors, graph.num_vertices)
    @inbounds for other in 1:graph.num_vertices
        _gcgraph_multiplicity(graph, vertex, other) > 0 && push!(neighbors, other)
    end
    return neighbors
end

function _is_connected_gcgraph(graph::GCGraph)::Bool
    graph.num_vertices > 0 || return false
    graph.num_vertices == 1 && return true
    return _is_connected_graph_rep(_gcgraph_edges(graph), graph.num_vertices)
end

# Preserve old private generator call sites without allocating a graph object.
function build_internal_graph(graph_rep::GraphRep, num_vertices::Int)
    return _GraphRepView(graph_rep, num_vertices)
end
is_connected(graph::_GraphRepView)::Bool =
    _is_connected_graph_rep(graph.graph, graph.num_vertices)

"""
    gen_distances(graph::GCGraph; inc=0.25)

Return symmetric curve offsets for plotting parallel edges.
"""
function gen_distances(graph::GCGraph; inc=0.25)
    distances = Float64[]
    sizehint!(distances, _gcgraph_num_edges(graph))
    @inbounds for multiplicity in graph.multiplicities
        if isone(multiplicity)
            push!(distances, 0.0)
        elseif multiplicity > 1
            m = iseven(multiplicity) ? multiplicity ÷ 2 : (multiplicity - 1) ÷ 2
            append!(distances, range(-m * inc, m * inc; length=multiplicity))
        end
    end
    return distances
end

# Graphs.jl interoperability is supplied by the optional GraphsExt extension.
function build_graph end
