import GraphCombinations as GC

module FrontierReference
include(joinpath(@__DIR__, "packed_levelwise_workspace.jl"))
end

module FrontierCandidate
include(joinpath(@__DIR__, "packed_levelwise_frontier_orbits.jl"))
end

const FRONTIER_N3_PERMUTATIONS = (
    [1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]
)
const FRONTIER_N3_COLORINGS = ([1, 1, 1], [1, 1, 2], [1, 2, 1], [1, 2, 2], [1, 2, 3])

function frontier_graph_from_mask(n::Int, mask::UInt64)
    edges = Pair{Int,Int}[]
    bit = 0
    for source in 1:n, target in 1:n
        !iszero(mask & (UInt64(1) << bit)) && push!(edges, source => target)
        bit += 1
    end
    return GC.DirectedGCGraph(edges, n)
end

function frontier_relabel_colors(colors::Vector{Int}, mapping::Vector{Int})
    result = similar(colors)
    @inbounds for old_vertex in eachindex(colors)
        result[mapping[old_vertex]] = colors[old_vertex]
    end
    return result
end

function frontier_same_result(
    left::GC.DirectedCanonicalizationBuffer,
    right::GC.DirectedCanonicalizationBuffer,
    n::Int,
)::Bool
    left.automorphism_order == right.automorphism_order || return false
    @inbounds for slot in 1:(n * n)
        left.canonical_multiplicities[slot] == right.canonical_multiplicities[slot] ||
            return false
    end
    return true
end

function certify_frontier_n3()
    n = 3
    reference_workspace = FrontierReference.PackedLevelwiseWorkspace(
        n; frontier_capacity=256
    )
    candidate_workspace = FrontierCandidate.PackedLevelwiseOrbitWorkspace(
        n; frontier_capacity=256
    )
    reference = GC.DirectedCanonicalizationBuffer(n)
    candidate = GC.DirectedCanonicalizationBuffer(n)
    cases = 0
    relabelings = 0

    for mask in UInt64(0):((UInt64(1) << (n * n)) - UInt64(1))
        graph = frontier_graph_from_mask(n, mask)
        for colors_tuple in FRONTIER_N3_COLORINGS
            colors = collect(colors_tuple)
            FrontierReference.canonicalize_levelwise_workspace!(
                reference, reference_workspace, graph, colors
            )
            FrontierCandidate.canonicalize_levelwise_frontier_orbits!(
                candidate, candidate_workspace, graph, colors
            )
            frontier_same_result(reference, candidate, n) ||
                error("frontier-orbit mismatch: mask=$mask colors=$colors")
            cases += 1

            for mapping_tuple in FRONTIER_N3_PERMUTATIONS
                mapping = collect(mapping_tuple)
                relabeled_graph = GC._relabel_directed_graph(graph, mapping)
                relabeled_colors = frontier_relabel_colors(colors, mapping)
                FrontierCandidate.canonicalize_levelwise_frontier_orbits!(
                    candidate, candidate_workspace, relabeled_graph, relabeled_colors
                )
                frontier_same_result(reference, candidate, n) ||
                    error("frontier-orbit relabeling mismatch")
                relabelings += 1
            end
        end
    end
    println("FRONTIER-CERT|n3-base|", cases)
    println("FRONTIER-CERT|n3-relabelings|", relabelings)
    return nothing
end

function frontier_bidirected(n::Int, undirected_edges::Vector{Pair{Int,Int}})
    directed = Pair{Int,Int}[]
    for edge in undirected_edges
        source = first(edge)
        target = last(edge)
        push!(directed, source => target)
        source == target || push!(directed, target => source)
    end
    return GC.DirectedGCGraph(directed, n)
end

function frontier_cycle(n::Int)
    edges = Pair{Int,Int}[]
    for vertex in 1:(n - 1)
        push!(edges, vertex => vertex + 1)
    end
    push!(edges, 1 => n)
    return frontier_bidirected(n, edges), ones(Int, n)
end

