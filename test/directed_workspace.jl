@testset "reusable directed canonicalization storage" begin
    edges = [1 => 1, 1 => 3, 1 => 3, 2 => 4, 3 => 2, 4 => 1]
    graph = DirectedGCGraph(edges, 4)
    colors = Int[10, 10, 20, 30]
    expected = canonicalize_directed(graph, colors)

    workspace = DirectedCanonicalizationWorkspace(4)
    buffer = DirectedCanonicalizationBuffer(4)
    @test @inferred(canonicalize_directed!(buffer, workspace, graph, colors)) === buffer
    @test canonical_graph(buffer) == canonical_graph(expected)
    @test canonical_automorphism_order(buffer) == canonical_automorphism_order(expected)

    mapping = vertex_mapping(canonical_relabeling(expected))
    for old_vertex in 1:4
        @test canonical_rank(buffer, old_vertex) == mapping[old_vertex]
        @test original_vertex(buffer, canonical_rank(buffer, old_vertex)) == old_vertex
    end

    relabeled_graph, relabeled_colors = _relabel_directed_fixture(
        graph, colors, Int[3, 1, 4, 2]
    )
    canonicalize_directed!(buffer, workspace, relabeled_graph, relabeled_colors)
    @test canonical_graph(buffer) == canonical_graph(expected)
    @test canonical_automorphism_order(buffer) == canonical_automorphism_order(expected)
end

@testset "flat workspace agrees exhaustively with certified search" begin
    workspace = DirectedCanonicalizationWorkspace(3)
    buffer = DirectedCanonicalizationBuffer(3)
    colorings = (Int[1, 1, 1], Int[1, 1, 2], Int[1, 2, 3])

    for mask in 0:(2 ^ 9 - 1)
        edges = Pair{Int,Int}[]
        bit_index = 0
        for source in 1:3, target in 1:3
            isodd(mask >> bit_index) && push!(edges, source => target)
            bit_index += 1
        end
        graph = DirectedGCGraph(edges, 3)
        for colors in colorings
            expected = canonicalize_directed(graph, colors)
            canonicalize_directed!(buffer, workspace, graph, colors)
            @test canonical_graph(buffer) == canonical_graph(expected)
            @test canonical_automorphism_order(buffer) ==
                canonical_automorphism_order(expected)
            mapping = vertex_mapping(canonical_relabeling(expected))
            @test all(canonical_rank(buffer, vertex) == mapping[vertex] for vertex in 1:3)
        end
    end
end

@testset "prepared workspace hot path is allocation free" begin
    graph = DirectedGCGraph(
        vcat(
            [vertex => mod1(vertex + 1, 7) for vertex in 1:7],
            [mod1(vertex + 1, 7) => vertex for vertex in 1:7],
        ),
        7,
    )
    colors = ones(Int, 7)
    workspace = DirectedCanonicalizationWorkspace(7)
    buffer = DirectedCanonicalizationBuffer(7)

    canonicalize_directed!(buffer, workspace, graph, colors)
    allocated = @allocated canonicalize_directed!(buffer, workspace, graph, colors)
    @test allocated == 0
    @test canonical_automorphism_order(buffer) == 14
end

@testset "uncolored and empty reusable canonicalization" begin
    graph = DirectedGCGraph([1 => 2, 2 => 3, 3 => 1], 3)
    expected = canonicalize_directed(graph)
    workspace = DirectedCanonicalizationWorkspace(3)
    buffer = DirectedCanonicalizationBuffer(3)
    canonicalize_directed!(buffer, workspace, graph)
    @test canonical_graph(buffer) == canonical_graph(expected)
    @test canonical_automorphism_order(buffer) == canonical_automorphism_order(expected)

    empty_graph = DirectedGCGraph(Pair{Int,Int}[], 0)
    empty_workspace = DirectedCanonicalizationWorkspace(0)
    empty_buffer = DirectedCanonicalizationBuffer(0)
    canonicalize_directed!(empty_buffer, empty_workspace, empty_graph, Int[])
    @test canonical_graph(empty_buffer) == empty_graph
    @test canonical_automorphism_order(empty_buffer) == 1
end

@testset "reusable storage validates graph size" begin
    graph = DirectedGCGraph([1 => 2], 2)
    @test_throws DimensionMismatch canonicalize_directed!(
        DirectedCanonicalizationBuffer(3),
        DirectedCanonicalizationWorkspace(2),
        graph,
        Int[1, 1],
    )
    @test_throws DimensionMismatch canonicalize_directed!(
        DirectedCanonicalizationBuffer(2),
        DirectedCanonicalizationWorkspace(3),
        graph,
        Int[1, 1],
    )
end
