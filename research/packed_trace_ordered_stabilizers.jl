include(joinpath(@__DIR__, "packed_recursive_stabilizer_orbits.jl"))

mutable struct TraceOrderedRecursiveWorkspace
    recursive::RecursiveStabilizerWorkspace
    word_capacity::Int
    candidate_order::Vector{Int}
    candidate_refined_cells::Vector{Int}
    candidate_trace_hash::Vector{UInt64}
    trace_cell_masks::Vector{UInt64}
    trace_candidates_evaluated::Int
    trace_nodes_reordered::Int
    trace_probe_refinement_rounds::Int
    trace_probe_splitter_steps::Int
    trace_probe_cell_splits::Int
end

function TraceOrderedRecursiveWorkspace(capacity::Integer)
    n = Int(capacity)
    n >= 0 || throw(ArgumentError("capacity must be non-negative"))
    word_capacity = min(n, 64)
    depth_capacity = n + 1
    flat_capacity = word_capacity * depth_capacity
    return TraceOrderedRecursiveWorkspace(
        RecursiveStabilizerWorkspace(n),
        word_capacity,
        zeros(Int, flat_capacity),
        zeros(Int, flat_capacity),
        zeros(UInt64, flat_capacity),
        zeros(UInt64, word_capacity),
        0,
        0,
        0,
        0,
        0,
    )
end

@inline function trace_candidate_slot(
    candidate::TraceOrderedRecursiveWorkspace, depth::Int, position::Int
)::Int
    return (depth - 1) * candidate.word_capacity + position
end

@inline function trace_mix(value::UInt64, item::UInt64)::UInt64
    value ⊻= item
    return value * UInt64(0x100000001b3)
end

function trace_partition_certificate!(
    candidate::TraceOrderedRecursiveWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
)::Tuple{Int,UInt64}
    recursive = candidate.recursive
    packed = recursive.packed
    workspace = packed.workspace
    n = graph.num_vertices
    masks = candidate.trace_cell_masks

    @inbounds for color in 1:n
        masks[color] = 0
    end

    num_colors = 0
    @inbounds for vertex in 1:n
        color = workspace.color_stack[vertex, depth]
        num_colors = max(num_colors, color)
        masks[color] |= recursive_bit(vertex)
    end

    hash_value = UInt64(0xcbf29ce484222325)
    hash_value = trace_mix(hash_value, UInt64(n))
    hash_value = trace_mix(hash_value, UInt64(num_colors))

    @inbounds for source_color in 1:num_colors
        source_mask = masks[source_color]
        source_size = count_ones(source_mask)
        source_vertex = trailing_zeros(source_mask) + 1
        hash_value = trace_mix(hash_value, UInt64(source_size))
        source_row = packed.out_rows[source_vertex]
        for target_color in 1:num_colors
            out_count = count_ones(source_row & masks[target_color])
            hash_value = trace_mix(hash_value, UInt64(out_count))
        end
    end

    return num_colors, hash_value
end

@inline function trace_candidate_precedes(
    candidate::TraceOrderedRecursiveWorkspace,
    depth::Int,
    left_position::Int,
    right_position::Int,
)::Bool
    left_slot = trace_candidate_slot(candidate, depth, left_position)
    right_slot = trace_candidate_slot(candidate, depth, right_position)
    left_cells = candidate.candidate_refined_cells[left_slot]
    right_cells = candidate.candidate_refined_cells[right_slot]
    left_cells != right_cells && return left_cells > right_cells

    left_hash = candidate.candidate_trace_hash[left_slot]
    right_hash = candidate.candidate_trace_hash[right_slot]
    left_hash != right_hash && return left_hash < right_hash

    return candidate.candidate_order[left_slot] < candidate.candidate_order[right_slot]
end

