# --- Graph Generation ---

"""
    allgraphs(n::Vector{Int})

Generates all unique, connected topologies for a given vertex specification.

Args:
    n: A vector where `n[k]` is the number of vertices of degree `k`.
       `n[1]` represents external vertices, `n[k]` for k>1 are internal.

Returns:
    A Vector of Tuples `(graph_representation, symmetry_factor)`.
    `graph_representation` is a canonically sorted `Vector{Edge}`.
    `symmetry_factor` is a Float64.
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
    total_degree = sum(i * n[i] for i in 1:length(n))
    if isodd(total_degree)
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

    # 1. Generate points for correlation function
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

    # 2. Generate all pairings (raw graphs)
    all_pairings = corr(points)

    # 3. Filter for connected graphs
    connected_graphs = filter_graphs(all_pairings, num_total_vertices)
    if isempty(connected_graphs)
        return Vector{Tuple{GraphRep,Float64}}()
    end

    # 4. Define internal indices for reduction
    # Indices are 1 to num_total_vertices.
    # External are 1 to num_external.
    # Internal are num_external + 1 to num_total_vertices.
    internal_indices = (num_external + 1):num_total_vertices

    # 5. Reduce isomorphic graphs
    # reduce_isomorphic_graphs function already returns Vector{Tuple{GraphRep, Int}}
    reduced_graphs_with_counts = reduce_isomorphic_graphs(
        connected_graphs, internal_indices
    )

    # 6. Calculate symmetry factors
    # Factor from permutations of identical internal vertices (degree > 1)
    vertex_perms_factor = 1.0
    if length(n) > 1
        vertex_perms_factor = prod(factorial.(n[2:end]))
    end

    # Factor from permutations of edge endpoints attached to vertices of same degree
    edge_endpoint_perms_factor = prod(factorial(k)^n[k] for k in 1:length(n))

    total_combinatoric_factor = vertex_perms_factor * edge_endpoint_perms_factor

    # 7. Combine results
    final_results = Vector{Tuple{GraphRep,Float64}}()
    for (canonical_graph, count) in reduced_graphs_with_counts
        # count is the number of raw connected graphs mapping to this canonical form
        symmetry_factor = total_combinatoric_factor / count

        push!(final_results, (canonical_graph, symmetry_factor))
    end

    return final_results
end
