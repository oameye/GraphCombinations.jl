import GraphCombinations as GC
import NautyGraphs
using Graphs

module ExternalLevelwise
include(joinpath(@__DIR__, "packed_levelwise_workspace.jl"))
end

module ExternalDFS
include(joinpath(@__DIR__, "packed_recursive_stabilizer_orbits.jl"))
end

function external_bidirected(n::Int, undirected_edges::Vector{Pair{Int,Int}})
    directed = Pair{Int,Int}[]
    for edge in undirected_edges
        source = first(edge)
        target = last(edge)
        push!(directed, source => target)
        source == target || push!(directed, target => source)
    end
    return GC.DirectedGCGraph(directed, n)
end

function fixture_complete(n::Int)
    edges = Pair{Int,Int}[]
    for left in 1:n, right in (left + 1):n
        push!(edges, left => right)
    end
    return external_bidirected(n, edges), ones(Int, n)
end

fixture_empty(n::Int) = (GC.DirectedGCGraph(Pair{Int,Int}[], n), ones(Int, n))

function fixture_complete_bipartite(left_size::Int, right_size::Int)
    n = left_size + right_size
    edges = Pair{Int,Int}[]
    for left in 1:left_size, right in (left_size + 1):n
        push!(edges, left => right)
    end
    return external_bidirected(n, edges), ones(Int, n)
end

function fixture_cycle(n::Int)
    edges = Pair{Int,Int}[]
    for vertex in 1:(n - 1)
        push!(edges, vertex => (vertex + 1))
    end
    push!(edges, 1 => n)
    return external_bidirected(n, edges), ones(Int, n)
end

function fixture_petersen()
    edges = Pair{Int,Int}[]
    for vertex in 1:5
        push!(edges, vertex => mod1(vertex + 1, 5))
        push!(edges, vertex => (5 + vertex))
    end
    for vertex in 1:5
        push!(edges, (5 + vertex) => (5 + mod1(vertex + 2, 5)))
    end
    return external_bidirected(10, edges), ones(Int, 10)
end

function fixture_triangular(base_n::Int)
    pairs = Tuple{Int,Int}[]
    for left in 1:base_n, right in (left + 1):base_n
        push!(pairs, (left, right))
    end
    n = length(pairs)
    edges = Pair{Int,Int}[]
    for left in 1:n, right in (left + 1):n
        a, b = pairs[left]
        c, d = pairs[right]
        (a == c || a == d || b == c || b == d) && push!(edges, left => right)
    end
    return external_bidirected(n, edges), ones(Int, n)
end

function fixture_rook(size::Int)
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
    return external_bidirected(n, edges), ones(Int, n)
end

function fixture_hypercube(dimension::Int)
    n = 1 << dimension
    edges = Pair{Int,Int}[]
    for zero_vertex in 0:(n - 1)
        for bit in 0:(dimension - 1)
            neighbor = zero_vertex ⊻ (1 << bit)
            zero_vertex < neighbor || continue
            push!(edges, (zero_vertex + 1) => (neighbor + 1))
        end
    end
    return external_bidirected(n, edges), ones(Int, n)
end

function fixture_paley13()
    p = 13
    residues = Set((1, 3, 4, 9, 10, 12))
    edges = Pair{Int,Int}[]
    for zero_left in 0:(p - 1), zero_right in (zero_left + 1):(p - 1)
        mod(zero_right - zero_left, p) in residues &&
            push!(edges, (zero_left + 1) => (zero_right + 1))
    end
    return external_bidirected(p, edges), ones(Int, p)
end

function fixture_shrikhande()
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
    return external_bidirected(n, edges), ones(Int, n)
end

function fixture_repeated_directed_cycles(count::Int, size::Int)
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

function fixture_asymmetric(n::Int)
    edges = Pair{Int,Int}[]
    for source in 1:n, target in 1:n
        source == target && continue
        value = mod(37source + 53target + 7source * target + 11source^2 + 3target^2, 97)
        value < 18 && push!(edges, source => target)
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function to_nauty(::Type{T}, graph::GC.DirectedGCGraph, colors::Vector{Int}) where {T}
    n = graph.num_vertices
    result = T(n; vertex_labels=colors)
    @inbounds for source in 1:n, target in 1:n
        graph.multiplicities[GC._directed_slot(source, target, n)] == 0 && continue
        add_edge!(result, source, target)
    end
    return result
end

function minimum_call_ns(f, repetitions::Int)::Int
    best = typemax(Int)
    for _ in 1:repetitions
        start = time_ns()
        f()
        best = min(best, Int(time_ns() - start))
    end
    return best
end

