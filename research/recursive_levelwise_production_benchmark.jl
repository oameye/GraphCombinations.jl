import GraphCombinations as GC

const RecursiveGC = GC.DirectedRecursive

function production_bench_bidirected(n::Int, undirected_edges::Vector{Pair{Int,Int}})
    directed = Pair{Int,Int}[]
    for edge in undirected_edges
        source = first(edge)
        target = last(edge)
        push!(directed, source => target)
        source == target || push!(directed, target => source)
    end
    return GC.DirectedGCGraph(directed, n)
end

function production_bench_complete(n::Int)
    edges = Pair{Int,Int}[]
    for left in 1:n, right in (left + 1):n
        push!(edges, left => right)
    end
    return production_bench_bidirected(n, edges), ones(Int, n)
end

production_bench_empty(n::Int) = (GC.DirectedGCGraph(Pair{Int,Int}[], n), ones(Int, n))

function production_bench_complete_bipartite(left_size::Int, right_size::Int)
    n = left_size + right_size
    edges = Pair{Int,Int}[]
    for left in 1:left_size, right in (left_size + 1):n
        push!(edges, left => right)
    end
    return production_bench_bidirected(n, edges), ones(Int, n)
end

function production_bench_cycle(n::Int)
    edges = Pair{Int,Int}[]
    for vertex in 1:(n - 1)
        push!(edges, vertex => (vertex + 1))
    end
    push!(edges, 1 => n)
    return production_bench_bidirected(n, edges), ones(Int, n)
end

function production_bench_petersen()
    edges = Pair{Int,Int}[]
    for vertex in 1:5
        push!(edges, vertex => mod1(vertex + 1, 5))
        push!(edges, vertex => (5 + vertex))
    end
    for vertex in 1:5
        push!(edges, (5 + vertex) => (5 + mod1(vertex + 2, 5)))
    end
    return production_bench_bidirected(10, edges), ones(Int, 10)
end

function production_bench_triangular(base_n::Int)
    pairs = Tuple{Int,Int}[]
    for left in 1:base_n, right in (left + 1):base_n
        push!(pairs, (left, right))
    end
    n = length(pairs)
    edges = Pair{Int,Int}[]
    for left in 1:n, right in (left + 1):n
        a, b = pairs[left]
        c, d = pairs[right]
        if a == c || a == d || b == c || b == d
            push!(edges, left => right)
        end
    end
    return production_bench_bidirected(n, edges), ones(Int, n)
end

function production_bench_rook(size::Int)
    n = size * size
    edges = Pair{Int,Int}[]
    vertex(row, column) = (row - 1) * size + column
    for row in 1:size, column in 1:size
        source = vertex(row, column)
        for other_column in (column + 1):size
            push!(edges, source => vertex(row, other_column))
        end
        for other_row in (row + 1):size
            push!(edges, source => vertex(other_row, column))
        end
    end
    return production_bench_bidirected(n, edges), ones(Int, n)
end

function production_bench_hypercube(dimension::Int)
    n = 1 << dimension
    edges = Pair{Int,Int}[]
    for zero_vertex in 0:(n - 1)
        for bit in 0:(dimension - 1)
            neighbor = zero_vertex ⊻ (1 << bit)
            zero_vertex < neighbor || continue
            push!(edges, (zero_vertex + 1) => (neighbor + 1))
        end
    end
    return production_bench_bidirected(n, edges), ones(Int, n)
end

function production_bench_paley13()
    p = 13
    residues = Set((1, 3, 4, 9, 10, 12))
    edges = Pair{Int,Int}[]
    for zero_left in 0:(p - 1), zero_right in (zero_left + 1):(p - 1)
        difference = mod(zero_right - zero_left, p)
        difference in residues && push!(edges, (zero_left + 1) => (zero_right + 1))
    end
    return production_bench_bidirected(p, edges), ones(Int, p)
end

function production_bench_shrikhande()
    size = 4
    n = size * size
    vertex(x, y) = mod(x, size) * size + mod(y, size) + 1
    connection = ((1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1))
    seen = Set{Tuple{Int,Int}}()
    edges = Pair{Int,Int}[]
    for x in 0:(size - 1), y in 0:(size - 1)
        source = vertex(x, y)
        for (dx, dy) in connection
            target = vertex(x + dx, y + dy)
            left, right = minmax(source, target)
            left == right && continue
            key = (left, right)
            key in seen && continue
            push!(seen, key)
            push!(edges, left => right)
        end
    end
    return production_bench_bidirected(n, edges), ones(Int, n)
end

function production_bench_repeated_directed_cycles(count::Int, size::Int)
    n = count * size
    edges = Pair{Int,Int}[]
    for component in 0:(count - 1)
        offset = component * size
        for local_vertex in 1:size
            push!(edges, (offset + local_vertex) => (offset + mod1(local_vertex + 1, size)))
        end
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function production_bench_deterministic_asymmetric(n::Int)
    edges = Pair{Int,Int}[]
    for source in 1:n, target in 1:n
        source == target && continue
        value = mod(37source + 53target + 7source * target + 11source^2 + 3target^2, 97)
        value < 18 && push!(edges, source => target)
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function production_minimum_levelwise_ns(
    buffer::GC.DirectedCanonicalizationBuffer,
    workspace::GC.DirectedSimpleCanonicalizationWorkspace,
    graph::GC.DirectedGCGraph,
    colors::Vector{Int},
    repetitions::Int,
)::Int
    best = typemax(Int)
    for _ in 1:repetitions
        start = time_ns()
        GC.canonicalize_directed_simple!(buffer, workspace, graph, colors)
        best = min(best, Int(time_ns() - start))
    end
    return best
