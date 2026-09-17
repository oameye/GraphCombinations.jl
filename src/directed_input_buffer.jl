# --- Reusable mutable input storage for directed canonicalization ---

"""
    DirectedGCGraphBuffer(capacity)

Reusable mutable input storage for exact directed multigraph canonicalization with at most
`capacity` vertices. Unlike `DirectedGCGraph`, this type is scratch storage rather than a hashable
graph value. Load a new edge set with `load_directed_graph!` and pass the buffer directly to
`canonicalize_directed!`.
"""
mutable struct DirectedGCGraphBuffer
    num_vertices::Int
    multiplicities::Vector{Int}
end

function DirectedGCGraphBuffer(capacity::Integer)
    n = Int(capacity)
    n >= 0 || throw(ArgumentError("capacity must be non-negative."))
    return DirectedGCGraphBuffer(n, zeros(Int, n * n))
end

@inline _directed_graph_buffer_capacity(graph::DirectedGCGraphBuffer)::Int =
    isqrt(length(graph.multiplicities))

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

@inline function _prepare_directed_graph_buffer!(
    graph::DirectedGCGraphBuffer, num_vertices::Integer
)::Nothing
    n = Int(num_vertices)
    0 <= n <= _directed_graph_buffer_capacity(graph) ||
        throw(DimensionMismatch("directed graph input buffer capacity is too small"))
    @inbounds for slot in 1:(n * n)
        graph.multiplicities[slot] = 0
    end
    graph.num_vertices = n
    return nothing
end

"""
    load_directed_graph!(graph, edges[, num_vertices])

Replace the complete edge multiset stored in a reusable `DirectedGCGraphBuffer`. The optional
`num_vertices` selects any active graph size up to the buffer capacity; without it, the current
active size is retained. Both `source => target` pairs and `(source, target)` integer tuples are
accepted. Repeated entries accumulate exact edge multiplicity.
"""
function load_directed_graph!(
    graph::DirectedGCGraphBuffer,
    edges::AbstractVector{<:Pair{<:Integer,<:Integer}},
    num_vertices::Integer=graph.num_vertices,
)::DirectedGCGraphBuffer
    _prepare_directed_graph_buffer!(graph, num_vertices)
    @inbounds for edge in edges
        _directed_graph_buffer_edge!(graph, first(edge), last(edge))
    end
    return graph
end

function load_directed_graph!(
    graph::DirectedGCGraphBuffer,
    edges::AbstractVector{<:Tuple{<:Integer,<:Integer}},
    num_vertices::Integer=graph.num_vertices,
)::DirectedGCGraphBuffer
    _prepare_directed_graph_buffer!(graph, num_vertices)
    @inbounds for edge in edges
        _directed_graph_buffer_edge!(graph, edge[1], edge[2])
    end
    return graph
end

@inline function _directed_graph_view(graph::DirectedGCGraphBuffer)::DirectedGCGraph
    return DirectedGCGraph(graph.num_vertices, graph.multiplicities)
end

function canonicalize_directed!(
    buffer::DirectedCanonicalizationBuffer,
    workspace::DirectedCanonicalizationWorkspace,
    graph::DirectedGCGraphBuffer,
    vertex_colors::AbstractVector{<:Integer},
)::DirectedCanonicalizationBuffer
    return canonicalize_directed!(
        buffer, workspace, _directed_graph_view(graph), vertex_colors
    )
end

function canonicalize_directed!(
    buffer::DirectedCanonicalizationBuffer,
    workspace::DirectedCanonicalizationWorkspace,
    graph::DirectedGCGraphBuffer,
)::DirectedCanonicalizationBuffer
    return canonicalize_directed!(buffer, workspace, _directed_graph_view(graph))
end
