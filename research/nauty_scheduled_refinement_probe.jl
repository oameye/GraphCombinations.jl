include("nauty_active_refinement_probe.jl")

@inline function scheduled_pending_splitter(
    workspace::ActiveWordWorkspace, cell_mask::UInt64, head::Int, tail::Int
)::Int
    @inbounds for index in head:tail
        workspace.queue[index] == cell_mask && return index
    end
    return 0
end

function schedule_split_fragments!(
    workspace::ActiveWordWorkspace,
    cell_mask::UInt64,
    num_fragments::Int,
    head::Int,
    tail::Int,
)::Int
    pending = scheduled_pending_splitter(workspace, cell_mask, head, tail)
    if !iszero(pending)
        workspace.queue[pending] = workspace.fragment_masks[1]
        @inbounds for fragment in 2:num_fragments
            tail += 1
            tail <= length(workspace.queue) || error("scheduled splitter queue capacity exceeded")
            workspace.queue[tail] = workspace.fragment_masks[fragment]
        end
        return tail
    end

    largest_fragment = 1
    largest_size = count_ones(workspace.fragment_masks[1])
    @inbounds for fragment in 2:num_fragments
        fragment_size = count_ones(workspace.fragment_masks[fragment])
        if fragment_size > largest_size
            largest_fragment = fragment
            largest_size = fragment_size
        end
    end

    @inbounds for fragment in 1:num_fragments
        fragment == largest_fragment && continue
        tail += 1
        tail <= length(workspace.queue) || error("scheduled splitter queue capacity exceeded")
        workspace.queue[tail] = workspace.fragment_masks[fragment]
    end
    return tail
end

function scheduled_active_refine!(
    workspace::ActiveWordWorkspace, depth::Int, n::Int, seed_mask::UInt64
)::Nothing
    word = workspace.word
    num_cells = build_active_cells!(workspace, depth, n)
    iszero(n) && return nothing

    head = 1
    tail = 0
    if iszero(seed_mask)
        @inbounds for cell in 1:num_cells
            tail += 1
            workspace.queue[tail] = workspace.cells[cell]
        end
    else
        tail = 1
        workspace.queue[1] = seed_mask
    end

    while head <= tail && num_cells < n
        splitter = workspace.queue[head]
        head += 1
        workspace.splitter_visits += 1
        word.refinement_rounds += 1

        @inbounds for vertex in 1:n
            workspace.hit_out[vertex] = count_ones(word.out_rows[vertex] & splitter)
            workspace.hit_in[vertex] = count_ones(word.in_rows[vertex] & splitter)
        end

        next_count = 0
        split_happened = false
        @inbounds for cell in 1:num_cells
            cell_mask = workspace.cells[cell]
            num_fragments = active_fragment_cell!(workspace, cell_mask, n)
            if num_fragments == 1
                next_count += 1
                workspace.next_cells[next_count] = cell_mask
                continue
            end

            split_happened = true
            for fragment in 1:num_fragments
                next_count += 1
                workspace.next_cells[next_count] = workspace.fragment_masks[fragment]
            end
            tail = schedule_split_fragments!(
                workspace, cell_mask, num_fragments, head, tail
            )
        end

        if split_happened
            num_cells = next_count
            @inbounds for cell in 1:num_cells
                workspace.cells[cell] = workspace.next_cells[cell]
            end
        end
    end

    @inbounds for cell in 1:num_cells
        bits = workspace.cells[cell]
        while !iszero(bits)
            vertex = trailing_zeros(bits) + 1
            bits &= bits - UInt64(1)
            word.color_stack[vertex, depth] = cell
        end
    end
    return nothing
end

