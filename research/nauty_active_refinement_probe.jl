include("nauty_word_refinement_probe.jl")

mutable struct ActiveWordWorkspace
    word::WordDirectedWorkspace
    cells::Vector{UInt64}
    next_cells::Vector{UInt64}
    queue::Vector{UInt64}
    fragment_masks::Vector{UInt64}
    fragment_keys::Vector{Int}
    hit_out::Vector{Int}
    hit_in::Vector{Int}
    splitter_visits::Int
end

function ActiveWordWorkspace(capacity::Integer)
    n = Int(capacity)
    0 <= n <= 64 || throw(ArgumentError("active word workspace capacity must be in 0:64"))
    return ActiveWordWorkspace(
        WordDirectedWorkspace(n),
        zeros(UInt64, n),
        zeros(UInt64, n),
        zeros(UInt64, max(1, n * n + n)),
        zeros(UInt64, n),
        zeros(Int, n),
        zeros(Int, n),
        zeros(Int, n),
        0,
    )
end

function build_active_cells!(workspace::ActiveWordWorkspace, depth::Int, n::Int)::Int
    word = workspace.word
    num_cells = 0
    @inbounds for vertex in 1:n
        num_cells = max(num_cells, word.color_stack[vertex, depth])
    end
    @inbounds for cell in 1:num_cells
        workspace.cells[cell] = 0
    end
    @inbounds for vertex in 1:n
        cell = word.color_stack[vertex, depth]
        workspace.cells[cell] |= _vertex_bit(vertex)
    end
    return num_cells
end

function active_fragment_cell!(
    workspace::ActiveWordWorkspace, cell_mask::UInt64, n::Int
)::Int
    num_fragments = 0
    bits = cell_mask
    @inbounds while !iszero(bits)
        vertex = trailing_zeros(bits) + 1
        bits &= bits - UInt64(1)
        key = workspace.hit_out[vertex] * (n + 1) + workspace.hit_in[vertex]

        fragment = 0
        for index in 1:num_fragments
            if workspace.fragment_keys[index] == key
                fragment = index
                break
            end
        end
        if iszero(fragment)
            num_fragments += 1
            fragment = num_fragments
            workspace.fragment_keys[fragment] = key
            workspace.fragment_masks[fragment] = 0
        end
        workspace.fragment_masks[fragment] |= _vertex_bit(vertex)
    end

    @inbounds for index in 2:num_fragments
        key = workspace.fragment_keys[index]
        mask = workspace.fragment_masks[index]
        position = index - 1
        while position >= 1 && key < workspace.fragment_keys[position]
            workspace.fragment_keys[position + 1] = workspace.fragment_keys[position]
            workspace.fragment_masks[position + 1] = workspace.fragment_masks[position]
            position -= 1
        end
        workspace.fragment_keys[position + 1] = key
        workspace.fragment_masks[position + 1] = mask
    end
    return num_fragments
end

