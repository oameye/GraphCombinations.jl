include(joinpath(@__DIR__, "packed_levelwise_frontier_orbits.jl"))

function packed_refine_from_singleton!(
    packed::GC.PackedDirectedCanonicalizationWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    singleton_mask::UInt64,
)::Nothing
    workspace = packed.workspace
    n = graph.num_vertices
    iszero(n) && return nothing

    num_colors = GC._packed_directed_workspace_build_cell_masks!(packed, graph, depth)
    active_count = 1
    packed.active_masks[1] = singleton_mask

    while active_count > 0
        split_members = UInt64(0)
        @inbounds for index in 1:active_count
            split, num_colors = GC._packed_directed_workspace_refine_splitter!(
                packed,
                graph,
                depth,
                packed.active_masks[index],
                num_colors,
            )
            split_members |= split
        end
        workspace.refinement_rounds += 1
        iszero(split_members) && break

        next_count = 0
        @inbounds for color in 1:num_colors
            mask = packed.cell_masks[color]
            iszero(mask & split_members) && continue
            next_count += 1
            packed.next_active_masks[next_count] = mask
        end
        active_count = next_count
        @inbounds for index in 1:active_count
            packed.active_masks[index] = packed.next_active_masks[index]
        end
    end
    return nothing
end

function traced_refine_from_singleton!(
    traced::IncrementalRefinementTraceWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    singleton_mask::UInt64,
)::Nothing
    packed = traced.packed
    workspace = packed.workspace
    n = graph.num_vertices
    iszero(n) && return nothing

    num_colors = GC._packed_directed_workspace_build_cell_masks!(packed, graph, depth)
    active_count = 1
    packed.active_masks[1] = singleton_mask
    wave = 0

    while active_count > 0
        wave += 1
        trace_event_push!(traced, 1)
        trace_event_push!(traced, wave)
        trace_event_push!(traced, active_count)
        trace_event_push!(traced, num_colors)

        split_members = UInt64(0)
        @inbounds for index in 1:active_count
            split, num_colors = traced_refine_splitter!(
                traced,
                graph,
                depth,
                packed.active_masks[index],
                index,
                num_colors,
            )
            split_members |= split
        end
        workspace.refinement_rounds += 1
        iszero(split_members) && break

        next_count = 0
        @inbounds for color in 1:num_colors
            mask = packed.cell_masks[color]
            iszero(mask & split_members) && continue
            next_count += 1
            packed.next_active_masks[next_count] = mask
        end
        active_count = next_count
        @inbounds for index in 1:active_count
            packed.active_masks[index] = packed.next_active_masks[index]
        end
    end

    trace_event_push!(traced, 0)
    trace_event_push!(traced, num_colors)
    return nothing
end

mutable struct PackedLevelwiseIncrementalWorkspace
    orbit::PackedLevelwiseOrbitWorkspace
end

function PackedLevelwiseIncrementalWorkspace(
    capacity::Integer; frontier_capacity::Integer=max(256, 16 * max(Int(capacity), 1))
)
    return PackedLevelwiseIncrementalWorkspace(
        PackedLevelwiseOrbitWorkspace(capacity; frontier_capacity)
    )
end

function incremental_prepare_child_trace!(
    candidate::PackedLevelwiseIncrementalWorkspace,
    graph::GC.DirectedGCGraph,
    parent_colors::Vector{Int},
    parent_node::Int,
    target_color::Int,
    chosen_vertex::Int,
)::Nothing
    base = candidate.orbit.base
    traced = base.traced
    workspace = traced.packed.workspace
    n = graph.num_vertices

    @inbounds for vertex in 1:n
        color = parent_colors[levelwise_slot(base, parent_node, vertex)]
        workspace.color_stack[vertex, 1] = if color < target_color
            color
        elseif color > target_color
            color + 1
        elseif vertex == chosen_vertex
            target_color
        else
            target_color + 1
        end
    end
    traced.packed.active_splitter_steps = 0
    traced.packed.active_cell_splits = 0
    trace_event_reset!(traced)
    traced_refine_from_singleton!(
        traced,
        graph,
        1,
        GC._packed_directed_vertex_bit(chosen_vertex),
    )
    return nothing
end

function incremental_experimental_inverse!(
    candidate::PackedLevelwiseIncrementalWorkspace,
    graph::GC.DirectedGCGraph,
    colors::Vector{Int},
    node::Int,
)::Nothing
    base = candidate.orbit.base
    packed = base.path_packed
    workspace = packed.workspace
    n = graph.num_vertices

    @inbounds for vertex in 1:n
        workspace.color_stack[vertex, 1] = colors[levelwise_slot(base, node, vertex)]
    end
    depth = 1

    while true
        target_color = GC._directed_workspace_target_color!(workspace, graph, depth)
        if iszero(target_color)
            @inbounds for vertex in 1:n
                base.scratch_inverse[workspace.color_stack[vertex, depth]] = vertex
            end
            base.experimental_paths += 1
            return nothing
        end

        chosen_vertex = 0
        @inbounds for vertex in 1:n
            if workspace.color_stack[vertex, depth] == target_color
                chosen_vertex = vertex
                break
            end
        end
        iszero(chosen_vertex) && error("incremental experimental path found no target-cell member")

        child_depth = depth + 1
        child_depth <= n + 1 || error("incremental experimental path depth capacity exhausted")
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
        packed_refine_from_singleton!(
            packed,
            graph,
            child_depth,
            GC._packed_directed_vertex_bit(chosen_vertex),
        )
        depth = child_depth
    end
end

