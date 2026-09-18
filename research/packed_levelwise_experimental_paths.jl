include(joinpath(@__DIR__, "packed_levelwise_trace_search.jl"))

mutable struct ExperimentalPathStats
    paths::Int
    exact_image_matches::Int
    proven_frontier_automorphisms::Int
    quotient_discards::Int
    automorphism_checks::Int
end

ExperimentalPathStats() = ExperimentalPathStats(0, 0, 0, 0, 0)

function experimental_leaf_inverse(
    graph::GC.DirectedGCGraph,
    colors::Vector{Int},
)::Vector{Int}
    n = graph.num_vertices
    packed = GC.PackedDirectedCanonicalizationWorkspace(n)
    GC._prepare_packed_directed_rows!(packed, graph) ||
        error("experimental-path research requires a simple directed graph with n <= 64")
    workspace = packed.workspace
    @inbounds for vertex in 1:n
        workspace.colors[vertex] = colors[vertex]
    end
    GC._reset_directed_workspace_search!(workspace)
    GC._directed_workspace_initialize_colors!(workspace, n)

    depth = 1
    while true
        GC._packed_directed_workspace_refine!(packed, graph, depth)
        target_color = GC._directed_workspace_target_color!(workspace, graph, depth)
        if iszero(target_color)
            inverse = zeros(Int, n)
            @inbounds for vertex in 1:n
                inverse[workspace.color_stack[vertex, depth]] = vertex
            end
            return inverse
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

@inline function labelled_image_hash(
    graph::GC.DirectedGCGraph, inverse::Vector{Int}
)::UInt64
    n = graph.num_vertices
    value = UInt64(0xcbf29ce484222325)
    @inbounds for canonical_source in 1:n
        old_source = inverse[canonical_source]
        for canonical_target in 1:n
            old_target = inverse[canonical_target]
            item = graph.multiplicities[GC._directed_slot(old_source, old_target, n)]
            value ⊻= UInt64(item + 1)
            value *= UInt64(0x100000001b3)
        end
    end
    return value
end

function same_labelled_image(
    graph::GC.DirectedGCGraph,
    left_inverse::Vector{Int},
    right_inverse::Vector{Int},
)::Bool
    n = graph.num_vertices
    @inbounds for canonical_source in 1:n
        left_source = left_inverse[canonical_source]
        right_source = right_inverse[canonical_source]
        for canonical_target in 1:n
            left_target = left_inverse[canonical_target]
            right_target = right_inverse[canonical_target]
            graph.multiplicities[GC._directed_slot(left_source, left_target, n)] ==
                graph.multiplicities[GC._directed_slot(right_source, right_target, n)] ||
                return false
        end
    end
    return true
end

function induced_automorphism(
    left_inverse::Vector{Int}, right_inverse::Vector{Int}
)::Vector{Int}
    n = length(left_inverse)
    permutation = zeros(Int, n)
    @inbounds for canonical_vertex in 1:n
        permutation[left_inverse[canonical_vertex]] = right_inverse[canonical_vertex]
    end
    return permutation
end

function verify_graph_automorphism(
    graph::GC.DirectedGCGraph, permutation::Vector{Int}
)::Bool
    n = graph.num_vertices
    @inbounds for source in 1:n
        mapped_source = permutation[source]
        1 <= mapped_source <= n || return false
        for target in 1:n
            mapped_target = permutation[target]
            1 <= mapped_target <= n || return false
            graph.multiplicities[GC._directed_slot(source, target, n)] ==
                graph.multiplicities[GC._directed_slot(mapped_source, mapped_target, n)] ||
                return false
        end
    end
    return true
end

function verify_partition_transport(
    left_colors::Vector{Int},
    right_colors::Vector{Int},
    permutation::Vector{Int},
)::Bool
    length(left_colors) == length(right_colors) == length(permutation) || return false
    @inbounds for vertex in eachindex(left_colors)
        left_colors[vertex] == right_colors[permutation[vertex]] || return false
    end
    return true
end

