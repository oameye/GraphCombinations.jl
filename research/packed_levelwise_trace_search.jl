include(joinpath(@__DIR__, "packed_incremental_refinement_trace.jl"))

struct LevelwiseTraceNode
    colors::Vector{Int}
end

mutable struct LevelwiseTraceSearchStats
    levels::Int
    generated_nodes::Int
    retained_nodes::Int
    discarded_by_trace::Int
    leaves::Int
    maximum_frontier::Int
end

LevelwiseTraceSearchStats() = LevelwiseTraceSearchStats(0, 0, 1, 0, 0, 1)

function trace_compare(left::AbstractVector{Int}, right::AbstractVector{Int})::Int
    common = min(length(left), length(right))
    @inbounds for index in 1:common
        left_value = left[index]
        right_value = right[index]
        left_value == right_value && continue
        return left_value < right_value ? -1 : 1
    end
    length(left) == length(right) && return 0
    return length(left) < length(right) ? -1 : 1
end

function stable_partition_from_workspace(
    traced::IncrementalRefinementTraceWorkspace, n::Int
)::Vector{Int}
    workspace = traced.packed.workspace
    return [workspace.color_stack[vertex, 1] for vertex in 1:n]
end

function refine_partition_with_trace!(
    traced::IncrementalRefinementTraceWorkspace,
    graph::GC.DirectedGCGraph,
    colors::Vector{Int},
)::Tuple{Vector{Int},Vector{Int}}
    prepare_traced_partition!(traced, graph, colors)
    traced_refine!(traced, graph, 1)
    return stable_partition_from_workspace(traced, graph.num_vertices), collect(trace_view(traced))
end

function target_color_from_partition(colors::Vector{Int})::Int
    n = length(colors)
    counts = zeros(Int, n)
    num_colors = 0
    @inbounds for color in colors
        counts[color] += 1
        num_colors = max(num_colors, color)
    end
    target_color = 0
    target_size = typemax(Int)
    @inbounds for color in 1:num_colors
        count = counts[color]
        if 1 < count < target_size
            target_color = color
            target_size = count
        end
    end
    return target_color
end

function individualize_partition(
    colors::Vector{Int}, target_color::Int, chosen_vertex::Int
)::Vector{Int}
    n = length(colors)
    child = similar(colors)
    @inbounds for vertex in 1:n
        color = colors[vertex]
        child[vertex] = if color < target_color
            color
        elseif color > target_color
            color + 1
        elseif vertex == chosen_vertex
            target_color
        else
            target_color + 1
        end
    end
    return child
end

function inverse_mapping_from_discrete_partition(colors::Vector{Int})::Vector{Int}
    n = length(colors)
    inverse = zeros(Int, n)
    @inbounds for vertex in 1:n
        canonical_vertex = colors[vertex]
        1 <= canonical_vertex <= n || error("discrete partition has invalid canonical label")
        iszero(inverse[canonical_vertex]) || error("partition is not discrete")
        inverse[canonical_vertex] = vertex
    end
    all(!iszero, inverse) || error("partition is not discrete")
    return inverse
end

function levelwise_trace_canonical_inverse(
    graph::GC.DirectedGCGraph,
    initial_colors::AbstractVector{<:Integer},
)::Tuple{Vector{Int},LevelwiseTraceSearchStats}
    n = graph.num_vertices
    colors = collect(Int, initial_colors)
    length(colors) == n || error("one color required per vertex")
    traced = IncrementalRefinementTraceWorkspace(n)
    root_colors, _ = refine_partition_with_trace!(traced, graph, colors)
    frontier = LevelwiseTraceNode[LevelwiseTraceNode(root_colors)]
    stats = LevelwiseTraceSearchStats()

    while true
        stats.levels += 1
        stats.maximum_frontier = max(stats.maximum_frontier, length(frontier))

        root_target = target_color_from_partition(frontier[1].colors)
        if iszero(root_target)
            best_inverse = inverse_mapping_from_discrete_partition(frontier[1].colors)
            stats.leaves = length(frontier)
            for node_index in 2:length(frontier)
                candidate_inverse = inverse_mapping_from_discrete_partition(
                    frontier[node_index].colors
                )
                comparison = GC._compare_directed_inverse_mappings(
                    graph, candidate_inverse, best_inverse
                )
                if comparison < 0 ||
                   (iszero(comparison) && candidate_inverse < best_inverse)
                    best_inverse = candidate_inverse
                end
            end
            return best_inverse, stats
        end

        best_trace = Int[]
        has_best_trace = false
        next_frontier = LevelwiseTraceNode[]

        for node in frontier
            target_color = target_color_from_partition(node.colors)
            iszero(target_color) && error("mixed discrete/non-discrete maximal trace frontier")
            @inbounds for chosen_vertex in 1:n
                node.colors[chosen_vertex] == target_color || continue
                raw_child = individualize_partition(
                    node.colors, target_color, chosen_vertex
                )
                child_colors, child_trace = refine_partition_with_trace!(
                    traced, graph, raw_child
                )
                stats.generated_nodes += 1

                comparison = if has_best_trace
                    trace_compare(child_trace, best_trace)
                else
                    1
                end
                if comparison > 0
                    stats.discarded_by_trace += length(next_frontier)
                    empty!(next_frontier)
                    best_trace = child_trace
                    has_best_trace = true
                    push!(next_frontier, LevelwiseTraceNode(child_colors))
                elseif iszero(comparison)
                    push!(next_frontier, LevelwiseTraceNode(child_colors))
                else
                    stats.discarded_by_trace += 1
                end
            end
        end

        isempty(next_frontier) && error("trace search produced an empty frontier")
        stats.retained_nodes += length(next_frontier)
        frontier = next_frontier
    end
end

function levelwise_trace_canonical_buffer(
    graph::GC.DirectedGCGraph,
    initial_colors::AbstractVector{<:Integer},
)::Tuple{GC.DirectedCanonicalizationBuffer,LevelwiseTraceSearchStats}
    inverse, stats = levelwise_trace_canonical_inverse(graph, initial_colors)
    n = graph.num_vertices
    buffer = GC.DirectedCanonicalizationBuffer(n)
    # Automorphism order is deliberately not part of this first canonical-only
    # traversal experiment.  Materialize the trace-defined representative and
    # witness explicitly so relabeling invariance can be certified.
    @inbounds for canonical_vertex in 1:n
        old_vertex = inverse[canonical_vertex]
        buffer.canonical_to_old[canonical_vertex] = old_vertex
        buffer.old_to_canonical[old_vertex] = canonical_vertex
    end
    @inbounds for canonical_source in 1:n
        old_source = inverse[canonical_source]
        for canonical_target in 1:n
            old_target = inverse[canonical_target]
            buffer.canonical_multiplicities[GC._directed_slot(
                canonical_source, canonical_target, n
            )] = graph.multiplicities[GC._directed_slot(old_source, old_target, n)]
        end
    end
    buffer.automorphism_order = 0
    return buffer, stats
end
