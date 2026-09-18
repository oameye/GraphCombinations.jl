include(joinpath(@__DIR__, "packed_levelwise_frontier_orbits.jl"))

mutable struct PackedLevelwisePersistentWorkspace
    frontier::PackedLevelwiseOrbitWorkspace
    generator_capacity::Int
    generator_count::Int
    generator_permutations::Vector{Int}
    reused_generators::Int
    duplicate_generators::Int
end

function PackedLevelwisePersistentWorkspace(
    capacity::Integer;
    frontier_capacity::Integer=max(256, 16 * max(Int(capacity), 1)),
    generator_capacity::Integer=max(64, Int(capacity)^2),
)
    n = Int(capacity)
    generator_cap = Int(generator_capacity)
    generator_cap >= 1 || throw(ArgumentError("generator_capacity must be positive"))
    return PackedLevelwisePersistentWorkspace(
        PackedLevelwiseOrbitWorkspace(n; frontier_capacity),
        generator_cap,
        0,
        zeros(Int, max(n, 1) * generator_cap),
        0,
        0,
    )
end

@inline function persistent_generator_slot(
    candidate::PackedLevelwisePersistentWorkspace,
    generator::Int,
    vertex::Int,
)::Int
    n = max(candidate.frontier.base.capacity, 1)
    return (generator - 1) * n + vertex
end

function persistent_generator_equal(
    candidate::PackedLevelwisePersistentWorkspace,
    generator::Int,
    n::Int,
)::Bool
    permutation = candidate.frontier.permutation
    @inbounds for vertex in 1:n
        candidate.generator_permutations[
            persistent_generator_slot(candidate, generator, vertex)
        ] == permutation[vertex] || return false
    end
    return true
end

function persistent_store_generator!(
    candidate::PackedLevelwisePersistentWorkspace,
    n::Int,
)::Bool
    @inbounds for generator in 1:candidate.generator_count
        if persistent_generator_equal(candidate, generator, n)
            candidate.duplicate_generators += 1
            return false
        end
    end

    next_generator = candidate.generator_count + 1
    next_generator <= candidate.generator_capacity ||
        error("persistent generator capacity exhausted")
    permutation = candidate.frontier.permutation
    @inbounds for vertex in 1:n
        candidate.generator_permutations[
            persistent_generator_slot(candidate, next_generator, vertex)
        ] = permutation[vertex]
    end
    candidate.generator_count = next_generator
    return true
end

function persistent_load_generator!(
    candidate::PackedLevelwisePersistentWorkspace,
    generator::Int,
    n::Int,
)::Nothing
    permutation = candidate.frontier.permutation
    @inbounds for vertex in 1:n
        permutation[vertex] = candidate.generator_permutations[
            persistent_generator_slot(candidate, generator, vertex)
        ]
    end
    return nothing
end

function persistent_apply_stored_generators!(
    candidate::PackedLevelwisePersistentWorkspace,
    colors::Vector{Int},
    count::Int,
    n::Int,
)::Nothing
    frontier = candidate.frontier
    @inbounds for generator in 1:candidate.generator_count
        persistent_load_generator!(candidate, generator, n)
        frontier_apply_generator!(frontier, colors, count, n)
        candidate.reused_generators += 1
    end
    return nothing
end

function persistent_initialize_frontier!(
    candidate::PackedLevelwisePersistentWorkspace,
    count::Int,
)::Nothing
    frontier = candidate.frontier
    @inbounds for node in 1:count
        frontier.parent[node] = node
        frontier.orbit_weight[node] = 0
        frontier.path_ready[node] = false
    end
    return nothing
end

