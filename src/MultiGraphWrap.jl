# https://github.com/MakieOrg/GraphMakie.jl/issues/52

using Multigraphs
using Graphs
using Graphs.SimpleGraphs

struct MultigraphWrap{T} <: AbstractGraph{T}
    g::Multigraph{T}
end
Base.eltype(g::MultigraphWrap) = eltype(g.g)
Graphs.edgetype(g::MultigraphWrap) = edgetype(g.g)
Graphs.has_edge(g::MultigraphWrap, s, d) = has_edge(g.g, s, d)
Graphs.has_vertex(g::MultigraphWrap, i) = has_vertex(g.g, i)
Graphs.inneighbors(g::MultigraphWrap{T}, i) where {T} = inneighbors(g.g, i)
Graphs.outneighbors(g::MultigraphWrap{T}, i) where {T} = outneighbors(g.g, i)

Graphs.ne(g::MultigraphWrap) = ne(g.g; count_mul=true)
Graphs.nv(g::MultigraphWrap) = nv(g.g)
Graphs.vertices(g::MultigraphWrap) = vertices(g.g)
Graphs.is_directed(g::MultigraphWrap) = is_directed(g.g)
Graphs.is_directed(::Type{<:MultigraphWrap}) = false
Graphs.is_connected(g::MultigraphWrap) = is_connected(g.g)

function Graphs.edges(g::MultigraphWrap)
    out = SimpleEdge[]
    for e in edges(g.g)
        for m in 1:e.mul
            push!(out, SimpleEdge(e.src, e.dst))
        end
    end
    return out
end

function gen_distances(g::MultigraphWrap; inc=0.25)
    edgearray = edges(g.g)
    distances = Float64[]
    for e in edgearray
        multiplicity = mul(e)
        if isone(multiplicity)
            push!(distances, 0.0)
        else
            m = iseven(multiplicity) ? (multiplicity ÷ 2) : (multiplicity-1) ÷ 2
            append!(distances, collect(range(-m*inc, m*inc; length=multiplicity)))
        end
    end
    return distances
end
