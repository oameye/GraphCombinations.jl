using BenchmarkTools
using GraphCombinations
using Test

const GC = GraphCombinations

mutable struct WordDirectedWorkspace
    out_rows::Vector{UInt64}
    in_rows::Vector{UInt64}
    cell_masks::Vector{UInt64}
    colors::Vector{Int}
    color_stack::Matrix{Int}
    refined_colors::Vector{Int}
    order::Vector{Int}
    signatures::Vector{Int}
    cell_counts::Vector{Int}
    inverse_mapping::Vector{Int}
    best_inverse_mapping::Vector{Int}
    automorphism_order::Int
    has_best::Bool
    search_nodes::Int
    search_leaves::Int
    refinement_rounds::Int
end

function WordDirectedWorkspace(capacity::Integer)
    n = Int(capacity)
    0 <= n <= 64 || throw(ArgumentError("word workspace capacity must be in 0:64"))
    return WordDirectedWorkspace(
        zeros(UInt64, n),
        zeros(UInt64, n),
        zeros(UInt64, n),
        Vector{Int}(undef, n),
        Matrix{Int}(undef, n, n + 1),
        Vector{Int}(undef, n),
        Vector{Int}(undef, n),
        Vector{Int}(undef, n * (1 + 2 * n)),
        Vector{Int}(undef, n),
        Vector{Int}(undef, n),
        Vector{Int}(undef, n),
        0,
        false,
        0,
        0,
        0,
    )
end

@inline _vertex_bit(vertex::Int)::UInt64 = UInt64(1) << (vertex - 1)

function load_word_rows!(
    workspace::WordDirectedWorkspace, graph::GC.DirectedGCGraph
)::Nothing
    n = graph.num_vertices
    n <= min(length(workspace.out_rows), 64) ||
        throw(DimensionMismatch("word workspace capacity is too small"))
    @inbounds for vertex in 1:n
        workspace.out_rows[vertex] = 0
        workspace.in_rows[vertex] = 0
    end
    @inbounds for source in 1:n, target in 1:n
        multiplicity = graph.multiplicities[GC._directed_slot(source, target, n)]
        (multiplicity == 0 || multiplicity == 1) ||
            throw(ArgumentError("word prototype accepts only simple directed graphs"))
        iszero(multiplicity) && continue
        workspace.out_rows[source] |= _vertex_bit(target)
        workspace.in_rows[target] |= _vertex_bit(source)
    end
    return nothing
end

@inline function word_signature_less(
    workspace::WordDirectedWorkspace,
    left_vertex::Int,
    right_vertex::Int,
    signature_length::Int,
    stride::Int,
)::Bool
    left_offset = (left_vertex - 1) * stride
    right_offset = (right_vertex - 1) * stride
    @inbounds for coordinate in 1:signature_length
        left = workspace.signatures[left_offset + coordinate]
        right = workspace.signatures[right_offset + coordinate]
        left == right && continue
        return left < right
    end
    return false
end

function word_sort_signatures!(
    workspace::WordDirectedWorkspace, n::Int, signature_length::Int, stride::Int
)::Nothing
    @inbounds for vertex in 1:n
        workspace.order[vertex] = vertex
    end
    @inbounds for index in 2:n
        vertex = workspace.order[index]
        position = index - 1
        while position >= 1 && word_signature_less(
            workspace, vertex, workspace.order[position], signature_length, stride
        )
            workspace.order[position + 1] = workspace.order[position]
            position -= 1
        end
        workspace.order[position + 1] = vertex
    end
    return nothing
end

function word_initialize_colors!(workspace::WordDirectedWorkspace, n::Int)::Nothing
    @inbounds for vertex in 1:n
        workspace.order[vertex] = vertex
    end
    @inbounds for index in 2:n
        vertex = workspace.order[index]
        value = workspace.colors[vertex]
        position = index - 1
        while position >= 1 && value < workspace.colors[workspace.order[position]]
            workspace.order[position + 1] = workspace.order[position]
            position -= 1
        end
        workspace.order[position + 1] = vertex
    end

    next_color = 0
    previous_value = 0
    @inbounds for index in 1:n
        vertex = workspace.order[index]
        value = workspace.colors[vertex]
        if index == 1 || value != previous_value
            next_color += 1
            previous_value = value
        end
        workspace.color_stack[vertex, 1] = next_color
    end
    return nothing
