using BenchmarkTools
using GraphCombinations
using Test

import GraphCombinations as GC

@inline vertex_bit(vertex::Int)::UInt64 = UInt64(1) << (vertex - 1)

mutable struct CompactPackedWorkspace
    colors::Vector{Int}
    color_stack::Matrix{UInt8}
    refined_colors::Vector{UInt8}
    order::Vector{Int}
    signatures::Vector{UInt8}
    cell_counts::Vector{UInt8}
    inverse_mapping::Vector{Int}
    best_inverse_mapping::Vector{Int}
    out_rows::Vector{UInt64}
    in_rows::Vector{UInt64}
    cell_masks::Vector{UInt64}
    automorphism_order::Int
    has_best::Bool
    search_nodes::Int
    search_leaves::Int
    refinement_rounds::Int
end

function CompactPackedWorkspace(capacity::Integer)
    n = Int(capacity)
    0 <= n <= 64 || throw(ArgumentError("compact packed capacity must be in 0:64"))
    return CompactPackedWorkspace(
        Vector{Int}(undef, n),
        Matrix{UInt8}(undef, n, n + 1),
        Vector{UInt8}(undef, n),
        Vector{Int}(undef, n),
        Vector{UInt8}(undef, n * (1 + 2 * n)),
        Vector{UInt8}(undef, n),
        Vector{Int}(undef, n),
        Vector{Int}(undef, n),
        zeros(UInt64, n),
        zeros(UInt64, n),
        zeros(UInt64, n),
        0,
        false,
        0,
        0,
        0,
    )
end

function prepare_rows!(workspace::CompactPackedWorkspace, graph::GC.DirectedGCGraph)::Bool
    n = graph.num_vertices
    n <= length(workspace.out_rows) || return false
    @inbounds for vertex in 1:n
        workspace.out_rows[vertex] = 0
        workspace.in_rows[vertex] = 0
    end
    @inbounds for source in 1:n
        for target in 1:n
            multiplicity = graph.multiplicities[GC._directed_slot(source, target, n)]
            iszero(multiplicity) && continue
            multiplicity == 1 || return false
            workspace.out_rows[source] |= vertex_bit(target)
            workspace.in_rows[target] |= vertex_bit(source)
        end
    end
    return true
end

function initialize_colors!(workspace::CompactPackedWorkspace, n::Int)::Nothing
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
        workspace.color_stack[vertex, 1] = UInt8(next_color)
    end
    return nothing
end