function quotient_frontier_by_experimental_paths(
    graph::GC.DirectedGCGraph,
    frontier::Vector{LevelwiseTraceNode},
    stats::ExperimentalPathStats,
)::Vector{LevelwiseTraceNode}
    length(frontier) <= 1 && return frontier

    retained = LevelwiseTraceNode[]
    retained_inverses = Vector{Vector{Int}}()
    hash_buckets = Dict{UInt64,Vector{Int}}()

    for node in frontier
        inverse = experimental_leaf_inverse(graph, node.colors)
        stats.paths += 1
        image_hash = labelled_image_hash(graph, inverse)
        bucket = get(hash_buckets, image_hash, Int[])
        equivalent = false

        for retained_index in bucket
            representative_inverse = retained_inverses[retained_index]
            same_labelled_image(graph, representative_inverse, inverse) || continue
            stats.exact_image_matches += 1
            permutation = induced_automorphism(representative_inverse, inverse)
            stats.automorphism_checks += 1
            verify_graph_automorphism(graph, permutation) ||
                error("equal experimental leaf images failed automorphism verification")
            verify_partition_transport(
                retained[retained_index].colors, node.colors, permutation
            ) || continue

            stats.proven_frontier_automorphisms += 1
            stats.quotient_discards += 1
            equivalent = true
            break
        end

        equivalent && continue
        push!(retained, node)
        push!(retained_inverses, inverse)
        retained_index = length(retained)
        if haskey(hash_buckets, image_hash)
            push!(hash_buckets[image_hash], retained_index)
        else
            hash_buckets[image_hash] = [retained_index]
        end
    end
    return retained
end

function levelwise_trace_experimental_canonical_inverse(
    graph::GC.DirectedGCGraph,
    initial_colors::AbstractVector{<:Integer},
)::Tuple{Vector{Int},LevelwiseTraceSearchStats,ExperimentalPathStats}
    n = graph.num_vertices
    colors = collect(Int, initial_colors)
    length(colors) == n || error("one color required per vertex")
    traced = IncrementalRefinementTraceWorkspace(n)
    root_colors, _ = refine_partition_with_trace!(traced, graph, colors)
    frontier = LevelwiseTraceNode[LevelwiseTraceNode(root_colors)]
    stats = LevelwiseTraceSearchStats()
    experimental = ExperimentalPathStats()

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
                   (iszero(comparison) && inverse_lex_less(candidate_inverse, best_inverse))
                    best_inverse = candidate_inverse
                end
            end
            return best_inverse, stats, experimental
        end

        best_trace = Int[]
        has_best_trace = false
        next_frontier = LevelwiseTraceNode[]

        for node in frontier
            target_color = target_color_from_partition(node.colors)
            iszero(target_color) && error("mixed discrete/non-discrete maximal trace frontier")
            @inbounds for chosen_vertex in 1:n
                node.colors[chosen_vertex] == target_color || continue
                raw_child = individualize_partition(node.colors, target_color, chosen_vertex)
                child_colors, child_trace = refine_partition_with_trace!(
                    traced, graph, raw_child
                )
                stats.generated_nodes += 1

                comparison = has_best_trace ? trace_compare(child_trace, best_trace) : 1
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

        isempty(next_frontier) && error("experimental trace search produced an empty frontier")
        if !iszero(target_color_from_partition(next_frontier[1].colors))
            next_frontier = quotient_frontier_by_experimental_paths(
                graph, next_frontier, experimental
            )
        end
        stats.retained_nodes += length(next_frontier)
        frontier = next_frontier
    end
end

function levelwise_trace_experimental_canonical_buffer(
    graph::GC.DirectedGCGraph,
    initial_colors::AbstractVector{<:Integer},
)::Tuple{GC.DirectedCanonicalizationBuffer,LevelwiseTraceSearchStats,ExperimentalPathStats}
    inverse, stats, experimental = levelwise_trace_experimental_canonical_inverse(
        graph, initial_colors
    )
    n = graph.num_vertices
    buffer = GC.DirectedCanonicalizationBuffer(n)
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
    return buffer, stats, experimental
end
