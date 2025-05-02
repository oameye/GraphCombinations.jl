# https://github.com/MakieOrg/GraphMakie.jl/issues/52

using Multigraphs
using Graphs
using Graphs.SimpleGraphs

"""
    MultigraphWrap{T} <: AbstractGraph{T}

A wrapper for `Multigraph` that implements the `AbstractGraph` interface from Graphs.jl.

This wrapper is necessary because GraphMakie.jl only supports the Graphs.jl interface,
but not Multigraphs.jl directly. See the discussion at
https://github.com/MakieOrg/GraphMakie.jl/issues/52 for more details.

The wrapper provides all necessary methods to make a `Multigraph` compatible with
functions expecting an `AbstractGraph` from Graphs.jl, especially for visualization
purposes with GraphMakie.jl.
"""
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

"""
    gen_distances(g::MultigraphWrap; inc=0.25)

Generates a list of evenly spaced distances based on the multiplicity of edges in the multigraph. This is useful for plotting the graph for example with GraphMakie.jl.

## Example

```julia
using GraphCombinations, GraphMakie, CairoMakie
import GraphMakie.NetworkLayout as NL
import GraphCombinations as GC

n = [2, 0, 0, 2]

topologies = allgraphs(n)
graph, _ = last(topologies)
g = GC.build_graph(graph)

f, ax, p = graphplot(g;
    layout=NL.Align(NL.Spring()),
    curve_distance=GC.gen_distances(g), curve_distance_usage=true)
```
"""
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
