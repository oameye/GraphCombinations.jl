include(joinpath(@__DIR__, "packed_levelwise_experimental_paths.jl"))

mutable struct WeightedTraceNode
    colors::Vector{Int}
    multiplicity::Int
end

function weighted_quotient_frontier_by_experimental_paths(
    graph::GC.DirectedGCGraph,
    frontier::Vector{WeightedTraceNode},
    stats::ExperimentalPathStats,
)::Vector{WeightedTraceNode}
    length(frontier) <= 1 && return frontier

    retained = WeightedTraceNode[]
    retained_inverses = Vector{Vector{Int}}()
    hash_buckets = Dict{UInt64,Vector{Int}}()

    for node in frontier
        inverse = experimental_leaf_inverse(graph, node.colors)
        stats.paths += 1
        image_hash = labelled_image_hash(graph, inverse)
        bucket = get(hash_buckets, image_hash, Int[])
        equivalent_index = 0

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
            equivalent_index = retained_index
            break
        end

        if !iszero(equivalent_index)
            retained[equivalent_index].multiplicity = Base.Checked.checked_add(
                retained[equivalent_index].multiplicity, node.multiplicity
            )
            continue
        end

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

function levelwise_trace_exact_inverse_order(
    graph::GC.DirectedGCGraph,
    initial_colors::AbstractVector{<:Integer},
)::Tuple{Vector{Int},Int,LevelwiseTraceSearchStats,ExperimentalPathStats}
    n = graph.num_vertices
    colors = collect(Int, initial_colors)
    length(colors) == n || error("one color required per vertex")
    traced = IncrementalRefinementTraceWorkspace(n)
    root_colors, _ = refine_partition_with_trace!(traced, graph, colors)
    frontier = WeightedTraceNode[WeightedTraceNode(root_colors, 1)]
    stats = LevelwiseTraceSearchStats()
    experimental = ExperimentalPathStats()

    while true
        stats.levels += 1
        stats.maximum_frontier = max(stats.maximum_frontier, length(frontier))

        root_target = target_color_from_partition(frontier[1].colors)
        if iszero(root_target)
            best_inverse = inverse_mapping_from_discrete_partition(frontier[1].colors)
            automorphism_order = frontier[1].multiplicity
            stats.leaves = length(frontier)
            for node_index in 2:length(frontier)
                node = frontier[node_index]
                candidate_inverse = inverse_mapping_from_discrete_partition(node.colors)
                comparison = GC._compare_directed_inverse_mappings(
                    graph, candidate_inverse, best_inverse
                )
                if comparison < 0
                    best_inverse = candidate_inverse
                    automorphism_order = node.multiplicity
                elseif iszero(comparison)
                    automorphism_order = Base.Checked.checked_add(
                        automorphism_order, node.multiplicity
                    )
                    if inverse_lex_less(candidate_inverse, best_inverse)
                        best_inverse = candidate_inverse
                    end
                end
            end
            return best_inverse, automorphism_order, stats, experimental
        end

        best_trace = Int[]
        has_best_trace = false
        next_frontier = WeightedTraceNode[]

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
                    push!(
                        next_frontier,
                        WeightedTraceNode(child_colors, node.multiplicity),
                    )
                elseif iszero(comparison)
                    push!(
                        next_frontier,
                        WeightedTraceNode(child_colors, node.multiplicity),
                    )
                else
                    stats.discarded_by_trace += 1
                end
            end
        end

        isempty(next_frontier) && error("weighted trace search produced an empty frontier")
        if !iszero(target_color_from_partition(next_frontier[1].colors))
            next_frontier = weighted_quotient_frontier_by_experimental_paths(
                graph, next_frontier, experimental
            )
        end
        stats.retained_nodes += length(next_frontier)
        frontier = next_frontier
    end
end

function levelwise_trace_exact_buffer(
    graph::GC.DirectedGCGraph,
    initial_colors::AbstractVector{<:Integer},
)::Tuple{GC.DirectedCanonicalizationBuffer,LevelwiseTraceSearchStats,ExperimentalPathStats}
    inverse, automorphism_order, stats, experimental = levelwise_trace_exact_inverse_order(
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
    buffer.automorphism_order = automorphism_order
    return buffer, stats, experimental
end
