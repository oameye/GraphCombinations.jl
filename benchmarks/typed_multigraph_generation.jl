import GraphCombinations as GC

function loopless_typed_problem(num_vertices::Int)
    allowed = trues(num_vertices, num_vertices)
    @inbounds for vertex in 1:num_vertices
        allowed[vertex, vertex] = false
    end
    return GC.TypedMultigraphProblem(fill(2, num_vertices), fill(1, num_vertices); allowed)
end

function cycle_graph(num_vertices::Int)
    graph = Pair{Int,Int}[]
    sizehint!(graph, num_vertices)
    for vertex in 1:(num_vertices - 1)
        push!(graph, vertex => vertex + 1)
    end
    push!(graph, 1 => num_vertices)
    return graph
end

function edge_list_canonicalize(graph, mappings)
    best = similar(graph)
    candidate = similar(graph)
    automorphism_order = 0

    for (mapping_index, mapping) in pairs(mappings)
        GC._write_mapped_graph!(candidate, graph, mapping)
        if mapping_index == 1
            copyto!(best, candidate)
            automorphism_order = 1
            continue
        end

        comparison = GC._compare_graph_reps(candidate, best)
        if comparison < 0
            copyto!(best, candidate)
            automorphism_order = 1
        elseif iszero(comparison)
            automorphism_order += 1
        end
    end
    return best, automorphism_order
end

function typed_multigraph_generation!(SUITE)
    problem5 = loopless_typed_problem(5)
    problem6 = loopless_typed_problem(6)
    mappings6 = GC._typed_problem_relabelings(problem6)
    graph6 = cycle_graph(6)

    SUITE["Typed multigraph generation"]["construct loopless n6"] = @benchmarkable loopless_typed_problem(
        6
    ) seconds = 5
    SUITE["Typed multigraph generation"]["canonicalize cycle n6 edge-list"] = @benchmarkable edge_list_canonicalize(
        $graph6, $mappings6
    ) seconds = 5
    SUITE["Typed multigraph generation"]["canonicalize cycle n6 matrix"] = @benchmarkable GC._canonicalize_under_mappings(
        $graph6, $mappings6
    ) seconds = 5
    SUITE["Typed multigraph generation"]["generate loopless n5"] = @benchmarkable GC.generate_multigraphs(
        $problem5
    ) seconds = 5

    return nothing
end