function scheduled_active_search!(
    workspace::ActiveWordWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    multiplicity::Int,
    seed_mask::UInt64,
)::Nothing
    word = workspace.word
    n = graph.num_vertices
    word.search_nodes += 1
    scheduled_active_refine!(workspace, depth, n, seed_mask)
    target_color = word_target_color!(word, depth, n)
    if iszero(target_color)
        word_record_leaf!(word, graph, depth, multiplicity)
        return nothing
    end

    child_depth = depth + 1
    @inbounds for chosen_vertex in 1:n
        word.color_stack[chosen_vertex, depth] == target_color || continue

        has_earlier_twin = false
        for earlier_vertex in 1:(chosen_vertex - 1)
            word.color_stack[earlier_vertex, depth] == target_color || continue
            if GC._directed_workspace_exact_twins(graph, chosen_vertex, earlier_vertex)
                has_earlier_twin = true
                break
            end
        end
        has_earlier_twin && continue

        twin_class_size = 1
        for later_vertex in (chosen_vertex + 1):n
            word.color_stack[later_vertex, depth] == target_color || continue
            if GC._directed_workspace_exact_twins(graph, chosen_vertex, later_vertex)
                twin_class_size += 1
            end
        end
        child_multiplicity = Base.Checked.checked_mul(multiplicity, twin_class_size)

        for vertex in 1:n
            color = word.color_stack[vertex, depth]
            word.color_stack[vertex, child_depth] = if color < target_color
                color
            elseif color > target_color
                color + 1
            elseif vertex == chosen_vertex
                target_color
            else
                target_color + 1
            end
        end
        scheduled_active_search!(
            workspace, graph, child_depth, child_multiplicity, _vertex_bit(chosen_vertex)
        )
    end
    return nothing
end

function canonicalize_scheduled_active_word!(
    buffer::GC.DirectedCanonicalizationBuffer,
    workspace::ActiveWordWorkspace,
    graph::GC.DirectedGCGraph,
    vertex_colors::AbstractVector{<:Integer},
    ;
    load_rows::Bool=true,
)::GC.DirectedCanonicalizationBuffer
    word = workspace.word
    n = graph.num_vertices
    length(vertex_colors) == n ||
        throw(ArgumentError("vertex_colors must have one entry per vertex"))
    n <= length(word.colors) || throw(DimensionMismatch("scheduled word workspace too small"))
    load_rows && load_word_rows!(word, graph)
    @inbounds for vertex in 1:n
        word.colors[vertex] = Int(vertex_colors[vertex])
    end
    reset_active_search!(workspace)
    word_initialize_colors!(word, n)
    scheduled_active_search!(workspace, graph, 1, 1, UInt64(0))
    word.has_best || error("scheduled word canonical search produced no candidate")
    write_word_buffer!(buffer, word, graph)
    return buffer
end

@testset "scheduled splitter exact exhaustive 3-vertex simple digraphs" begin
    baseline_workspace = GC.DirectedCanonicalizationWorkspace(3)
    baseline_buffer = GC.DirectedCanonicalizationBuffer(3)
    word_workspace = WordDirectedWorkspace(3)
    word_buffer = GC.DirectedCanonicalizationBuffer(3)
    scheduled_workspace = ActiveWordWorkspace(3)
    scheduled_buffer = GC.DirectedCanonicalizationBuffer(3)
    colorings = (Int[1, 1, 1], Int[1, 1, 2], Int[1, 2, 3])

    for mask in 0:(2 ^ 9 - 1)
        graph = simple_graph(mask, 3)
        for colors in colorings
            GC.canonicalize_directed!(baseline_buffer, baseline_workspace, graph, colors)
            canonicalize_word!(word_buffer, word_workspace, graph, colors)
            canonicalize_scheduled_active_word!(
                scheduled_buffer, scheduled_workspace, graph, colors
            )
            assert_same_result(baseline_buffer, scheduled_buffer, 3)
            @test GC.canonical_graph(scheduled_buffer) == GC.canonical_graph(word_buffer)
        end
    end
end

