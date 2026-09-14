import GraphCombinations as GC

function _compact_profile_problem(vertex_colors::Vector{Int})
    num_vertices = length(vertex_colors)
    source_ports = zeros(Int, num_vertices, 1)
    target_ports = zeros(Int, num_vertices, 1)
    source_ports[1, 1] = 1
    target_ports[2, 1] = 1
    for vertex in 3:num_vertices
        source_ports[vertex, 1] = 2
        target_ports[vertex, 1] = 2
    end
    compatibility = trues(num_vertices, 1, num_vertices, 1)
    compatibility[1, 1, 2, 1] = false
    return GC._PortMatchingProblem(
        vertex_colors, source_ports, target_ports, compatibility, 2
    )
end

function _test_compact_matches_reference(problem::GC._PortMatchingProblem)
    reference_results, reference_stats = @inferred GC._weighted_port_matchings_with_stats(
        problem
    )
    compact_results, compact_stats = @inferred GC._weighted_port_matchings_compact_with_stats(
        problem
    )

    @test compact_results == reference_results
    @test compact_stats.automorphisms == reference_stats.automorphisms
    @test compact_stats.layer_states == reference_stats.layer_states
    @test compact_stats.transitions == reference_stats.transitions
    @test compact_stats.canonicalization_calls == reference_stats.canonicalization_calls
    @test compact_stats.merged_transitions == reference_stats.merged_transitions
    return nothing
end

@testset "compact edge multiplicities preserve canonical edge order" begin
    problem = GC._PortMatchingProblem(
        [1, 2], zeros(Int, 2, 2), zeros(Int, 2, 2), trues(2, 2), 2
    )
    layout = @inferred GC._CompactPortLayout(problem)
    data = zeros(Int, layout.total_length)
    first_edge = GC._compact_port_edge_index(layout, 1, 1, 1, 2)
    second_edge = GC._compact_port_edge_index(layout, 1, 2, 1, 1)
    data[first_edge] = 2
    data[second_edge] = 1
    edges = @inferred GC._materialize_compact_port_edges(GC._CompactPortKey(data), layout)

    @test edges == [
        GC._PortEdge(1, 1, 1, 2),
        GC._PortEdge(1, 1, 1, 2),
        GC._PortEdge(1, 2, 1, 1),
    ]
end

@testset "compact weighted traversal matches reference fixtures" begin
    _test_compact_matches_reference(_compact_profile_problem(collect(1:6)))
    _test_compact_matches_reference(_compact_profile_problem([1, 2, 3, 3, 3]))
    _test_compact_matches_reference(_compact_profile_problem([1, 2, 3, 3, 3, 3]))
end

@testset "compact traversal preserves colored and asymmetric admissibility" begin
    colored = GC._PortMatchingProblem(
        [10, 11, 20, 20],
        [1 0 0; 0 0 0; 0 1 1; 0 1 1],
        [0 0 0; 1 0 0; 0 1 1; 0 1 1],
        Bool[0 1 1; 1 1 1; 1 1 1],
        2,
    )
    _test_compact_matches_reference(colored)

    compatibility = trues(4, 1, 4, 1)
    compatibility[3, 1, 4, 1] = false
    asymmetric = GC._PortMatchingProblem(
        [1, 2, 3, 3], ones(Int, 4, 1), ones(Int, 4, 1), compatibility, 2
    )
    @test length(GC._port_automorphisms(asymmetric)) == 1
    _test_compact_matches_reference(asymmetric)
end

@testset "compact traversal handles empty and impossible problems" begin
    empty_problem = GC._PortMatchingProblem(
        [1, 2], zeros(Int, 2, 1), zeros(Int, 2, 1), trues(1, 1), 2
    )
    _test_compact_matches_reference(empty_problem)

    impossible = GC._PortMatchingProblem(
        [1, 2], ones(Int, 2, 1), ones(Int, 2, 1), falses(1, 1), 2
    )
    _test_compact_matches_reference(impossible)
end
