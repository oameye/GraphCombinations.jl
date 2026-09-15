# --- Exact directed color refinement ---

function _directed_initial_color_ranks(vertex_colors::Vector{Int})::Vector{Int}
    isempty(vertex_colors) && return Int[]
    color_values = sort!(unique(copy(vertex_colors)))
    return Int[searchsortedfirst(color_values, color) for color in vertex_colors]
end

function _directed_refinement_signatures(
    graph::DirectedGCGraph, colors::Vector{Int}
)::Vector{Vector{Int}}
    n = graph.num_vertices
    length(colors) == n || error("Internal error: directed refinement color size mismatch.")
    num_colors = isempty(colors) ? 0 : maximum(colors)
    signatures = [zeros(Int, 1 + 2 * num_colors) for _ in 1:n]

    @inbounds for vertex in 1:n
        signature = signatures[vertex]
        signature[1] = colors[vertex]
        for other in 1:n
            cell = colors[other]
            signature[2 * cell] += graph.multiplicities[_directed_slot(vertex, other, n)]
            signature[2 * cell + 1] += graph.multiplicities[_directed_slot(
                other, vertex, n
            )]
        end
    end
    return signatures
end

@inline function _directed_signature_less(a::Vector{Int}, b::Vector{Int})::Bool
    @inbounds for index in eachindex(a, b)
        a[index] == b[index] && continue
        return a[index] < b[index]
    end
    return false
end

function _directed_refine_once(graph::DirectedGCGraph, colors::Vector{Int})::Vector{Int}
    signatures = _directed_refinement_signatures(graph, colors)
    order = collect(eachindex(colors))
    sort!(order; lt=(a, b) -> _directed_signature_less(signatures[a], signatures[b]))

    refined = similar(colors)
    next_color = 0
    previous_vertex = 0
    @inbounds for vertex in order
        if iszero(previous_vertex) ||
            !isequal(signatures[vertex], signatures[previous_vertex])
            next_color += 1
        end
        refined[vertex] = next_color
        previous_vertex = vertex
    end
    return refined
end

"""
Return the coarsest stable directed weighted equitable refinement of `vertex_colors`.

The initial opaque integer colors are first assigned deterministic ranks by sorted color value.
Each refinement signature consists of the current color followed by exact outgoing and incoming
edge-multiplicity totals to every current color cell. Signatures are sorted lexicographically and
assigned dense deterministic ranks. Iteration stops when no cell splits further.
"""
function _directed_refined_colors(
    graph::DirectedGCGraph, vertex_colors::Vector{Int}
)::Vector{Int}
    length(vertex_colors) == graph.num_vertices ||
        error("Internal error: directed refinement color size mismatch.")
    colors = _directed_initial_color_ranks(vertex_colors)
    while true
        refined = _directed_refine_once(graph, colors)
        refined == colors && return colors
        colors = refined
    end
end

function _directed_refined_cells(
    graph::DirectedGCGraph, vertex_colors::Vector{Int}
)::Vector{Vector{Int}}
    colors = _directed_refined_colors(graph, vertex_colors)
    num_colors = isempty(colors) ? 0 : maximum(colors)
    cells = [Int[] for _ in 1:num_colors]
    @inbounds for vertex in eachindex(colors)
        push!(cells[colors[vertex]], vertex)
    end
    return cells
end
