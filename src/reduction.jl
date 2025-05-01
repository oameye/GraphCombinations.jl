# --- Graph Reduction ---

"""
    reduce_isomorphic_graphs(graphs::Vector{GraphRep}, internal_indices::UnitRange{Int})

Reduces a list of graphs by identifying unique graphs up to permutations of
internal vertices and counting their occurrences.

Args:
    graphs: A vector of graph representations (each a Vector{Propagator}).
    internal_indices: A UnitRange specifying the indices considered internal,
                      which are subject to permutation for isomorphism checks.

Returns:
    A Vector of Pairs, where each Pair contains the canonical representation
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
    end

    # Handle empty input list
    if isempty(graphs)
        # Return the correct empty vector type
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
