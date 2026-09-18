include(joinpath(@__DIR__, "packed_levelwise_exact_multiplicity.jl"))
include(joinpath(@__DIR__, "packed_recursive_stabilizer_orbits.jl"))

const MULT_N3_PERMUTATIONS = (
    [1, 2, 3],
    [1, 3, 2],
    [2, 1, 3],
    [2, 3, 1],
    [3, 1, 2],
    [3, 2, 1],
)

const MULT_N3_COLORINGS = (
    [1, 1, 1],
    [1, 1, 2],
    [1, 2, 1],
    [1, 2, 2],
    [1, 2, 3],
)

function multiplicity_graph_from_mask(n::Int, mask::UInt64)
    edges = Pair{Int,Int}[]
    bit = 0
    for source in 1:n
        for target in 1:n
            if !iszero(mask & (UInt64(1) << bit))
                push!(edges, source => target)
            end
            bit += 1
        end
    end
    return GC.DirectedGCGraph(edges, n)
end

function multiplicity_relabel_colors(colors::Vector{Int}, mapping::Vector{Int})
    result = similar(colors)
    @inbounds for old_vertex in eachindex(colors)
        result[mapping[old_vertex]] = colors[old_vertex]
    end
    return result
end

function multiplicity_same_image(
    left::GC.DirectedCanonicalizationBuffer,
    right::GC.DirectedCanonicalizationBuffer,
    n::Int,
)::Bool
    @inbounds for slot in 1:(n * n)
        left.canonical_multiplicities[slot] == right.canonical_multiplicities[slot] ||
            return false
    end
    return true
end

function multiplicity_witness_reconstructs(
    buffer::GC.DirectedCanonicalizationBuffer,
    graph::GC.DirectedGCGraph,
)::Bool
    n = graph.num_vertices
    @inbounds for canonical_source in 1:n
        old_source = buffer.canonical_to_old[canonical_source]
        buffer.old_to_canonical[old_source] == canonical_source || return false
        for canonical_target in 1:n
            old_target = buffer.canonical_to_old[canonical_target]
            buffer.canonical_multiplicities[GC._directed_slot(
                canonical_source, canonical_target, n
            )] == graph.multiplicities[GC._directed_slot(old_source, old_target, n)] ||
                return false
        end
    end
    return true
end

function certify_exact_multiplicity_n3()
    n = 3
    base_cases = 0
    relabel_cases = 0
    nontrivial_orders = 0
    maximum_order = 0

    for mask in UInt64(0):((UInt64(1) << (n * n)) - UInt64(1))
        graph = multiplicity_graph_from_mask(n, mask)
        for colors_tuple in MULT_N3_COLORINGS
            colors = collect(colors_tuple)
            exact_buffer, _, _ = levelwise_trace_exact_buffer(graph, colors)
            trace_buffer, _, _ = levelwise_trace_experimental_canonical_buffer(graph, colors)
            multiplicity_same_image(exact_buffer, trace_buffer, n) ||
                error("weighted quotient changed trace-defined image: mask=$mask colors=$colors")
            multiplicity_witness_reconstructs(exact_buffer, graph) ||
                error("weighted witness does not reconstruct image: mask=$mask colors=$colors")

            reference = GC.canonicalize_directed(graph, colors)
            reference_order = GC.canonical_automorphism_order(reference)
            exact_buffer.automorphism_order == reference_order ||
                error(
                    "automorphism order mismatch: mask=$mask colors=$colors exact=$(exact_buffer.automorphism_order) reference=$reference_order"
                )
            nontrivial_orders += reference_order > 1
            maximum_order = max(maximum_order, reference_order)
            base_cases += 1

            for mapping_tuple in MULT_N3_PERMUTATIONS
                mapping = collect(mapping_tuple)
                relabeled_graph = GC._relabel_directed_graph(graph, mapping)
                relabeled_colors = multiplicity_relabel_colors(colors, mapping)
                relabeled_buffer, _, _ = levelwise_trace_exact_buffer(
                    relabeled_graph, relabeled_colors
                )
                multiplicity_same_image(exact_buffer, relabeled_buffer, n) ||
                    error(
                        "weighted canonical image changed under relabeling: mask=$mask colors=$colors map=$mapping"
                    )
                relabeled_buffer.automorphism_order == reference_order ||
                    error(
                        "weighted order changed under relabeling: mask=$mask colors=$colors map=$mapping"
                    )
                multiplicity_witness_reconstructs(relabeled_buffer, relabeled_graph) ||
                    error("relabeled weighted witness does not reconstruct image")
                relabel_cases += 1
            end
        end
    end

    println("MULTIPLICITY-CERT|n3-base|", base_cases)
    println("MULTIPLICITY-CERT|n3-relabelings|", relabel_cases)
    println("MULTIPLICITY-CERT|n3-nontrivial-orders|", nontrivial_orders)
    println("MULTIPLICITY-CERT|n3-max-order|", maximum_order)
    return nothing
