import GraphCombinations as GC

function _directed_cycle(num_vertices::Int)
    return GC.DirectedGCGraph(
        [vertex => mod1(vertex + 1, num_vertices) for vertex in 1:num_vertices], num_vertices
    )
end

function _bidirectional_cycle(num_vertices::Int)
    return GC.DirectedGCGraph(
        vcat(
            [vertex => mod1(vertex + 1, num_vertices) for vertex in 1:num_vertices],
            [mod1(vertex + 1, num_vertices) => vertex for vertex in 1:num_vertices],
        ),
        num_vertices,
    )
end

function _complete_directed_graph(num_vertices::Int)
    return GC.DirectedGCGraph(
        [
            source => target for source in 1:num_vertices for target in 1:num_vertices if
            source != target
        ],
        num_vertices,
    )
end

function _paired_color_cycle(num_cells::Int)
    num_vertices = 2 * num_cells
    edges = Pair{Int,Int}[]
    for cell in 1:num_cells
        next_cell = mod1(cell + 1, num_cells)
        current_vertices = (2 * cell - 1, 2 * cell)
        next_vertices = (2 * next_cell - 1, 2 * next_cell)
        for source in current_vertices, target in next_vertices
            push!(edges, source => target)
        end
    end
    colors = repeat(collect(1:num_cells); inner=2)
    return GC.DirectedGCGraph(edges, num_vertices), colors
end

function _color_cell_sizes(colors::Vector{Int})
    counts = Dict{Int,Int}()
    for color in colors
        counts[color] = get(counts, color, 0) + 1
    end
    return sort!(collect(values(counts)); rev=true)
end

function _initial_relabeling_group_order(colors::Vector{Int})
    return foldl(*, (factorial(cell_size) for cell_size in _color_cell_sizes(colors)); init=1)
end

function _report_directed_fixture!(name::String, graph::GC.DirectedGCGraph, colors::Vector{Int})
    workspace = GC.DirectedCanonicalizationWorkspace(graph.num_vertices)
    buffer = GC.DirectedCanonicalizationBuffer(graph.num_vertices)
    GC.canonicalize_directed!(buffer, workspace, graph, colors)
    println(
        "directed fixture: ",
        name,
        "; vertices=",
        graph.num_vertices,
        "; edges=",
        sum(graph.multiplicities),
        "; color_cells=",
        _color_cell_sizes(colors),
        "; initial_group_order=",
        _initial_relabeling_group_order(colors),
        "; search_nodes=",
        workspace.search_nodes,
        "; search_leaves=",
        workspace.search_leaves,
        "; refinement_rounds=",
        workspace.refinement_rounds,
        "; automorphism_order=",
        GC.canonical_automorphism_order(buffer),
    )
    return nothing
end

function directed_canonicalization!(SUITE)
    paired_cycle, paired_colors = _paired_color_cycle(6)
    fixtures = (
        (
            "tiny colored",
            GC.DirectedGCGraph([1 => 1, 1 => 3, 2 => 4, 3 => 2, 4 => 1], 4),
            Int[10, 10, 20, 30],
        ),
        ("directed cycle", _directed_cycle(7), ones(Int, 7)),
        ("bidirectional cycle", _bidirectional_cycle(7), ones(Int, 7)),
        (
            "almost discrete colors",
            _directed_cycle(8),
            Int[1, 2, 3, 4, 5, 6, 7, 7],
        ),
        (
            "fixed center",
            GC.DirectedGCGraph(
                vcat([1 => leaf for leaf in 2:7], [leaf => 1 for leaf in 2:7]), 7
            ),
            Int[2, 1, 1, 1, 1, 1, 1],
        ),
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
        ("many small unresolved cells", paired_cycle, paired_colors),
        ("high symmetry", _complete_directed_graph(6), ones(Int, 6)),
    )

    for (name, graph, colors) in fixtures
        _report_directed_fixture!(name, graph, colors)
        workspace = GC.DirectedCanonicalizationWorkspace(graph.num_vertices)
        buffer = GC.DirectedCanonicalizationBuffer(graph.num_vertices)
        GC.canonicalize_directed!(buffer, workspace, graph, colors)
        num_vertices = graph.num_vertices

        SUITE["Directed canonicalization"][name]["certified allocating"] = @benchmarkable GC.canonicalize_directed(
            $graph, $colors
        ) seconds = 5
        SUITE["Directed canonicalization"][name]["workspace setup + run"] = @benchmarkable begin
            workspace = GC.DirectedCanonicalizationWorkspace($num_vertices)
            buffer = GC.DirectedCanonicalizationBuffer($num_vertices)
            GC.canonicalize_directed!(buffer, workspace, $graph, $colors)
        end seconds = 5
        SUITE["Directed canonicalization"][name]["workspace warmed"] = @benchmarkable GC.canonicalize_directed!(
            $buffer, $workspace, $graph, $colors
        ) seconds = 5
    end

    for num_vertices in (3, 5, 7, 9)
        for (family, constructor) in
            (("directed", _directed_cycle), ("bidirectional", _bidirectional_cycle))
            graph = constructor(num_vertices)
            colors = ones(Int, num_vertices)
            workspace = GC.DirectedCanonicalizationWorkspace(num_vertices)
            buffer = GC.DirectedCanonicalizationBuffer(num_vertices)
            GC.canonicalize_directed!(buffer, workspace, graph, colors)
            label = "$family cycle n=$num_vertices"
            SUITE["Directed canonicalization"]["scaling"][label] = @benchmarkable GC.canonicalize_directed!(
                $buffer, $workspace, $graph, $colors
            ) seconds = 5
        end
    end

    return nothing
end
