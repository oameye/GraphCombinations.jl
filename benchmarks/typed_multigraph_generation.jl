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
    colors = vcat(fill(1, num_per_color), fill(2, num_per_color))
    return GC.TypedMultigraphProblem(fill(2, num_vertices), colors; allowed)
end

function fixed_two_species_typed_problem()
    allowed = loopless_allowed(6)
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

struct _TypedBenchmarkSink end
@inline (::_TypedBenchmarkSink)(_)::Nothing = nothing

struct _TypedConnectedBenchmarkSink
    num_vertices::Int
end

@inline function (sink::_TypedConnectedBenchmarkSink)(graph)::Nothing
    GC.is_connected(GC.build_internal_graph(graph, sink.num_vertices))
    return nothing
end

function enumerate_admissible_typed(degrees::Vector{Int}, allowed::BitMatrix)::Nothing
    GC._foreach_admissible_labeled_multigraph(_TypedBenchmarkSink(), degrees, allowed)
    return nothing
end

function enumerate_connected_admissible_typed(
    degrees::Vector{Int}, allowed::BitMatrix
)::Nothing
    GC._foreach_admissible_labeled_multigraph(
        _TypedConnectedBenchmarkSink(length(degrees)), degrees, allowed
    )
    return nothing
end

function admissible_labeled_counts(
    problem::GC.TypedMultigraphProblem
)::Tuple{Int,Int}
    degrees = GC.vertex_degrees(problem)
    allowed = GC.edge_admissibility(problem)
    num_vertices = length(degrees)
    total = Ref(0)
    connected = Ref(0)
    GC._foreach_admissible_labeled_multigraph(degrees, allowed) do graph
        total[] += 1
        GC.is_connected(GC.build_internal_graph(graph, num_vertices)) && (connected[] += 1)
        return nothing
    end
    return total[], connected[]
end

function log_typed_workload_profile(
    name::String, problem::GC.TypedMultigraphProblem
)::Nothing
    labeled_candidates, connected_labeled_candidates = admissible_labeled_counts(problem)
    @info "typed workload profile" workload = name relabelings = length(
        GC._typed_problem_relabelings(problem)
    ) labeled_candidates connected_labeled_candidates connected_results = length(
        GC.generate_multigraphs(problem)
    )
    return nothing
end

function typed_multigraph_generation!(SUITE)
    problem5 = loopless_typed_problem(5)
    problem6 = loopless_typed_problem(6)
    bipartite8 = bipartite_typed_problem(4)
    fixed_two_species6 = fixed_two_species_typed_problem()
    loop_subset6 = loop_subset_typed_problem()
    mappings6 = GC._typed_problem_relabelings(problem6)
    graph6 = cycle_graph(6)
    bipartite_degrees = GC.vertex_degrees(bipartite8)
    bipartite_allowed = GC.edge_admissibility(bipartite8)

    log_typed_workload_profile("bipartite n8", bipartite8)
    log_typed_workload_profile("fixed two-species n6", fixed_two_species6)
    log_typed_workload_profile("loop-subset n6", loop_subset6)

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
    SUITE["Typed multigraph generation"]["relabelings bipartite n8"] = @benchmarkable GC._typed_problem_relabelings(
        $bipartite8
    ) seconds = 5
    SUITE["Typed multigraph generation"]["enumerate bipartite n8"] = @benchmarkable enumerate_admissible_typed(
        $bipartite_degrees, $bipartite_allowed
    ) seconds = 5
    SUITE["Typed multigraph generation"]["enumerate + connected bipartite n8"] = @benchmarkable enumerate_connected_admissible_typed(
        $bipartite_degrees, $bipartite_allowed
    ) seconds = 5
    SUITE["Typed multigraph generation"]["generate loopless n5"] = @benchmarkable GC.generate_multigraphs(
        $problem5
    ) seconds = 5
    SUITE["Typed multigraph generation"]["generate bipartite n8"] = @benchmarkable GC.generate_multigraphs(
        $bipartite8
    ) seconds = 5
    SUITE["Typed multigraph generation"]["generate fixed two-species n6"] = @benchmarkable GC.generate_multigraphs(
        $fixed_two_species6
    ) seconds = 5
    SUITE["Typed multigraph generation"]["generate loop-subset n6"] = @benchmarkable GC.generate_multigraphs(
        $loop_subset6
    ) seconds = 5

    return nothing
end
