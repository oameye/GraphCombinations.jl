import GraphCombinations as GC

function _bidirectional_cycle(num_vertices::Int)
    return GC.DirectedGCGraph(
        vcat(
            [vertex => mod1(vertex + 1, num_vertices) for vertex in 1:num_vertices],
            [mod1(vertex + 1, num_vertices) => vertex for vertex in 1:num_vertices],
        ),
        num_vertices,
    )
end

function directed_canonicalization!(SUITE)
    fixtures = (
        (
            "tiny colored",
            GC.DirectedGCGraph([1 => 1, 1 => 3, 2 => 4, 3 => 2, 4 => 1], 4),
            Int[10, 10, 20, 30],
        ),
        ("bidirectional cycle", _bidirectional_cycle(7), ones(Int, 7)),
        (
            "loops and multiplicity",
            GC.DirectedGCGraph(
                [1 => 1, 1 => 2, 1 => 2, 2 => 3, 2 => 3, 3 => 1, 4 => 4, 4 => 1], 4
            ),
            Int[1, 1, 1, 2],
        ),
        (
            "disconnected colored",
            GC.DirectedGCGraph([1 => 2, 2 => 1, 3 => 4, 4 => 3, 5 => 5], 5),
            Int[1, 1, 1, 1, 2],
        ),
        (
            "subdivision style",
            GC.DirectedGCGraph(
                [
                    1 => 5,
                    5 => 2,
                    1 => 6,
                    6 => 2,
                    2 => 7,
                    7 => 3,
                    3 => 8,
                    8 => 1,
                    3 => 9,
                    9 => 4,
                    4 => 10,
                    10 => 1,
                ],
                10,
            ),
            Int[1, 1, 1, 2, 3, 3, 3, 3, 4, 4],
        ),
    )

    for (name, graph, colors) in fixtures
        workspace = GC.DirectedCanonicalizationWorkspace(graph.num_vertices)
        buffer = GC.DirectedCanonicalizationBuffer(graph.num_vertices)
        GC.canonicalize_directed!(buffer, workspace, graph, colors)

        SUITE["Directed canonicalization"][name]["allocating"] = @benchmarkable GC.canonicalize_directed(
            $graph, $colors
        ) seconds = 5
        SUITE["Directed canonicalization"][name]["workspace"] = @benchmarkable GC.canonicalize_directed!(
            $buffer, $workspace, $graph, $colors
        ) seconds = 5
    end

    for num_vertices in (3, 5, 7, 9)
        graph = _bidirectional_cycle(num_vertices)
        colors = ones(Int, num_vertices)
        workspace = GC.DirectedCanonicalizationWorkspace(num_vertices)
        buffer = GC.DirectedCanonicalizationBuffer(num_vertices)
        GC.canonicalize_directed!(buffer, workspace, graph, colors)
        label = "cycle n=$num_vertices"
        SUITE["Directed canonicalization"]["scaling"][label] = @benchmarkable GC.canonicalize_directed!(
            $buffer, $workspace, $graph, $colors
        ) seconds = 5
    end

    return nothing
end