end

function word_refine_once!(workspace::WordDirectedWorkspace, depth::Int, n::Int)::Bool
    iszero(n) && return true

    num_colors = 0
    @inbounds for vertex in 1:n
        num_colors = max(num_colors, workspace.color_stack[vertex, depth])
    end
    @inbounds for color in 1:num_colors
        workspace.cell_masks[color] = 0
    end
    @inbounds for vertex in 1:n
        color = workspace.color_stack[vertex, depth]
        workspace.cell_masks[color] |= _vertex_bit(vertex)
    end

    stride = 1 + 2 * n
    signature_length = 1 + 2 * num_colors
    @inbounds for vertex in 1:n
        offset = (vertex - 1) * stride
        workspace.signatures[offset + 1] = workspace.color_stack[vertex, depth]
        out_row = workspace.out_rows[vertex]
        in_row = workspace.in_rows[vertex]
        for color in 1:num_colors
            mask = workspace.cell_masks[color]
            workspace.signatures[offset + 2 * color] = count_ones(out_row & mask)
            workspace.signatures[offset + 2 * color + 1] = count_ones(in_row & mask)
        end
    end

    word_sort_signatures!(workspace, n, signature_length, stride)
    next_color = 0
    previous_vertex = 0
    @inbounds for index in 1:n
        vertex = workspace.order[index]
        if iszero(previous_vertex) ||
            word_signature_less(workspace, previous_vertex, vertex, signature_length, stride)
            next_color += 1
        end
        workspace.refined_colors[vertex] = next_color
        previous_vertex = vertex
    end

    stable = true
    @inbounds for vertex in 1:n
        refined = workspace.refined_colors[vertex]
        stable &= refined == workspace.color_stack[vertex, depth]
        workspace.color_stack[vertex, depth] = refined
    end
    workspace.refinement_rounds += 1
    return stable
end

function word_refine!(workspace::WordDirectedWorkspace, depth::Int, n::Int)::Nothing
    while !word_refine_once!(workspace, depth, n)
    end
    return nothing
end

function word_target_color!(workspace::WordDirectedWorkspace, depth::Int, n::Int)::Int
    @inbounds for color in 1:n
        workspace.cell_counts[color] = 0
    end
    num_colors = 0
    @inbounds for vertex in 1:n
        color = workspace.color_stack[vertex, depth]
        workspace.cell_counts[color] += 1
        num_colors = max(num_colors, color)
    end

    target_color = 0
    target_size = typemax(Int)
    @inbounds for color in 1:num_colors
        count = workspace.cell_counts[color]
        if 1 < count < target_size
            target_color = color
            target_size = count
        end
    end
    return target_color
end

function word_record_candidate!(
    workspace::WordDirectedWorkspace, graph::GC.DirectedGCGraph, multiplicity::Int
)::Nothing
    n = graph.num_vertices
    if !workspace.has_best
        iszero(n) ||
            copyto!(workspace.best_inverse_mapping, 1, workspace.inverse_mapping, 1, n)
        workspace.automorphism_order = multiplicity
        workspace.has_best = true
        return nothing
    end

    comparison = GC._compare_directed_inverse_mappings(
        graph, workspace.inverse_mapping, workspace.best_inverse_mapping
    )
    if comparison < 0
        iszero(n) ||
            copyto!(workspace.best_inverse_mapping, 1, workspace.inverse_mapping, 1, n)
        workspace.automorphism_order = multiplicity
    elseif iszero(comparison)
        workspace.automorphism_order = Base.Checked.checked_add(
            workspace.automorphism_order, multiplicity
        )
    end
    return nothing
end

