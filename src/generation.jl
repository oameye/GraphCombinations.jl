# --- Graph Generation ---

"""
    $(TYPEDSIGNATURES)

Generates all unique, connected topologies for a given vertex specification.
It takes in a vector where `n[k]` is the number of vertices of degree `k`.

Returns a Vector of Tuples `(Vector{Edge}, S)` with `Edge`` a `Tuple{Int64,Int64}`
representing an edge in the graph and `S::Float64` the corresponding symmetry factor.
"""
function allgraphs(n::Vector{Int})
    # Input validation
    if isempty(n) || any(x -> x < 0, n)
        error("Input vector n must be non-empty and contain non-negative integers.")
    end
    # Remove trailing zeros for canonical representation of n
    while length(n) > 1 && n[end] == 0
        pop!(n)
    end
    if isempty(n) # Handle case where input was all zeros
        return Vector{Tuple{GraphRep,Float64}}()
    end

    # Check total degree (Handshaking Lemma)
    _total_degree = total_degree(n)
    if isodd(_total_degree)
        # Cannot form pairings with an odd number of connection points
        return Vector{Tuple{GraphRep,Float64}}()
    end

    num_external = n[1]
    num_total_vertices = sum(n)

    # Base case: n = [2] (or [2, 0, 0...]) -> two external vertices
    if num_total_vertices == 2 && num_external == 2 && length(n) == 1
        # Symmetry factor calculation: vertex_perms=1, edge_perms=(1!)^2=1. count=1.
        return [([Edge(1, 2)], 1.0)]
    end
    # Handle case n = [0], should not happen if total_degree is even and non-zero, but good practice
    if num_total_vertices == 0
        return Vector{Tuple{GraphRep,Float64}}()
    end

    return _allgraphs(n)
end

function _allgraphs(n::Vector{Int})
    # 1. Generate points for correlation function
    points = create_points(n)

    # 2. Generate all pairings (raw graphs)
    all_pairings = corr(points)

    # 3. Filter for connected graphs
    connected_graphs = filter_graphs(all_pairings)
    if isempty(connected_graphs)
        return Vector{Tuple{GraphRep,Float64}}()
    end

    # 5. Reduce isomorphic graphs
    num_total_vertices = sum(n)
    num_external = n[1]
    internal_indices = (num_external + 1):num_total_vertices
    reduced_graphs_with_counts = reduce_isomorphic_graphs(
        connected_graphs, internal_indices
    )

    # 6. Calculate symmetry factors
    _combinatoric_factor = combinatoric_factor(n)

    # 7. Combine results
    final_results = Vector{Tuple{GraphRep,Float64}}()
    for (canonical_graph, count) in reduced_graphs_with_counts
        # count is the number of raw connected graphs mapping to this canonical form
        symmetry_factor = _combinatoric_factor / count

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
- Vertex 1 (degree 1) appears once: [1]
- Vertex 2 (degree 1) appears once: [2]
- Vertex 3 (degree 2) appears twice: [3, 3]
- Result: [1, 2, 3, 3]
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

Computes the combinatorial factor for graph symmetry calculations.

This function calculates the product of two factors:
1. The vertex permutation factor: number of ways to permute identical internal vertices
2. The edge endpoint permutation factor: number of ways to permute edge endpoints
   attached to vertices of the same degree

This factor is used in the calculation of symmetry factors for Feynman diagrams.

## Parameters
- `n`: Vector where `n[k]` is the number of vertices with degree `k`

## Returns
- A floating point number representing the total combinatorial factor
"""
function combinatoric_factor(n)
    vertex_perms_factor = 1.0
    if length(n) > 1 # Factor from permutations of identical internal vertices (degree > 1)
        vertex_perms_factor = prod(factorial.(n[2:end]))
    end

    # Factor from permutations of edge endpoints attached to vertices of same degree
    edge_endpoint_perms_factor = prod(factorial(k)^n[k] for k in 1:length(n))

    total_combinatoric_factor = vertex_perms_factor * edge_endpoint_perms_factor
    return total_combinatoric_factor
end
