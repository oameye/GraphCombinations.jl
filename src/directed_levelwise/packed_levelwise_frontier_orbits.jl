mutable struct PackedLevelwiseOrbitWorkspace
    base::PackedLevelwiseWorkspace
    parent::Vector{Int}
    orbit_weight::Vector{Int}
    path_ready::Vector{Bool}
    permutation::Vector{Int}
    generators::Int
    generator_unions::Int
    orbit_path_skips::Int
end

function PackedLevelwiseOrbitWorkspace(
    capacity::Integer; frontier_capacity::Integer=max(256, 16 * max(Int(capacity), 1))
)
    n = Int(capacity)
    frontier = Int(frontier_capacity)
    return PackedLevelwiseOrbitWorkspace(
        PackedLevelwiseWorkspace(n; frontier_capacity=frontier),
        zeros(Int, frontier),
        zeros(Int, frontier),
        falses(frontier),
        zeros(Int, max(n, 1)),
        0,
        0,
        0,
    )
end

@inline function frontier_find!(candidate::PackedLevelwiseOrbitWorkspace, node::Int)::Int
    parent = candidate.parent
    root = node
    @inbounds while parent[root] != root
        root = parent[root]
    end
    current = node
    @inbounds while parent[current] != current
        next = parent[current]
        parent[current] = root
        current = next
    end
    return root
end

@inline function frontier_union_min!(
    candidate::PackedLevelwiseOrbitWorkspace, left::Int, right::Int
)::Bool
    left_root = frontier_find!(candidate, left)
    right_root = frontier_find!(candidate, right)
    left_root == right_root && return false
    low = min(left_root, right_root)
    high = max(left_root, right_root)
    @inbounds candidate.parent[high] = low
    candidate.generator_unions += 1
    return true
end

function frontier_store_path_inverse!(
    candidate::PackedLevelwiseOrbitWorkspace, node::Int, n::Int
)::Nothing
    base = candidate.base
    @inbounds for canonical_vertex in 1:n
        base.retained_inverses[levelwise_slot(base, node, canonical_vertex)] = base.scratch_inverse[canonical_vertex]
    end
    candidate.path_ready[node] = true
    return nothing
end

function frontier_build_generator!(
    candidate::PackedLevelwiseOrbitWorkspace, retained::Int, n::Int
)::Nothing
    base = candidate.base
    @inbounds for canonical_vertex in 1:n
        left_vertex = base.retained_inverses[levelwise_slot(
            base, retained, canonical_vertex
        )]
        right_vertex = base.scratch_inverse[canonical_vertex]
        candidate.permutation[left_vertex] = right_vertex
    end
    return nothing
end

function frontier_partition_transport_by_generator(
    candidate::PackedLevelwiseOrbitWorkspace,
    colors::Vector{Int},
    left::Int,
    right::Int,
    n::Int,
)::Bool
    base = candidate.base
    permutation = candidate.permutation
    @inbounds for vertex in 1:n
        colors[levelwise_slot(base, left, vertex)] ==
        colors[levelwise_slot(base, right, permutation[vertex])] || return false
    end
    return true
end

function frontier_apply_generator!(
    candidate::PackedLevelwiseOrbitWorkspace, colors::Vector{Int}, count::Int, n::Int
)::Nothing
    candidate.generators += 1
    @inbounds for left in 1:count
        for right in 1:count
            frontier_partition_transport_by_generator(candidate, colors, left, right, n) ||
                continue
            frontier_union_min!(candidate, left, right)
            break
        end
    end
    return nothing
end

