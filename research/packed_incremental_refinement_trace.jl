import GraphCombinations as GC

mutable struct IncrementalRefinementTraceWorkspace
    packed::GC.PackedDirectedCanonicalizationWorkspace
    trace::Vector{Int}
    trace_length::Int
    split_events::Int
end

function IncrementalRefinementTraceWorkspace(capacity::Integer)
    n = Int(capacity)
    n >= 0 || throw(ArgumentError("capacity must be non-negative"))
    # A successful cell split strictly increases the number of cells.  The
    # event payload can nevertheless be quadratic because each split records
    # all fragments.  This generous research bound keeps the prepared path
    # allocation-free for the one-word regime.
    trace_capacity = max(64, 16 * max(n, 1)^2 + 32 * max(n, 1) + 64)
    return IncrementalRefinementTraceWorkspace(
        GC.PackedDirectedCanonicalizationWorkspace(n),
        zeros(Int, trace_capacity),
        0,
        0,
    )
end

@inline function trace_event_push!(
    traced::IncrementalRefinementTraceWorkspace, value::Int
)::Nothing
    next = traced.trace_length + 1
    next <= length(traced.trace) || error("incremental refinement trace capacity exhausted")
    @inbounds traced.trace[next] = value
    traced.trace_length = next
    return nothing
end

function trace_event_reset!(traced::IncrementalRefinementTraceWorkspace)::Nothing
    traced.trace_length = 0
    traced.split_events = 0
    return nothing
end

function trace_record_split!(
    traced::IncrementalRefinementTraceWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    color::Int,
    cell_mask::UInt64,
    touched_vertices::UInt64,
    next_color::Int,
)::Nothing
    packed = traced.packed
    workspace = packed.workspace
    count = 0
    members = cell_mask
    @inbounds while !iszero(members)
        vertex = trailing_zeros(members) + 1
        count += 1
        workspace.order[count] = vertex
        members &= members - UInt64(1)
    end

    @inbounds for index in 2:count
        vertex = workspace.order[index]
        key = GC._packed_directed_cached_key(packed, vertex, touched_vertices)
        position = index - 1
        while position >= 1 &&
              key < GC._packed_directed_cached_key(
            packed, workspace.order[position], touched_vertices
        )
            workspace.order[position + 1] = workspace.order[position]
            position -= 1
        end
        workspace.order[position + 1] = vertex
    end

    group_count = 0
    previous_key = -1
    @inbounds for index in 1:count
        vertex = workspace.order[index]
        key = GC._packed_directed_cached_key(packed, vertex, touched_vertices)
        if index == 1 || key != previous_key
            group_count += 1
            previous_key = key
        end
    end

    # Tag 3 = one cell split.  Record only canonical partition coordinates and
    # invariant directed-count keys/sizes, never original vertex identities.
    trace_event_push!(traced, 3)
    trace_event_push!(traced, color)
    trace_event_push!(traced, count)
    trace_event_push!(traced, next_color + 1)
    trace_event_push!(traced, group_count)

    previous_key = -1
    group_size = 0
    @inbounds for index in 1:count
        vertex = workspace.order[index]
        key = GC._packed_directed_cached_key(packed, vertex, touched_vertices)
        if index == 1
            previous_key = key
            group_size = 1
        elseif key == previous_key
            group_size += 1
        else
            trace_event_push!(traced, previous_key)
            trace_event_push!(traced, group_size)
            previous_key = key
            group_size = 1
        end
    end
    trace_event_push!(traced, previous_key)
    trace_event_push!(traced, group_size)
    traced.split_events += 1
    return nothing
end

