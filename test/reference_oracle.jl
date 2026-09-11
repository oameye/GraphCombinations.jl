using Test, GraphCombinations
using Combinatorics: permutations
import GraphCombinations as GC

function halfedge_degrees(graph, num_vertices)
    degrees = zeros(Int, num_vertices)
    for edge in graph
        degrees[edge.first] += 1
        degrees[edge.second] += 1
    end
    return degrees
end

function degree_sequence(n)
    degrees = Int[]
    for (degree, count) in enumerate(n)
        append!(degrees, fill(degree, count))
    end
    return degrees
end

function multiplicity_matrix(graph, num_vertices)
    matrix = zeros(Int, num_vertices, num_vertices)
    for edge in graph
        u, v = edge.first, edge.second
        matrix[u, v] += 1
        u == v || (matrix[v, u] += 1)
    end
    return matrix
end

function brute_force_automorphism_order(graph, num_external, num_vertices)
    matrix = multiplicity_matrix(graph, num_vertices)
    internal_vertices = collect((num_external + 1):num_vertices)

    # Count automorphisms directly on the multiplicity matrix. This deliberately does not use
    # canonicalization or `apply_permutation`, so it remains an independent oracle.
    num_automorphisms = 0
    for permutation in permutations(internal_vertices)
        labels = collect(1:num_vertices)
        labels[(num_external + 1):num_vertices] = permutation
        matrix[labels, labels] == matrix && (num_automorphisms += 1)
    end
    return num_automorphisms
end

function brute_force_symmetry_denominator(graph, num_external, num_vertices)
    matrix = multiplicity_matrix(graph, num_vertices)
    num_automorphisms = brute_force_automorphism_order(graph, num_external, num_vertices)

    edge_factor = big(1)
    for u in 1:num_vertices
        loops = matrix[u, u]
        edge_factor *= big(2)^loops * factorial(big(loops))
        for v in (u + 1):num_vertices
            edge_factor *= factorial(big(matrix[u, v]))
        end
    end

    return big(num_automorphisms) * edge_factor
end

pairing_count(total_degree) = prod(big(k) for k in 1:2:(total_degree - 1))

@testset "Wick reference oracle" begin
    # Exhaust a small but structurally diverse set of degree specifications. Keeping the total
    # degree at most eight makes the brute-force Wick path cheap enough to remain a unit-test
    # oracle while still covering loops, parallel edges, mixed valences, and multiple externals.
    specifications = Vector{Vector{Int}}()
    for n1 in 0:2, n2 in 0:2, n3 in 0:2, n4 in 0:2
        n = [n1, n2, n3, n4]
        degree = total_degree(n)
        iseven(degree) && 0 < degree <= 8 && sum(n[2:end]) <= 4 && push!(specifications, n)
    end

    for n in specifications
        results = ReferenceGC.allgraphs_wick_reference(n; connected=false)
        normalization = combinatoric_factor(n)
        num_vertices = sum(n)
        internal_indices = (n[1] + 1):num_vertices
        expected_degrees = degree_sequence(n)

        # The reference path must return one canonical representative per topology class.
        @test length(unique(first.(results))) == length(results)

        reconstructed_pairings = big(0)
        for (graph, symmetry_denominator) in results
            @test symmetry_denominator isa BigInt
            @test symmetry_denominator > 0
            @test iszero(rem(normalization, symmetry_denominator))
            @test graph == GC.canonical_form(graph, internal_indices)
            @test length(graph) * 2 == total_degree(n)
            @test sort(halfedge_degrees(graph, num_vertices)) == sort(expected_degrees)

            # Independent graph-local symmetry formula. External vertices stay fixed; any
            # internal automorphism necessarily preserves valence.
            @test symmetry_denominator ==
                brute_force_symmetry_denominator(graph, n[1], num_vertices)

            reconstructed_pairings += normalization ÷ symmetry_denominator
        end

        # Summing the raw contraction multiplicity of every topology must reconstruct the
        # complete number of perfect matchings of the half-edges.
        @test reconstructed_pairings == pairing_count(total_degree(n))

        connected_results = ReferenceGC.allgraphs_wick_reference(n; connected=true)
        @test all(graph -> GC.is_connected(build_graph(graph)), first.(connected_results))
    end
end
