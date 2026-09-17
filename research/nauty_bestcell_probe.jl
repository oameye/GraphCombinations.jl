include("nauty_word_refinement_probe.jl")

function word_best_target_color!(
    workspace::WordDirectedWorkspace, depth::Int, n::Int
)::Int
    @inbounds for color in 1:n
        workspace.cell_counts[color] = 0
        workspace.cell_masks[color] = 0
        workspace.order[color] = 0
        workspace.refined_colors[color] = 0
    end

    num_colors = 0
    @inbounds for vertex in 1:n
        color = workspace.color_stack[vertex, depth]
        workspace.cell_counts[color] += 1
        workspace.cell_masks[color] |= _vertex_bit(vertex)
        iszero(workspace.order[color]) && (workspace.order[color] = vertex)
        num_colors = max(num_colors, color)
    end

    num_nonsingleton = 0
    @inbounds for color in 1:num_colors
        workspace.cell_counts[color] > 1 && (num_nonsingleton += 1)
    end
    iszero(num_nonsingleton) && return 0

    @inbounds for left_color in 1:num_colors
        workspace.cell_counts[left_color] > 1 || continue
        representative = workspace.order[left_color]
        out_row = workspace.out_rows[representative]
        for right_color in (left_color + 1):num_colors
            workspace.cell_counts[right_color] > 1 || continue
            right_mask = workspace.cell_masks[right_color]
            hits = out_row & right_mask
            if !iszero(hits) && hits != right_mask
                workspace.refined_colors[left_color] += 1
                workspace.refined_colors[right_color] += 1
            end
        end
    end

    target_color = 0
    best_score = -1
    @inbounds for color in 1:num_colors
        workspace.cell_counts[color] > 1 || continue
        score = workspace.refined_colors[color]
        if score > best_score
            target_color = color
            best_score = score
        end
    end
    return target_color
end

function word_best_search!(
    workspace::WordDirectedWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    multiplicity::Int,
)::Nothing
    n = graph.num_vertices
    workspace.search_nodes += 1
    word_refine!(workspace, depth, n)
    target_color = word_best_target_color!(workspace, depth, n)
    if iszero(target_color)
        word_record_leaf!(workspace, graph, depth, multiplicity)
        return nothing
    end

    child_depth = depth + 1
    @inbounds for chosen_vertex in 1:n
        workspace.color_stack[chosen_vertex, depth] == target_color || continue

        has_earlier_twin = false
        for earlier_vertex in 1:(chosen_vertex - 1)
            workspace.color_stack[earlier_vertex, depth] == target_color || continue
            if GC._directed_workspace_exact_twins(graph, chosen_vertex, earlier_vertex)
                has_earlier_twin = true
                break
            end
        end
        has_earlier_twin && continue

        twin_class_size = 1
        for later_vertex in (chosen_vertex + 1):n
            workspace.color_stack[later_vertex, depth] == target_color || continue
            if GC._directed_workspace_exact_twins(graph, chosen_vertex, later_vertex)
                twin_class_size += 1
            end
        end
        child_multiplicity = Base.Checked.checked_mul(multiplicity, twin_class_size)

        for vertex in 1:n
            color = workspace.color_stack[vertex, depth]
            workspace.color_stack[vertex, child_depth] = if color < target_color
                color
            elseif color > target_color
                color + 1
            elseif vertex == chosen_vertex
                target_color
            else
                target_color + 1
            end
        end
        word_best_search!(workspace, graph, child_depth, child_multiplicity)
    end
    return nothing
end

function canonicalize_word_best!(
    buffer::GC.DirectedCanonicalizationBuffer,
    workspace::WordDirectedWorkspace,
    graph::GC.DirectedGCGraph,
    vertex_colors::AbstractVector{<:Integer},
    ;
    load_rows::Bool=true,
)::GC.DirectedCanonicalizationBuffer
    n = graph.num_vertices
    length(vertex_colors) == n ||
        throw(ArgumentError("vertex_colors must have one entry per vertex"))
    n <= length(workspace.colors) || throw(DimensionMismatch("word workspace too small"))
    load_rows && load_word_rows!(workspace, graph)
    @inbounds for vertex in 1:n
        workspace.colors[vertex] = Int(vertex_colors[vertex])
    end
    reset_word_search!(workspace)
    word_initialize_colors!(workspace, n)
    word_best_search!(workspace, graph, 1, 1)
    workspace.has_best || error("bestcell word canonical search produced no candidate")
    write_word_buffer!(buffer, workspace, graph)
    return buffer
end

@testset "bestcell target exact exhaustive 3-vertex simple digraphs" begin
    baseline_workspace = GC.DirectedCanonicalizationWorkspace(3)
    baseline_buffer = GC.DirectedCanonicalizationBuffer(3)
    word_workspace = WordDirectedWorkspace(3)
    word_buffer = GC.DirectedCanonicalizationBuffer(3)
    best_workspace = WordDirectedWorkspace(3)
    best_buffer = GC.DirectedCanonicalizationBuffer(3)
    colorings = (Int[1, 1, 1], Int[1, 1, 2], Int[1, 2, 3])

    for mask in 0:(2 ^ 9 - 1)
        graph = simple_graph(mask, 3)
        for colors in colorings
            GC.canonicalize_directed!(baseline_buffer, baseline_workspace, graph, colors)
            canonicalize_word!(word_buffer, word_workspace, graph, colors)
            canonicalize_word_best!(best_buffer, best_workspace, graph, colors)
            assert_same_result(baseline_buffer, best_buffer, 3)
            @test GC.canonical_graph(best_buffer) == GC.canonical_graph(word_buffer)
        end
    end
