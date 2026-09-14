function _apply_directed_witness(
    graph::DirectedGCGraph, relabeling::VertexRelabeling
)::DirectedGCGraph
    return GraphCombinations._relabel_directed_graph(graph, vertex_mapping(relabeling))
end

@testset "directed graph construction and fixed colors" begin
    graph = @inferred DirectedGCGraph([1 => 2, 1 => 2, 2 => 1, 2 => 2], 2)
    result = @inferred canonicalize_directed(graph, Int[10, 20])

    @test canonical_graph(result) == graph
    @test vertex_mapping(canonical_relabeling(result)) == [1, 2]
    @test canonical_automorphism_order(result) == 1
    @test _apply_directed_witness(graph, canonical_relabeling(result)) == canonical_graph(result)

    @test_throws ArgumentError DirectedGCGraph([1 => 3], 2)
    @test_throws ArgumentError DirectedGCGraph([0 => 1], 2)
    @test_throws ArgumentError DirectedGCGraph(Pair{Int,Int}[], -1)
    @test_throws ArgumentError canonicalize_directed(graph, Int[1])
    @test_throws ArgumentError VertexRelabeling([1, 1])
end

@testset "old-to-new witness convention" begin
    graph = DirectedGCGraph([1 => 3], 3)
    colors = Int[1, 1, 2]
    result = canonicalize_directed(graph, colors)

    @test vertex_mapping(canonical_relabeling(result)) == [2, 1, 3]
    @test canonical_graph(result) == DirectedGCGraph([2 => 3], 3)
    @test canonical_automorphism_order(result) == 1
    @test _apply_directed_witness(graph, canonical_relabeling(result)) == canonical_graph(result)
end

@testset "color-preserving automorphism order" begin
    cycle = DirectedGCGraph([1 => 2, 2 => 3, 3 => 1], 3)
    cycle_result = @inferred canonicalize_directed(cycle, Int[1, 1, 1])
    @test canonical_automorphism_order(cycle_result) == 3
    @test _apply_directed_witness(cycle, canonical_relabeling(cycle_result)) ==
          canonical_graph(cycle_result)

    symmetric = DirectedGCGraph([1 => 3, 2 => 3, 3 => 1, 3 => 2], 3)
    symmetric_result = canonicalize_directed(symmetric, Int[1, 1, 2])
    @test canonical_automorphism_order(symmetric_result) == 2
    @test vertex_mapping(canonical_relabeling(symmetric_result))[3] == 3

    edgeless = DirectedGCGraph(Pair{Int,Int}[], 3)
    edgeless_result = canonicalize_directed(edgeless, Int[1, 1, 1])
    @test canonical_automorphism_order(edgeless_result) == 6
end

@testset "direction is part of canonical identity" begin
    out_star = DirectedGCGraph([1 => 2, 1 => 3], 3)
    in_star = DirectedGCGraph([2 => 1, 3 => 1], 3)

    @test canonical_graph(canonicalize_directed(out_star)) !=
          canonical_graph(canonicalize_directed(in_star))
end

@testset "loops, parallel edges, and relabeled-copy invariance" begin
    edges = [1 => 1, 1 => 2, 1 => 2, 2 => 3, 3 => 1]
    graph = DirectedGCGraph(edges, 3)
    permutation = Int[2, 3, 1]
    relabeled_edges = [permutation[first(edge)] => permutation[last(edge)] for edge in edges]
    relabeled = DirectedGCGraph(relabeled_edges, 3)

    original_result = canonicalize_directed(graph)
    relabeled_result = canonicalize_directed(relabeled)

    @test canonical_graph(original_result) == canonical_graph(relabeled_result)
    @test canonical_automorphism_order(original_result) ==
          canonical_automorphism_order(relabeled_result)
    @test _apply_directed_witness(graph, canonical_relabeling(original_result)) ==
          canonical_graph(original_result)
    @test _apply_directed_witness(relabeled, canonical_relabeling(relabeled_result)) ==
          canonical_graph(relabeled_result)
end

@testset "colored relabeled-copy invariance" begin
    edges = [1 => 3, 2 => 3, 3 => 4, 4 => 1]
    colors = Int[1, 1, 2, 3]
    graph = DirectedGCGraph(edges, 4)

    permutation = Int[2, 1, 3, 4]
    relabeled_edges = [permutation[first(edge)] => permutation[last(edge)] for edge in edges]
    relabeled_colors = similar(colors)
    for old_vertex in eachindex(colors)
        relabeled_colors[permutation[old_vertex]] = colors[old_vertex]
    end
    relabeled = DirectedGCGraph(relabeled_edges, 4)

    result = canonicalize_directed(graph, colors)
    relabeled_result = canonicalize_directed(relabeled, relabeled_colors)
    @test canonical_graph(result) == canonical_graph(relabeled_result)
    @test canonical_automorphism_order(result) == canonical_automorphism_order(relabeled_result)
end

@testset "empty directed graph" begin
    graph = DirectedGCGraph(Pair{Int,Int}[], 0)
    result = @inferred canonicalize_directed(graph, Int[])
    @test canonical_graph(result) == graph
    @test vertex_mapping(canonical_relabeling(result)) == Int[]
    @test canonical_automorphism_order(result) == 1
end