@inline function signature_less(
    workspace::CompactPackedWorkspace,
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

function sort_signatures!(
    workspace::CompactPackedWorkspace, n::Int, signature_length::Int, stride::Int
)::Nothing
    @inbounds for vertex in 1:n
        workspace.order[vertex] = vertex
    end
    @inbounds for index in 2:n
        vertex = workspace.order[index]
        position = index - 1
        while position >= 1 && signature_less(
            workspace, vertex, workspace.order[position], signature_length, stride
        )
            workspace.order[position + 1] = workspace.order[position]
            position -= 1
        end
        workspace.order[position + 1] = vertex
    end
    return nothing
end

function refine_once!(workspace::CompactPackedWorkspace, depth::Int, n::Int)::Bool
    iszero(n) && return true
    num_colors = 0
    @inbounds for vertex in 1:n
        num_colors = max(num_colors, Int(workspace.color_stack[vertex, depth]))
    end
    @inbounds for color in 1:num_colors
        workspace.cell_masks[color] = 0
    end
    @inbounds for vertex in 1:n
        color = Int(workspace.color_stack[vertex, depth])
        workspace.cell_masks[color] |= vertex_bit(vertex)
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
            workspace.signatures[offset + 2 * color] = UInt8(count_ones(out_row & mask))
            workspace.signatures[offset + 2 * color + 1] = UInt8(count_ones(in_row & mask))
        end
    end

    sort_signatures!(workspace, n, signature_length, stride)
    next_color = 0
    previous_vertex = 0
    @inbounds for index in 1:n
        vertex = workspace.order[index]
        if iszero(previous_vertex) || signature_less(
            workspace, previous_vertex, vertex, signature_length, stride
        )
            next_color += 1
        end
        workspace.refined_colors[vertex] = UInt8(next_color)
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

function refine!(workspace::CompactPackedWorkspace, depth::Int, n::Int)::Nothing
    while !refine_once!(workspace, depth, n)
    end
    return nothing
end

function target_color!(workspace::CompactPackedWorkspace, depth::Int, n::Int)::Int
    @inbounds for color in 1:n
        workspace.cell_counts[color] = 0
    end
    num_colors = 0
    @inbounds for vertex in 1:n
        color = Int(workspace.color_stack[vertex, depth])
        workspace.cell_counts[color] += UInt8(1)
        num_colors = max(num_colors, color)
    end

    target_color = 0
    target_size = typemax(Int)
    @inbounds for color in 1:num_colors
        count = Int(workspace.cell_counts[color])
        if 1 < count < target_size
            target_color = color
            target_size = count
        end
    end
    return target_color
end

function record_candidate!(
    workspace::CompactPackedWorkspace, graph::GC.DirectedGCGraph, multiplicity::Int
)::Nothing
    n = graph.num_vertices
    if !workspace.has_best
        iszero(n) || copyto!(workspace.best_inverse_mapping, 1, workspace.inverse_mapping, 1, n)
        workspace.automorphism_order = multiplicity
        workspace.has_best = true
        return nothing
    end

    comparison = GC._compare_directed_inverse_mappings(
        graph, workspace.inverse_mapping, workspace.best_inverse_mapping
    )
    if comparison < 0
        iszero(n) || copyto!(workspace.best_inverse_mapping, 1, workspace.inverse_mapping, 1, n)
        workspace.automorphism_order = multiplicity
    elseif iszero(comparison)
        workspace.automorphism_order = Base.Checked.checked_add(
            workspace.automorphism_order, multiplicity
        )
    end
    return nothing
end

function record_leaf!(
    workspace::CompactPackedWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    multiplicity::Int,
)::Nothing
    n = graph.num_vertices
    @inbounds for vertex in 1:n
        canonical_vertex = Int(workspace.color_stack[vertex, depth])
        workspace.inverse_mapping[canonical_vertex] = vertex
    end
    workspace.search_leaves += 1
    record_candidate!(workspace, graph, multiplicity)
    return nothing
end

function search!(
    workspace::CompactPackedWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    multiplicity::Int,
)::Nothing
    n = graph.num_vertices
    workspace.search_nodes += 1
    refine!(workspace, depth, n)
    target = target_color!(workspace, depth, n)
    if iszero(target)
        record_leaf!(workspace, graph, depth, multiplicity)
        return nothing
    end

    child_depth = depth + 1
    @inbounds for chosen_vertex in 1:n
        Int(workspace.color_stack[chosen_vertex, depth]) == target || continue

        has_earlier_twin = false
        for earlier_vertex in 1:(chosen_vertex - 1)
            Int(workspace.color_stack[earlier_vertex, depth]) == target || continue
            if GC._directed_workspace_exact_twins(graph, chosen_vertex, earlier_vertex)
                has_earlier_twin = true
                break
            end
        end
        has_earlier_twin && continue

        twin_class_size = 1
        for later_vertex in (chosen_vertex + 1):n
            Int(workspace.color_stack[later_vertex, depth]) == target || continue
            if GC._directed_workspace_exact_twins(graph, chosen_vertex, later_vertex)
                twin_class_size += 1
            end
        end
        child_multiplicity = Base.Checked.checked_mul(multiplicity, twin_class_size)

        for vertex in 1:n
            color = Int(workspace.color_stack[vertex, depth])
            workspace.color_stack[vertex, child_depth] = UInt8(
                color < target ? color : color > target ? color + 1 : vertex == chosen_vertex ? target : target + 1
            )
        end
        search!(workspace, graph, child_depth, child_multiplicity)
    end
    return nothing
end

function reset!(workspace::CompactPackedWorkspace)::Nothing
    workspace.automorphism_order = 0
    workspace.has_best = false
    workspace.search_nodes = 0
    workspace.search_leaves = 0
    workspace.refinement_rounds = 0
    return nothing
end

function canonicalize_compact!(
    buffer::GC.DirectedCanonicalizationBuffer,
    workspace::CompactPackedWorkspace,
    graph::GC.DirectedGCGraph,
    vertex_colors::AbstractVector{<:Integer},
)::GC.DirectedCanonicalizationBuffer
    n = graph.num_vertices
    n <= length(workspace.colors) || throw(DimensionMismatch("compact workspace too small"))
    length(vertex_colors) == n || throw(ArgumentError("one color per vertex required"))
    prepare_rows!(workspace, graph) || throw(ArgumentError("compact probe requires a simple graph"))
    @inbounds for vertex in 1:n
        workspace.colors[vertex] = Int(vertex_colors[vertex])
    end
    reset!(workspace)
    initialize_colors!(workspace, n)
    search!(workspace, graph, 1, 1)
    workspace.has_best || error("compact packed search produced no candidate")
    GC._write_directed_buffer!(
        buffer, graph, workspace.best_inverse_mapping, workspace.automorphism_order
    )
    return buffer
end

function simple_graph(mask::Int, n::Int)
    edges = Pair{Int,Int}[]
    bit = 0
    for source in 1:n, target in 1:n
        isodd(mask >> bit) && push!(edges, source => target)
        bit += 1
    end
    return GC.DirectedGCGraph(edges, n)
end

@testset "compact packed exact exhaustive 3-vertex simple digraphs" begin
    baseline_workspace = GC.PackedDirectedCanonicalizationWorkspace(3)
    baseline_buffer = GC.DirectedCanonicalizationBuffer(3)
    compact_workspace = CompactPackedWorkspace(3)
    compact_buffer = GC.DirectedCanonicalizationBuffer(3)
    colorings = (Int[1, 1, 1], Int[1, 1, 2], Int[1, 2, 3])

    for mask in 0:(2 ^ 9 - 1)
        graph = simple_graph(mask, 3)
        for colors in colorings
            GC.canonicalize_directed_packed!(baseline_buffer, baseline_workspace, graph, colors)
            canonicalize_compact!(compact_buffer, compact_workspace, graph, colors)
            @test GC.canonical_graph(compact_buffer) == GC.canonical_graph(baseline_buffer)
            @test GC.canonical_automorphism_order(compact_buffer) ==
                GC.canonical_automorphism_order(baseline_buffer)
            @test all(
                GC.canonical_rank(compact_buffer, vertex) ==
                GC.canonical_rank(baseline_buffer, vertex) for vertex in 1:3
            )
        end
    end
end

function cycle_graph(n::Int)
    return GC.DirectedGCGraph([vertex => mod1(vertex + 1, n) for vertex in 1:n], n)
end

println("\ncompact packed workspace footprint")
for n in (12, 17, 26, 36, 41)
    old_alloc = @allocated GC.PackedDirectedCanonicalizationWorkspace(n)
    compact_alloc = @allocated CompactPackedWorkspace(n)
    println(
        "n=",
        n,
        " | old=",
        old_alloc,
        " B | compact=",
        compact_alloc,
        " B | ratio=",
        round(compact_alloc / old_alloc; digits=3),
        "x",
    )
end

println("\ncompact packed search benchmark")
for n in (8, 10, 12)
    graph = cycle_graph(n)
    colors = ones(Int, n)
    old_workspace = GC.PackedDirectedCanonicalizationWorkspace(n)
    old_buffer = GC.DirectedCanonicalizationBuffer(n)
    compact_workspace = CompactPackedWorkspace(n)
    compact_buffer = GC.DirectedCanonicalizationBuffer(n)
    GC.canonicalize_directed_packed!(old_buffer, old_workspace, graph, colors)
    canonicalize_compact!(compact_buffer, compact_workspace, graph, colors)
    old_time = @belapsed GC.canonicalize_directed_packed!(
        $old_buffer, $old_workspace, $graph, $colors
    ) samples=101 evals=1
    compact_time = @belapsed canonicalize_compact!(
        $compact_buffer, $compact_workspace, $graph, $colors
    ) samples=101 evals=1
    compact_alloc = @allocated canonicalize_compact!(
        compact_buffer, compact_workspace, graph, colors
    )
    println(
        "cycle-",
        n,
        " | old=",
        round(1e6 * old_time; digits=2),
        " us | compact=",
        round(1e6 * compact_time; digits=2),
        " us | ratio=",
        round(compact_time / old_time; digits=3),
        "x | alloc=",
        compact_alloc,
    )
end
