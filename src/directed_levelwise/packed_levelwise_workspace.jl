mutable struct PackedLevelwiseWorkspace
    traced::IncrementalRefinementTraceWorkspace
    path_packed::GC.PackedDirectedCanonicalizationWorkspace
    capacity::Int
    frontier_capacity::Int
    current_colors::Vector{Int}
    next_colors::Vector{Int}
    current_multiplicities::Vector{Int}
    next_multiplicities::Vector{Int}
    retained_inverses::Vector{Int}
    retained_hashes::Vector{UInt64}
    scratch_inverse::Vector{Int}
    best_inverse::Vector{Int}
    best_trace::Vector{Int}
    best_trace_length::Int
    cell_counts::Vector{Int}
    levels::Int
    generated_nodes::Int
    retained_nodes::Int
    discarded_by_trace::Int
    leaves::Int
    maximum_frontier::Int
    experimental_paths::Int
    exact_image_matches::Int
    proven_frontier_automorphisms::Int
    quotient_discards::Int
end

function PackedLevelwiseWorkspace(
    capacity::Integer; frontier_capacity::Integer=max(256, 16 * max(Int(capacity), 1))
)
    n = Int(capacity)
    n >= 0 || throw(ArgumentError("capacity must be non-negative"))
    frontier = Int(frontier_capacity)
    frontier >= 1 || throw(ArgumentError("frontier_capacity must be positive"))
    traced = IncrementalRefinementTraceWorkspace(n)
    flat = max(n, 1) * frontier
    return PackedLevelwiseWorkspace(
        traced,
        GC.PackedDirectedCanonicalizationWorkspace(n),
        n,
        frontier,
        zeros(Int, flat),
        zeros(Int, flat),
        zeros(Int, frontier),
        zeros(Int, frontier),
        zeros(Int, flat),
        zeros(UInt64, frontier),
        zeros(Int, max(n, 1)),
        zeros(Int, max(n, 1)),
        zeros(Int, length(traced.trace)),
        0,
        zeros(Int, max(n, 1)),
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    )
end

@inline function levelwise_slot(
    candidate::PackedLevelwiseWorkspace, node::Int, vertex::Int
)::Int
    return (node - 1) * max(candidate.capacity, 1) + vertex
end

function reset_levelwise_stats!(candidate::PackedLevelwiseWorkspace)::Nothing
    candidate.best_trace_length = 0
    candidate.levels = 0
    candidate.generated_nodes = 0
    candidate.retained_nodes = 0
    candidate.discarded_by_trace = 0
    candidate.leaves = 0
    candidate.maximum_frontier = 0
    candidate.experimental_paths = 0
    candidate.exact_image_matches = 0
    candidate.proven_frontier_automorphisms = 0
    candidate.quotient_discards = 0
    return nothing
end

function levelwise_target_color!(
    candidate::PackedLevelwiseWorkspace, colors::Vector{Int}, node::Int, n::Int
)::Int
    @inbounds for color in 1:n
        candidate.cell_counts[color] = 0
    end
    num_colors = 0
    @inbounds for vertex in 1:n
        color = colors[levelwise_slot(candidate, node, vertex)]
        candidate.cell_counts[color] += 1
        num_colors = max(num_colors, color)
    end

    target_color = 0
    target_size = typemax(Int)
    @inbounds for color in 1:num_colors
        count = candidate.cell_counts[color]
        if 1 < count < target_size
            target_color = color
            target_size = count
        end
    end
    return target_color
end

function levelwise_compare_trace_to_best(candidate::PackedLevelwiseWorkspace)::Int
    traced = candidate.traced
    common = min(traced.trace_length, candidate.best_trace_length)
    @inbounds for index in 1:common
        left = traced.trace[index]
        right = candidate.best_trace[index]
        left == right && continue
        return left < right ? -1 : 1
    end
    traced.trace_length == candidate.best_trace_length && return 0
    return traced.trace_length < candidate.best_trace_length ? -1 : 1
end

function levelwise_copy_best_trace!(candidate::PackedLevelwiseWorkspace)::Nothing
    traced = candidate.traced
    @inbounds for index in 1:traced.trace_length
        candidate.best_trace[index] = traced.trace[index]
    end
    candidate.best_trace_length = traced.trace_length
    return nothing
end

