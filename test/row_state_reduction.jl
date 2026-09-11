using Test, GraphCombinations
import GraphCombinations as GC

function relabel_row_state(graph, mapping)
    relabeled = GC.Edge[]
    sizehint!(relabeled, length(graph))
    for edge in graph
        u = mapping[edge.first]
        v = mapping[edge.second]
        push!(relabeled, GC.Edge(minmax(u, v)...))
    end
    sort!(relabeled)
    return relabeled
end

@testset "Row-state isomorphism reduction" begin
    # The row-reduced generator must reproduce the already certified direct generator over the
    # complete small validation domain, for both connected and disconnected output semantics.
    specifications = Vector{Vector{Int}}()
    for n1 in 0:2, n2 in 0:2, n3 in 0:2, n4 in 0:2
        n = [n1, n2, n3, n4]
        degree = total_degree(n)
        iseven(degree) && 0 < degree <= 8 && sum(n[2:end]) <= 4 && push!(specifications, n)
    end

    for n in specifications
        @test GC._allgraphs_row_reduced(n; connected=false) ==
            GC._allgraphs_direct(n; connected=false)
        @test GC._allgraphs_row_reduced(n; connected=true) ==
            GC._allgraphs_direct(n; connected=true)
    end

    # At a row boundary, only relabelings that preserve the closed/open frontier have equivalent
    # continuation spaces. Open vertices of the same target degree may be exchanged; a closed vertex
    # may not be exchanged with an open one merely because their final degrees agree.
    partial_n = [2, 0, 0, 3]
    target_degrees = GC._vertex_degrees(partial_n)
    row = 4
    partial = [GC.Edge(1, 3), GC.Edge(2, 4), GC.Edge(3, 4), GC.Edge(3, 4), GC.Edge(3, 5)]

    swap_open = [1, 2, 3, 5, 4]
    open_relabeling = relabel_row_state(partial, swap_open)
    @test GC._row_state_key(partial, target_degrees, 2, row).key ==
        GC._row_state_key(open_relabeling, target_degrees, 2, row).key

    swap_across_frontier = [1, 2, 4, 3, 5]
    frontier_relabeling = relabel_row_state(partial, swap_across_frontier)
    @test GC._row_state_key(partial, target_degrees, 2, row).key !=
        GC._row_state_key(frontier_relabeling, target_degrees, 2, row).key

    colors = GC._row_state_colors(target_degrees, 2, row)
    @test colors[3] != colors[4]
    @test colors[4] == colors[5]

    # Select the early quotient by degree-preserving label redundancy, not raw vertex count. The
    # measured crossover is 24 internal permutations: phi^4 order 3 has 3! = 6 and stays direct,
    # while order 4 has 4! = 24 and switches. Mixed-valence inputs with little label redundancy stay
    # on the direct path even when they have four internal vertices.
    @test !GC._use_row_state_reduction([2, 0, 0, 3])
    @test GC._use_row_state_reduction([2, 0, 0, 4])
    @test !GC._use_row_state_reduction([2, 0, 2, 2])
    @test GC._use_row_state_reduction([2, 1, 0, 4])
    @test GC._use_row_state_reduction([2, 0, 0, 6])
    @test GC._use_row_state_reduction([2, 0, 0, 7])

    order3 = [2, 0, 0, 3]
    order4 = [2, 0, 0, 4]
    @test GC._allgraphs_hybrid(order3) == GC._allgraphs_direct(order3)
    @test GC._allgraphs_hybrid(order4) == GC._allgraphs_row_reduced(order4)
    @test allgraphs(order4) == GC._allgraphs_row_reduced(order4)

    # Phi^4 order five is far beyond the Wick oracle but remains small enough to compare both direct
    # generators exactly. Row-state quotienting should reach only one complete state per topology,
    # while rejecting a substantial number of equivalent partial states before completion.
    order5 = [2, 0, 0, 5]
    reduced_order5 = GC._allgraphs_row_reduced(order5; connected=true)
    @test reduced_order5 == GC._allgraphs_direct(order5; connected=true)
    @test length(reduced_order5) == 174
    @test allgraphs(order5) == reduced_order5

    order5_stats = GC._row_reduction_stats(order5; connected=true)
    @test order5_stats.complete_topologies == 340
    @test order5_stats.canonicalization_calls == order5_stats.states
    @test order5_stats.duplicate_states > 0
    @test order5_stats.states < 3_000
    @test order5_stats.states < GC._count_labeled_multigraphs(order5)
end