function incremental_quotient_next_frontier!(
    candidate::PackedLevelwiseIncrementalWorkspace,
    graph::GC.DirectedGCGraph,
    next_count::Int,
)::Int
    orbit = candidate.orbit
    base = orbit.base
    n = graph.num_vertices

    @inbounds for node in 1:next_count
        orbit.parent[node] = node
        orbit.orbit_weight[node] = 0
        orbit.path_ready[node] = false
    end

    @inbounds for node in 1:next_count
        if frontier_find!(orbit, node) != node
            orbit.orbit_path_skips += 1
            continue
        end

        incremental_experimental_inverse!(candidate, graph, base.next_colors, node)
        image_hash = levelwise_image_hash(base, graph)
        matched = 0

        for retained in 1:(node - 1)
            orbit.path_ready[retained] || continue
            base.retained_hashes[retained] == image_hash || continue
            levelwise_same_retained_image(base, graph, retained) || continue
            base.exact_image_matches += 1
            levelwise_partition_transport(
                base, base.next_colors, retained, node, n
            ) || continue
            matched = retained
            frontier_build_generator!(orbit, retained, n)
            frontier_apply_generator!(orbit, base.next_colors, next_count, n)
            base.proven_frontier_automorphisms += 1
            break
        end

        if iszero(matched)
            frontier_store_path_inverse!(orbit, node, n)
            base.retained_hashes[node] = image_hash
        end
    end

    @inbounds for node in 1:next_count
        root = frontier_find!(orbit, node)
        orbit.orbit_weight[root] = Base.Checked.checked_add(
            orbit.orbit_weight[root], base.next_multiplicities[node]
        )
    end

    retained_count = 0
    @inbounds for node in 1:next_count
        frontier_find!(orbit, node) == node || continue
        retained_count += 1
        levelwise_copy_partition!(base, base.next_colors, retained_count, node, n)
        base.next_multiplicities[retained_count] = orbit.orbit_weight[node]
    end
    base.quotient_discards += next_count - retained_count
    return retained_count
end

function canonicalize_levelwise_incremental!(
    buffer::GC.DirectedCanonicalizationBuffer,
    candidate::PackedLevelwiseIncrementalWorkspace,
    graph::GC.DirectedGCGraph,
    vertex_colors::AbstractVector{<:Integer},
)::GC.DirectedCanonicalizationBuffer
    orbit = candidate.orbit
    base = orbit.base
    n = graph.num_vertices
    n <= base.capacity || error("levelwise workspace capacity exhausted")
    length(vertex_colors) == n || error("vertex_colors must have one entry per vertex")
    GC._check_directed_workspace_capacity(buffer, base.traced.packed.workspace, graph)
    GC._prepare_packed_directed_rows!(base.traced.packed, graph) ||
        error("incremental child research requires a simple directed graph with n <= 64")
    GC._prepare_packed_directed_rows!(base.path_packed, graph) ||
        error("incremental child research requires a simple directed graph with n <= 64")

    reset_levelwise_stats!(base)
    orbit.generators = 0
    orbit.generator_unions = 0
    orbit.orbit_path_skips = 0

    # Root input need not be equitable, so retain the full exact root refinement.
    prepare_traced_partition!(base.traced, graph, vertex_colors)
    traced_refine!(base.traced, graph, 1)
    levelwise_store_root!(base, graph)
    current_count = 1
    base.retained_nodes = 1

    while true
        base.levels += 1
        base.maximum_frontier = max(base.maximum_frontier, current_count)
        root_target = levelwise_target_color!(base, base.current_colors, 1, n)
        if iszero(root_target)
            return levelwise_finalize!(buffer, base, graph, current_count)
        end

        next_count = 0
        has_best_trace = false
        base.best_trace_length = 0

        @inbounds for node in 1:current_count
            target_color = levelwise_target_color!(base, base.current_colors, node, n)
            iszero(target_color) && error("mixed discrete/non-discrete trace frontier")

            for chosen_vertex in 1:n
                base.current_colors[
                    levelwise_slot(base, node, chosen_vertex)
                ] == target_color || continue

                incremental_prepare_child_trace!(
                    candidate,
                    graph,
                    base.current_colors,
                    node,
                    target_color,
                    chosen_vertex,
                )
                base.generated_nodes += 1
                comparison = has_best_trace ? levelwise_compare_trace_to_best(base) : 1

                if comparison > 0
                    base.discarded_by_trace += next_count
                    next_count = 1
                    levelwise_copy_best_trace!(base)
                    has_best_trace = true
                    levelwise_store_traced_child!(
                        base,
                        next_count,
                        base.current_multiplicities[node],
                        n,
                    )
                elseif iszero(comparison)
                    next_count += 1
                    next_count <= base.frontier_capacity ||
                        error("levelwise frontier capacity exhausted")
                    levelwise_store_traced_child!(
                        base,
                        next_count,
                        base.current_multiplicities[node],
                        n,
                    )
                else
                    base.discarded_by_trace += 1
                end
            end
        end

        iszero(next_count) && error("incremental levelwise search produced an empty frontier")
        if !iszero(levelwise_target_color!(base, base.next_colors, 1, n))
            next_count = incremental_quotient_next_frontier!(candidate, graph, next_count)
        end
        base.retained_nodes += next_count

        colors_tmp = base.current_colors
        base.current_colors = base.next_colors
        base.next_colors = colors_tmp
        multiplicities_tmp = base.current_multiplicities
        base.current_multiplicities = base.next_multiplicities
        base.next_multiplicities = multiplicities_tmp
        current_count = next_count
    end
end