function active_refine!(
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
                fragment_mask = workspace.fragment_masks[fragment]
                workspace.next_cells[next_count] = fragment_mask
                tail += 1
                tail <= length(workspace.queue) ||
                    error("active splitter queue capacity exceeded")
                workspace.queue[tail] = fragment_mask
            end
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

function active_search!(
    workspace::ActiveWordWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    multiplicity::Int,
    seed_mask::UInt64,
)::Nothing
    word = workspace.word
    n = graph.num_vertices
    word.search_nodes += 1
    active_refine!(workspace, depth, n, seed_mask)
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
        active_search!(
            workspace, graph, child_depth, child_multiplicity, _vertex_bit(chosen_vertex)
        )
    end
    return nothing
end

function reset_active_search!(workspace::ActiveWordWorkspace)::Nothing
    reset_word_search!(workspace.word)
    workspace.splitter_visits = 0
    return nothing
end

function canonicalize_active_word!(
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
    n <= length(word.colors) || throw(DimensionMismatch("active word workspace too small"))
    load_rows && load_word_rows!(word, graph)
    @inbounds for vertex in 1:n
        word.colors[vertex] = Int(vertex_colors[vertex])
    end
    reset_active_search!(workspace)
    word_initialize_colors!(word, n)
    active_search!(workspace, graph, 1, 1, 0)
    word.has_best || error("active word canonical search produced no candidate")
    write_word_buffer!(buffer, word, graph)
    return buffer
end

@testset "active splitter exact exhaustive 3-vertex simple digraphs" begin
    baseline_workspace = GC.DirectedCanonicalizationWorkspace(3)
    baseline_buffer = GC.DirectedCanonicalizationBuffer(3)
    word_workspace = WordDirectedWorkspace(3)
    word_buffer = GC.DirectedCanonicalizationBuffer(3)
    active_workspace = ActiveWordWorkspace(3)
    active_buffer = GC.DirectedCanonicalizationBuffer(3)
    colorings = (Int[1, 1, 1], Int[1, 1, 2], Int[1, 2, 3])

    for mask in 0:(2 ^ 9 - 1)
        graph = simple_graph(mask, 3)
        for colors in colorings
            GC.canonicalize_directed!(baseline_buffer, baseline_workspace, graph, colors)
            canonicalize_word!(word_buffer, word_workspace, graph, colors)
            canonicalize_active_word!(active_buffer, active_workspace, graph, colors)
            assert_same_result(baseline_buffer, active_buffer, 3)
            @test GC.canonical_graph(active_buffer) == GC.canonical_graph(word_buffer)
        end
    end
end

function benchmark_active_fixture(
    name::String, graph::GC.DirectedGCGraph, colors::Vector{Int}
)
    n = graph.num_vertices
    baseline_workspace = GC.DirectedCanonicalizationWorkspace(n)
    baseline_buffer = GC.DirectedCanonicalizationBuffer(n)
    word_workspace = WordDirectedWorkspace(n)
    word_buffer = GC.DirectedCanonicalizationBuffer(n)
    active_workspace = ActiveWordWorkspace(n)
    active_buffer = GC.DirectedCanonicalizationBuffer(n)

    GC.canonicalize_directed!(baseline_buffer, baseline_workspace, graph, colors)
    canonicalize_word!(word_buffer, word_workspace, graph, colors)
    canonicalize_active_word!(active_buffer, active_workspace, graph, colors)
    assert_same_result(baseline_buffer, active_buffer, n)
    @test GC.canonical_graph(active_buffer) == GC.canonical_graph(word_buffer)

    load_word_rows!(word_workspace, graph)
    load_word_rows!(active_workspace.word, graph)

    baseline_time = @belapsed GC.canonicalize_directed!(
        $baseline_buffer, $baseline_workspace, $graph, $colors
    ) samples=101 evals=1
    word_kernel_time = @belapsed canonicalize_word!(
        $word_buffer, $word_workspace, $graph, $colors; load_rows=false
    ) samples=101 evals=1
    active_kernel_time = @belapsed canonicalize_active_word!(
        $active_buffer, $active_workspace, $graph, $colors; load_rows=false
    ) samples=101 evals=1
    active_full_time = @belapsed canonicalize_active_word!(
        $active_buffer, $active_workspace, $graph, $colors
    ) samples=101 evals=1

    canonicalize_active_word!(active_buffer, active_workspace, graph, colors)
    active_alloc = @allocated canonicalize_active_word!(
        active_buffer, active_workspace, graph, colors
    )

    return println(
        join(
            (
                name,
                "n=$(n)",
                "baseline=$(round(1e6 * baseline_time; digits=2)) us",
                "word=$(round(1e6 * word_kernel_time; digits=2)) us",
                "active-kernel=$(round(1e6 * active_kernel_time; digits=2)) us",
                "active-full=$(round(1e6 * active_full_time; digits=2)) us",
                "active/base=$(round(active_full_time / baseline_time; digits=3))x",
                "active/word=$(round(active_kernel_time / word_kernel_time; digits=3))x",
                "alloc=$(active_alloc)",
                "nodes=$(active_workspace.word.search_nodes)",
                "leaves=$(active_workspace.word.search_leaves)",
                "splitters=$(active_workspace.splitter_visits)",
            ),
            " | ",
        ),
    )
end

println("\nactive-splitter refinement benchmark")
for (name, fixture) in (
    "discrete-35" => paired_fixture(35; block=1),
    "paired-35" => paired_fixture(35; block=2),
    "tripled-41" => paired_fixture(41; block=3),
    "paired-24" => paired_fixture(24; block=2),
    "cycle-8" => cycle_fixture(8),
)
    graph, colors = fixture
    benchmark_active_fixture(name, graph, colors)
end
