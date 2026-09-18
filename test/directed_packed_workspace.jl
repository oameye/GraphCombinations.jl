@testset "packed directed candidate agrees exhaustively" begin
    general_workspace = DirectedCanonicalizationWorkspace(3)
    packed_workspace = PackedDirectedCanonicalizationWorkspace(3)
    general_buffer = DirectedCanonicalizationBuffer(3)
    packed_buffer = DirectedCanonicalizationBuffer(3)
    colorings = (Int[1, 1, 1], Int[1, 1, 2], Int[1, 2, 3])
    saw_prefix_check = false
    saw_prefix_prune = false

    for mask in 0:(2 ^ 9 - 1)
        edges = Pair{Int,Int}[]
        bit = 0
        for source in 1:3, target in 1:3
            isodd(mask >> bit) && push!(edges, source => target)
            bit += 1
        end
        graph = DirectedGCGraph(edges, 3)
        for colors in colorings
            canonicalize_directed!(general_buffer, general_workspace, graph, colors)
            @test @inferred(
                canonicalize_directed_packed!(
                    packed_buffer, packed_workspace, graph, colors
                )
            ) === packed_buffer
            @test canonical_graph(packed_buffer) == canonical_graph(general_buffer)
            @test canonical_automorphism_order(packed_buffer) ==
                canonical_automorphism_order(general_buffer)
            @test all(
                canonical_rank(packed_buffer, vertex) ==
                canonical_rank(general_buffer, vertex) for vertex in 1:3
            )
            @test packed_workspace.active_splitter_steps > 0
            saw_prefix_check |= packed_workspace.canonical_prefix_checks > 0
            saw_prefix_prune |= packed_workspace.canonical_prefix_prunes > 0
        end
    end
    @test saw_prefix_check
    @test saw_prefix_prune
end

@testset "packed active-cell refinement preserves larger exact semantics" begin
    fixtures = (
        (
            [1 => 2, 2 => 3, 3 => 4, 4 => 5, 5 => 6, 6 => 1, 1 => 4, 2 => 5],
            Int[1, 1, 1, 1, 1, 1],
        ),
        (
            [
                1 => 2,
                2 => 1,
                2 => 3,
                3 => 2,
                3 => 4,
                4 => 3,
                4 => 1,
                1 => 4,
                5 => 1,
                5 => 3,
            ],
            Int[1, 1, 1, 1, 2],
        ),
        (
            [1 => 1, 1 => 2, 2 => 3, 3 => 1, 4 => 2, 4 => 3, 5 => 4, 6 => 4, 6 => 5],
            Int[1, 1, 1, 2, 2, 2],
        ),
    )

    saw_split = false
    for (edges, colors) in fixtures
        n = length(colors)
        graph = DirectedGCGraph(edges, n)
        general_workspace = DirectedCanonicalizationWorkspace(n)
        packed_workspace = PackedDirectedCanonicalizationWorkspace(n)
        general_buffer = DirectedCanonicalizationBuffer(n)
        packed_buffer = DirectedCanonicalizationBuffer(n)

        canonicalize_directed!(general_buffer, general_workspace, graph, colors)
        canonicalize_directed_packed!(packed_buffer, packed_workspace, graph, colors)

        @test canonical_graph(packed_buffer) == canonical_graph(general_buffer)
        @test canonical_automorphism_order(packed_buffer) ==
            canonical_automorphism_order(general_buffer)
        @test all(
            canonical_rank(packed_buffer, vertex) == canonical_rank(general_buffer, vertex)
            for vertex in 1:n
        )
        @test packed_buffer.canonical_to_old[1:n] == general_buffer.canonical_to_old[1:n]
        @test packed_workspace.active_splitter_steps > 0
        saw_split |= packed_workspace.active_cell_splits > 0
    end
    @test saw_split
end

@testset "packed directed candidate exact fallback" begin
    repeated = DirectedGCGraph([1 => 2, 1 => 2, 2 => 1], 2)
    repeated_colors = Int[1, 1]
    expected_repeated = canonicalize_directed(repeated, repeated_colors)
    packed_workspace = PackedDirectedCanonicalizationWorkspace(70)
    buffer = DirectedCanonicalizationBuffer(70)

    canonicalize_directed_packed!(buffer, packed_workspace, repeated, repeated_colors)
    @test canonical_graph(buffer) == canonical_graph(expected_repeated)
    @test canonical_automorphism_order(buffer) ==
        canonical_automorphism_order(expected_repeated)
    @test packed_workspace.canonical_prefix_checks == 0
    @test packed_workspace.canonical_prefix_prunes == 0

    large_edges = [vertex => mod1(vertex + 1, 65) for vertex in 1:65]
    large = DirectedGCGraph(large_edges, 65)
    large_colors = ones(Int, 65)
    expected_large = canonicalize_directed(large, large_colors)
    canonicalize_directed_packed!(buffer, packed_workspace, large, large_colors)
    @test canonical_graph(buffer) == canonical_graph(expected_large)
    @test canonical_automorphism_order(buffer) ==
        canonical_automorphism_order(expected_large)
    @test packed_workspace.canonical_prefix_checks == 0
    @test packed_workspace.canonical_prefix_prunes == 0
end

@testset "packed directed graph buffer and allocation contract" begin
    edges = Tuple{Int,Int}[]
    for vertex in 1:12
        push!(edges, (vertex, mod1(vertex + 1, 12)))
        push!(edges, (mod1(vertex + 1, 12), vertex))
    end
    colors = ones(Int, 12)
    graph = DirectedGCGraphBuffer(16)
    load_directed_graph!(graph, edges, 12)
    packed_workspace = PackedDirectedCanonicalizationWorkspace(16)
    buffer = DirectedCanonicalizationBuffer(16)

    canonicalize_directed_packed!(buffer, packed_workspace, graph, colors)
    expected = canonicalize_directed(
        DirectedGCGraph([source => target for (source, target) in edges], 12), colors
    )
    @test canonical_graph(buffer) == canonical_graph(expected)
    @test canonical_automorphism_order(buffer) == canonical_automorphism_order(expected)

    allocated = @allocated canonicalize_directed_packed!(
        buffer, packed_workspace, graph, colors
    )
    @test !iszero(Base.JLOptions().code_coverage) || allocated == 0
end
