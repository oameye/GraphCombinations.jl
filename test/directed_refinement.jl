@testset "stable directed weighted equitable refinement" begin
    graph = DirectedGCGraph([1 => 3, 1 => 3, 2 => 3], 3)
    cells = GraphCombinations._directed_refined_cells(graph, Int[1, 1, 2])
    @test cells == [Int[2], Int[1], Int[3]]

    cycle = DirectedGCGraph([1 => 2, 2 => 3, 3 => 1], 3)
    @test GraphCombinations._directed_refined_cells(cycle, Int[1, 1, 1]) ==
        [Int[1, 2, 3]]

    empty_graph = DirectedGCGraph(Pair{Int,Int}[], 0)
    @test GraphCombinations._directed_refined_cells(empty_graph, Int[]) ==
        Vector{Vector{Int}}()
end

@testset "directed refinement is equivariant under arbitrary relabeling" begin
    edges = [1 => 1, 1 => 3, 1 => 3, 2 => 4, 3 => 2, 4 => 1]
    colors = Int[10, 10, 20, 30]
    graph = DirectedGCGraph(edges, 4)
    permutation = Int[3, 1, 4, 2]

    relabeled_edges = [
        permutation[first(edge)] => permutation[last(edge)] for edge in edges
    ]
    relabeled_colors = similar(colors)
    @inbounds for old_vertex in eachindex(colors)
        relabeled_colors[permutation[old_vertex]] = colors[old_vertex]
    end
    relabeled_graph = DirectedGCGraph(relabeled_edges, 4)

    refined = GraphCombinations._directed_refined_colors(graph, colors)
    relabeled_refined =
        GraphCombinations._directed_refined_colors(relabeled_graph, relabeled_colors)
    @inbounds for old_vertex in eachindex(colors)
        @test relabeled_refined[permutation[old_vertex]] == refined[old_vertex]
    end
end
