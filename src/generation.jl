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

    return _allgraphs_hybrid(normalized_n; connected)
end

"""
$(TYPEDSIGNATURES)

Computes the exact combinatorial normalization used to obtain graph symmetry denominators.

For `n[k]` vertices of degree `k`, the normalization is
`(∏_{k≥2} n_k!) (∏_{k≥1} (k!)^{n_k})`.

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
