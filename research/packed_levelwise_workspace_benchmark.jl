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
    repetitions::Int=20,
)::Nothing
    n = graph.num_vertices
    level_buffer = GC.DirectedCanonicalizationBuffer(n)
    dfs_buffer = GC.DirectedCanonicalizationBuffer(n)
    level = WorkspaceCandidate.PackedLevelwiseWorkspace(n; frontier_capacity=4096)
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
        level_ns / dfs_ns,
        "|level_alloc=",
        level_alloc,
        "|dfs_alloc=",
        dfs_alloc,
        "|level_generated=",
        level.generated_nodes,
        "|level_paths=",
        level.experimental_paths,
        "|dfs_nodes=",
        dfs.packed.workspace.search_nodes,
    )
    return nothing
end

let graph, colors = bench_complete(9)
    run_workspace_benchmark("complete-9", graph, colors)
end
let graph, colors = bench_cycle(31)
    run_workspace_benchmark("cycle-31", graph, colors; repetitions=10)
end
let graph, colors = bench_petersen()
    run_workspace_benchmark("petersen", graph, colors)
end
let graph, colors = bench_triangular(6)
    run_workspace_benchmark("triangular-6", graph, colors)
end
let graph, colors = bench_rook(4)
    run_workspace_benchmark("rook-4", graph, colors)
end
let graph, colors = bench_hypercube(5)
    run_workspace_benchmark("hypercube-5", graph, colors; repetitions=10)
end
let graph, colors = bench_repeated_directed_cycles(4, 7)
    run_workspace_benchmark("repeated-directed-c7x4", graph, colors; repetitions=10)
end
