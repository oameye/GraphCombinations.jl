const DirectedRecursiveGC = GraphCombinations.DirectedRecursive

@testset "recursive stabilizer agrees exhaustively" begin
    general_workspace = DirectedCanonicalizationWorkspace(3)
    recursive_workspace = DirectedRecursiveGC.PackedRecursiveStabilizerWorkspace(3)
    general_buffer = DirectedCanonicalizationBuffer(3)
    recursive_buffer = DirectedCanonicalizationBuffer(3)
    colorings = (Int[1, 1, 1], Int[1, 1, 2], Int[1, 2, 3])

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
                DirectedRecursiveGC.canonicalize_recursive_stabilizers!(
                    recursive_buffer, recursive_workspace, graph, colors
                )
            ) === recursive_buffer
            @test canonical_graph(recursive_buffer) == canonical_graph(general_buffer)
            @test canonical_automorphism_order(recursive_buffer) ==
                canonical_automorphism_order(general_buffer)
            @test recursive_buffer.canonical_to_old[1:3] ==
                general_buffer.canonical_to_old[1:3]
        end
    end
end

@testset "recursive stabilizer exact symmetry fixtures" begin
    fixtures = (
        ([vertex => mod1(vertex + 1, 8) for vertex in 1:8], ones(Int, 8)),
        (
            vcat(
                [vertex => mod1(vertex + 1, 6) for vertex in 1:6],
                [mod1(vertex + 1, 6) => vertex for vertex in 1:6],
            ),
            ones(Int, 6),
        ),
        ([1 => 2, 2 => 3, 3 => 1, 4 => 5, 5 => 6, 6 => 4], ones(Int, 6)),
        (
            vcat([1 => leaf for leaf in 2:7], [leaf => 1 for leaf in 2:7]),
            Int[1, 2, 2, 2, 2, 2, 2],
        ),
        (
            [1 => 2, 1 => 4, 2 => 3, 3 => 1, 4 => 2, 5 => 4, 6 => 5, 7 => 6],
            Int[1, 1, 1, 2, 2, 2, 3],
        ),
    )

    for (edges, colors) in fixtures
        n = length(colors)
        graph = DirectedGCGraph(edges, n)
        general_workspace = DirectedCanonicalizationWorkspace(n)
        recursive_workspace = DirectedRecursiveGC.PackedRecursiveStabilizerWorkspace(n)
        general_buffer = DirectedCanonicalizationBuffer(n)
        recursive_buffer = DirectedCanonicalizationBuffer(n)

        canonicalize_directed!(general_buffer, general_workspace, graph, colors)
        DirectedRecursiveGC.canonicalize_recursive_stabilizers!(
            recursive_buffer, recursive_workspace, graph, colors
        )

        @test canonical_graph(recursive_buffer) == canonical_graph(general_buffer)
        @test canonical_automorphism_order(recursive_buffer) ==
            canonical_automorphism_order(general_buffer)
        @test recursive_buffer.canonical_to_old[1:n] == general_buffer.canonical_to_old[1:n]
    end
end

@testset "recursive stabilizer allocation contract" begin
    edges = Tuple{Int,Int}[]
    for vertex in 1:12
        push!(edges, (vertex, mod1(vertex + 1, 12)))
        push!(edges, (mod1(vertex + 1, 12), vertex))
    end
    graph = DirectedGCGraph([source => target for (source, target) in edges], 12)
    colors = ones(Int, 12)
    workspace = DirectedRecursiveGC.PackedRecursiveStabilizerWorkspace(16)
    buffer = DirectedCanonicalizationBuffer(16)

    DirectedRecursiveGC.canonicalize_recursive_stabilizers!(
        buffer, workspace, graph, colors
    )
    allocated = @allocated DirectedRecursiveGC.canonicalize_recursive_stabilizers!(
        buffer, workspace, graph, colors
    )
    @test !iszero(Base.JLOptions().code_coverage) || allocated == 0
end