function traced_refine_splitter!(
    traced::IncrementalRefinementTraceWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    splitter_mask::UInt64,
    splitter_index::Int,
    num_colors::Int,
)::Tuple{UInt64,Int}
    packed = traced.packed
    workspace = packed.workspace
    n = graph.num_vertices
    packed.active_splitter_steps += 1

    # Tag 2 = splitter application.  The splitter index is its canonical
    # position in the active wave; the mask itself is intentionally absent.
    trace_event_push!(traced, 2)
    trace_event_push!(traced, splitter_index)
    trace_event_push!(traced, count_ones(splitter_mask))
    trace_event_push!(traced, num_colors)

    touched_vertices = GC._packed_directed_touched_vertices(packed, splitter_mask)
    iszero(touched_vertices) && return UInt64(0), num_colors

    remaining = touched_vertices
    @inbounds while !iszero(remaining)
        vertex = trailing_zeros(remaining) + 1
        packed.splitter_keys[vertex] = GC._packed_directed_splitter_key(
            packed, vertex, splitter_mask, n
        )
        remaining &= remaining - UInt64(1)
    end

    split_members = UInt64(0)
    @inbounds for color in 1:num_colors
        cell_mask = packed.cell_masks[color]
        touched_cell = cell_mask & touched_vertices
        iszero(touched_cell) && continue

        first_key = if touched_cell == cell_mask
            first_vertex = trailing_zeros(touched_cell) + 1
            packed.splitter_keys[first_vertex]
        else
            0
        end

        differs = false
        members = touched_cell
        while !iszero(members)
            vertex = trailing_zeros(members) + 1
            if packed.splitter_keys[vertex] != first_key
                differs = true
                break
            end
            members &= members - UInt64(1)
        end
        differs || continue

        split_members |= cell_mask
        workspace.signatures[color] = 1
        packed.active_cell_splits += 1
    end
    iszero(split_members) && return UInt64(0), num_colors

    next_color = 0
    @inbounds for color in 1:num_colors
        cell_mask = packed.cell_masks[color]
        if iszero(cell_mask & split_members)
            next_color += 1
            packed.next_active_masks[next_color] = cell_mask
            members = cell_mask
            while !iszero(members)
                vertex = trailing_zeros(members) + 1
                workspace.refined_colors[vertex] = next_color
                members &= members - UInt64(1)
            end
            continue
        end

        trace_record_split!(
            traced,
            graph,
            depth,
            color,
            cell_mask,
            touched_vertices,
            next_color,
        )

        count = 0
        members = cell_mask
        while !iszero(members)
            vertex = trailing_zeros(members) + 1
            count += 1
            workspace.order[count] = vertex
            members &= members - UInt64(1)
        end

        for index in 2:count
            vertex = workspace.order[index]
            key = GC._packed_directed_cached_key(packed, vertex, touched_vertices)
            position = index - 1
            while position >= 1 &&
                  key < GC._packed_directed_cached_key(
                packed, workspace.order[position], touched_vertices
            )
                workspace.order[position + 1] = workspace.order[position]
                position -= 1
            end
            workspace.order[position + 1] = vertex
        end

        previous_key = -1
        for index in 1:count
            vertex = workspace.order[index]
            key = GC._packed_directed_cached_key(packed, vertex, touched_vertices)
            if index == 1 || key != previous_key
                next_color += 1
                packed.next_active_masks[next_color] = 0
                previous_key = key
            end
            workspace.refined_colors[vertex] = next_color
            packed.next_active_masks[next_color] |= GC._packed_directed_vertex_bit(vertex)
        end
    end

    @inbounds for vertex in 1:n
        workspace.color_stack[vertex, depth] = workspace.refined_colors[vertex]
    end
    @inbounds for color in 1:next_color
        packed.cell_masks[color] = packed.next_active_masks[color]
    end
    return split_members, next_color
end

function traced_refine!(
    traced::IncrementalRefinementTraceWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
)::Nothing
    packed = traced.packed
    workspace = packed.workspace
    n = graph.num_vertices
    iszero(n) && return nothing

    num_colors = GC._packed_directed_workspace_build_cell_masks!(packed, graph, depth)
    active_count = num_colors
    @inbounds for index in 1:active_count
        packed.active_masks[index] = packed.cell_masks[index]
    end

    wave = 0
    while active_count > 0
        wave += 1
        # Tag 1 = active splitter wave.
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

    trace_event_push!(traced, 0) # end-of-refinement sentinel
    trace_event_push!(traced, num_colors)
    return nothing
end

function prepare_traced_partition!(
    traced::IncrementalRefinementTraceWorkspace,
    graph::GC.DirectedGCGraph,
    colors::AbstractVector{<:Integer},
)::Nothing
    n = graph.num_vertices
    length(colors) == n || error("one color required per vertex")
    packed = traced.packed
    workspace = packed.workspace
    GC._prepare_packed_directed_rows!(packed, graph) ||
        error("incremental trace research requires a simple directed graph with n <= 64")
    @inbounds for vertex in 1:n
        workspace.colors[vertex] = Int(colors[vertex])
    end
    GC._reset_directed_workspace_search!(workspace)
    packed.active_splitter_steps = 0
    packed.active_cell_splits = 0
    GC._directed_workspace_initialize_colors!(workspace, n)
    trace_event_reset!(traced)
    return nothing
end

function refine_root_trace!(
    traced::IncrementalRefinementTraceWorkspace,
    graph::GC.DirectedGCGraph,
    colors::AbstractVector{<:Integer},
)::Nothing
    prepare_traced_partition!(traced, graph, colors)
    traced_refine!(traced, graph, 1)
    return nothing
end

function refine_individualized_trace!(
    traced::IncrementalRefinementTraceWorkspace,
    graph::GC.DirectedGCGraph,
    colors::AbstractVector{<:Integer},
    chosen_vertex::Int,
)::Nothing
    prepare_traced_partition!(traced, graph, colors)
    packed = traced.packed
    workspace = packed.workspace
    GC._packed_directed_workspace_refine!(packed, graph, 1)
    target_color = GC._directed_workspace_target_color!(workspace, graph, 1)
    iszero(target_color) && error("cannot individualize a discrete root partition")
    workspace.color_stack[chosen_vertex, 1] == target_color ||
        error("chosen vertex is outside the root target cell")

    n = graph.num_vertices
    @inbounds for vertex in 1:n
        color = workspace.color_stack[vertex, 1]
        workspace.color_stack[vertex, 2] = if color < target_color
            color
        elseif color > target_color
            color + 1
        elseif vertex == chosen_vertex
            target_color
        else
            target_color + 1
        end
    end
    trace_event_reset!(traced)
    traced_refine!(traced, graph, 2)
    return nothing
end

function trace_view(traced::IncrementalRefinementTraceWorkspace)
    return @view traced.trace[1:traced.trace_length]
end
