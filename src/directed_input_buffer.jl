# --- Reusable mutable input storage for directed canonicalization ---

"""
    DirectedGCGraphBuffer(num_vertices)

Reusable mutable input storage for exact directed multigraph canonicalization at one graph size.
Unlike `DirectedGCGraph`, this type is scratch storage rather than a hashable graph value. Load a
new edge set with `load_directed_graph!` and pass the buffer directly to
`canonicalize_directed!`.
"""
mutable struct DirectedGCGraphBuffer
    num_vertices::Int
    multiplicities::Vector{Int}
end

function DirectedGCGraphBuffer(num_vertices::Integer)
    n = Int(num_vertices)
    n >= 0 || throw(ArgumentError("num_vertices must be non-negative."))
    return DirectedGCGraphBuffer(n, zeros(Int, n * n))
end

@inline function _directed_graph_buffer_edge!(
    graph::DirectedGCGraphBuffer, source::Integer, target::Integer
)::Nothing
    n = graph.num_vertices
    src = Int(source)
    dst = Int(target)
    1 <= src <= n || throw(ArgumentError("Source vertex $src is outside 1:$n."))
    1 <= dst <= n || throw(ArgumentError("Target vertex $dst is outside 1:$n."))
    graph.multiplicities[_directed_slot(src, dst, n)] += 1
    return nothing
end

function load_directed_graph!(
    graph::DirectedGCGraphBuffer,
    edges::AbstractVector{<:Pair{<:Integer,<:Integer}},
)::DirectedGCGraphBuffer
    fill!(graph.multiplicities, 0)
    @inbounds for edge in edges
        _directed_graph_buffer_edge!(graph, first(edge), last(edge))
    end
    return graph
end

function load_directed_graph!(
    graph::DirectedGCGraphBuffer,
    edges::AbstractVector{<:Tuple{<:Integer,<:Integer}},
)::DirectedGCGraphBuffer
    fill!(graph.multiplicities, 0)
    @inbounds for edge in edges
        _directed_graph_buffer_edge!(graph, edge[1], edge[2])
    end
    return graph
end

@inline function _directed_graph_view(graph::DirectedGCGraphBuffer)::DirectedGCGraph
    return DirectedGCGraph(graph.num_vertices, graph.multiplicities)
end
