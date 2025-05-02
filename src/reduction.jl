# --- Graph Reduction ---

"""
$(TYPEDSIGNATURES)

Filters a collection of graph representations to keep only connected graphs.

Takes in a collection of graph representations (each a Vector of Edges) and returns
only those that form connected graphs. Additionally ensures that each returned graph
has its edges sorted in canonical order.

## Arguments
- `all_pairings`: A collection of graph representations to filter

## Returns
- `Vector{GraphRep}`: A vector containing only the connected graphs with sorted edge representations
"""
function filter_graphs(all_pairings)::Vector{GraphRep}
    connected_graphs = Vector{GraphRep}()
    for graph_rep in all_pairings
        # Need num_total_vertices for graph construction
        g = build_graph(graph_rep)
        if is_connected(g)
            # Ensure the graph representation itself is sorted before adding
            push!(connected_graphs, sort_graph_edges(graph_rep))
        end
    end
    return connected_graphs
end

"""
    $(TYPEDSIGNATURES)

Reduces a list of graphs by identifying unique graphs up to permutations of
internal vertices and counting their occurrences.

## Arguments
- graphs: A vector of graph representations (each a Vector{Edge}).
    internal_indices: A UnitRange specifying the indices considered internal,
                      which are subject to permutation for isomorphism checks.

## Returns
- A Vector of Pairs, where each Pair contains the canonical representation
    of a unique graph and its count. e.g. `[(canonical_graph1 => count1), ...]`
"""
function reduce_isomorphic_graphs(
    graphs::Vector{GraphRep}, internal_indices::UnitRange{Int}
)
    # Base case: If only one graph, return it with count 1 (after canonical sort)
    if length(graphs) == 1
        # Use canonical_form which handles sorting and trivial permutations
        # Return a Pair
        return [canonical_form(graphs[1], internal_indices) => 1]
    elseif isempty(graphs)
        # If no graphs, return an empty vector
        return Vector{Pair{GraphRep,Int}}()
    end

    # Dictionary to store counts of canonical forms
    counts = Dict{GraphRep,Int}()
    for graph in graphs
        # Find the canonical form for the current graph
        canon_g = canonical_form(graph, internal_indices)
        # Increment the count for this canonical form
        counts[canon_g] = get(counts, canon_g, 0) + 1
    end

    # Convert the dictionary of counts into a vector of Pairs
    # collect(pairs(counts)) already does this correctly
    return collect(pairs(counts))
end