end

function production_minimum_recursive_ns(
    buffer::GC.DirectedCanonicalizationBuffer,
    workspace::RecursiveGC.PackedRecursiveStabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    colors::Vector{Int},
    repetitions::Int,
)::Int
    best = typemax(Int)
    for _ in 1:repetitions
        start = time_ns()
        RecursiveGC.canonicalize_recursive_stabilizers!(buffer, workspace, graph, colors)
        best = min(best, Int(time_ns() - start))
    end
    return best
end

function run_production_crossover_benchmark(
    name::String, graph::GC.DirectedGCGraph, colors::Vector{Int}; repetitions::Int=40
)::Nothing
    n = graph.num_vertices
    level_buffer = GC.DirectedCanonicalizationBuffer(n)
    recursive_buffer = GC.DirectedCanonicalizationBuffer(n)
    frontier_capacity = max(4096, 16 * max(n, 1)^2)
    level = GC.DirectedSimpleCanonicalizationWorkspace(n; frontier_capacity)
    recursive = RecursiveGC.PackedRecursiveStabilizerWorkspace(n)

    GC.canonicalize_directed_simple!(level_buffer, level, graph, colors)
    RecursiveGC.canonicalize_recursive_stabilizers!(
        recursive_buffer, recursive, graph, colors
    )
    level_buffer.canonical_multiplicities[1:(n * n)] ==
    recursive_buffer.canonical_multiplicities[1:(n * n)] ||
        error("canonical image mismatch for $name")
    level_buffer.old_to_canonical[1:n] == recursive_buffer.old_to_canonical[1:n] ||
        error("canonical witness mismatch for $name")
    level_buffer.automorphism_order == recursive_buffer.automorphism_order ||
        error("automorphism-order mismatch for $name")

    level_alloc = @allocated GC.canonicalize_directed_simple!(
        level_buffer, level, graph, colors
    )
    recursive_alloc = @allocated RecursiveGC.canonicalize_recursive_stabilizers!(
        recursive_buffer, recursive, graph, colors
    )
    iszero(level_alloc) || error("levelwise allocated $level_alloc bytes for $name")
    iszero(recursive_alloc) || error("recursive allocated $recursive_alloc bytes for $name")

    level_ns = production_minimum_levelwise_ns(
        level_buffer, level, graph, colors, repetitions
    )
    recursive_ns = production_minimum_recursive_ns(
        recursive_buffer, recursive, graph, colors, repetitions
    )
    level_stats = level.orbit.base

    println(
        "PRODUCTION-CROSSOVER|",
        name,
        "|n=",
        n,
        "|level_ns=",
        level_ns,
        "|recursive_ns=",
        recursive_ns,
        "|level_over_recursive=",
        round(level_ns / recursive_ns; digits=3),
        "|level_alloc=",
        level_alloc,
        "|recursive_alloc=",
        recursive_alloc,
        "|level_generated=",
        level_stats.generated_nodes,
        "|level_retained=",
        level_stats.retained_nodes,
        "|level_paths=",
        level_stats.experimental_paths,
        "|level_quotient_discards=",
        level_stats.quotient_discards,
        "|recursive_nodes=",
        recursive.packed.workspace.search_nodes,
        "|recursive_leaves=",
        recursive.packed.workspace.search_leaves,
        "|recursive_orbit_skips=",
        recursive.total_orbit_skips,
        "|recursive_automorphisms=",
        recursive.total_automorphisms,
    )
    return nothing
end

function run_production_fixture(
    name::String, fixture::Tuple{GC.DirectedGCGraph,Vector{Int}}; repetitions::Int=40
)::Nothing
    graph, colors = fixture
    run_production_crossover_benchmark(name, graph, colors; repetitions)
    return nothing
end

run_production_fixture("complete-9", production_bench_complete(9))
run_production_fixture("empty-9", production_bench_empty(9))
run_production_fixture("k6-6", production_bench_complete_bipartite(6, 6))
run_production_fixture("cycle-31", production_bench_cycle(31); repetitions=20)
run_production_fixture("petersen", production_bench_petersen())
run_production_fixture("triangular-6", production_bench_triangular(6))
run_production_fixture("rook-4", production_bench_rook(4))
run_production_fixture("hypercube-5", production_bench_hypercube(5); repetitions=20)
run_production_fixture("paley-13", production_bench_paley13())
run_production_fixture("shrikhande", production_bench_shrikhande())
run_production_fixture(
    "repeated-directed-c7x4",
    production_bench_repeated_directed_cycles(4, 7);
    repetitions=20,
)
run_production_fixture(
    "asymmetric-24", production_bench_deterministic_asymmetric(24); repetitions=20
)
