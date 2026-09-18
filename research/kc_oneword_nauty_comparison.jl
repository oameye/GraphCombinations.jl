import GraphCombinations as GC
import NautyGraphs
import Graphs

include(joinpath(@__DIR__, "packed_incremental_child_refinement.jl"))

const Candidate = Main

function bidirected_graph(n::Int, undirected_edges::Vector{Pair{Int,Int}})
    directed = Pair{Int,Int}[]
    for edge in undirected_edges
        u, v = first(edge), last(edge)
        push!(directed, u => v)
        u == v || push!(directed, v => u)
    end
    return GC.DirectedGCGraph(directed, n), directed
end

function cycle_fixture(n::Int)
    edges = Pair{Int,Int}[i => i + 1 for i in 1:(n - 1)]
    push!(edges, 1 => n)
    graph, directed = bidirected_graph(n, edges)
    return graph, directed, ones(Int, n)
end

function complete_fixture(n::Int)
    edges = Pair{Int,Int}[]
    for u in 1:n, v in (u + 1):n
        push!(edges, u => v)
    end
    graph, directed = bidirected_graph(n, edges)
    return graph, directed, ones(Int, n)
end

function empty_fixture(n::Int)
    return GC.DirectedGCGraph(Pair{Int,Int}[], n), Pair{Int,Int}[], ones(Int, n)
end

function complete_bipartite_fixture(left::Int, right::Int)
    n = left + right
    edges = Pair{Int,Int}[]
    for u in 1:left, v in (left + 1):n
        push!(edges, u => v)
    end
    graph, directed = bidirected_graph(n, edges)
    return graph, directed, ones(Int, n)
end

function petersen_fixture()
    edges = Pair{Int,Int}[]
    for vertex in 1:5
        push!(edges, vertex => mod1(vertex + 1, 5))
        push!(edges, vertex => 5 + vertex)
    end
    for vertex in 1:5
        push!(edges, (5 + vertex) => (5 + mod1(vertex + 2, 5)))
    end
    graph, directed = bidirected_graph(10, edges)
    return graph, directed, ones(Int, 10)
end

function triangular_fixture(base_n::Int)
    pairs = Tuple{Int,Int}[]
    for a in 1:base_n, b in (a + 1):base_n
        push!(pairs, (a, b))
    end
    edges = Pair{Int,Int}[]
    for i in eachindex(pairs), j in (i + 1):length(pairs)
        a, b = pairs[i]
        c, d = pairs[j]
        (a == c || a == d || b == c || b == d) && push!(edges, i => j)
    end
    graph, directed = bidirected_graph(length(pairs), edges)
    return graph, directed, ones(Int, length(pairs))
end

function rook_fixture(size::Int)
    n = size * size
    vertex(row, col) = (row - 1) * size + col
    edges = Pair{Int,Int}[]
    for row in 1:size, col in 1:size
        u = vertex(row, col)
        for other_col in (col + 1):size
            push!(edges, u => vertex(row, other_col))
        end
        for other_row in (row + 1):size
            push!(edges, u => vertex(other_row, col))
        end
    end
    graph, directed = bidirected_graph(n, edges)
    return graph, directed, ones(Int, n)
end

function hypercube_fixture(dimension::Int)
    n = 1 << dimension
    edges = Pair{Int,Int}[]
    for u0 in 0:(n - 1), bit in 0:(dimension - 1)
        v0 = u0 ⊻ (1 << bit)
        u0 < v0 || continue
        push!(edges, u0 + 1 => v0 + 1)
    end
    graph, directed = bidirected_graph(n, edges)
    return graph, directed, ones(Int, n)
end

function shrikhande_fixture()
    side = 4
    n = side * side
    vertex(x, y) = mod(x, side) * side + mod(y, side) + 1
    connection = ((1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1))
    seen = Set{Tuple{Int,Int}}()
    edges = Pair{Int,Int}[]
    for x in 0:(side - 1), y in 0:(side - 1)
        u = vertex(x, y)
        for (dx, dy) in connection
            v = vertex(x + dx, y + dy)
            a, b = minmax(u, v)
            a == b && continue
            key = (a, b)
            key in seen && continue
            push!(seen, key)
            push!(edges, a => b)
        end
    end
    graph, directed = bidirected_graph(n, edges)
    return graph, directed, ones(Int, n)
end

function make_nauty_graph(::Type{G}, n::Int, edges, colors) where {G}
    g = G(n; vertex_labels=colors)
    for edge in edges
        Graphs.add_edge!(g, first(edge), last(edge))
    end
    return g
end

mutable struct PreparedDenseNauty{G,O,S,C,L,P,R}
    graph::G
    options::O
    statistics::S
    canong::C
    lab0::L
    ptn0::P
    lab::L
    ptn::P
    orbits::R
end

function PreparedDenseNauty(g::NautyGraphs.DenseNautyGraph)
    lab0, ptn0 = NautyGraphs.vertexlabels2labptn(NautyGraphs.labels(g))
    lab = similar(lab0)
    ptn = similar(ptn0)
    orbits = zeros(Cint, Graphs.nv(g))
    options = NautyGraphs.default_options(g)
    statistics = NautyGraphs.NautyStatistics()
    canong = NautyGraphs.Graphset{NautyGraphs.wordtype(g)}(g.graphset.n, g.graphset.m)
    return PreparedDenseNauty(
        g, options, statistics, canong, lab0, ptn0, lab, ptn, orbits
    )
end

function run_prepared_nauty!(prepared::PreparedDenseNauty)
    copyto!(prepared.lab, prepared.lab0)
    copyto!(prepared.ptn, prepared.ptn0)
    fill!(prepared.orbits, 0)
    NautyGraphs._ccall_nauty(
        prepared.graph,
        prepared.lab,
        prepared.ptn,
        prepared.orbits,
        prepared.options,
        prepared.statistics,
        prepared.canong,
    )
    return nothing
