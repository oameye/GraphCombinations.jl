import GraphCombinations as GC

const RecursiveGC = GC.DirectedRecursive

function repeated_directed_cycles(count::Int, size::Int)
    n = count * size
    edges = Pair{Int,Int}[]
    for component in 0:(count - 1)
        offset = component * size
        for local_vertex in 1:size
            source = offset + local_vertex
            target = offset + mod1(local_vertex + 1, size)
            push!(edges, source => target)
        end
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function directed_cycle(size::Int)
    edges = Pair{Int,Int}[]
    for source in 1:size
        push!(edges, source => mod1(source + 1, size))
    end
    return GC.DirectedGCGraph(edges, size), ones(Int, size)
end

function disjoint_asymmetric_components(count::Int, size::Int)
    n = count * size
    edges = Pair{Int,Int}[]
    colors = ones(Int, n)
    for component in 0:(count - 1)
        offset = component * size
        for local_source in 1:size, local_target in 1:size
            local_source == local_target && continue
            value = mod(
                37local_source +
                53local_target +
                7local_source * local_target +
                11local_source^2,
                97,
            )
            value < 24 || continue
            push!(edges, (offset + local_source) => (offset + local_target))
        end
        colors[(offset + 1):(offset + size)] .= component + 1
    end
    return GC.DirectedGCGraph(edges, n), colors
end

function minimum_ns(f, repetitions::Int)::Int
    best = typemax(Int)
    for _ in 1:repetitions
        start = time_ns()
        f()
        best = min(best, Int(time_ns() - start))
    end
    return best
end

function benchmark_fixture(name::String, graph::GC.DirectedGCGraph, colors::Vector{Int})
    n = graph.num_vertices
    output = GC.DirectedCanonicalizationBuffer(n; materialize_canonical=false)

    levelwise_workspace = GC.DirectedSimpleCanonicalizationWorkspace(
        n; frontier_capacity=max(4096, 16 * max(n, 1)^2)
    )
    recursive_workspace = RecursiveGC.PackedRecursiveStabilizerWorkspace(n)
    component_recursive = GC.DirectedComponentCanonicalizationWorkspace(n, Val(:recursive))
    component_levelwise = GC.DirectedComponentCanonicalizationWorkspace(n, Val(:levelwise))
    component_general = GC.DirectedComponentCanonicalizationWorkspace(n)

    GC.canonicalize_directed_simple!(output, levelwise_workspace, graph, colors)
    levelwise_order = GC.canonical_automorphism_order(output)
    RecursiveGC.canonicalize_recursive_stabilizers!(
        output, recursive_workspace, graph, colors
    )
    recursive_order = GC.canonical_automorphism_order(output)
    GC.canonicalize_directed_components!(output, component_recursive, graph, colors)
    component_recursive_order = GC.canonical_automorphism_order(output)
    GC.canonicalize_directed_components!(output, component_levelwise, graph, colors)
    component_levelwise_order = GC.canonical_automorphism_order(output)
    GC.canonicalize_directed_components!(output, component_general, graph, colors)
    component_general_order = GC.canonical_automorphism_order(output)

    levelwise_order ==
    recursive_order ==
    component_recursive_order ==
    component_levelwise_order ==
    component_general_order || error("automorphism-order mismatch on $name")

    levelwise_alloc = @allocated GC.canonicalize_directed_simple!(
        output, levelwise_workspace, graph, colors
    )
    recursive_alloc = @allocated RecursiveGC.canonicalize_recursive_stabilizers!(
        output, recursive_workspace, graph, colors
    )
    component_recursive_alloc = @allocated GC.canonicalize_directed_components!(
        output, component_recursive, graph, colors
    )
    component_levelwise_alloc = @allocated GC.canonicalize_directed_components!(
        output, component_levelwise, graph, colors
    )
    component_general_alloc = @allocated GC.canonicalize_directed_components!(
        output, component_general, graph, colors
    )

    repetitions = n <= 32 ? 50 : 20
    levelwise_ns = minimum_ns(
        () -> GC.canonicalize_directed_simple!(output, levelwise_workspace, graph, colors),
        repetitions,
    )
    recursive_ns = minimum_ns(
        () -> RecursiveGC.canonicalize_recursive_stabilizers!(
            output, recursive_workspace, graph, colors
        ),
        repetitions,
    )
    component_recursive_ns = minimum_ns(
        () -> GC.canonicalize_directed_components!(
            output, component_recursive, graph, colors
        ),
        repetitions,
    )
    component_levelwise_ns = minimum_ns(
        () -> GC.canonicalize_directed_components!(
            output, component_levelwise, graph, colors
        ),
        repetitions,
    )
    component_general_ns = minimum_ns(
        () ->
            GC.canonicalize_directed_components!(output, component_general, graph, colors),
        repetitions,
    )

    println(
        "COMPONENT_PROD|",
        name,
        "|n=",
        n,
        "|order=",
        levelwise_order,
        "|levelwise_ns=",
        levelwise_ns,
        "|recursive_ns=",
        recursive_ns,
        "|component_recursive_ns=",
        component_recursive_ns,
        "|component_levelwise_ns=",
        component_levelwise_ns,
        "|component_general_ns=",
        component_general_ns,
        "|levelwise_over_component_recursive=",
        round(levelwise_ns / component_recursive_ns; digits=3),
        "|recursive_over_component_recursive=",
        round(recursive_ns / component_recursive_ns; digits=3),
        "|levelwise_alloc=",
        levelwise_alloc,
        "|recursive_alloc=",
        recursive_alloc,
        "|component_recursive_alloc=",
        component_recursive_alloc,
        "|component_levelwise_alloc=",
        component_levelwise_alloc,
        "|component_general_alloc=",
        component_general_alloc,
    )
    return nothing
end

cycle4, cycle4_colors = repeated_directed_cycles(4, 7)
benchmark_fixture("c7x4", cycle4, cycle4_colors)

asymmetric, asymmetric_colors = disjoint_asymmetric_components(4, 6)
benchmark_fixture("asymmetric6x4", asymmetric, asymmetric_colors)

connected, connected_colors = directed_cycle(31)
benchmark_fixture("connected-c31", connected, connected_colors)
