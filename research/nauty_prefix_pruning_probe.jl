include("nauty_word_refinement_probe.jl")

mutable struct PrefixWordWorkspace
    word::WordDirectedWorkspace
    pruned_nodes::Int
end

PrefixWordWorkspace(capacity::Integer) = PrefixWordWorkspace(WordDirectedWorkspace(capacity), 0)

function compare_fixed_prefix_to_best(
    workspace::WordDirectedWorkspace, graph::GC.DirectedGCGraph, depth::Int
)::Int
    workspace.has_best || return 0
    n = graph.num_vertices

    @inbounds for color in 1:n
        workspace.cell_counts[color] = 0
        workspace.order[color] = 0
    end

    num_colors = 0
    @inbounds for vertex in 1:n
        color = workspace.color_stack[vertex, depth]
        workspace.cell_counts[color] += 1
        iszero(workspace.order[color]) && (workspace.order[color] = vertex)
        num_colors = max(num_colors, color)
    end

    fixed_prefix = 0
    @inbounds while fixed_prefix < num_colors && workspace.cell_counts[fixed_prefix + 1] == 1
        fixed_prefix += 1
    end
    iszero(fixed_prefix) && return 0

    @inbounds for source_rank in 1:fixed_prefix
        candidate_source = workspace.order[source_rank]
        best_source = workspace.best_inverse_mapping[source_rank]
        target_rank = 1
        for target_color in 1:num_colors
            candidate_target = workspace.order[target_color]
            candidate_value = graph.multiplicities[GC._directed_slot(
                candidate_source, candidate_target, n
            )]
            for _ in 1:workspace.cell_counts[target_color]
                best_target = workspace.best_inverse_mapping[target_rank]
                best_value = graph.multiplicities[GC._directed_slot(
                    best_source, best_target, n
                )]
                candidate_value == best_value ||
                    return candidate_value < best_value ? -1 : 1
                target_rank += 1
            end
        end
    end
    return 0
end

function prefix_word_search!(
    prefix::PrefixWordWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    multiplicity::Int,
)::Nothing
    workspace = prefix.word
    n = graph.num_vertices
    workspace.search_nodes += 1
    word_refine!(workspace, depth, n)

    if compare_fixed_prefix_to_best(workspace, graph, depth) > 0
        prefix.pruned_nodes += 1
        return nothing
    end

    target_color = word_target_color!(workspace, depth, n)
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
        prefix_word_search!(prefix, graph, child_depth, child_multiplicity)
    end
    return nothing
end

function canonicalize_word_prefix!(
    buffer::GC.DirectedCanonicalizationBuffer,
    prefix::PrefixWordWorkspace,
    graph::GC.DirectedGCGraph,
    vertex_colors::AbstractVector{<:Integer},
    ;
    load_rows::Bool=true,
)::GC.DirectedCanonicalizationBuffer
    workspace = prefix.word
    n = graph.num_vertices
    length(vertex_colors) == n ||
        throw(ArgumentError("vertex_colors must have one entry per vertex"))
    n <= length(workspace.colors) || throw(DimensionMismatch("prefix workspace too small"))
    load_rows && load_word_rows!(workspace, graph)
    @inbounds for vertex in 1:n
        workspace.colors[vertex] = Int(vertex_colors[vertex])
    end
    reset_word_search!(workspace)
    prefix.pruned_nodes = 0
    word_initialize_colors!(workspace, n)
    prefix_word_search!(prefix, graph, 1, 1)
    workspace.has_best || error("prefix-pruned canonical search produced no candidate")
    write_word_buffer!(buffer, workspace, graph)
    return buffer
end

@testset "prefix pruning exact exhaustive 3-vertex simple digraphs" begin
    baseline_workspace = GC.DirectedCanonicalizationWorkspace(3)
    baseline_buffer = GC.DirectedCanonicalizationBuffer(3)
    prefix_workspace = PrefixWordWorkspace(3)
    prefix_buffer = GC.DirectedCanonicalizationBuffer(3)
    colorings = (Int[1, 1, 1], Int[1, 1, 2], Int[1, 2, 3])

    for mask in 0:(2 ^ 9 - 1)
        graph = simple_graph(mask, 3)
        for colors in colorings
            GC.canonicalize_directed!(baseline_buffer, baseline_workspace, graph, colors)
            canonicalize_word_prefix!(prefix_buffer, prefix_workspace, graph, colors)
            assert_same_result(baseline_buffer, prefix_buffer, 3)
        end
    end
end