function trace_prepare_candidate_order!(
    candidate::TraceOrderedRecursiveWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    child_depth::Int,
    target_color::Int,
    target_mask::UInt64,
)::Int
    recursive = candidate.recursive
    packed = recursive.packed
    workspace = packed.workspace
    n = graph.num_vertices

    before_rounds = workspace.refinement_rounds
    before_steps = packed.active_splitter_steps
    before_splits = packed.active_cell_splits

    count = 0
    members = target_mask
    @inbounds while !iszero(members)
        chosen_vertex = trailing_zeros(members) + 1
        members &= members - UInt64(1)
        count += 1
        slot = trace_candidate_slot(candidate, depth, count)
        candidate.candidate_order[slot] = chosen_vertex

        recursive_individualize!(
            recursive, graph, depth, child_depth, target_color, chosen_vertex
        )
        GC._packed_directed_workspace_refine!(packed, graph, child_depth)
        refined_cells, trace_hash = trace_partition_certificate!(candidate, graph, child_depth)
        candidate.candidate_refined_cells[slot] = refined_cells
        candidate.candidate_trace_hash[slot] = trace_hash
    end

    candidate.trace_candidates_evaluated += count
    candidate.trace_probe_refinement_rounds += workspace.refinement_rounds - before_rounds
    candidate.trace_probe_splitter_steps += packed.active_splitter_steps - before_steps
    candidate.trace_probe_cell_splits += packed.active_cell_splits - before_splits
    workspace.refinement_rounds = before_rounds
    packed.active_splitter_steps = before_steps
    packed.active_cell_splits = before_splits

    @inbounds for index in 2:count
        slot = trace_candidate_slot(candidate, depth, index)
        vertex = candidate.candidate_order[slot]
        refined_cells = candidate.candidate_refined_cells[slot]
        trace_hash = candidate.candidate_trace_hash[slot]
        position = index - 1
        while position >= 1 && trace_candidate_precedes(candidate, depth, index, position)
            from_slot = trace_candidate_slot(candidate, depth, position)
            to_slot = trace_candidate_slot(candidate, depth, position + 1)
            candidate.candidate_order[to_slot] = candidate.candidate_order[from_slot]
            candidate.candidate_refined_cells[to_slot] =
                candidate.candidate_refined_cells[from_slot]
            candidate.candidate_trace_hash[to_slot] = candidate.candidate_trace_hash[from_slot]
            position -= 1
        end
        destination = trace_candidate_slot(candidate, depth, position + 1)
        candidate.candidate_order[destination] = vertex
        candidate.candidate_refined_cells[destination] = refined_cells
        candidate.candidate_trace_hash[destination] = trace_hash
    end

    reordered = false
    previous = 0
    @inbounds for index in 1:count
        vertex = candidate.candidate_order[trace_candidate_slot(candidate, depth, index)]
        if index > 1 && vertex < previous
            reordered = true
            break
        end
        previous = vertex
    end
    candidate.trace_nodes_reordered += reordered
    return count
end

function trace_seed_chosen_twins!(
    candidate::TraceOrderedRecursiveWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    chosen_vertex::Int,
    target_mask::UInt64,
)::Nothing
    recursive = candidate.recursive
    unexplored = target_mask & ~recursive.explored_masks[depth]
    @inbounds while !iszero(unexplored)
        other = trailing_zeros(unexplored) + 1
        unexplored &= unexplored - UInt64(1)
        other == chosen_vertex && continue
        if GC._directed_workspace_exact_twins(graph, chosen_vertex, other)
            recursive_orbit_union!(recursive, depth, chosen_vertex, other)
        end
    end
    return nothing
end

