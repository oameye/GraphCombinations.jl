using Test, GraphCombinations
using GraphCombinations: reduce_isomorphic_graphs, Edge, GraphRep

# Helper function to sort reduce results for comparison
sort_reduce_results(results) = sort(results, by=x -> x[1])
# ^ Sort by canonical graph

function sort_graph_props_test(graph::GraphRep)
    sort([Edge(minmax(p.first, p.second)...) for p in graph])
end

@testset "Graph Reduction (reduce_isomorphic_graphs)" begin
    # Test case 1: Empty input list
    @test reduce_isomorphic_graphs(GraphRep[], 1:0) == [] # Use 1:0 for empty range

    # Test case 2: Single graph, no internal vertices
    graph1 = [Edge(1, 2)]
    @test reduce_isomorphic_graphs([graph1], 1:0) == [graph1 => 1] # Use 1:0 for empty range, expect Pair
    # Test single graph, with internal vertices (should still just return it)
    graph2 = [Edge(1, 3), Edge(2, 4)] # 3, 4 internal
    # Expected canonical form is the sorted graph itself
    expected_graph2_sorted = sort_graph_props_test(graph2)
    @test reduce_isomorphic_graphs([graph2], 3:4) == [expected_graph2_sorted => 1] # Expect Pair

    # Test case 3: Two identical graphs, no internal vertices
    graph3 = [Edge(1, 2), Edge(3, 4)]
    graph3_sorted = sort_graph_props_test(graph3)
    @test reduce_isomorphic_graphs([graph3, graph3], 1:0) == [graph3_sorted => 2] # Use 1:0, expect Pair

    # Test case 4: Two different graphs, no internal vertices
    graph4a = [Edge(1, 2)] # Already sorted
    graph4b = [Edge(1, 3)] # Already sorted
    expected4 = [graph4a => 1, graph4b => 1] # Expect Pairs
    @test sort_reduce_results(reduce_isomorphic_graphs([graph4a, graph4b], 1:0)) ==
        sort_reduce_results(expected4) # Use 1:0
    @test sort_reduce_results(reduce_isomorphic_graphs([graph4b, graph4a], 1:0)) ==
        sort_reduce_results(expected4) # Order invariant

    # Test case 5: Isomorphic graphs via internal permutations
    # g5a: 1-3, 2-4. Internal: 3, 4
    # g5b: 1-4, 2-3. Internal: 3, 4
    # Permutation (3->4, 4->3) maps g5a to g5b and vice versa.
    # Canonical form should be the same (lexicographically smaller one).
    g5a = [Edge(1, 3), Edge(2, 4)]
    g5b = [Edge(1, 4), Edge(2, 3)]
    internal5 = 3:4
    # Canonical form: apply perm {3->3, 4->4} to g5a -> [1=>3, 2=>4] (sorted)
    # apply perm {3->4, 4->3} to g5a -> [1=>4, 2=>3] (sorted)
    # Lexicographically, [1=>3, 2=>4] < [1=>4, 2=>3]
    canonical5 = [Edge(1, 3), Edge(2, 4)] # Expected canonical form
    result5 = reduce_isomorphic_graphs([g5a, g5b], internal5)
    @test length(result5) == 1
    @test result5[1] == (canonical5 => 2) # Check the Pair directly
    # Test with duplicates of one form
    result5_dup = reduce_isomorphic_graphs([g5a, g5a, g5b], internal5)
    @test length(result5_dup) == 1
    @test result5_dup[1] == (canonical5 => 3) # Check the Pair directly

    # Test case 6: Non-isomorphic graphs with internal vertices
    # g6a: 1-3, 2-4. Internal 3, 4. Canonical: [1=>3, 2=>4]
    # g6b: 1-2, 3-4. Internal 3, 4. Canonical: [1=>2, 3=>4] (no change by permuting 3,4)
    g6a = [Edge(1, 3), Edge(2, 4)]
    g6b = [Edge(1, 2), Edge(3, 4)]
    internal6 = 3:4
    canonical6a = [Edge(1, 3), Edge(2, 4)] # From test 5
    canonical6b = sort_graph_props_test(g6b) # [1=>2, 3=>4]
    expected6 = [canonical6a => 1, canonical6b => 1] # Expect Pairs
    result6 = reduce_isomorphic_graphs([g6a, g6b], internal6)
    @test sort_reduce_results(result6) == sort_reduce_results(expected6)

    # Test case 7: More complex internal permutations (3 vertices: 5, 6, 7)
    # g7a: 1-5, 2-6, 3-7, 4-8 (8 is external)
    # g7b: 1-6, 2-5, 3-7, 4-8 (swap 5, 6)
    # g7c: 1-5, 2-7, 3-6, 4-8 (swap 6, 7)
    g7a = [Edge(1, 5), Edge(2, 6), Edge(3, 7), Edge(4, 8)]
    g7b = [Edge(1, 6), Edge(2, 5), Edge(3, 7), Edge(4, 8)]
    g7c = [Edge(1, 5), Edge(2, 7), Edge(3, 6), Edge(4, 8)]
    internal7 = 5:7
    # From thought block: canonical form is the sorted version of g7a
    canonical7 = sort_graph_props_test(g7a) # [1=>5, 2=>6, 3=>7, 4=>8]
    result7 = reduce_isomorphic_graphs([g7a, g7b, g7c], internal7)
    @test length(result7) == 1
    @test result7[1] == (canonical7 => 3) # Check the Pair directly
end