function levelwise_prepare_child_trace!(
    candidate::PackedLevelwiseWorkspace,
    graph::GC.DirectedGCGraph,
    parent_colors::Vector{Int},
    parent_node::Int,
    target_color::Int,
    chosen_vertex::Int,
)::Nothing
    traced = candidate.traced
    packed = traced.packed
    workspace = packed.workspace
    n = graph.num_vertices

    @inbounds for vertex in 1:n
        color = parent_colors[levelwise_slot(candidate, parent_node, vertex)]
        workspace.colors[vertex] = if color < target_color
            color
        elseif color > target_color
            color + 1
        elseif vertex == chosen_vertex
            target_color
        else
            target_color + 1
        end
    end

    GC._reset_directed_workspace_search!(workspace)
    packed.active_splitter_steps = 0
    packed.active_cell_splits = 0
    GC._directed_workspace_initialize_colors!(workspace, n)
    trace_event_reset!(traced)
    traced_refine!(traced, graph, 1)
    return nothing
end

function levelwise_store_traced_child!(
    candidate::PackedLevelwiseWorkspace, node::Int, multiplicity::Int, n::Int
)::Nothing
    node <= candidate.frontier_capacity || error("levelwise frontier capacity exhausted")
    workspace = candidate.traced.packed.workspace
    @inbounds for vertex in 1:n
        candidate.next_colors[levelwise_slot(candidate, node, vertex)] = workspace.color_stack[
            vertex, 1
        ]
    end
    @inbounds candidate.next_multiplicities[node] = multiplicity
    return nothing
end

function levelwise_store_root!(
    candidate::PackedLevelwiseWorkspace, graph::GC.DirectedGCGraph
)::Nothing
    n = graph.num_vertices
    workspace = candidate.traced.packed.workspace
    @inbounds for vertex in 1:n
        candidate.current_colors[levelwise_slot(candidate, 1, vertex)] = workspace.color_stack[
            vertex, 1
        ]
    end
    candidate.current_multiplicities[1] = 1
    return nothing
end

function levelwise_prepare_path_partition!(
    candidate::PackedLevelwiseWorkspace,
    graph::GC.DirectedGCGraph,
    colors::Vector{Int},
    node::Int,
)::Nothing
    packed = candidate.path_packed
    workspace = packed.workspace
    n = graph.num_vertices
    @inbounds for vertex in 1:n
        workspace.colors[vertex] = colors[levelwise_slot(candidate, node, vertex)]
    end
    GC._reset_directed_workspace_search!(workspace)
    packed.active_splitter_steps = 0
    packed.active_cell_splits = 0
    GC._directed_workspace_initialize_colors!(workspace, n)
    return nothing
end

function levelwise_experimental_inverse!(
    candidate::PackedLevelwiseWorkspace,
    graph::GC.DirectedGCGraph,
    colors::Vector{Int},
    node::Int,
)::Nothing
    levelwise_prepare_path_partition!(candidate, graph, colors, node)
    packed = candidate.path_packed
    workspace = packed.workspace
    n = graph.num_vertices
    depth = 1

    while true
        GC._packed_directed_workspace_refine!(packed, graph, depth)
        target_color = GC._directed_workspace_target_color!(workspace, graph, depth)
        if iszero(target_color)
            @inbounds for vertex in 1:n
                candidate.scratch_inverse[workspace.color_stack[vertex, depth]] = vertex
            end
            candidate.experimental_paths += 1
            return nothing
        end

        chosen_vertex = 0
        @inbounds for vertex in 1:n
            if workspace.color_stack[vertex, depth] == target_color
                chosen_vertex = vertex
                break
            end
        end
        iszero(chosen_vertex) && error("experimental path found no target-cell member")
        child_depth = depth + 1
        child_depth <= n + 1 || error("experimental path depth capacity exhausted")
        @inbounds for vertex in 1:n
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
        depth = child_depth
    end
end

function levelwise_image_hash(
    candidate::PackedLevelwiseWorkspace, graph::GC.DirectedGCGraph
)::UInt64
    n = graph.num_vertices
    value = UInt64(0xcbf29ce484222325)
    @inbounds for canonical_source in 1:n
        old_source = candidate.scratch_inverse[canonical_source]
        for canonical_target in 1:n
            old_target = candidate.scratch_inverse[canonical_target]
            item = graph.multiplicities[GC._directed_slot(old_source, old_target, n)]
            value ⊻= UInt64(item + 1)
            value *= UInt64(0x100000001b3)
        end
    end
    return value
end

function levelwise_same_retained_image(
    candidate::PackedLevelwiseWorkspace, graph::GC.DirectedGCGraph, retained::Int
)::Bool
    n = graph.num_vertices
    @inbounds for canonical_source in 1:n
        retained_source = candidate.retained_inverses[levelwise_slot(
            candidate, retained, canonical_source
        )]
        scratch_source = candidate.scratch_inverse[canonical_source]
        for canonical_target in 1:n
            retained_target = candidate.retained_inverses[levelwise_slot(
                candidate, retained, canonical_target
            )]
            scratch_target = candidate.scratch_inverse[canonical_target]
            graph.multiplicities[GC._directed_slot(retained_source, retained_target, n)] ==
            graph.multiplicities[GC._directed_slot(scratch_source, scratch_target, n)] ||
                return false
        end
    end
    return true
