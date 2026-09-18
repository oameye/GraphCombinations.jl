import GraphCombinations as GC

module WorkspaceCandidate
include(joinpath(@__DIR__, "packed_levelwise_workspace.jl"))
end

module WorkspaceDFS
include(joinpath(@__DIR__, "packed_recursive_stabilizer_orbits.jl"))
end

function bench_bidirected(n::Int, undirected_edges::Vector{Pair{Int,Int}})
    directed = Pair{Int,Int}[]
    for edge in undirected_edges
        source = first(edge)
        target = last(edge)
        push!(directed, source => target)
        source == target || push!(directed, target => source)
    end
    return GC.DirectedGCGraph(directed, n)
end

function bench_complete(n::Int)
    edges = Pair{Int,Int}[]
    for left in 1:n, right in (left + 1):n
        push!(edges, left => right)
    end
    return bench_bidirected(n, edges), ones(Int, n)
end

bench_empty(n::Int) = (GC.DirectedGCGraph(Pair{Int,Int}[], n), ones(Int, n))

function bench_complete_bipartite(left_size::Int, right_size::Int)
    n = left_size + right_size
    edges = Pair{Int,Int}[]
    for left in 1:left_size, right in (left_size + 1):n
        push!(edges, left => right)
    end
    return bench_bidirected(n, edges), ones(Int, n)
end

function bench_cycle(n::Int)
    edges = Pair{Int,Int}[]
    for vertex in 1:(n - 1)
        push!(edges, vertex => (vertex + 1))
    end
    push!(edges, 1 => n)
    return bench_bidirected(n, edges), ones(Int, n)
end

function bench_petersen()
    edges = Pair{Int,Int}[]
    for vertex in 1:5
        push!(edges, vertex => mod1(vertex + 1, 5))
        push!(edges, vertex => (5 + vertex))
    end
    for vertex in 1:5
        push!(edges, (5 + vertex) => (5 + mod1(vertex + 2, 5)))
    end
    return bench_bidirected(10, edges), ones(Int, 10)
end

function bench_triangular(base_n::Int)
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
    return bench_bidirected(n, edges), ones(Int, n)
end

function bench_rook(size::Int)
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
    return bench_bidirected(n, edges), ones(Int, n)
end

function bench_hypercube(dimension::Int)
    n = 1 << dimension
    edges = Pair{Int,Int}[]
    for zero_vertex in 0:(n - 1)
        for bit in 0:(dimension - 1)
            neighbor = zero_vertex ⊻ (1 << bit)
            zero_vertex < neighbor || continue
            push!(edges, (zero_vertex + 1) => (neighbor + 1))
        end
    end
    return bench_bidirected(n, edges), ones(Int, n)
end

function bench_paley13()
    p = 13
    residues = Set((1, 3, 4, 9, 10, 12))
    edges = Pair{Int,Int}[]
    for zero_left in 0:(p - 1), zero_right in (zero_left + 1):(p - 1)
        difference = mod(zero_right - zero_left, p)
        difference in residues && push!(edges, (zero_left + 1) => (zero_right + 1))
    end
    return bench_bidirected(p, edges), ones(Int, p)
end

function bench_shrikhande()
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
    return bench_bidirected(n, edges), ones(Int, n)
end

function bench_repeated_directed_cycles(count::Int, size::Int)
    n = count * size
    edges = Pair{Int,Int}[]
    for component in 0:(count - 1)
        offset = component * size
        for local_vertex in 1:size
            push!(
                edges,
                (offset + local_vertex) => (offset + mod1(local_vertex + 1, size)),
            )
        end
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function bench_deterministic_asymmetric(n::Int)
    edges = Pair{Int,Int}[]
    for source in 1:n, target in 1:n
        source == target && continue
        value = mod(37source + 53target + 7source * target + 11source^2 + 3target^2, 97)
        value < 18 && push!(edges, source => target)
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function minimum_levelwise_ns(
    buffer::GC.DirectedCanonicalizationBuffer,
    workspace::WorkspaceCandidate.PackedLevelwiseWorkspace,
    graph::GC.DirectedGCGraph,
    colors::Vector{Int},
    repetitions::Int,
)::Int
    best = typemax(Int)
    for _ in 1:repetitions
        start = time_ns()
        WorkspaceCandidate.canonicalize_levelwise_workspace!(
            buffer, workspace, graph, colors
        )
        elapsed = Int(time_ns() - start)
        best = min(best, elapsed)
    end
    return best
