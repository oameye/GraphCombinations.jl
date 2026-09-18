using BenchmarkTools

include(joinpath(@__DIR__, "packed_trace_ordered_stabilizers.jl"))

function interleaved_anchored_cycles(sizes::Tuple{Vararg{Int}})
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

function interleaved_anchored_circulants(
    components::Tuple{Vararg{Tuple{Int,Tuple{Vararg{Int}}}}}
)
    sizes = ntuple(index -> components[index][1], length(components))
    component_count = length(components)
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
        size, offsets = components[component]
        for local_source in 1:size
            source = ids[component][local_source]
            for delta in offsets
                target = ids[component][mod1(local_source + delta, size)]
                push!(edges, source => target)
            end
            push!(edges, source => anchor)
            push!(edges, anchor => source)
        end
    end
    return GC.DirectedGCGraph(edges, n), colors
end

function assert_same_trace_result(
    name::String,
    base::GC.DirectedCanonicalizationBuffer,
    trace::GC.DirectedCanonicalizationBuffer,
    n::Int,
)
    @view(base.canonical_multiplicities[1:(n * n)]) ==
        @view(trace.canonical_multiplicities[1:(n * n)]) ||
        error("trace canonical image mismatch for $name")
    @view(base.old_to_canonical[1:n]) == @view(trace.old_to_canonical[1:n]) ||
        error("trace canonical witness mismatch for $name")
    base.automorphism_order == trace.automorphism_order ||
        error("trace automorphism-order mismatch for $name")
    return nothing
end

function benchmark_trace_fixture(name::String, graph::GC.DirectedGCGraph, colors::Vector{Int})
    n = graph.num_vertices
    base = RecursiveStabilizerWorkspace(n)
    base_buffer = GC.DirectedCanonicalizationBuffer(n)
    trace = TraceOrderedRecursiveWorkspace(n)
    trace_buffer = GC.DirectedCanonicalizationBuffer(n)

    canonicalize_recursive_stabilizers!(base_buffer, base, graph, colors)
    canonicalize_trace_ordered_stabilizers!(trace_buffer, trace, graph, colors)
    assert_same_trace_result(name, base_buffer, trace_buffer, n)

    base_trial = @benchmark canonicalize_recursive_stabilizers!(
        $base_buffer, $base, $graph, $colors
    ) samples = 120 seconds = 1 evals = 1
    trace_trial = @benchmark canonicalize_trace_ordered_stabilizers!(
        $trace_buffer, $trace, $graph, $colors
    ) samples = 120 seconds = 1 evals = 1
    base_estimate = minimum(base_trial)
    trace_estimate = minimum(trace_trial)

    println(
        "TRACE|",
        name,
        "|",
        trace_estimate.time / base_estimate.time,
        "|",
        base.packed.workspace.search_nodes,
        "|",
        trace.recursive.packed.workspace.search_nodes,
        "|",
        base.packed.workspace.search_leaves,
        "|",
        trace.recursive.packed.workspace.search_leaves,
        "|",
        base.total_orbit_skips,
        "|",
        trace.recursive.total_orbit_skips,
        "|",
        trace.trace_candidates_evaluated,
        "|",
        trace.trace_nodes_reordered,
        "|",
        trace.trace_probe_refinement_rounds,
        "|",
        trace.trace_probe_splitter_steps,
        "|",
        trace_estimate.memory,
        "|",
        trace_estimate.allocs,
    )
    return nothing
end

fixtures = (
    ("anchored-cycles-7x9", interleaved_anchored_cycles((7, 9))...),
    ("anchored-cycles-5x7x11", interleaved_anchored_cycles((5, 7, 11))...),
    ("anchored-cycles-5x7x9x11", interleaved_anchored_cycles((5, 7, 9, 11))...),
    ("anchored-cycles-5x7x9x11x13", interleaved_anchored_cycles((5, 7, 9, 11, 13))...),
    (
        "anchored-circulants-7x11x13",
        interleaved_anchored_circulants(((7, (1, 3)), (11, (1, 4)), (13, (1, 5))))...,
    ),
)

println("TRACE-ORDERED-STABILIZER-FIXTURES")
for (name, graph, colors) in fixtures
    benchmark_trace_fixture(name, graph, colors)
end