function levelwise_quotient_next_frontier_persistent!(
    candidate::PackedLevelwisePersistentWorkspace,
    graph::GC.DirectedGCGraph,
    next_count::Int,
)::Int
    frontier = candidate.frontier
    base = frontier.base
    n = graph.num_vertices
    persistent_initialize_frontier!(candidate, next_count)

    # Exact graph automorphisms discovered at earlier levels remain valid at
    # every later level.  Apply their generated subgroup to the new frontier
    # before paying for any new experimental path.
    persistent_apply_stored_generators!(candidate, base.next_colors, next_count, n)

    @inbounds for node in 1:next_count
        if frontier_find!(frontier, node) != node
            frontier.orbit_path_skips += 1
            continue
        end

        levelwise_experimental_inverse!(base, graph, base.next_colors, node)
        image_hash = levelwise_image_hash(base, graph)
        matched = 0

        for retained in 1:(node - 1)
            frontier.path_ready[retained] || continue
            base.retained_hashes[retained] == image_hash || continue
            levelwise_same_retained_image(base, graph, retained) || continue
            base.exact_image_matches += 1
            levelwise_partition_transport(
                base, base.next_colors, retained, node, n
            ) || continue

            matched = retained
            frontier_build_generator!(frontier, retained, n)
            is_new = persistent_store_generator!(candidate, n)
            frontier_apply_generator!(frontier, base.next_colors, next_count, n)
            base.proven_frontier_automorphisms += 1
            # If this exact permutation was already stored, the current level
            # may still benefit from applying it after additional DSU unions;
            # therefore the application above is unconditional.
            is_new || nothing
            break
        end

        if iszero(matched)
            frontier_store_path_inverse!(frontier, node, n)
            base.retained_hashes[node] = image_hash
        end
    end

    @inbounds for node in 1:next_count
        root = frontier_find!(frontier, node)
        frontier.orbit_weight[root] = Base.Checked.checked_add(
            frontier.orbit_weight[root], base.next_multiplicities[node]
        )
    end

    retained_count = 0
    @inbounds for node in 1:next_count
        frontier_find!(frontier, node) == node || continue
        retained_count += 1
        levelwise_copy_partition!(
            base, base.next_colors, retained_count, node, n
        )
        base.next_multiplicities[retained_count] = frontier.orbit_weight[node]
    end
    base.quotient_discards += next_count - retained_count
    return retained_count
end

function canonicalize_levelwise_persistent_generators!(
    buffer::GC.DirectedCanonicalizationBuffer,
    candidate::PackedLevelwisePersistentWorkspace,
    graph::GC.DirectedGCGraph,
    vertex_colors::AbstractVector{<:Integer},
)::GC.DirectedCanonicalizationBuffer
    frontier = candidate.frontier
    base = frontier.base
    n = graph.num_vertices
    n <= base.capacity || error("levelwise workspace capacity exhausted")
    length(vertex_colors) == n || error("vertex_colors must have one entry per vertex")
    GC._check_directed_workspace_capacity(buffer, base.traced.packed.workspace, graph)
    GC._prepare_packed_directed_rows!(base.traced.packed, graph) ||
        error("persistent-generator research requires a simple directed graph with n <= 64")
    GC._prepare_packed_directed_rows!(base.path_packed, graph) ||
        error("persistent-generator research requires a simple directed graph with n <= 64")

    reset_levelwise_stats!(base)
    frontier.generators = 0
    frontier.generator_unions = 0
    frontier.orbit_path_skips = 0
    candidate.generator_count = 0
    candidate.reused_generators = 0
    candidate.duplicate_generators = 0

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
            target_color = levelwise_target_color!(
                base, base.current_colors, node, n
            )
            iszero(target_color) && error("mixed discrete/non-discrete trace frontier")

            for chosen_vertex in 1:n
                base.current_colors[
                    levelwise_slot(base, node, chosen_vertex)
                ] == target_color || continue

                levelwise_prepare_child_trace!(
                    base,
                    graph,
                    base.current_colors,
                    node,
                    target_color,
                    chosen_vertex,
                )
                base.generated_nodes += 1
                comparison = has_best_trace ?
                    levelwise_compare_trace_to_best(base) : 1

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

        iszero(next_count) && error("levelwise trace search produced an empty frontier")
        if !iszero(levelwise_target_color!(base, base.next_colors, 1, n))
            next_count = levelwise_quotient_next_frontier_persistent!(
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