end

function levelwise_partition_transport(
    candidate::PackedLevelwiseWorkspace,
    colors::Vector{Int},
    retained::Int,
    node::Int,
    n::Int,
)::Bool
    # Equal labelled leaf images make the witness-pair permutation an exact
    # graph automorphism.  This check proves that the same automorphism also
    # transports the retained frontier partition onto the candidate partition.
    @inbounds for canonical_vertex in 1:n
        left_vertex = candidate.retained_inverses[levelwise_slot(
            candidate, retained, canonical_vertex
        )]
        right_vertex = candidate.scratch_inverse[canonical_vertex]
        colors[levelwise_slot(candidate, retained, left_vertex)] ==
        colors[levelwise_slot(candidate, node, right_vertex)] || return false
    end
    return true
end

function levelwise_copy_partition!(
    candidate::PackedLevelwiseWorkspace,
    colors::Vector{Int},
    destination::Int,
    source::Int,
    n::Int,
)::Nothing
    destination == source && return nothing
    @inbounds for vertex in 1:n
        colors[levelwise_slot(candidate, destination, vertex)] = colors[levelwise_slot(
            candidate, source, vertex
        )]
    end
    return nothing
end

function levelwise_store_retained_inverse!(
    candidate::PackedLevelwiseWorkspace, retained::Int, n::Int
)::Nothing
    @inbounds for canonical_vertex in 1:n
        candidate.retained_inverses[levelwise_slot(candidate, retained, canonical_vertex)] = candidate.scratch_inverse[canonical_vertex]
    end
    return nothing
end

function levelwise_quotient_next_frontier!(
    candidate::PackedLevelwiseWorkspace, graph::GC.DirectedGCGraph, next_count::Int
)::Int
    n = graph.num_vertices
    retained_count = 0

    @inbounds for node in 1:next_count
        levelwise_experimental_inverse!(candidate, graph, candidate.next_colors, node)
        image_hash = levelwise_image_hash(candidate, graph)
        equivalent = 0

        for retained in 1:retained_count
            candidate.retained_hashes[retained] == image_hash || continue
            levelwise_same_retained_image(candidate, graph, retained) || continue
            candidate.exact_image_matches += 1
            levelwise_partition_transport(
                candidate, candidate.next_colors, retained, node, n
            ) || continue
            equivalent = retained
            candidate.proven_frontier_automorphisms += 1
            candidate.quotient_discards += 1
            break
        end

        if !iszero(equivalent)
            candidate.next_multiplicities[equivalent] = Base.Checked.checked_add(
                candidate.next_multiplicities[equivalent],
                candidate.next_multiplicities[node],
            )
            continue
        end

        retained_count += 1
        levelwise_copy_partition!(candidate, candidate.next_colors, retained_count, node, n)
        if retained_count != node
            candidate.next_multiplicities[retained_count] = candidate.next_multiplicities[node]
        end
        levelwise_store_retained_inverse!(candidate, retained_count, n)
        candidate.retained_hashes[retained_count] = image_hash
    end
    return retained_count
end

function levelwise_discrete_inverse!(
    candidate::PackedLevelwiseWorkspace, colors::Vector{Int}, node::Int, n::Int
)::Nothing
    @inbounds for vertex in 1:n
        canonical_vertex = colors[levelwise_slot(candidate, node, vertex)]
        candidate.scratch_inverse[canonical_vertex] = vertex
    end
    return nothing
end

function levelwise_inverse_lex_less(left::Vector{Int}, right::Vector{Int}, n::Int)::Bool
    @inbounds for index in 1:n
        left[index] == right[index] && continue
        return left[index] < right[index]
    end
    return false
end

function levelwise_copy_best_inverse!(candidate::PackedLevelwiseWorkspace, n::Int)::Nothing
    @inbounds for canonical_vertex in 1:n
        candidate.best_inverse[canonical_vertex] = candidate.scratch_inverse[canonical_vertex]
    end
    return nothing
end

