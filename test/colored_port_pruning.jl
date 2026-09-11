import GraphCombinations as GC

@testset "accept-all pruning matches baseline" begin
    problem = GC._PortMatchingProblem(
        fill(1, 3), ones(Int, 3, 1), ones(Int, 3, 1), trues(1, 1)
    )
    baseline, baseline_stats = GC._weighted_port_matchings_with_stats(problem)
    pruned, stats = GC._weighted_port_matchings_pruned_with_stats(problem, _ -> true)

    @test pruned == baseline
    @test stats.pruned_transitions == 0
    @test stats.automorphisms == baseline_stats.automorphisms
    @test stats.layer_states == baseline_stats.layer_states
    @test stats.transitions == baseline_stats.transitions
    @test stats.canonicalization_calls == baseline_stats.canonicalization_calls
    @test stats.merged_transitions == baseline_stats.merged_transitions
end

@testset "monotone invariant pruning matches completion filtering" begin
    problem = GC._PortMatchingProblem(
        fill(1, 3), ones(Int, 3, 1), ones(Int, 3, 1), trues(1, 1)
    )
    no_self_edges(state) = all(edge -> edge.source != edge.target, state.edges)

    baseline = filter(
        result -> all(edge -> edge.source != edge.target, first(result)),
        GC._weighted_port_matchings(problem),
    )
    pruned, stats = GC._weighted_port_matchings_pruned_with_stats(problem, no_self_edges)

    @test pruned == baseline
    @test stats.pruned_transitions > 0
    @test stats.canonicalization_calls < stats.transitions + 1
end
