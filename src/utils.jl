# --- Core Definitions and Helpers ---

const Edge = Pair{Int,Int} # Represents Δ[a, b] with a < b
const GraphRep = Vector{Edge}

"""
    sort_graph_propagators(graph::GraphRep)::GraphRep

Sorts propagators within a graph representation canonically.
Ensures `a < b` in each `a => b` and then sorts the vector of propagators.
"""
function sort_graph_propagators(graph::GraphRep)::GraphRep
    # Ensure a < b in each propagator and sort the propagators
    sorted_props = [Edge(minmax(p.first, p.second)...) for p in graph]
    return sort(sorted_props) # Sorts based on pairs, first element then second
end

"""
    apply_permutation(graph::GraphRep, perm_map::Dict{Int, Int}, internal_indices::UnitRange{Int})::GraphRep

Applies a permutation map to the internal vertices of a graph.
Returns a new graph representation with permuted internal vertices, sorted canonically.
"""
function apply_permutation(
    graph::GraphRep, perm_map::Dict{Int,Int}, internal_indices::UnitRange{Int}
)::GraphRep
    new_graph = Vector{Edge}(undef, length(graph))
    for (i, prop) in enumerate(graph)
        u, v = prop.first, prop.second
        # Apply permutation only if the vertex is internal
        u_new = u in internal_indices ? get(perm_map, u, u) : u
        v_new = v in internal_indices ? get(perm_map, v, v) : v
        # Ensure canonical order within the propagator
        new_graph[i] = Edge(minmax(u_new, v_new)...)
    end
    # Return the sorted list of propagators
    return sort(new_graph)
end

"""
    canonical_form(graph::GraphRep, internal_indices::UnitRange{Int})::GraphRep

Finds the canonical representation of a graph under permutations of internal vertices.
The canonical form is the lexicographically smallest graph representation achievable
through permutation of `internal_indices`.
"""
function canonical_form(graph::GraphRep, internal_indices::UnitRange{Int})::GraphRep
    # Handle cases with 0 or 1 internal vertex (no non-trivial permutations)
    if length(internal_indices) < 2
        # Just ensure the graph propagators themselves are sorted
        return sort_graph_propagators(graph)
    end

    internal_vec = collect(internal_indices)
    perms = permutations(internal_vec)

    # Start with the sorted version of the original graph as the initial best candidate
    # Sorting ensures consistent comparison basis
    current_canonical = sort_graph_propagators(graph)

    for p in perms
        # Create the mapping for the current permutation
        perm_map = Dict(zip(internal_vec, p))
        # Apply the permutation and get the sorted result
        permuted_g = apply_permutation(graph, perm_map, internal_indices)

        # Update canonical form if the new permuted graph is lexicographically smaller
        # Comparison works directly on sorted Vector{Edge}
        if permuted_g < current_canonical
            current_canonical = permuted_g
        end
    end
    return current_canonical
end

"""
    $(TYPEDSIGNATURES)

Builds a [`MultigraphWrap`](@ref) from an edges list.
"""
function build_graph(graph_rep::GraphRep, num_vertices::Int)::MultigraphWrap
    g = Multigraph(num_vertices)
    for prop in graph_rep
        add_edge!(g, prop.first, prop.second, 1)
    end
    return MultigraphWrap(g)
end

function build_graph(graph_rep::GraphRep)::MultigraphWrap
    vertices = unique(vcat(first.(graph_rep), last.(graph_rep)))
    num_vertices = length(vertices)
    return build_graph(graph_rep, num_vertices)
end