end

@testset "bestcell target exact exhaustive 4-vertex two-color digraphs" begin
    baseline_workspace = GC.DirectedCanonicalizationWorkspace(4)
    baseline_buffer = GC.DirectedCanonicalizationBuffer(4)
    best_workspace = WordDirectedWorkspace(4)
    best_buffer = GC.DirectedCanonicalizationBuffer(4)
    colors = Int[1, 1, 2, 2]

    for mask in 0:(2 ^ 16 - 1)
        graph = simple_graph(mask, 4)
        GC.canonicalize_directed!(baseline_buffer, baseline_workspace, graph, colors)
        canonicalize_word_best!(best_buffer, best_workspace, graph, colors)
        assert_same_result(baseline_buffer, best_buffer, 4)
    end
end

function bridge_fixture(width::Int)
    width >= 2 || throw(ArgumentError("width must be at least 2"))
    a = 2
    b = width
    c = width
    n = a + b + c
    colors = vcat(fill(1, a), fill(2, b), fill(3, c))
    edges = Pair{Int,Int}[]

    b0 = a
    c0 = a + b
    split = cld(width, 2)
    for j in 1:width
        avertex = j <= split ? 1 : 2
        bvertex = b0 + j
        cvertex = c0 + j
        push!(edges, avertex => bvertex)
        push!(edges, bvertex => avertex)
        push!(edges, bvertex => cvertex)
        push!(edges, cvertex => bvertex)
        push!(edges, cvertex => c0 + mod1(j + 1, width))
    end
    return GC.DirectedGCGraph(unique(edges), n), colors
end

function benchmark_bestcell_fixture(
    name::String, graph::GC.DirectedGCGraph, colors::Vector{Int}
)
    n = graph.num_vertices
    baseline_workspace = GC.DirectedCanonicalizationWorkspace(n)
    baseline_buffer = GC.DirectedCanonicalizationBuffer(n)
    word_workspace = WordDirectedWorkspace(n)
    word_buffer = GC.DirectedCanonicalizationBuffer(n)
    best_workspace = WordDirectedWorkspace(n)
    best_buffer = GC.DirectedCanonicalizationBuffer(n)

    GC.canonicalize_directed!(baseline_buffer, baseline_workspace, graph, colors)
    canonicalize_word!(word_buffer, word_workspace, graph, colors)
    canonicalize_word_best!(best_buffer, best_workspace, graph, colors)
    assert_same_result(baseline_buffer, best_buffer, n)
    @test GC.canonical_graph(best_buffer) == GC.canonical_graph(word_buffer)

    load_word_rows!(word_workspace, graph)
    load_word_rows!(best_workspace, graph)

    baseline_time = @belapsed GC.canonicalize_directed!(
        $baseline_buffer, $baseline_workspace, $graph, $colors
    ) samples=101 evals=1
    word_time = @belapsed canonicalize_word!(
        $word_buffer, $word_workspace, $graph, $colors; load_rows=false
    ) samples=101 evals=1
    best_time = @belapsed canonicalize_word_best!(
        $best_buffer, $best_workspace, $graph, $colors; load_rows=false
    ) samples=101 evals=1
    best_full_time = @belapsed canonicalize_word_best!(
        $best_buffer, $best_workspace, $graph, $colors
    ) samples=101 evals=1

    canonicalize_word!(word_buffer, word_workspace, graph, colors)
    word_nodes = word_workspace.search_nodes
    word_leaves = word_workspace.search_leaves
    canonicalize_word_best!(best_buffer, best_workspace, graph, colors)
    best_nodes = best_workspace.search_nodes
    best_leaves = best_workspace.search_leaves
    best_alloc = @allocated canonicalize_word_best!(best_buffer, best_workspace, graph, colors)

    return println(
        join(
            (
                name,
                "n=$(n)",
                "baseline=$(round(1e6 * baseline_time; digits=2)) us",
                "word=$(round(1e6 * word_time; digits=2)) us",
                "best=$(round(1e6 * best_time; digits=2)) us",
                "best-full=$(round(1e6 * best_full_time; digits=2)) us",
                "best/base=$(round(best_full_time / baseline_time; digits=3))x",
                "best/word=$(round(best_time / word_time; digits=3))x",
                "alloc=$(best_alloc)",
                "nodes=$(word_nodes)->$(best_nodes)",
                "leaves=$(word_leaves)->$(best_leaves)",
            ),
            " | ",
        ),
    )
end

println("\nnauty bestcell target benchmark")
for (name, fixture) in (
    "cycle-8" => cycle_fixture(8),
    "cycle-10" => cycle_fixture(10),
    "bridge-4" => bridge_fixture(4),
    "bridge-6" => bridge_fixture(6),
    "bridge-8" => bridge_fixture(8),
)
    graph, colors = fixture
    benchmark_bestcell_fixture(name, graph, colors)
end
