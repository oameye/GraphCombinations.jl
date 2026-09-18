using BenchmarkTools
import GraphCombinations as GC

const POLICIES = (:smallest, :first, :connectivity)

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

function isolated_twins_plus_cycle(cycle_size::Int)
    n = cycle_size + 2
    edges = Pair{Int,Int}[]
    for offset in 1:cycle_size
        source = 2 + offset
        target = 2 + mod1(offset + 1, cycle_size)
        push!(edges, source => target)
    end
    colors = vcat(fill(1, 2), fill(2, cycle_size))
    return GC.DirectedGCGraph(edges, n), colors
end

function biregular_choice()
    a = 1:4
    b = 5:10
    c = 11:16
    edges = Pair{Int,Int}[]

    for t in 0:11
        av = first(a) + mod(t, length(a))
        bv = first(b) + mod(t, length(b))
        push!(edges, av => bv)
        push!(edges, bv => av)
    end
    for j in 0:5
        bv = first(b) + j
        cv = first(c) + j
        cv_next = first(c) + mod(j + 1, length(c))
        push!(edges, bv => cv)
        push!(edges, bv => cv_next)
        push!(edges, cv => bv)
        push!(edges, cv_next => bv)
    end

    colors = vcat(fill(1, length(a)), fill(2, length(b)), fill(3, length(c)))
    return GC.DirectedGCGraph(edges, 16), colors
end

function benchmark_policy(
    name::String, graph::GC.DirectedGCGraph, colors::Vector{Int}, policy::Symbol
)
    n = graph.num_vertices
    workspace = GC.PackedDirectedCanonicalizationWorkspace(n; target_policy=policy)
    buffer = GC.DirectedCanonicalizationBuffer(n)
    GC.canonicalize_directed_packed!(buffer, workspace, graph, colors)

    trial = @benchmark GC.canonicalize_directed_packed!(
        $buffer, $workspace, $graph, $colors
    ) samples = 250 seconds = 1 evals = 1
    estimate = minimum(trial)
    search = workspace.workspace

    println(
        "RESULT|",
        name,
        "|",
        policy,
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
        workspace.active_splitter_steps,
        "|",
        workspace.active_cell_splits,
    )
    return copy(buffer.canonical_multiplicities[1:(n * n)]), buffer.automorphism_order
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
    ("isolated-twins-cycle-10", isolated_twins_plus_cycle(10)...),
    ("biregular-choice", biregular_choice()...),
)

for (name, graph, colors) in fixtures
    reference_image = nothing
    reference_order = 0
    for policy in POLICIES
        image, order = benchmark_policy(name, graph, colors, policy)
        if reference_image === nothing
            reference_image = image
            reference_order = order
        else
            @assert image == reference_image
            @assert order == reference_order
        end
    end
end