function word_record_leaf!(
    workspace::WordDirectedWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    multiplicity::Int,
)::Nothing
    n = graph.num_vertices
    @inbounds for vertex in 1:n
        canonical_vertex = workspace.color_stack[vertex, depth]
        workspace.inverse_mapping[canonical_vertex] = vertex
    end
    workspace.search_leaves += 1
    word_record_candidate!(workspace, graph, multiplicity)
    return nothing
end

function word_search!(
    workspace::WordDirectedWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    multiplicity::Int,
)::Nothing
    n = graph.num_vertices
    workspace.search_nodes += 1
    word_refine!(workspace, depth, n)
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
        word_search!(workspace, graph, child_depth, child_multiplicity)
    end
    return nothing
end

function reset_word_search!(workspace::WordDirectedWorkspace)::Nothing
    workspace.automorphism_order = 0
    workspace.has_best = false
    workspace.search_nodes = 0
    workspace.search_leaves = 0
    workspace.refinement_rounds = 0
    return nothing
end

function write_word_buffer!(
    buffer::GC.DirectedCanonicalizationBuffer,
    workspace::WordDirectedWorkspace,
    graph::GC.DirectedGCGraph,
)::Nothing
    n = graph.num_vertices
    iszero(n) || copyto!(buffer.canonical_to_old, 1, workspace.best_inverse_mapping, 1, n)
    @inbounds for canonical_vertex in 1:n
        old_vertex = workspace.best_inverse_mapping[canonical_vertex]
        buffer.old_to_canonical[old_vertex] = canonical_vertex
    end
    @inbounds for canonical_source in 1:n
        old_source = workspace.best_inverse_mapping[canonical_source]
        for canonical_target in 1:n
            old_target = workspace.best_inverse_mapping[canonical_target]
            buffer.canonical_multiplicities[GC._directed_slot(canonical_source, canonical_target, n)] = graph.multiplicities[GC._directed_slot(
                old_source, old_target, n
            )]
        end
    end
    buffer.automorphism_order = workspace.automorphism_order
    buffer.num_vertices = n
    return nothing
end

