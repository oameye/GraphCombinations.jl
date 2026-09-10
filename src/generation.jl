# --- Graph Generation ---

"""
    $(TYPEDSIGNATURES)

Generates all unique topologies for a given vertex specification.
It takes in a vector where `n[k]` is the number of vertices of degree `k`. By default,
it generates connected graphs; disconnected graphs can be computed by setting
`connected=false`.

Returns a vector of tuples `(edges, S)`, where `edges` is a `Vector{Pair{Int,Int}}`
representing the graph and `S::BigInt` is the exact symmetry denominator associated with the
topology. Each edge `a => b` is stored with `a ≤ b`; therefore self-loops such as `a => a`
are valid.

The input vertex specification is not modified.

## Example
For input `n = [2, 0, 0, 2]` (2 vertices of degree 1, 2 vertex of degree 4):
```jldoctest
julia> using GraphCombinations

julia> sort(allgraphs([2, 0, 0, 2]); by=first)
3-element Vector{Tuple{Vector{Pair{Int64, Int64}}, BigInt}}:
 ([1 => 3, 2 => 3, 3 => 4, 3 => 4, 4 => 4], 4)
 ([1 => 3, 2 => 4, 3 => 3, 3 => 4, 4 => 4], 4)
 ([1 => 3, 2 => 4, 3 => 4, 3 => 4, 3 => 4], 6)
```
"""
function allgraphs(n::AbstractVector{<:Integer}; connected=true)
    # Input validation
    if isempty(n) || any(x -> x < 0, n)
        error("Input vector n must be non-empty and contain non-negative integers.")
    end

    # Work on an owned Int vector so normalization never mutates the caller's input.
    normalized_n = collect(Int, n)

    # Remove trailing zeros for canonical representation of n.
    while length(normalized_n) > 1 && iszero(normalized_n[end])
        pop!(normalized_n)
    end

    # Check total degree (Handshaking Lemma)
    _total_degree = total_degree(normalized_n)
    if isodd(_total_degree)
        # Cannot form pairings with an odd number of connection points
        return Vector{Tuple{GraphRep,BigInt}}()
    end

    num_external = normalized_n[1]
    num_total_vertices = sum(normalized_n)

    # Base case: n = [2] (or [2, 0, 0...]) -> two external vertices
    if num_total_vertices == 2 && num_external == 2 && length(normalized_n) == 1
        # Symmetry factor calculation: vertex_perms=1, edge_perms=(1!)^2=1. count=1.
        return [([Edge(1, 2)], big(1))]
    end
    # Handle case n = [0], should not happen if total_degree is even and non-zero, but good practice
    if num_total_vertices == 0
        return Vector{Tuple{GraphRep,BigInt}}()
    end

    return _allgraphs(normalized_n; connected)
end

function _allgraphs(n::Vector{Int}; connected=true)
    # 1. Generate points for correlation function
    points = create_points(n)

    # 2. Generate all pairings (raw graphs)
    all_pairings = corr(points)

    # 3. Filter for connected graphs
    num_total_vertices = sum(n)
    connected_graphs = if connected
        filter_graphs(all_pairings, num_total_vertices)
    else
        sort_graph_edges.(all_pairings)
    end
    if isempty(connected_graphs)
        return Vector{Tuple{GraphRep,BigInt}}()
    end

    # 5. Reduce isomorphic graphs
    num_external = n[1]
    internal_indices = (num_external + 1):num_total_vertices
    reduced_graphs_with_counts = reduce_isomorphic_graphs(
        connected_graphs, internal_indices
    )

    # 6. Calculate symmetry factors
    _combinatoric_factor = combinatoric_factor(n)

    # 7. Combine results
    final_results = Vector{Tuple{GraphRep,BigInt}}()
    for (canonical_graph, count) in reduced_graphs_with_counts
        # `count` is the number of raw contractions mapping to this canonical graph.
        symmetry_factor, remainder = divrem(_combinatoric_factor, count)
        iszero(remainder) || error(
            "Internal error: combinatorial factor $(_combinatoric_factor) is not divisible by contraction count $(count)."
        )

        push!(final_results, (canonical_graph, symmetry_factor))
    end
    return final_results
end

"""
$(TYPEDSIGNATURES)

Converts a vertex degree specification `n` to a flat array of vertex indices.

For a vector `n` where `n[k]` specifies the number of vertices with degree `k`,
this function creates a vector where each vertex index appears a number of times
equal to its degree. This representation is used for generating all possible
pairings in the correlation function calculation.

## Example
For input `n = [2, 1]` (2 vertices of degree 1, 1 vertex of degree 2):
```jldoctest
julia> import GraphCombinations as GC

julia> GC.create_points([2, 1])
4-element Vector{Int64}:
 1
 2
 3
 3
```

"""
function create_points(n::Vector{Int})
    points = Vector{Int}()
    current_vertex_index = 1
    for i in 1:length(n) # Degree i
        for _ in 1:n[i] # Number of vertices with degree i
            for _ in 1:i # Add vertex index 'i' times
                push!(points, current_vertex_index)
            end
            current_vertex_index += 1
        end
    end
    return points
end

"""
$(TYPEDSIGNATURES)

Computes the exact combinatorial normalization used to obtain graph symmetry denominators.

For `n[k]` vertices of degree `k`, this is

```math
\left(\prod_{k\geq 2} n_k!\right)
\left(\prod_{k\geq 1} (k!)^{n_k}\right).
```

The first product counts permutations of identical internal vertices; degree-1 vertices are
external and remain fixed. The second product counts permutations of edge endpoints at each
vertex.

Returns a `BigInt` so the result remains exact even when the factorial products exceed machine
integer range.
"""
function combinatoric_factor(n::AbstractVector{<:Integer})
    factor = big(1)
    for (degree, count) in enumerate(n)
        count < 0 && throw(ArgumentError("Vertex counts must be non-negative."))
        degree > 1 && (factor *= factorial(big(count)))
        factor *= factorial(big(degree))^count
    end
    return factor
end
