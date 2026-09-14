import GraphCombinations as GC

function loopless_allowed(num_vertices::Int)
    allowed = trues(num_vertices, num_vertices)
    @inbounds for vertex in 1:num_vertices
        allowed[vertex, vertex] = false
    end
    return allowed
end

function loopless_typed_problem(num_vertices::Int)
    return GC.TypedMultigraphProblem(
        fill(2, num_vertices), fill(1, num_vertices); allowed=loopless_allowed(num_vertices)
    )
end

function degree_split_typed_problem()
    return GC.TypedMultigraphProblem(
        [1, 1, 2, 2, 3, 3], fill(1, 6); allowed=loopless_allowed(6)
    )
end

function admissibility_refined_typed_problem()
    allowed = falses(6, 6)
    @inbounds for vertex in 1:5
        allowed[vertex, vertex + 1] = true
        allowed[vertex + 1, vertex] = true
    end
    return GC.TypedMultigraphProblem(fill(2, 6), fill(1, 6); allowed)
end

function mixed_color_typed_problem()
    return GC.TypedMultigraphProblem(
        fill(2, 6), [1, 2, 1, 3, 2, 3]; allowed=loopless_allowed(6)
    )
end

function bipartite_typed_problem(num_per_color::Int)
    num_vertices = 2 * num_per_color
    allowed = falses(num_vertices, num_vertices)
    @inbounds for left in 1:num_per_color
        for right in (num_per_color + 1):num_vertices
            allowed[left, right] = true
            allowed[right, left] = true
        end
    end
    return GC.TypedMultigraphProblem(
        fill(2, num_vertices), vcat(fill(1, num_per_color), fill(2, num_per_color)); allowed
    )
end

function fixed_species_typed_problem()
    allowed = trues(6, 6)
    @inbounds for vertex in 1:6
        allowed[vertex, vertex] = false
    end
    @inbounds for vertex in 5:6
        allowed[1, vertex] = false
        allowed[vertex, 1] = false
    end
    @inbounds for vertex in 3:4
        allowed[2, vertex] = false
        allowed[vertex, 2] = false
    end
    return GC.TypedMultigraphProblem(
        [1, 1, 3, 3, 3, 3], [10, 11, 1, 1, 2, 2]; num_fixed=2, allowed
    )
end

function loop_subset_typed_problem()
    allowed = trues(6, 6)
    @inbounds for vertex in 4:6
        allowed[vertex, vertex] = false
    end
    return GC.TypedMultigraphProblem(fill(2, 6), [1, 1, 1, 2, 2, 2]; allowed)
end

function identity_group_typed_problem()
    return GC.TypedMultigraphProblem(fill(2, 6), collect(1:6); allowed=loopless_allowed(6))
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
    actions6 = GC._triangular_relabeling_actions(mappings6, 6)
    graph6 = cycle_graph(6)
    bipartite8 = bipartite_typed_problem(4)
    fixed_species6 = fixed_species_typed_problem()
    loop_subset6 = loop_subset_typed_problem()
    identity_group6 = identity_group_typed_problem()

    SUITE["Typed multigraph generation"]["construct loopless n6"] = @benchmarkable loopless_typed_problem(
        6
    ) seconds = 5
    SUITE["Typed multigraph generation"]["construct degree-split n6"] = @benchmarkable degree_split_typed_problem() seconds =
        5
    SUITE["Typed multigraph generation"]["construct admissibility-refined n6"] = @benchmarkable admissibility_refined_typed_problem() seconds =
        5
    SUITE["Typed multigraph generation"]["construct mixed-color n6"] = @benchmarkable mixed_color_typed_problem() seconds =
        5
    SUITE["Typed multigraph generation"]["canonicalize cycle n6 edge-list"] = @benchmarkable edge_list_canonicalize(
        $graph6, $mappings6
    ) seconds = 5
    SUITE["Typed multigraph generation"]["canonicalize cycle n6 matrix"] = @benchmarkable GC._canonicalize_under_mappings(
        $graph6, $mappings6
    ) seconds = 5
    SUITE["Typed multigraph generation"]["canonicalize cycle n6 triangular"] = @benchmarkable GC._canonicalize_under_triangular_actions(
        $graph6, $actions6, 6
    ) seconds = 5
    SUITE["Typed multigraph generation"]["generate loopless n5"] = @benchmarkable GC.generate_multigraphs(
        $problem5
    ) seconds = 5

    SUITE["Typed continuation reduction"]["identity group n6 direct"] = @benchmarkable GC.generate_multigraphs(
        $identity_group6
    ) seconds = 5
    SUITE["Typed continuation reduction"]["identity group n6 native"] = @benchmarkable GC._generate_typed_native_multiplicity(
        $identity_group6
    ) seconds = 5
    SUITE["Typed continuation reduction"]["bipartite n8 direct"] = @benchmarkable GC.generate_multigraphs(
        $bipartite8
    ) seconds = 5
    SUITE["Typed continuation reduction"]["bipartite n8 row-reduced"] = @benchmarkable GC._generate_typed_row_reduced(
        $bipartite8
    ) seconds = 5
    SUITE["Typed continuation reduction"]["bipartite n8 packed"] = @benchmarkable GC._generate_typed_packed_row_reduced(
        $bipartite8
    ) seconds = 5
    SUITE["Typed continuation reduction"]["bipartite n8 native"] = @benchmarkable GC._generate_typed_native_multiplicity(
        $bipartite8
    ) seconds = 5
    SUITE["Typed continuation reduction"]["fixed species n6 direct"] = @benchmarkable GC.generate_multigraphs(
        $fixed_species6
    ) seconds = 5
    SUITE["Typed continuation reduction"]["fixed species n6 row-reduced"] = @benchmarkable GC._generate_typed_row_reduced(
        $fixed_species6
    ) seconds = 5
    SUITE["Typed continuation reduction"]["fixed species n6 packed"] = @benchmarkable GC._generate_typed_packed_row_reduced(
        $fixed_species6
    ) seconds = 5
    SUITE["Typed continuation reduction"]["fixed species n6 native"] = @benchmarkable GC._generate_typed_native_multiplicity(
        $fixed_species6
    ) seconds = 5
    SUITE["Typed continuation reduction"]["loop subset n6 direct"] = @benchmarkable GC.generate_multigraphs(
        $loop_subset6
    ) seconds = 5
    SUITE["Typed continuation reduction"]["loop subset n6 row-reduced"] = @benchmarkable GC._generate_typed_row_reduced(
        $loop_subset6
    ) seconds = 5
    SUITE["Typed continuation reduction"]["loop subset n6 packed"] = @benchmarkable GC._generate_typed_packed_row_reduced(
        $loop_subset6
    ) seconds = 5
    SUITE["Typed continuation reduction"]["loop subset n6 native"] = @benchmarkable GC._generate_typed_native_multiplicity(
        $loop_subset6
    ) seconds = 5

    return nothing
end