end

function minimum_ns(f, repetitions::Int)
    best = typemax(Int)
    for _ in 1:repetitions
        start = time_ns()
        f()
        best = min(best, Int(time_ns() - start))
    end
    return best
end

function benchmark_fixture(name::String, fixture; repetitions::Int=100)
    graph, edges, colors = fixture
    n = graph.num_vertices
    capacity = max(4096, 16 * max(n, 1)^2)

    gc_workspace = Candidate.PackedLevelwiseIncrementalWorkspace(
        n; frontier_capacity=capacity
    )
    gc_buffer = GC.DirectedCanonicalizationBuffer(n)
    Candidate.canonicalize_levelwise_incremental!(gc_buffer, gc_workspace, graph, colors)

    dense = make_nauty_graph(NautyGraphs.NautyDiGraph, n, edges, colors)
    sparse = make_nauty_graph(NautyGraphs.SpNautyDiGraph, n, edges, colors)

    dense_perm, dense_aut = NautyGraphs.nauty(dense)
    sparse_perm, sparse_aut = NautyGraphs.nauty(sparse)
    dense_order = round(Int, dense_aut.n)
    sparse_order = round(Int, sparse_aut.n)
    dense_order == gc_buffer.automorphism_order ||
        error("dense Nauty order mismatch for $name: $dense_order != $(gc_buffer.automorphism_order)")
    sparse_order == gc_buffer.automorphism_order ||
        error("sparse Nauty order mismatch for $name: $sparse_order != $(gc_buffer.automorphism_order)")
    length(dense_perm) == n || error("dense Nauty witness length mismatch for $name")
    length(sparse_perm) == n || error("sparse Nauty witness length mismatch for $name")

    prepared_dense = PreparedDenseNauty(dense)
    run_prepared_nauty!(prepared_dense)
    prepared_dense.statistics.numnodes > 0 || error("Nauty reported no nodes for $name")

    gc_alloc = @allocated Candidate.canonicalize_levelwise_incremental!(
        gc_buffer, gc_workspace, graph, colors
    )
    dense_full_alloc = @allocated NautyGraphs.nauty(dense)
    sparse_full_alloc = @allocated NautyGraphs.nauty(sparse)
    dense_canon_alloc = @allocated NautyGraphs.canonical_permutation(dense)
    sparse_canon_alloc = @allocated NautyGraphs.canonical_permutation(sparse)
    prepared_alloc = @allocated run_prepared_nauty!(prepared_dense)

    gc_ns = minimum_ns(repetitions) do
        Candidate.canonicalize_levelwise_incremental!(gc_buffer, gc_workspace, graph, colors)
    end
    dense_full_ns = minimum_ns(repetitions) do
        NautyGraphs.nauty(dense)
    end
    sparse_full_ns = minimum_ns(repetitions) do
        NautyGraphs.nauty(sparse)
    end
    dense_canon_ns = minimum_ns(repetitions) do
        NautyGraphs.canonical_permutation(dense)
    end
    sparse_canon_ns = minimum_ns(repetitions) do
        NautyGraphs.canonical_permutation(sparse)
    end
    prepared_ns = minimum_ns(repetitions) do
        run_prepared_nauty!(prepared_dense)
    end

    best_full_ns = min(dense_full_ns, sparse_full_ns)
    best_canon_ns = min(dense_canon_ns, sparse_canon_ns)
    stats = prepared_dense.statistics

    println(
        "NAUTY-COMPARE|", name,
        "|n=", n,
        "|gc_ns=", gc_ns,
        "|gc_alloc=", gc_alloc,
        "|dense_full_ns=", dense_full_ns,
        "|dense_full_alloc=", dense_full_alloc,
        "|sparse_full_ns=", sparse_full_ns,
        "|sparse_full_alloc=", sparse_full_alloc,
        "|best_full_ratio=", round(gc_ns / best_full_ns; digits=3),
        "|dense_canon_ns=", dense_canon_ns,
        "|dense_canon_alloc=", dense_canon_alloc,
        "|sparse_canon_ns=", sparse_canon_ns,
        "|sparse_canon_alloc=", sparse_canon_alloc,
        "|best_canon_ratio=", round(gc_ns / best_canon_ns; digits=3),
        "|prepared_dense_ns=", prepared_ns,
        "|prepared_dense_alloc=", prepared_alloc,
        "|prepared_dense_ratio=", round(gc_ns / prepared_ns; digits=3),
        "|nauty_nodes=", stats.numnodes,
        "|nauty_generators=", stats.numgenerators,
        "|nauty_maxlevel=", stats.maxlevel,
        "|nauty_canupdates=", stats.canupdates,
        "|gc_generated=", gc_workspace.orbit.base.generated_nodes,
        "|gc_paths=", gc_workspace.orbit.base.experimental_paths,
        "|order=", gc_buffer.automorphism_order,
    )
    return nothing
end

println("NAUTY-VERSION|", Base.pkgversion(NautyGraphs))
benchmark_fixture("complete-9", complete_fixture(9); repetitions=50)
benchmark_fixture("empty-9", empty_fixture(9); repetitions=50)
benchmark_fixture("k6-6", complete_bipartite_fixture(6, 6); repetitions=50)
benchmark_fixture("cycle-31", cycle_fixture(31); repetitions=50)
benchmark_fixture("petersen", petersen_fixture())
benchmark_fixture("triangular-6", triangular_fixture(6))
benchmark_fixture("rook-4", rook_fixture(4))
benchmark_fixture("hypercube-5", hypercube_fixture(5); repetitions=50)
benchmark_fixture("shrikhande", shrikhande_fixture())