end

function multiplicity_interleaved_anchored_cycles(sizes::Tuple{Vararg{Int}})
    component_count = length(sizes)
    n = sum(sizes) + 1
    ids = [zeros(Int, size) for size in sizes]
    next_vertex = 1
    for local_index in 1:maximum(sizes)
        for component in 1:component_count
            local_index <= sizes[component] || continue
            ids[component][local_index] = next_vertex
            next_vertex += 1
        end
    end

    anchor = n
    edges = Pair{Int,Int}[]
    colors = ones(Int, n)
    colors[anchor] = 2
    for component in 1:component_count
        size = sizes[component]
        for local_index in 1:size
            source = ids[component][local_index]
            target = ids[component][mod1(local_index + 1, size)]
            push!(edges, source => target)
            push!(edges, source => anchor)
            push!(edges, anchor => source)
        end
    end
    return GC.DirectedGCGraph(edges, n), colors
end

function certify_cycle_product(name::String, sizes::Tuple{Vararg{Int}})
    graph, colors = multiplicity_interleaved_anchored_cycles(sizes)
    n = graph.num_vertices
    exact_buffer, stats, experimental = levelwise_trace_exact_buffer(graph, colors)

    recursive = RecursiveStabilizerWorkspace(n)
    recursive_buffer = GC.DirectedCanonicalizationBuffer(n)
    canonicalize_recursive_stabilizers!(recursive_buffer, recursive, graph, colors)

    expected_order = prod(sizes)
    exact_buffer.automorphism_order == expected_order ||
        error("known cycle-product order mismatch for $name")
    exact_buffer.automorphism_order == recursive_buffer.automorphism_order ||
        error("#186 order mismatch for $name")
    multiplicity_witness_reconstructs(exact_buffer, graph) ||
        error("weighted witness does not reconstruct cycle-product image for $name")

    println(
        "MULTIPLICITY|",
        name,
        "|order=",
        exact_buffer.automorphism_order,
        "|expected=",
        expected_order,
        "|generated=",
        stats.generated_nodes,
        "|retained=",
        stats.retained_nodes,
        "|leaves=",
        stats.leaves,
        "|paths=",
        experimental.paths,
        "|quotient_discards=",
        experimental.quotient_discards,
        "|dfs_nodes=",
        recursive.packed.workspace.search_nodes,
        "|dfs_leaves=",
        recursive.packed.workspace.search_leaves,
    )
    return nothing
end

certify_exact_multiplicity_n3()
certify_cycle_product("anchored-cycles-7x9", (7, 9))
certify_cycle_product("anchored-cycles-5x7x11", (5, 7, 11))
certify_cycle_product("anchored-cycles-5x7x9x11", (5, 7, 9, 11))
certify_cycle_product("anchored-cycles-5x7x9x11x13", (5, 7, 9, 11, 13))
