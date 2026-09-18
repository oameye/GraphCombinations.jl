import GraphCombinations as GC
using Profile
import NautyGraphs
using Graphs

module ProfileLevelwise
include(joinpath(@__DIR__, "packed_levelwise_workspace.jl"))
end

module ProfileDFS
include(joinpath(@__DIR__, "packed_recursive_stabilizer_orbits.jl"))
end

function profile_bidirected(n::Int, undirected_edges::Vector{Pair{Int,Int}})
    directed = Pair{Int,Int}[]
    for edge in undirected_edges
        source = first(edge)
        target = last(edge)
        push!(directed, source => target)
        source == target || push!(directed, target => source)
    end
    return GC.DirectedGCGraph(directed, n)
end

function profile_petersen()
    edges = Pair{Int,Int}[]
    for vertex in 1:5
        push!(edges, vertex => mod1(vertex + 1, 5))
        push!(edges, vertex => 5 + vertex)
    end
    for vertex in 1:5
        push!(edges, (5 + vertex) => (5 + mod1(vertex + 2, 5)))
    end
    return profile_bidirected(10, edges), ones(Int, 10)
end

function profile_triangular(base_n::Int)
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
    return profile_bidirected(n, edges), ones(Int, n)
end

function profile_rook(size::Int)
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
    return profile_bidirected(n, edges), ones(Int, n)
end

function profile_hypercube(dimension::Int)
    n = 1 << dimension
    edges = Pair{Int,Int}[]
    for zero_vertex in 0:(n - 1)
        for bit in 0:(dimension - 1)
            neighbor = zero_vertex ⊻ (1 << bit)
            zero_vertex < neighbor || continue
            push!(edges, (zero_vertex + 1) => (neighbor + 1))
        end
    end
    return profile_bidirected(n, edges), ones(Int, n)
end

function profile_shrikhande()
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
    return profile_bidirected(n, edges), ones(Int, n)
end

function profile_cycle(n::Int)
    edges = Pair{Int,Int}[]
    for vertex in 1:(n - 1)
        push!(edges, vertex => vertex + 1)
    end
    push!(edges, 1 => n)
    return profile_bidirected(n, edges), ones(Int, n)
end

function profile_to_nauty(graph::GC.DirectedGCGraph, colors::Vector{Int})
    n = graph.num_vertices
    result = NautyGraphs.NautyDiGraph(n; vertex_labels=colors)
    @inbounds for source in 1:n, target in 1:n
        graph.multiplicities[GC._directed_slot(source, target, n)] == 0 && continue
        add_edge!(result, source, target)
    end
    return result
end

function report_nauty_nodes(name::String, graph::GC.DirectedGCGraph, colors::Vector{Int})
    nauty_graph = profile_to_nauty(graph, colors)
    canong, _, _, statistics = NautyGraphs._nauty(nauty_graph)
    println(
        "NAUTY-STATS|", name,
        "|nodes=", statistics.numnodes,
        "|badleaves=", statistics.numbadleaves,
        "|maxlevel=", statistics.maxlevel,
        "|canupdates=", statistics.canupdates,
        "|orbits=", statistics.numorbits,
        "|generators=", statistics.numgenerators,
    )
    return canong
end

function profile_fixture(name::String, fixture; repetitions::Int=1000)
    graph, colors = fixture
    n = graph.num_vertices
    level = ProfileLevelwise.PackedLevelwiseWorkspace(
        n; frontier_capacity=max(4096, 16 * max(n, 1)^2)
    )
    level_buffer = GC.DirectedCanonicalizationBuffer(n)
    dfs = ProfileDFS.RecursiveStabilizerWorkspace(n)
    dfs_buffer = GC.DirectedCanonicalizationBuffer(n)

    ProfileLevelwise.canonicalize_levelwise_workspace!(level_buffer, level, graph, colors)
    ProfileDFS.canonicalize_recursive_stabilizers!(dfs_buffer, dfs, graph, colors)
    level_buffer.automorphism_order == dfs_buffer.automorphism_order || error("order mismatch")

    report_nauty_nodes(name, graph, colors)
    println(
        "GC-STATS|", name,
        "|level_generated=", level.generated_nodes,
        "|level_retained=", level.retained_nodes,
        "|level_leaves=", level.leaves,
        "|experimental_paths=", level.experimental_paths,
        "|quotient_discards=", level.quotient_discards,
        "|dfs_nodes=", dfs.packed.workspace.search_nodes,
        "|dfs_leaves=", dfs.packed.workspace.search_leaves,
    )

    Profile.clear()
    Profile.init(; delay=1.0e-6)
    @profile for _ in 1:repetitions
        ProfileLevelwise.canonicalize_levelwise_workspace!(
            level_buffer, level, graph, colors
        )
    end
    println("PROFILE-BEGIN|", name)
    Profile.print(; format=:flat, sortedby=:count, mincount=max(2, repetitions ÷ 20), C=false)
    println("PROFILE-END|", name)
    return nothing
end

profile_fixture("petersen", profile_petersen(); repetitions=1500)
profile_fixture("triangular-6", profile_triangular(6); repetitions=1000)
profile_fixture("rook-4", profile_rook(4); repetitions=1000)
profile_fixture("hypercube-5", profile_hypercube(5); repetitions=400)
profile_fixture("shrikhande", profile_shrikhande(); repetitions=1000)
profile_fixture("cycle-31", profile_cycle(31); repetitions=400)
