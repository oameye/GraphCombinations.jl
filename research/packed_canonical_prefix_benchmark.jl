using BenchmarkTools
import GraphCombinations as GC

function directed_cycle(n::Int)
    return GC.DirectedGCGraph([v => mod1(v + 1, n) for v in 1:n], n), ones(Int, n)
end

function bidirectional_cycle(n::Int)
    edges = Pair{Int,Int}[]
    for v in 1:n
        w = mod1(v + 1, n)
        push!(edges, v => w)
        push!(edges, w => v)
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function fixed_star(n::Int)
    edges = Pair{Int,Int}[]
    for leaf in 2:n
        push!(edges, 1 => leaf)
        push!(edges, leaf => 1)
    end
    colors = ones(Int, n)
    colors[1] = 2
    return GC.DirectedGCGraph(edges, n), colors
end

function paired_color_cycle(num_cells::Int)
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

function circulant(n::Int, offsets::Tuple{Vararg{Int}})
    edges = Pair{Int,Int}[]
    for source in 1:n, offset in offsets
        push!(edges, source => mod1(source + offset, n))
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function almost_discrete(n::Int)
    graph, _ = circulant(n, (1, 5, 11))
    colors = collect(1:n)
    colors[n - 1] = n - 1
    colors[n] = n - 1
    return graph, colors
end

function two_permutation_regular(permutation::Vector{Int})
    n = length(permutation)
    sort(permutation) == collect(1:n) || error("fixture permutation must be bijective")
    edges = Pair{Int,Int}[]
    for source in 1:n
        first_target = mod1(source + 1, n)
        second_target = permutation[source]
        first_target == second_target && error("fixture contains a repeated edge")
        push!(edges, source => first_target)
        push!(edges, source => second_target)
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function metric(workspace, name::Symbol)
    return hasproperty(workspace, name) ? getproperty(workspace, name) : -1
end

function benchmark_fixture(name::String, graph::GC.DirectedGCGraph, colors::Vector{Int})
    n = graph.num_vertices
    workspace = GC.PackedDirectedCanonicalizationWorkspace(n)
    buffer = GC.DirectedCanonicalizationBuffer(n)
    GC.canonicalize_directed_packed!(buffer, workspace, graph, colors)

    trial = @benchmark GC.canonicalize_directed_packed!(
        $buffer, $workspace, $graph, $colors
    ) samples = 180 seconds = 1 evals = 1
    estimate = minimum(trial)
    search = workspace.workspace
    variant = get(ENV, "GC_VARIANT", "unknown")

    println(
        "RESULT|",
        variant,
        "|",
        name,
        "|",
        n,
        "|",
        estimate.time,
        "|",
        estimate.memory,
        "|",
        estimate.allocs,
        "|",
        search.search_nodes,
        "|",
        search.search_leaves,
        "|",
        search.refinement_rounds,
        "|",
        metric(workspace, :active_splitter_steps),
        "|",
        metric(workspace, :active_cell_splits),
        "|",
        metric(workspace, :canonical_prefix_checks),
        "|",
        metric(workspace, :canonical_prefix_prunes),
    )
    return nothing
end

fixtures = (
    ("cycle-15", directed_cycle(15)...),
    ("bidirectional-cycle-15", bidirectional_cycle(15)...),
    ("fixed-star-12", fixed_star(12)...),
    ("paired-color-cycle-12", paired_color_cycle(6)...),
    ("paired-color-cycle-24", paired_color_cycle(12)...),
    ("circulant-24", circulant(24, (1, 5, 7))...),
    ("circulant-40", circulant(40, (1, 7, 13))...),
    ("almost-discrete-40", almost_discrete(40)...),
    (
        "two-permutation-12",
        two_permutation_regular([4, 7, 10, 1, 12, 2, 9, 5, 3, 6, 11, 8])...,
    ),
    (
        "two-permutation-16",
        two_permutation_regular([5, 9, 13, 1, 7, 12, 16, 4, 14, 3, 8, 15, 6, 11, 2, 10])...,
    ),
)

for (name, graph, colors) in fixtures
    benchmark_fixture(name, graph, colors)
end