function run_external_benchmark(name::String, fixture; repetitions::Int=40)
    graph, colors = fixture
    n = graph.num_vertices

    dfs_workspace = ExternalDFS.RecursiveStabilizerWorkspace(n)
    dfs_buffer = GC.DirectedCanonicalizationBuffer(n)
    level_workspace = ExternalLevelwise.PackedLevelwiseWorkspace(
        n; frontier_capacity=max(4096, 16 * max(n, 1)^2)
    )
    level_buffer = GC.DirectedCanonicalizationBuffer(n)

    ExternalDFS.canonicalize_recursive_stabilizers!(
        dfs_buffer, dfs_workspace, graph, colors
    )
    ExternalLevelwise.canonicalize_levelwise_workspace!(
        level_buffer, level_workspace, graph, colors
    )
    dfs_buffer.automorphism_order == level_buffer.automorphism_order ||
        error("GC exact-order disagreement for $name")

    dense = to_nauty(NautyGraphs.NautyDiGraph, graph, colors)
    sparse = to_nauty(NautyGraphs.SpNautyDiGraph, graph, colors)
    dense_buffer = NautyGraphs.NautyBuffer(dense)
    sparse_buffer = NautyGraphs.NautyBuffer(sparse)

    _, dense_exact_group = NautyGraphs.nauty(
        dense; exact_order=true, buffer=dense_buffer
    )
    _, sparse_exact_group = NautyGraphs.nauty(
        sparse; exact_order=true, buffer=sparse_buffer
    )
    BigInt(dfs_buffer.automorphism_order) == NautyGraphs.order(dense_exact_group) ||
        error("dense Nauty exact-order disagreement for $name")
    BigInt(dfs_buffer.automorphism_order) == NautyGraphs.order(sparse_exact_group) ||
        error("sparse Nauty exact-order disagreement for $name")

    ExternalDFS.canonicalize_recursive_stabilizers!(dfs_buffer, dfs_workspace, graph, colors)
    ExternalLevelwise.canonicalize_levelwise_workspace!(level_buffer, level_workspace, graph, colors)
    NautyGraphs.nauty(dense; exact_order=true, buffer=dense_buffer)
    NautyGraphs.nauty(sparse; exact_order=true, buffer=sparse_buffer)
    NautyGraphs.nauty(dense; buffer=dense_buffer)
    NautyGraphs.nauty(sparse; buffer=sparse_buffer)

    dfs_alloc = @allocated ExternalDFS.canonicalize_recursive_stabilizers!(
        dfs_buffer, dfs_workspace, graph, colors
    )
    level_alloc = @allocated ExternalLevelwise.canonicalize_levelwise_workspace!(
        level_buffer, level_workspace, graph, colors
    )
    dense_exact_alloc = @allocated NautyGraphs.nauty(
        dense; exact_order=true, buffer=dense_buffer
    )
    sparse_exact_alloc = @allocated NautyGraphs.nauty(
        sparse; exact_order=true, buffer=sparse_buffer
    )
    dense_default_alloc = @allocated NautyGraphs.nauty(dense; buffer=dense_buffer)
    sparse_default_alloc = @allocated NautyGraphs.nauty(sparse; buffer=sparse_buffer)

    dfs_ns = minimum_call_ns(repetitions) do
        ExternalDFS.canonicalize_recursive_stabilizers!(
            dfs_buffer, dfs_workspace, graph, colors
        )
    end
    level_ns = minimum_call_ns(repetitions) do
        ExternalLevelwise.canonicalize_levelwise_workspace!(
            level_buffer, level_workspace, graph, colors
        )
    end
    dense_exact_ns = minimum_call_ns(repetitions) do
        NautyGraphs.nauty(dense; exact_order=true, buffer=dense_buffer)
    end
    sparse_exact_ns = minimum_call_ns(repetitions) do
        NautyGraphs.nauty(sparse; exact_order=true, buffer=sparse_buffer)
    end
    dense_default_ns = minimum_call_ns(repetitions) do
        NautyGraphs.nauty(dense; buffer=dense_buffer)
    end
    sparse_default_ns = minimum_call_ns(repetitions) do
        NautyGraphs.nauty(sparse; buffer=sparse_buffer)
    end

    best_gc = min(dfs_ns, level_ns)
    best_nauty_exact = min(dense_exact_ns, sparse_exact_ns)
    best_nauty_default = min(dense_default_ns, sparse_default_ns)
    gc_kernel = level_ns < dfs_ns ? "levelwise" : "dfs"
    exact_backend = sparse_exact_ns < dense_exact_ns ? "sparse" : "dense"
    default_backend = sparse_default_ns < dense_default_ns ? "sparse" : "dense"

    println(
        "EXTERNAL|", name,
        "|n=", n,
        "|order=", dfs_buffer.automorphism_order,
        "|gc_kernel=", gc_kernel,
        "|gc_ns=", best_gc,
        "|dfs_ns=", dfs_ns,
        "|level_ns=", level_ns,
        "|nauty_exact_backend=", exact_backend,
        "|nauty_exact_ns=", best_nauty_exact,
        "|nauty_default_backend=", default_backend,
        "|nauty_default_ns=", best_nauty_default,
        "|gc_over_nauty_exact=", round(best_gc / best_nauty_exact; digits=3),
        "|gc_over_nauty_default=", round(best_gc / best_nauty_default; digits=3),
        "|dfs_alloc=", dfs_alloc,
        "|level_alloc=", level_alloc,
        "|dense_exact_alloc=", dense_exact_alloc,
        "|sparse_exact_alloc=", sparse_exact_alloc,
        "|dense_default_alloc=", dense_default_alloc,
        "|sparse_default_alloc=", sparse_default_alloc,
    )
    return nothing
end

run_external_benchmark("complete-9", fixture_complete(9))
run_external_benchmark("empty-9", fixture_empty(9))
run_external_benchmark("k6-6", fixture_complete_bipartite(6, 6))
run_external_benchmark("cycle-31", fixture_cycle(31); repetitions=20)
run_external_benchmark("petersen", fixture_petersen())
run_external_benchmark("triangular-6", fixture_triangular(6))
run_external_benchmark("rook-4", fixture_rook(4))
run_external_benchmark("hypercube-5", fixture_hypercube(5); repetitions=20)
run_external_benchmark("paley-13", fixture_paley13())
run_external_benchmark("shrikhande", fixture_shrikhande())
run_external_benchmark("repeated-directed-c7x4", fixture_repeated_directed_cycles(4, 7); repetitions=20)
run_external_benchmark("asymmetric-24", fixture_asymmetric(24); repetitions=20)
