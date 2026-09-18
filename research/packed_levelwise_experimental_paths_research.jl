include(joinpath(@__DIR__, "packed_levelwise_experimental_paths.jl"))
include(joinpath(@__DIR__, "packed_recursive_stabilizer_orbits.jl"))

const EXP_N3_COLORINGS = (
    [1, 1, 1],
    [1, 1, 2],
    [1, 2, 1],
    [1, 2, 2],
    [1, 2, 3],
)

function exp_graph_from_mask(n::Int, mask::UInt64)
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

function same_buffer_image(
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

function certify_experimental_n3()
    n = 3
    cases = 0
    for mask in UInt64(0):((UInt64(1) << (n * n)) - UInt64(1))
        graph = exp_graph_from_mask(n, mask)
        for colors_tuple in EXP_N3_COLORINGS
            colors = collect(colors_tuple)
            reference, _ = levelwise_trace_canonical_buffer(graph, colors)
            candidate, _, _ = levelwise_trace_experimental_canonical_buffer(graph, colors)
            same_buffer_image(reference, candidate, n) ||
                error("experimental quotient changed trace-defined canonical image: mask=$mask colors=$colors")
            cases += 1
        end
    end
    println("EXPERIMENTAL-CERT|n3-base-images|", cases)
    return nothing
end

function experimental_interleaved_anchored_cycles(sizes::Tuple{Vararg{Int}})
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

function measure_experimental_fixture(name::String, sizes::Tuple{Vararg{Int}})
    graph, colors = experimental_interleaved_anchored_cycles(sizes)
    n = graph.num_vertices

    recursive = RecursiveStabilizerWorkspace(n)
    recursive_buffer = GC.DirectedCanonicalizationBuffer(n)
    canonicalize_recursive_stabilizers!(recursive_buffer, recursive, graph, colors)

    plain_buffer, plain = levelwise_trace_canonical_buffer(graph, colors)
    experimental_buffer, experimental_search, experimental =
        levelwise_trace_experimental_canonical_buffer(graph, colors)
    same_buffer_image(plain_buffer, experimental_buffer, n) ||
        error("experimental quotient changed trace-defined canonical image for $name")

    println(
        "EXPERIMENTAL|",
        name,
        "|dfs_nodes=",
        recursive.packed.workspace.search_nodes,
        "|dfs_leaves=",
        recursive.packed.workspace.search_leaves,
        "|plain_generated=",
        plain.generated_nodes,
        "|plain_retained=",
        plain.retained_nodes,
        "|plain_leaves=",
        plain.leaves,
        "|exp_generated=",
        experimental_search.generated_nodes,
        "|exp_retained=",
        experimental_search.retained_nodes,
        "|exp_leaves=",
        experimental_search.leaves,
        "|paths=",
        experimental.paths,
        "|image_matches=",
        experimental.exact_image_matches,
        "|aut_proofs=",
        experimental.proven_frontier_automorphisms,
        "|quotient_discards=",
        experimental.quotient_discards,
        "|max_frontier=",
        experimental_search.maximum_frontier,
    )
    return nothing
end

certify_experimental_n3()
measure_experimental_fixture("anchored-cycles-7x9", (7, 9))
measure_experimental_fixture("anchored-cycles-5x7x11", (5, 7, 11))
measure_experimental_fixture("anchored-cycles-5x7x9x11", (5, 7, 9, 11))
measure_experimental_fixture("anchored-cycles-5x7x9x11x13", (5, 7, 9, 11, 13))