function levelwise_quotient_next_frontier_orbits!(
    candidate::PackedLevelwiseOrbitWorkspace, graph::GC.DirectedGCGraph, next_count::Int
)::Int
    base = candidate.base
    n = graph.num_vertices

    @inbounds for node in 1:next_count
        candidate.parent[node] = node
        candidate.orbit_weight[node] = 0
        candidate.path_ready[node] = false
    end

    @inbounds for node in 1:next_count
        if frontier_find!(candidate, node) != node
            candidate.orbit_path_skips += 1
            continue
        end

        levelwise_experimental_inverse!(base, graph, base.next_colors, node)
        image_hash = levelwise_image_hash(base, graph)
        matched = 0

        for retained in 1:(node - 1)
            candidate.path_ready[retained] || continue
            base.retained_hashes[retained] == image_hash || continue
            levelwise_same_retained_image(base, graph, retained) || continue
            base.exact_image_matches += 1
            levelwise_partition_transport(base, base.next_colors, retained, node, n) ||
                continue
            matched = retained
            frontier_build_generator!(candidate, retained, n)
            frontier_apply_generator!(candidate, base.next_colors, next_count, n)
            base.proven_frontier_automorphisms += 1
            break
        end

        if iszero(matched)
            frontier_store_path_inverse!(candidate, node, n)
            base.retained_hashes[node] = image_hash
        end
    end

    @inbounds for node in 1:next_count
        root = frontier_find!(candidate, node)
        candidate.orbit_weight[root] = Base.Checked.checked_add(
            candidate.orbit_weight[root], base.next_multiplicities[node]
        )
    end

    retained_count = 0
    @inbounds for node in 1:next_count
        frontier_find!(candidate, node) == node || continue
        retained_count += 1
        levelwise_copy_partition!(base, base.next_colors, retained_count, node, n)
        base.next_multiplicities[retained_count] = candidate.orbit_weight[node]
    end
    base.quotient_discards += next_count - retained_count
    return retained_count
end

function canonicalize_levelwise_frontier_orbits!(
    buffer::GC.DirectedCanonicalizationBuffer,
    candidate::PackedLevelwiseOrbitWorkspace,
    graph::GC.DirectedGCGraph,
    vertex_colors::AbstractVector{<:Integer},
)::GC.DirectedCanonicalizationBuffer
    base = candidate.base
    n = graph.num_vertices
    n <= base.capacity || error("levelwise workspace capacity exhausted")
    length(vertex_colors) == n || error("vertex_colors must have one entry per vertex")
    GC._check_directed_workspace_capacity(buffer, base.traced.packed.workspace, graph)
    GC._prepare_packed_directed_rows!(base.traced.packed, graph) ||
        error("frontier-orbit research requires a simple directed graph with n <= 64")
    GC._prepare_packed_directed_rows!(base.path_packed, graph) ||
        error("frontier-orbit research requires a simple directed graph with n <= 64")

    reset_levelwise_stats!(base)
    candidate.generators = 0
    candidate.generator_unions = 0
    candidate.orbit_path_skips = 0
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
                base.current_colors[levelwise_slot(base, node, chosen_vertex)] ==
                target_color || continue

                levelwise_prepare_child_trace!(
                    base, graph, base.current_colors, node, target_color, chosen_vertex
                )
                base.generated_nodes += 1
                comparison = has_best_trace ? levelwise_compare_trace_to_best(base) : 1

                if comparison > 0
                    base.discarded_by_trace += next_count
                    next_count = 1
                    levelwise_copy_best_trace!(base)
                    has_best_trace = true
                    levelwise_store_traced_child!(
                        base, next_count, base.current_multiplicities[node], n
                    )
                elseif iszero(comparison)
                    next_count += 1
                    next_count <= base.frontier_capacity ||
                        error("levelwise frontier capacity exhausted")
                    levelwise_store_traced_child!(
                        base, next_count, base.current_multiplicities[node], n
                    )
                else
                    base.discarded_by_trace += 1
                end
            end
        end

        iszero(next_count) && error("levelwise trace search produced an empty frontier")
        if !iszero(levelwise_target_color!(base, base.next_colors, 1, n))
            next_count = levelwise_quotient_next_frontier_orbits!(
                candidate, graph, next_count
            )
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
