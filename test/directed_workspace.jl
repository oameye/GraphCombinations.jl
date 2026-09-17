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
    workspace = DirectedCanonicalizationWorkspace(5)
    buffer = DirectedCanonicalizationBuffer(5)
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

@testset "capacity workspace hot path is allocation free" begin
    graph = DirectedGCGraph(
        vcat(
            [vertex => mod1(vertex + 1, 7) for vertex in 1:7],
            [mod1(vertex + 1, 7) => vertex for vertex in 1:7],
        ),
        7,
    )
    colors = ones(Int, 7)
    workspace = DirectedCanonicalizationWorkspace(9)
    buffer = DirectedCanonicalizationBuffer(9)

    canonicalize_directed!(buffer, workspace, graph, colors)
    allocated = @allocated canonicalize_directed!(buffer, workspace, graph, colors)
    @test allocated == 0
    @test canonical_automorphism_order(buffer) == 14
end

@testset "capacity storage is exact across changing graph sizes" begin
    large_edges = [1 => 1, 1 => 3, 1 => 3, 2 => 4, 3 => 2, 4 => 1]
    small_edges = [1 => 2, 2 => 1, 2 => 2]
    large_colors = Int[10, 10, 20, 30]
    small_colors = Int[7, 7]
    large = DirectedGCGraph(large_edges, 4)
    small = DirectedGCGraph(small_edges, 2)
    expected_large = canonicalize_directed(large, large_colors)
    expected_small = canonicalize_directed(small, small_colors)

    workspace = DirectedCanonicalizationWorkspace(6)
    buffer = DirectedCanonicalizationBuffer(6)

    for (graph, colors, expected) in (
        (large, large_colors, expected_large),
        (small, small_colors, expected_small),
        (large, large_colors, expected_large),
    )
        canonicalize_directed!(buffer, workspace, graph, colors)
        @test canonical_graph(buffer) == canonical_graph(expected)
        @test canonical_automorphism_order(buffer) == canonical_automorphism_order(expected)
    end
end

@testset "reusable directed graph input buffer" begin
    pair_edges = [1 => 1, 1 => 3, 1 => 3, 2 => 4, 3 => 2, 4 => 1]
    tuple_edges = [(first(edge), last(edge)) for edge in pair_edges]
    small_edges = [(1, 2), (2, 1), (2, 2)]
    colors = Int[10, 10, 20, 30]
    small_colors = Int[7, 7]
    expected = canonicalize_directed(DirectedGCGraph(pair_edges, 4), colors)
    expected_small = canonicalize_directed(
        DirectedGCGraph([1 => 2, 2 => 1, 2 => 2], 2), small_colors
    )

    graph = DirectedGCGraphBuffer(6)
    workspace = DirectedCanonicalizationWorkspace(6)
    buffer = DirectedCanonicalizationBuffer(6)

    @test @inferred(load_directed_graph!(graph, tuple_edges, 4)) === graph
    @test @inferred(canonicalize_directed!(buffer, workspace, graph, colors)) === buffer
    @test canonical_graph(buffer) == canonical_graph(expected)
    @test canonical_automorphism_order(buffer) == canonical_automorphism_order(expected)

    load_directed_graph!(graph, small_edges, 2)
    canonicalize_directed!(buffer, workspace, graph, small_colors)
    @test canonical_graph(buffer) == canonical_graph(expected_small)

    load_directed_graph!(graph, pair_edges, 4)
    canonicalize_directed!(buffer, workspace, graph, colors)
    @test canonical_graph(buffer) == canonical_graph(expected)

    allocated = @allocated begin
        load_directed_graph!(graph, small_edges, 2)
        canonicalize_directed!(buffer, workspace, graph, small_colors)
        load_directed_graph!(graph, tuple_edges, 4)
        canonicalize_directed!(buffer, workspace, graph, colors)
    end
    @test allocated == 0

    @test_throws ArgumentError load_directed_graph!(graph, [(0, 1)], 2)
    @test_throws ArgumentError load_directed_graph!(graph, [(1, 5)], 4)
    @test_throws DimensionMismatch load_directed_graph!(graph, pair_edges, 7)
end

@testset "uncolored and empty reusable canonicalization" begin
    graph = DirectedGCGraph([1 => 2, 2 => 3, 3 => 1], 3)
    expected = canonicalize_directed(graph)
    workspace = DirectedCanonicalizationWorkspace(5)
    buffer = DirectedCanonicalizationBuffer(5)
    canonicalize_directed!(buffer, workspace, graph)
    @test canonical_graph(buffer) == canonical_graph(expected)
    @test canonical_automorphism_order(buffer) == canonical_automorphism_order(expected)

    empty_graph = DirectedGCGraph(Pair{Int,Int}[], 0)
    canonicalize_directed!(buffer, workspace, empty_graph, Int[])
    @test canonical_graph(buffer) == empty_graph
    @test canonical_automorphism_order(buffer) == 1
end

@testset "reusable storage validates capacity" begin
    graph = DirectedGCGraph([1 => 2, 2 => 3], 3)
    @test_throws DimensionMismatch canonicalize_directed!(
        DirectedCanonicalizationBuffer(2),
        DirectedCanonicalizationWorkspace(3),
        graph,
        Int[1, 1, 1],
    )
    @test_throws DimensionMismatch canonicalize_directed!(
        DirectedCanonicalizationBuffer(3),
        DirectedCanonicalizationWorkspace(2),
        graph,
        Int[1, 1, 1],
    )

    larger_buffer = DirectedCanonicalizationBuffer(4)
    larger_workspace = DirectedCanonicalizationWorkspace(4)
    canonicalize_directed!(larger_buffer, larger_workspace, graph, Int[1, 1, 1])
    @test canonical_graph(larger_buffer) ==
        canonical_graph(canonicalize_directed(graph, Int[1, 1, 1]))

    graph_buffer = DirectedGCGraphBuffer(3)
    load_directed_graph!(graph_buffer, [(1, 2), (2, 3)], 3)
    @test_throws DimensionMismatch canonicalize_directed!(
        DirectedCanonicalizationBuffer(3),
        DirectedCanonicalizationWorkspace(2),
        graph_buffer,
        Int[1, 1, 1],
    )
end