function frontier_petersen()
    edges = Pair{Int,Int}[]
    for vertex in 1:5
        push!(edges, vertex => mod1(vertex + 1, 5))
        push!(edges, vertex => 5 + vertex)
    end
    for vertex in 1:5
        push!(edges, (5 + vertex) => (5 + mod1(vertex + 2, 5)))
    end
    return frontier_bidirected(10, edges), ones(Int, 10)
end

function frontier_triangular(base_n::Int)
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
    return frontier_bidirected(n, edges), ones(Int, n)
end

function frontier_rook(size::Int)
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
    return frontier_bidirected(n, edges), ones(Int, n)
end

function frontier_hypercube(dimension::Int)
    n = 1 << dimension
    edges = Pair{Int,Int}[]
    for zero_vertex in 0:(n - 1), bit in 0:(dimension - 1)
        neighbor = zero_vertex ⊻ (1 << bit)
        zero_vertex < neighbor || continue
        push!(edges, zero_vertex + 1 => neighbor + 1)
    end
    return frontier_bidirected(n, edges), ones(Int, n)
end

function frontier_shrikhande()
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
    return frontier_bidirected(n, edges), ones(Int, n)
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

function benchmark_frontier_fixture(name::String, fixture; repetitions::Int=30)
    graph, colors = fixture
    n = graph.num_vertices
    capacity = max(4096, 16 * max(n, 1)^2)
    reference_workspace = FrontierReference.PackedLevelwiseWorkspace(
        n; frontier_capacity=capacity
    )
    candidate_workspace = FrontierCandidate.PackedLevelwiseOrbitWorkspace(
        n; frontier_capacity=capacity
    )
    reference = GC.DirectedCanonicalizationBuffer(n)
    candidate = GC.DirectedCanonicalizationBuffer(n)

    FrontierReference.canonicalize_levelwise_workspace!(
        reference, reference_workspace, graph, colors
    )
    FrontierCandidate.canonicalize_levelwise_frontier_orbits!(
        candidate, candidate_workspace, graph, colors
    )
    frontier_same_result(reference, candidate, n) || error("result mismatch for $name")

    candidate_alloc = @allocated FrontierCandidate.canonicalize_levelwise_frontier_orbits!(
        candidate, candidate_workspace, graph, colors
    )
    iszero(candidate_alloc) || error("candidate allocated $candidate_alloc bytes for $name")

    reference_ns = minimum_ns(repetitions) do
        return FrontierReference.canonicalize_levelwise_workspace!(
            reference, reference_workspace, graph, colors
        )
    end
    candidate_ns = minimum_ns(repetitions) do
        return FrontierCandidate.canonicalize_levelwise_frontier_orbits!(
            candidate, candidate_workspace, graph, colors
        )
    end

    base = candidate_workspace.base
    println(
        "FRONTIER-BENCH|",
        name,
        "|reference_ns=",
        reference_ns,
        "|candidate_ns=",
        candidate_ns,
        "|ratio=",
        round(candidate_ns / reference_ns; digits=3),
        "|reference_paths=",
        reference_workspace.experimental_paths,
        "|candidate_paths=",
        base.experimental_paths,
        "|orbit_path_skips=",
        candidate_workspace.orbit_path_skips,
        "|generators=",
        candidate_workspace.generators,
        "|generator_unions=",
        candidate_workspace.generator_unions,
        "|generated=",
        base.generated_nodes,
        "|retained=",
        base.retained_nodes,
        "|order=",
        candidate.automorphism_order,
        "|allocated=",
        candidate_alloc,
    )
    return nothing
end

certify_frontier_n3()
benchmark_frontier_fixture("cycle-31", frontier_cycle(31); repetitions=20)
benchmark_frontier_fixture("petersen", frontier_petersen())
benchmark_frontier_fixture("triangular-6", frontier_triangular(6))
benchmark_frontier_fixture("rook-4", frontier_rook(4))
benchmark_frontier_fixture("hypercube-5", frontier_hypercube(5); repetitions=20)
benchmark_frontier_fixture("shrikhande", frontier_shrikhande())
