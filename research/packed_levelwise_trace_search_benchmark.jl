include(joinpath(@__DIR__, "packed_levelwise_trace_search.jl"))
include(joinpath(@__DIR__, "packed_recursive_stabilizer_orbits.jl"))

function levelwise_interleaved_anchored_cycles(sizes::Tuple{Vararg{Int}})
    component_count = length(sizes)
    component_vertices = sum(sizes)
    n = component_vertices + 1
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

function relabel_colors_levelwise(colors::Vector{Int}, mapping::Vector{Int})
    result = similar(colors)
    @inbounds for old_vertex in eachindex(colors)
        result[mapping[old_vertex]] = colors[old_vertex]
    end
    return result
end

function benchmark_levelwise_fixture(name::String, sizes::Tuple{Vararg{Int}})
    graph, colors = levelwise_interleaved_anchored_cycles(sizes)
    n = graph.num_vertices

    recursive = RecursiveStabilizerWorkspace(n)
    recursive_buffer = GC.DirectedCanonicalizationBuffer(n)
    canonicalize_recursive_stabilizers!(recursive_buffer, recursive, graph, colors)

    levelwise_buffer, stats = levelwise_trace_canonical_buffer(graph, colors)

    # Canonical-form invariance under a deliberately global relabeling.  The
    # trace-defined representative need not equal the legacy representative.
    mapping = collect(n:-1:1)
    relabeled_graph = GC._relabel_directed_graph(graph, mapping)
    relabeled_colors = relabel_colors_levelwise(colors, mapping)
    relabeled_buffer, relabeled_stats = levelwise_trace_canonical_buffer(
        relabeled_graph, relabeled_colors
    )
    @view(levelwise_buffer.canonical_multiplicities[1:(n * n)]) ==
        @view(relabeled_buffer.canonical_multiplicities[1:(n * n)]) ||
        error("levelwise canonical image changed under relabeling for $name")

    println(
        "LEVELWISE|",
        name,
        "|dfs_nodes=",
        recursive.packed.workspace.search_nodes,
        "|dfs_leaves=",
        recursive.packed.workspace.search_leaves,
        "|generated=",
        stats.generated_nodes,
        "|retained=",
        stats.retained_nodes,
        "|discarded=",
        stats.discarded_by_trace,
        "|leaves=",
        stats.leaves,
        "|levels=",
        stats.levels,
        "|max_frontier=",
        stats.maximum_frontier,
        "|relabel_generated=",
        relabeled_stats.generated_nodes,
    )
    return nothing
end

benchmark_levelwise_fixture("anchored-cycles-7x9", (7, 9))
benchmark_levelwise_fixture("anchored-cycles-5x7x11", (5, 7, 11))
benchmark_levelwise_fixture("anchored-cycles-5x7x9x11", (5, 7, 9, 11))
benchmark_levelwise_fixture("anchored-cycles-5x7x9x11x13", (5, 7, 9, 11, 13))