end

function minimum_dfs_ns(
    buffer::GC.DirectedCanonicalizationBuffer,
    workspace::WorkspaceDFS.RecursiveStabilizerWorkspace,
    graph::GC.DirectedGCGraph,
    colors::Vector{Int},
    repetitions::Int,
)::Int
    best = typemax(Int)
    for _ in 1:repetitions
        start = time_ns()
        WorkspaceDFS.canonicalize_recursive_stabilizers!(buffer, workspace, graph, colors)
        elapsed = Int(time_ns() - start)
        best = min(best, elapsed)
    end
    return best
end

function run_workspace_benchmark(
    name::String,
    graph::GC.DirectedGCGraph,
    colors::Vector{Int};
    repetitions::Int=40,
)::Nothing
    n = graph.num_vertices
    level_buffer = GC.DirectedCanonicalizationBuffer(n)
    dfs_buffer = GC.DirectedCanonicalizationBuffer(n)
    frontier_capacity = max(4096, 16 * max(n, 1)^2)
    level = WorkspaceCandidate.PackedLevelwiseWorkspace(n; frontier_capacity)
    dfs = WorkspaceDFS.RecursiveStabilizerWorkspace(n)

    WorkspaceCandidate.canonicalize_levelwise_workspace!(level_buffer, level, graph, colors)
    WorkspaceDFS.canonicalize_recursive_stabilizers!(dfs_buffer, dfs, graph, colors)
    level_buffer.automorphism_order == dfs_buffer.automorphism_order ||
        error("order mismatch for $name")

    level_alloc = @allocated WorkspaceCandidate.canonicalize_levelwise_workspace!(
        level_buffer, level, graph, colors
    )
    dfs_alloc = @allocated WorkspaceDFS.canonicalize_recursive_stabilizers!(
        dfs_buffer, dfs, graph, colors
    )
    iszero(level_alloc) || error("levelwise allocated $level_alloc bytes for $name")
    iszero(dfs_alloc) || error("recursive allocated $dfs_alloc bytes for $name")

    level_ns = minimum_levelwise_ns(
        level_buffer, level, graph, colors, repetitions
    )
    dfs_ns = minimum_dfs_ns(dfs_buffer, dfs, graph, colors, repetitions)

    println(
        "WORKSPACE-BENCH|",
        name,
        "|n=",
        n,
        "|level_ns=",
        level_ns,
        "|dfs_ns=",
        dfs_ns,
        "|ratio=",
        round(level_ns / dfs_ns; digits=3),
        "|level_alloc=",
        level_alloc,
        "|dfs_alloc=",
        dfs_alloc,
        "|level_generated=",
        level.generated_nodes,
        "|level_retained=",
        level.retained_nodes,
        "|level_paths=",
        level.experimental_paths,
        "|level_quotient_discards=",
        level.quotient_discards,
        "|dfs_nodes=",
        dfs.packed.workspace.search_nodes,
        "|dfs_leaves=",
        dfs.packed.workspace.search_leaves,
    )
    return nothing
end

function run_fixture(
    name::String,
    fixture::Tuple{GC.DirectedGCGraph,Vector{Int}};
    repetitions::Int=40,
)::Nothing
    graph, colors = fixture
    run_workspace_benchmark(name, graph, colors; repetitions)
    return nothing
end

run_fixture("complete-9", bench_complete(9))
run_fixture("empty-9", bench_empty(9))
run_fixture("k6-6", bench_complete_bipartite(6, 6))
run_fixture("cycle-31", bench_cycle(31); repetitions=20)
run_fixture("petersen", bench_petersen())
run_fixture("triangular-6", bench_triangular(6))
run_fixture("rook-4", bench_rook(4))
run_fixture("hypercube-5", bench_hypercube(5); repetitions=20)
run_fixture("paley-13", bench_paley13())
run_fixture("shrikhande", bench_shrikhande())
run_fixture("repeated-directed-c7x4", bench_repeated_directed_cycles(4, 7); repetitions=20)
run_fixture("asymmetric-24", bench_deterministic_asymmetric(24); repetitions=20)