@testset "prefix pruning exact exhaustive 4-vertex simple digraphs" begin
    baseline_workspace = GC.DirectedCanonicalizationWorkspace(4)
    baseline_buffer = GC.DirectedCanonicalizationBuffer(4)
    prefix_workspace = PrefixWordWorkspace(4)
    prefix_buffer = GC.DirectedCanonicalizationBuffer(4)
    colorings = (Int[1, 1, 1, 1], Int[1, 1, 2, 2])

    for mask in 0:(2 ^ 16 - 1)
        graph = simple_graph(mask, 4)
        for colors in colorings
            GC.canonicalize_directed!(baseline_buffer, baseline_workspace, graph, colors)
            canonicalize_word_prefix!(prefix_buffer, prefix_workspace, graph, colors)
            assert_same_result(baseline_buffer, prefix_buffer, 4)
        end
    end
end

function disjoint_cycles_fixture(lengths::Vararg{Int})
    n = sum(lengths)
    edges = Pair{Int,Int}[]
    offset = 0
    for length in lengths
        for local_vertex in 1:length
            vertex = offset + local_vertex
            next_vertex = offset + mod1(local_vertex + 1, length)
            push!(edges, vertex => next_vertex)
            push!(edges, next_vertex => vertex)
        end
        offset += length
    end
    return GC.DirectedGCGraph(unique(edges), n), ones(Int, n)
end

function benchmark_prefix_fixture(
    name::String, graph::GC.DirectedGCGraph, colors::Vector{Int}
)
    n = graph.num_vertices
    baseline_workspace = GC.DirectedCanonicalizationWorkspace(n)
    baseline_buffer = GC.DirectedCanonicalizationBuffer(n)
    word_workspace = WordDirectedWorkspace(n)
    word_buffer = GC.DirectedCanonicalizationBuffer(n)
    prefix_workspace = PrefixWordWorkspace(n)
    prefix_buffer = GC.DirectedCanonicalizationBuffer(n)

    GC.canonicalize_directed!(baseline_buffer, baseline_workspace, graph, colors)
    canonicalize_word!(word_buffer, word_workspace, graph, colors)
    canonicalize_word_prefix!(prefix_buffer, prefix_workspace, graph, colors)
    assert_same_result(baseline_buffer, prefix_buffer, n)
    @test GC.canonical_graph(prefix_buffer) == GC.canonical_graph(word_buffer)

    load_word_rows!(word_workspace, graph)
    load_word_rows!(prefix_workspace.word, graph)

    baseline_time = @belapsed GC.canonicalize_directed!(
        $baseline_buffer, $baseline_workspace, $graph, $colors
    ) samples=101 evals=1
    word_time = @belapsed canonicalize_word!(
        $word_buffer, $word_workspace, $graph, $colors; load_rows=false
    ) samples=101 evals=1
    prefix_time = @belapsed canonicalize_word_prefix!(
        $prefix_buffer, $prefix_workspace, $graph, $colors; load_rows=false
    ) samples=101 evals=1
    prefix_full_time = @belapsed canonicalize_word_prefix!(
        $prefix_buffer, $prefix_workspace, $graph, $colors
    ) samples=101 evals=1

    canonicalize_word!(word_buffer, word_workspace, graph, colors)
    word_nodes = word_workspace.search_nodes
    word_leaves = word_workspace.search_leaves
    canonicalize_word_prefix!(prefix_buffer, prefix_workspace, graph, colors)
    prefix_nodes = prefix_workspace.word.search_nodes
    prefix_leaves = prefix_workspace.word.search_leaves
    pruned_nodes = prefix_workspace.pruned_nodes
    prefix_alloc = @allocated canonicalize_word_prefix!(
        prefix_buffer, prefix_workspace, graph, colors
    )

    return println(
        join(
            (
                name,
                "n=$(n)",
                "baseline=$(round(1e6 * baseline_time; digits=2)) us",
                "word=$(round(1e6 * word_time; digits=2)) us",
                "prefix=$(round(1e6 * prefix_time; digits=2)) us",
                "prefix-full=$(round(1e6 * prefix_full_time; digits=2)) us",
                "prefix/base=$(round(prefix_full_time / baseline_time; digits=3))x",
                "prefix/word=$(round(prefix_time / word_time; digits=3))x",
                "alloc=$(prefix_alloc)",
                "nodes=$(word_nodes)->$(prefix_nodes)",
                "leaves=$(word_leaves)->$(prefix_leaves)",
                "pruned=$(pruned_nodes)",
            ),
            " | ",
        ),
    )
end

println("\ncanonical fixed-prefix pruning benchmark")
for (name, fixture) in (
    "cycle-8" => cycle_fixture(8),
    "cycle-10" => cycle_fixture(10),
    "cycles-3-5" => disjoint_cycles_fixture(3, 5),
    "cycles-4-6" => disjoint_cycles_fixture(4, 6),
    "cycles-5-7" => disjoint_cycles_fixture(5, 7),
)
    graph, colors = fixture
    benchmark_prefix_fixture(name, graph, colors)
end