function levelwise_finalize!(
    buffer::GC.DirectedCanonicalizationBuffer,
    candidate::PackedLevelwiseWorkspace,
    graph::GC.DirectedGCGraph,
    current_count::Int,
)::GC.DirectedCanonicalizationBuffer
    n = graph.num_vertices
    automorphism_order = 0
    has_best = false
    candidate.leaves = current_count

    @inbounds for node in 1:current_count
        levelwise_discrete_inverse!(candidate, candidate.current_colors, node, n)
        multiplicity = candidate.current_multiplicities[node]
        if !has_best
            levelwise_copy_best_inverse!(candidate, n)
            automorphism_order = multiplicity
            has_best = true
            continue
        end

        comparison = GC._compare_directed_inverse_mappings(
            graph, candidate.scratch_inverse, candidate.best_inverse
        )
        if comparison < 0
            levelwise_copy_best_inverse!(candidate, n)
            automorphism_order = multiplicity
        elseif iszero(comparison)
            automorphism_order = Base.Checked.checked_add(automorphism_order, multiplicity)
            if levelwise_inverse_lex_less(
                candidate.scratch_inverse, candidate.best_inverse, n
            )
                levelwise_copy_best_inverse!(candidate, n)
            end
        end
    end

    has_best || error("levelwise search produced no canonical leaf")
    GC._write_directed_buffer!(buffer, graph, candidate.best_inverse, automorphism_order)
    return buffer
end

function canonicalize_levelwise_workspace!(
    buffer::GC.DirectedCanonicalizationBuffer,
    candidate::PackedLevelwiseWorkspace,
    graph::GC.DirectedGCGraph,
    vertex_colors::AbstractVector{<:Integer},
)::GC.DirectedCanonicalizationBuffer
    n = graph.num_vertices
    n <= candidate.capacity || error("levelwise workspace capacity exhausted")
    length(vertex_colors) == n || error("vertex_colors must have one entry per vertex")
    GC._check_directed_workspace_capacity(buffer, candidate.traced.packed.workspace, graph)
    GC._prepare_packed_directed_rows!(candidate.traced.packed, graph) ||
        error("levelwise workspace research requires a simple directed graph with n <= 64")
    GC._prepare_packed_directed_rows!(candidate.path_packed, graph) ||
        error("levelwise workspace research requires a simple directed graph with n <= 64")

    reset_levelwise_stats!(candidate)
    prepare_traced_partition!(candidate.traced, graph, vertex_colors)
    traced_refine!(candidate.traced, graph, 1)
    levelwise_store_root!(candidate, graph)
    current_count = 1
    candidate.retained_nodes = 1

    while true
        candidate.levels += 1
        candidate.maximum_frontier = max(candidate.maximum_frontier, current_count)
        root_target = levelwise_target_color!(candidate, candidate.current_colors, 1, n)
        if iszero(root_target)
            return levelwise_finalize!(buffer, candidate, graph, current_count)
        end

        next_count = 0
        has_best_trace = false
        candidate.best_trace_length = 0

        @inbounds for node in 1:current_count
            target_color = levelwise_target_color!(
                candidate, candidate.current_colors, node, n
            )
            iszero(target_color) && error("mixed discrete/non-discrete trace frontier")

            for chosen_vertex in 1:n
                candidate.current_colors[levelwise_slot(candidate, node, chosen_vertex)] ==
                target_color || continue

                levelwise_prepare_child_trace!(
                    candidate,
                    graph,
                    candidate.current_colors,
                    node,
                    target_color,
                    chosen_vertex,
                )
                candidate.generated_nodes += 1
                comparison = has_best_trace ? levelwise_compare_trace_to_best(candidate) : 1

                if comparison > 0
                    candidate.discarded_by_trace += next_count
                    next_count = 1
                    levelwise_copy_best_trace!(candidate)
                    has_best_trace = true
                    levelwise_store_traced_child!(
                        candidate, next_count, candidate.current_multiplicities[node], n
                    )
                elseif iszero(comparison)
                    next_count += 1
                    next_count <= candidate.frontier_capacity ||
                        error("levelwise frontier capacity exhausted")
                    levelwise_store_traced_child!(
                        candidate, next_count, candidate.current_multiplicities[node], n
                    )
                else
                    candidate.discarded_by_trace += 1
                end
            end
        end

        iszero(next_count) && error("levelwise trace search produced an empty frontier")
        if !iszero(levelwise_target_color!(candidate, candidate.next_colors, 1, n))
            next_count = levelwise_quotient_next_frontier!(candidate, graph, next_count)
        end
        candidate.retained_nodes += next_count

        colors_tmp = candidate.current_colors
        candidate.current_colors = candidate.next_colors
        candidate.next_colors = colors_tmp
        multiplicities_tmp = candidate.current_multiplicities
        candidate.current_multiplicities = candidate.next_multiplicities
        candidate.next_multiplicities = multiplicities_tmp
        current_count = next_count
    end
end