function canonicalize_word!(
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
    word_search!(workspace, graph, 1, 1)
    workspace.has_best || error("word canonical search produced no candidate")
    write_word_buffer!(buffer, workspace, graph)
    return buffer
end

function simple_graph(mask::Integer, n::Int)
    edges = Pair{Int,Int}[]
    bit = 0
    for source in 1:n, target in 1:n
        isodd(mask >> bit) && push!(edges, source => target)
        bit += 1
    end
    return GC.DirectedGCGraph(edges, n)
end

function paired_fixture(n::Int; block::Int=2)
    colors = Int[1 + (vertex - 1) ÷ block for vertex in 1:n]
    edges = Pair{Int,Int}[]
    for vertex in 1:n
        push!(edges, vertex => mod1(vertex + 1, n))
        iseven(vertex) && push!(edges, vertex => mod1(vertex + 5, n))
        vertex % 3 == 0 && push!(edges, mod1(vertex + 7, n) => vertex)
    end
    return GC.DirectedGCGraph(unique(edges), n), colors
end

function cycle_fixture(n::Int)
    edges = Pair{Int,Int}[]
    for vertex in 1:n
        push!(edges, vertex => mod1(vertex + 1, n))
        push!(edges, mod1(vertex + 1, n) => vertex)
    end
    return GC.DirectedGCGraph(unique(edges), n), ones(Int, n)
end

function assert_same_result(
    baseline_buffer::GC.DirectedCanonicalizationBuffer,
    word_buffer::GC.DirectedCanonicalizationBuffer,
    n::Int,
)
    @test GC.canonical_graph(word_buffer) == GC.canonical_graph(baseline_buffer)
    @test GC.canonical_automorphism_order(word_buffer) ==
        GC.canonical_automorphism_order(baseline_buffer)
    @test all(
        GC.canonical_rank(word_buffer, vertex) ==
        GC.canonical_rank(baseline_buffer, vertex) for vertex in 1:n
    )
end

@testset "word refinement exact exhaustive 3-vertex simple digraphs" begin
    baseline_workspace = GC.DirectedCanonicalizationWorkspace(3)
    baseline_buffer = GC.DirectedCanonicalizationBuffer(3)
    word_workspace = WordDirectedWorkspace(3)
    word_buffer = GC.DirectedCanonicalizationBuffer(3)
    colorings = (Int[1, 1, 1], Int[1, 1, 2], Int[1, 2, 3])

    for mask in 0:(2 ^ 9 - 1)
        graph = simple_graph(mask, 3)
        for colors in colorings
            GC.canonicalize_directed!(baseline_buffer, baseline_workspace, graph, colors)
            canonicalize_word!(word_buffer, word_workspace, graph, colors)
            assert_same_result(baseline_buffer, word_buffer, 3)
        end
    end
end

@testset "word refinement rejects repeated multiplicity" begin
    graph = GC.DirectedGCGraph([1 => 2, 1 => 2], 2)
    @test_throws ArgumentError canonicalize_word!(
        GC.DirectedCanonicalizationBuffer(2), WordDirectedWorkspace(2), graph, ones(Int, 2)
    )
end

function benchmark_fixture(name::String, graph::GC.DirectedGCGraph, colors::Vector{Int})
    n = graph.num_vertices
    baseline_workspace = GC.DirectedCanonicalizationWorkspace(n)
    baseline_buffer = GC.DirectedCanonicalizationBuffer(n)
    word_workspace = WordDirectedWorkspace(n)
    word_buffer = GC.DirectedCanonicalizationBuffer(n)

    GC.canonicalize_directed!(baseline_buffer, baseline_workspace, graph, colors)
    canonicalize_word!(word_buffer, word_workspace, graph, colors)
    assert_same_result(baseline_buffer, word_buffer, n)

    load_word_rows!(word_workspace, graph)
    canonicalize_word!(word_buffer, word_workspace, graph, colors; load_rows=false)

    baseline_time = @belapsed GC.canonicalize_directed!(
        $baseline_buffer, $baseline_workspace, $graph, $colors
    ) samples=101 evals=1
    word_kernel_time = @belapsed canonicalize_word!(
        $word_buffer, $word_workspace, $graph, $colors; load_rows=false
    ) samples=101 evals=1
    word_full_time = @belapsed canonicalize_word!(
        $word_buffer, $word_workspace, $graph, $colors
    ) samples=101 evals=1

    GC.canonicalize_directed!(baseline_buffer, baseline_workspace, graph, colors)
    baseline_alloc = @allocated GC.canonicalize_directed!(
        baseline_buffer, baseline_workspace, graph, colors
    )
    canonicalize_word!(word_buffer, word_workspace, graph, colors)
    word_alloc = @allocated canonicalize_word!(word_buffer, word_workspace, graph, colors)

    return println(
        join(
            (
                name,
                "n=$(n)",
                "baseline=$(round(1e6 * baseline_time; digits=2)) us",
                "word-kernel=$(round(1e6 * word_kernel_time; digits=2)) us",
                "word-full=$(round(1e6 * word_full_time; digits=2)) us",
                "kernel-ratio=$(round(word_kernel_time / baseline_time; digits=3))x",
                "full-ratio=$(round(word_full_time / baseline_time; digits=3))x",
                "alloc=$(baseline_alloc)->$(word_alloc)",
                "nodes=$(word_workspace.search_nodes)",
                "leaves=$(word_workspace.search_leaves)",
                "refinements=$(word_workspace.refinement_rounds)",
            ),
            " | ",
        ),
    )
end

println("\nword-sized refinement benchmark")
for (name, fixture) in (
    "discrete-35" => (paired_fixture(35; block=1)),
    "paired-35" => (paired_fixture(35; block=2)),
    "tripled-41" => (paired_fixture(41; block=3)),
    "paired-24" => (paired_fixture(24; block=2)),
    "cycle-8" => (cycle_fixture(8)),
)
    graph, colors = fixture
    benchmark_fixture(name, graph, colors)
end
