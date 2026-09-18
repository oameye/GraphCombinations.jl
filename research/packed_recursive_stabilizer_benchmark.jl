include(joinpath(@__DIR__, "packed_recursive_stabilizer_orbits.jl"))
include(joinpath(@__DIR__, "packed_depth2_stabilizer_orbits.jl"))

function recursive_colored_cycle_product(sizes::Tuple{Vararg{Int}}; anchor::Bool=false)
    component_vertices = sum(sizes)
    n = component_vertices + (anchor ? 1 : 0)
    edges = Pair{Int,Int}[]
    colors = Vector{Int}(undef, n)
    offset = 0

    for (color, size) in enumerate(sizes)
        for local_vertex in 1:size
            source = offset + local_vertex
            target = offset + mod1(local_vertex + 1, size)
            push!(edges, source => target)
            colors[source] = color
        end
        offset += size
    end

    if anchor
        fixed = n
        colors[fixed] = length(sizes) + 1
        for vertex in 1:component_vertices
            push!(edges, fixed => vertex)
            push!(edges, vertex => fixed)
        end
    end

    return GC.DirectedGCGraph(edges, n), colors
end

function recursive_colored_circulant_product(
    components::Tuple{Vararg{Tuple{Int,Tuple{Vararg{Int}}}}}
)
    n = sum(first(component) for component in components)
    edges = Pair{Int,Int}[]
    colors = Vector{Int}(undef, n)
    offset = 0

    for (color, (size, offsets)) in enumerate(components)
        for local_source in 1:size
            source = offset + local_source
            colors[source] = color
            for delta in offsets
                target = offset + mod1(local_source + delta, size)
                push!(edges, source => target)
            end
        end
        offset += size
    end
    return GC.DirectedGCGraph(edges, n), colors
end

function recursive_assert_equal(
    name::String,
    base::GC.DirectedCanonicalizationBuffer,
    other::GC.DirectedCanonicalizationBuffer,
    n::Int,
    label::String,
)
    base_image = @view base.canonical_multiplicities[1:(n * n)]
    other_image = @view other.canonical_multiplicities[1:(n * n)]
    base_witness = @view base.old_to_canonical[1:n]
    other_witness = @view other.old_to_canonical[1:n]
    base_image == other_image || error("$label canonical image mismatch for $name")
    base_witness == other_witness || error("$label canonical witness mismatch for $name")
    base.automorphism_order == other.automorphism_order ||
        error("$label automorphism-order mismatch for $name")
    return nothing
end

function benchmark_recursive_fixture(
    name::String, graph::GC.DirectedGCGraph, colors::Vector{Int}
)
    n = graph.num_vertices
    base_workspace = GC.PackedDirectedCanonicalizationWorkspace(n)
    base_buffer = GC.DirectedCanonicalizationBuffer(n)
    depth2 = Depth2StabilizerWorkspace(n)
    depth2_buffer = GC.DirectedCanonicalizationBuffer(n)
    recursive = RecursiveStabilizerWorkspace(n)
    recursive_buffer = GC.DirectedCanonicalizationBuffer(n)

    GC.canonicalize_directed_packed!(base_buffer, base_workspace, graph, colors)
    canonicalize_depth2!(depth2_buffer, depth2, graph, colors)
    canonicalize_recursive_stabilizers!(recursive_buffer, recursive, graph, colors)
    recursive_assert_equal(name, base_buffer, depth2_buffer, n, "depth2")
    recursive_assert_equal(name, base_buffer, recursive_buffer, n, "recursive")

    base_trial = @benchmark GC.canonicalize_directed_packed!(
        $base_buffer, $base_workspace, $graph, $colors
    ) samples = 160 seconds = 1 evals = 1
    depth2_trial = @benchmark canonicalize_depth2!($depth2_buffer, $depth2, $graph, $colors) samples =
        160 seconds = 1 evals = 1
    recursive_trial = @benchmark canonicalize_recursive_stabilizers!(
        $recursive_buffer, $recursive, $graph, $colors
    ) samples = 160 seconds = 1 evals = 1

    base_estimate = minimum(base_trial)
    depth2_estimate = minimum(depth2_trial)
    recursive_estimate = minimum(recursive_trial)
    println(
        "RECURSIVE|",
        name,
        "|",
        recursive_estimate.time / base_estimate.time,
        "|",
        recursive_estimate.time / depth2_estimate.time,
        "|",
        base_workspace.workspace.search_nodes,
        "|",
        depth2.packed.workspace.search_nodes,
        "|",
        recursive.packed.workspace.search_nodes,
        "|",
        base_workspace.workspace.search_leaves,
        "|",
        depth2.packed.workspace.search_leaves,
        "|",
        recursive.packed.workspace.search_leaves,
        "|",
        recursive.total_orbit_skips,
        "|",
        recursive.total_orbit_merges,
        "|",
        recursive.total_automorphisms,
        "|",
        recursive_estimate.memory,
        "|",
        recursive_estimate.allocs,
    )
    return nothing
end

recursive_fixtures = (
    ("two-cycles-7x13", recursive_colored_cycle_product((7, 13))...),
    ("three-cycles-5x7x11", recursive_colored_cycle_product((5, 7, 11))...),
    ("three-cycles-7x11x13", recursive_colored_cycle_product((7, 11, 13))...),
    (
        "anchored-three-cycles-7x11x13",
        recursive_colored_cycle_product((7, 11, 13); anchor=true)...,
    ),
    ("four-cycles-5x7x11x13", recursive_colored_cycle_product((5, 7, 11, 13))...),
    (
        "three-circulants-7x11x13",
        recursive_colored_circulant_product(((7, (1, 3)), (11, (1, 4)), (13, (1, 5))))...,
    ),
    (
        "four-circulants-5x7x11x13",
        recursive_colored_circulant_product((
            (5, (1, 2)), (7, (1, 3)), (11, (1, 4)), (13, (1, 5))
        ))...,
    ),
)

println("RECURSIVE-STABILIZER-FIXTURES")
for (name, graph, colors) in recursive_fixtures
    benchmark_recursive_fixture(name, graph, colors)
end
