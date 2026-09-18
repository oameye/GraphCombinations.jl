using BenchmarkTools
import GraphCombinations as GC
include(joinpath(@__DIR__, "packed_recursive_stabilizer_orbits.jl"))

function easy_directed_cycle(n::Int)
    return GC.DirectedGCGraph([v => mod1(v + 1, n) for v in 1:n], n), ones(Int, n)
end

function easy_bidirectional_cycle(n::Int)
    edges = Pair{Int,Int}[]
    for v in 1:n
        w = mod1(v + 1, n)
        push!(edges, v => w)
        push!(edges, w => v)
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function easy_circulant(n::Int, offsets::Tuple{Vararg{Int}})
    edges = Pair{Int,Int}[]
    for source in 1:n, offset in offsets
        push!(edges, source => mod1(source + offset, n))
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function easy_fixed_star(n::Int)
    edges = Pair{Int,Int}[]
    for leaf in 2:n
        push!(edges, 1 => leaf)
        push!(edges, leaf => 1)
    end
    colors = ones(Int, n)
    colors[1] = 2
    return GC.DirectedGCGraph(edges, n), colors
end

function easy_paired_color_cycle(num_cells::Int)
    n = 2 * num_cells
    edges = Pair{Int,Int}[]
    for cell in 1:num_cells
        next_cell = mod1(cell + 1, num_cells)
        current = (2 * cell - 1, 2 * cell)
        following = (2 * next_cell - 1, 2 * next_cell)
        for source in current, target in following
            push!(edges, source => target)
        end
    end
    colors = repeat(collect(1:num_cells); inner=2)
    return GC.DirectedGCGraph(edges, n), colors
end

function easy_almost_discrete(n::Int)
    graph, _ = easy_circulant(n, (1, 5, 11))
    colors = collect(1:n)
    colors[n] = n - 1
    return graph, colors
end

function assert_easy_equal(
    name::String,
    base::GC.DirectedCanonicalizationBuffer,
    candidate::GC.DirectedCanonicalizationBuffer,
    n::Int,
)
    @views base.canonical_multiplicities[1:(n * n)] ==
           candidate.canonical_multiplicities[1:(n * n)] ||
        error("canonical image mismatch for $name")
    @views base.old_to_canonical[1:n] == candidate.old_to_canonical[1:n] ||
        error("canonical witness mismatch for $name")
    @views base.canonical_to_old[1:n] == candidate.canonical_to_old[1:n] ||
        error("inverse witness mismatch for $name")
    base.automorphism_order == candidate.automorphism_order ||
        error("automorphism-order mismatch for $name")
    return nothing
end

function benchmark_easy_fixture(name::String, graph::GC.DirectedGCGraph, colors::Vector{Int})
    n = graph.num_vertices
    base_workspace = GC.PackedDirectedCanonicalizationWorkspace(n)
    base_buffer = GC.DirectedCanonicalizationBuffer(n)
    recursive_workspace = RecursiveStabilizerWorkspace(n)
    recursive_buffer = GC.DirectedCanonicalizationBuffer(n)

    GC.canonicalize_directed_packed!(base_buffer, base_workspace, graph, colors)
    canonicalize_recursive_stabilizers!(
        recursive_buffer, recursive_workspace, graph, colors
    )
    assert_easy_equal(name, base_buffer, recursive_buffer, n)

    base_trial = @benchmark GC.canonicalize_directed_packed!(
        $base_buffer, $base_workspace, $graph, $colors
    ) samples = 250 seconds = 1 evals = 1
    recursive_trial = @benchmark canonicalize_recursive_stabilizers!(
        $recursive_buffer, $recursive_workspace, $graph, $colors
    ) samples = 250 seconds = 1 evals = 1

    base_estimate = minimum(base_trial)
    recursive_estimate = minimum(recursive_trial)
    println(
        "EASY|",
        name,
        "|",
        recursive_estimate.time / base_estimate.time,
        "|",
        base_workspace.workspace.search_nodes,
        "|",
        recursive_workspace.packed.workspace.search_nodes,
        "|",
        base_workspace.workspace.search_leaves,
        "|",
        recursive_workspace.packed.workspace.search_leaves,
        "|",
        recursive_estimate.memory,
        "|",
        recursive_estimate.allocs,
    )
    return nothing
end

easy_fixtures = (
    ("cycle-15", easy_directed_cycle(15)...),
    ("bidirectional-cycle-15", easy_bidirectional_cycle(15)...),
    ("fixed-star-12", easy_fixed_star(12)...),
    ("paired-color-cycle-12", easy_paired_color_cycle(6)...),
    ("paired-color-cycle-24", easy_paired_color_cycle(12)...),
    ("circulant-24", easy_circulant(24, (1, 5, 7))...),
    ("circulant-40", easy_circulant(40, (1, 7, 13))...),
    ("almost-discrete-40", easy_almost_discrete(40)...),
)

for (name, graph, colors) in easy_fixtures
    benchmark_easy_fixture(name, graph, colors)
end
