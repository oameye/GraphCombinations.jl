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

function benchmark_fixture(name::String, graph::GC.DirectedGCGraph, colors::Vector{Int})
    n = graph.num_vertices
    workspace = GC.PackedDirectedCanonicalizationWorkspace(n)
    buffer = GC.DirectedCanonicalizationBuffer(n)
    GC.canonicalize_directed_packed!(buffer, workspace, graph, colors)

    trial = @benchmark GC.canonicalize_directed_packed!(
        $buffer, $workspace, $graph, $colors
    ) samples = 250 seconds = 1 evals = 1
    estimate = minimum(trial)
    search = workspace.workspace
    active_steps = hasproperty(workspace, :active_splitter_steps) ?
        getproperty(workspace, :active_splitter_steps) : -1
    active_splits = hasproperty(workspace, :active_cell_splits) ?
        getproperty(workspace, :active_cell_splits) : -1
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
        active_steps,
        "|",
        active_splits,
    )
    return nothing
end

fixtures = (
    ("cycle-15", directed_cycle(15)...),
    ("bidirectional-cycle-15", bidirectional_cycle(15)...),
    ("fixed-star-24", fixed_star(24)...),
    ("paired-color-cycle-12", paired_color_cycle(6)...),
    ("paired-color-cycle-24", paired_color_cycle(12)...),
    ("circulant-24", circulant(24, (1, 5, 7))...),
    ("circulant-40", circulant(40, (1, 7, 13))...),
    ("almost-discrete-40", almost_discrete(40)...),
)

for (name, graph, colors) in fixtures
    benchmark_fixture(name, graph, colors)
end
