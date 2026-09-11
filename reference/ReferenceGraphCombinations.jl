module ReferenceGraphCombinations

using Combinatorics: permutations
using Memoization
import GraphCombinations as GC

const Edge = GC.Edge
const GraphRep = GC.GraphRep

# Memoized Wick oracle retained outside the production module. Keep the original Dict-backed
# semantics so reference benchmarks remain directly comparable to their historical baselines.
@memoize Dict function _corr_memo(points::Vector{Int})
    n = length(points)
    if n == 0
        return [Vector{Edge}()]
    elseif n == 2
        a, b = points
        return [[Edge(a, b)]]
    end

    a = points[1]
    all_terms = Vector{Vector{Edge}}()
    for i in 2:n
        xi = points[i]
        propagator = Edge(a, xi)
        remaining_points = vcat(points[2:(i - 1)], points[(i + 1):n])
        sub_terms = _corr_memo(remaining_points)
        for term in sub_terms
            push!(all_terms, vcat([propagator], term))
        end
    end
    return all_terms
end

function clear_corr_cache!()
    Memoization.empty_cache!(_corr_memo)
    return nothing
end

function corr(points::Vector{Int})
    if isodd(length(points))
        error("Cannot compute corr for an odd number of points: $(points)")
    end
    sorted_points = sort(points)
    return _corr_memo(sorted_points)
end

function create_points(n::Vector{Int})
    points = Vector{Int}()
    current_vertex_index = 1
    for i in 1:length(n)
        for _ in 1:n[i]
            for _ in 1:i
                push!(points, current_vertex_index)
            end
            current_vertex_index += 1
        end
    end
    return points
end

function filter_graphs(all_pairings, num_total_vertices)::Vector{GraphRep}
    connected_graphs = Vector{GraphRep}()
    for graph_rep in all_pairings
        g = GC.build_internal_graph(graph_rep, num_total_vertices)
        if GC.is_connected(g)
            push!(connected_graphs, GC.sort_graph_edges(graph_rep))
        end
    end
    return connected_graphs
end

function apply_permutation(
    graph::GraphRep, perm_map::Dict{Int,Int}, internal_indices::UnitRange{Int}
)::GraphRep
    new_graph = Vector{Edge}(undef, length(graph))
    for (i, prop) in enumerate(graph)
        u, v = prop.first, prop.second
        u_new = u in internal_indices ? get(perm_map, u, u) : u
        v_new = v in internal_indices ? get(perm_map, v, v) : v
        new_graph[i] = Edge(minmax(u_new, v_new)...)
    end
    return sort(new_graph)
end

function canonical_form_reference(
    graph::GraphRep, internal_indices::UnitRange{Int}
)::GraphRep
    if length(internal_indices) < 2
        return GC.sort_graph_edges(graph)
    end

    internal_vec = collect(internal_indices)
    current_canonical = GC.sort_graph_edges(graph)
    for p in permutations(internal_vec)
        perm_map = Dict(zip(internal_vec, p))
        permuted_graph = apply_permutation(graph, perm_map, internal_indices)
        permuted_graph < current_canonical && (current_canonical = permuted_graph)
    end
    return current_canonical
end

function canonical_form_scratch(graph::GraphRep, internal_indices::UnitRange{Int})::GraphRep
    if length(internal_indices) < 2
        return GC.sort_graph_edges(graph)
    end

    internal_vec = collect(internal_indices)
    first_internal = first(internal_indices)
    last_internal = last(internal_indices)
    current_canonical = GC.sort_graph_edges(graph)
    candidate = similar(graph)

    for permutation in permutations(internal_vec)
        @inbounds for i in eachindex(graph)
            prop = graph[i]
            u, v = prop.first, prop.second
            u_new = if first_internal <= u <= last_internal
                permutation[u - first_internal + 1]
            else
                u
            end
            v_new = if first_internal <= v <= last_internal
                permutation[v - first_internal + 1]
            else
                v
            end
            candidate[i] = Edge(minmax(u_new, v_new)...)
        end
        sort!(candidate)
        candidate < current_canonical && copyto!(current_canonical, candidate)
    end
    return current_canonical
end

function reduce_isomorphic_graphs(
    graphs::Vector{GraphRep}, internal_indices::UnitRange{Int}
)
    if length(graphs) == 1
        return [GC.canonical_form(graphs[1], internal_indices) => 1]
    elseif isempty(graphs)
        return Vector{Pair{GraphRep,Int}}()
    end

    counts = Dict{GraphRep,Int}()
    for graph in graphs
        canon_g = GC.canonical_form(graph, internal_indices)
        counts[canon_g] = get(counts, canon_g, 0) + 1
    end
    return collect(pairs(counts))
end

function allgraphs_wick_reference(n::Vector{Int}; connected=true)
    points = create_points(n)
    all_pairings = corr(points)
    num_total_vertices = sum(n)
    connected_graphs = if connected
        filter_graphs(all_pairings, num_total_vertices)
    else
        GC.sort_graph_edges.(all_pairings)
    end
    if isempty(connected_graphs)
        return Vector{Tuple{GraphRep,BigInt}}()
    end

    num_external = n[1]
    internal_indices = (num_external + 1):num_total_vertices
    reduced_graphs_with_counts = reduce_isomorphic_graphs(
        connected_graphs, internal_indices
    )
    normalization = GC.combinatoric_factor(n)

    final_results = Vector{Tuple{GraphRep,BigInt}}()
    for (canonical_graph, count) in reduced_graphs_with_counts
        symmetry_factor, remainder = divrem(normalization, count)
        iszero(remainder) || error(
            "Internal error: combinatorial factor $normalization is not divisible by contraction count $count.",
        )
        push!(final_results, (canonical_graph, symmetry_factor))
    end
    return final_results
end

end # module ReferenceGraphCombinations