function trace_recursive_search!(
    candidate::TraceOrderedRecursiveWorkspace, graph::GC.DirectedGCGraph, depth::Int
)::Int
    recursive = candidate.recursive
    packed = recursive.packed
    workspace = packed.workspace
    workspace.search_nodes += 1
    GC._packed_directed_workspace_refine!(packed, graph, depth)
    target_color = GC._directed_workspace_target_color!(workspace, graph, depth)

    if iszero(target_color)
        recursive_copy_leaf!(recursive, graph, depth)
        return 1
    end

    depth < recursive.depth_capacity || error("trace stabilizer depth capacity exhausted")
    target_mask = recursive_initialize_node!(recursive, graph, depth, target_color)
    child_depth = depth + 1
    candidate_count = trace_prepare_candidate_order!(
        candidate, graph, depth, child_depth, target_color, target_mask
    )

    @inbounds for position in 1:candidate_count
        chosen_vertex = candidate.candidate_order[
            trace_candidate_slot(candidate, depth, position)
        ]
        if recursive_candidate_explored(recursive, depth, chosen_vertex)
            recursive.orbit_skips[depth] += 1
            recursive.total_orbit_skips += 1
            continue
        end

        trace_seed_chosen_twins!(candidate, graph, depth, chosen_vertex, target_mask)
        recursive.explored_masks[depth] |= recursive_bit(chosen_vertex)
        recursive_individualize!(
            recursive, graph, depth, child_depth, target_color, chosen_vertex
        )
        child_order = trace_recursive_search!(candidate, graph, child_depth)

        if !recursive.has_best[depth]
            recursive_copy_child_best!(recursive, graph, depth, child_depth)
            recursive.best_vertices[depth] = chosen_vertex
            recursive.best_child_orders[depth] = child_order
            recursive.has_best[depth] = true
            continue
        end

        comparison = recursive_compare_child_to_best(
            recursive, graph, depth, child_depth
        )
        if comparison < 0
            recursive_copy_child_best!(recursive, graph, depth, child_depth)
            recursive.best_vertices[depth] = chosen_vertex
            recursive.best_child_orders[depth] = child_order
        elseif iszero(comparison)
            child_order == recursive.best_child_orders[depth] ||
                error("equal trace-ordered child branches have unequal stabilizer orders")
            recursive_record_automorphism!(recursive, graph, depth, child_depth)
        end
    end

    recursive.has_best[depth] || error("trace stabilizer search produced no child")
    best_vertex = recursive.best_vertices[depth]
    orbit_size = recursive_orbit_size(recursive, depth, best_vertex)
    return Base.Checked.checked_mul(orbit_size, recursive.best_child_orders[depth])
end

function canonicalize_trace_ordered_stabilizers!(
    buffer::GC.DirectedCanonicalizationBuffer,
    candidate::TraceOrderedRecursiveWorkspace,
    graph::GC.DirectedGCGraph,
    vertex_colors::AbstractVector{<:Integer},
)::GC.DirectedCanonicalizationBuffer
    recursive = candidate.recursive
    packed = recursive.packed
    workspace = packed.workspace
    n = graph.num_vertices
    length(vertex_colors) == n || error("vertex_colors must have one entry per vertex")
    GC._check_directed_workspace_capacity(buffer, workspace, graph)
    GC._prepare_packed_directed_rows!(packed, graph) ||
        error("trace stabilizer research requires a simple directed graph with n <= 64")

    @inbounds for vertex in 1:n
        workspace.colors[vertex] = Int(vertex_colors[vertex])
    end

    GC._reset_directed_workspace_search!(workspace)
    packed.active_splitter_steps = 0
    packed.active_cell_splits = 0
    fill!(recursive.target_masks, 0)
    fill!(recursive.explored_masks, 0)
    fill!(recursive.best_vertices, 0)
    fill!(recursive.best_child_orders, 0)
    fill!(recursive.has_best, false)
    fill!(recursive.orbit_skips, 0)
    fill!(recursive.orbit_merges, 0)
    fill!(recursive.automorphisms, 0)
    recursive.total_orbit_skips = 0
    recursive.total_orbit_merges = 0
    recursive.total_automorphisms = 0
    candidate.trace_candidates_evaluated = 0
    candidate.trace_nodes_reordered = 0
    candidate.trace_probe_refinement_rounds = 0
    candidate.trace_probe_splitter_steps = 0
    candidate.trace_probe_cell_splits = 0

    GC._directed_workspace_initialize_colors!(workspace, n)
    automorphism_order = trace_recursive_search!(candidate, graph, 1)
    recursive.has_best[1] || error("trace stabilizer search produced no canonical leaf")

    @inbounds for canonical_vertex in 1:n
        workspace.best_inverse_mapping[canonical_vertex] =
            recursive.best_inverse[recursive_slot(recursive, 1, canonical_vertex)]
    end
    workspace.automorphism_order = automorphism_order
    workspace.has_best = true
    GC._write_directed_buffer!(
        buffer, graph, workspace.best_inverse_mapping, workspace.automorphism_order
    )
    return buffer
end