function benchmark_scheduled_fixture(
    name::String, graph::GC.DirectedGCGraph, colors::Vector{Int}
)
    n = graph.num_vertices
    baseline_workspace = GC.DirectedCanonicalizationWorkspace(n)
    baseline_buffer = GC.DirectedCanonicalizationBuffer(n)
    word_workspace = WordDirectedWorkspace(n)
    word_buffer = GC.DirectedCanonicalizationBuffer(n)
    active_workspace = ActiveWordWorkspace(n)
    active_buffer = GC.DirectedCanonicalizationBuffer(n)
    scheduled_workspace = ActiveWordWorkspace(n)
    scheduled_buffer = GC.DirectedCanonicalizationBuffer(n)

    GC.canonicalize_directed!(baseline_buffer, baseline_workspace, graph, colors)
    canonicalize_word!(word_buffer, word_workspace, graph, colors)
    canonicalize_active_word!(active_buffer, active_workspace, graph, colors)
    canonicalize_scheduled_active_word!(
        scheduled_buffer, scheduled_workspace, graph, colors
    )
    assert_same_result(baseline_buffer, scheduled_buffer, n)
    @test GC.canonical_graph(scheduled_buffer) == GC.canonical_graph(word_buffer)
    @test GC.canonical_graph(scheduled_buffer) == GC.canonical_graph(active_buffer)

    load_word_rows!(word_workspace, graph)
    load_word_rows!(active_workspace.word, graph)
    load_word_rows!(scheduled_workspace.word, graph)

    baseline_time = @belapsed GC.canonicalize_directed!(
        $baseline_buffer, $baseline_workspace, $graph, $colors
    ) samples=101 evals=1
    word_time = @belapsed canonicalize_word!(
        $word_buffer, $word_workspace, $graph, $colors; load_rows=false
    ) samples=101 evals=1
    active_time = @belapsed canonicalize_active_word!(
        $active_buffer, $active_workspace, $graph, $colors; load_rows=false
    ) samples=101 evals=1
    scheduled_time = @belapsed canonicalize_scheduled_active_word!(
        $scheduled_buffer, $scheduled_workspace, $graph, $colors; load_rows=false
    ) samples=101 evals=1
    scheduled_full_time = @belapsed canonicalize_scheduled_active_word!(
        $scheduled_buffer, $scheduled_workspace, $graph, $colors
    ) samples=101 evals=1

    canonicalize_active_word!(active_buffer, active_workspace, graph, colors)
    naive_splitters = active_workspace.splitter_visits
    canonicalize_scheduled_active_word!(
        scheduled_buffer, scheduled_workspace, graph, colors
    )
    scheduled_splitters = scheduled_workspace.splitter_visits
    scheduled_alloc = @allocated canonicalize_scheduled_active_word!(
        scheduled_buffer, scheduled_workspace, graph, colors
    )

    return println(
        join(
            (
                name,
                "n=$(n)",
                "baseline=$(round(1e6 * baseline_time; digits=2)) us",
                "word=$(round(1e6 * word_time; digits=2)) us",
                "active=$(round(1e6 * active_time; digits=2)) us",
                "scheduled=$(round(1e6 * scheduled_time; digits=2)) us",
                "scheduled-full=$(round(1e6 * scheduled_full_time; digits=2)) us",
                "scheduled/base=$(round(scheduled_full_time / baseline_time; digits=3))x",
                "scheduled/word=$(round(scheduled_time / word_time; digits=3))x",
                "scheduled/active=$(round(scheduled_time / active_time; digits=3))x",
                "alloc=$(scheduled_alloc)",
                "nodes=$(scheduled_workspace.word.search_nodes)",
                "leaves=$(scheduled_workspace.word.search_leaves)",
                "splitters=$(naive_splitters)->$(scheduled_splitters)",
            ),
            " | ",
        ),
    )
end

println("\nHopcroft-scheduled active refinement benchmark")
for (name, fixture) in (
    "discrete-35" => paired_fixture(35; block=1),
    "paired-35" => paired_fixture(35; block=2),
    "tripled-41" => paired_fixture(41; block=3),
    "paired-24" => paired_fixture(24; block=2),
    "cycle-8" => cycle_fixture(8),
)
    graph, colors = fixture
    benchmark_scheduled_fixture(name, graph, colors)
end
