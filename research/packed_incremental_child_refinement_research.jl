import GraphCombinations as GC

module IncrementalReference
include(joinpath(@__DIR__, "packed_levelwise_frontier_orbits.jl"))
end

module IncrementalCandidate
include(joinpath(@__DIR__, "packed_incremental_child_refinement.jl"))
end

const INCREMENTAL_N3_PERMUTATIONS = (
    [1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1],
)
const INCREMENTAL_N3_COLORINGS = (
    [1, 1, 1], [1, 1, 2], [1, 2, 1], [1, 2, 2], [1, 2, 3],
)

function incremental_graph_from_mask(n::Int, mask::UInt64)
    edges = Pair{Int,Int}[]
    bit = 0
    for source in 1:n, target in 1:n
        !iszero(mask & (UInt64(1) << bit)) && push!(edges, source => target)
        bit += 1
    end
    return GC.DirectedGCGraph(edges, n)
end

function incremental_relabel_colors(colors::Vector{Int}, mapping::Vector{Int})
    result = similar(colors)
    @inbounds for old_vertex in eachindex(colors)
        result[mapping[old_vertex]] = colors[old_vertex]
    end
    return result
end

function incremental_same_image(
    left::GC.DirectedCanonicalizationBuffer,
    right::GC.DirectedCanonicalizationBuffer,
    n::Int,
)::Bool
    @inbounds for slot in 1:(n * n)
        left.canonical_multiplicities[slot] == right.canonical_multiplicities[slot] ||
            return false
    end
    return true
end

function incremental_witness_reconstructs(
    buffer::GC.DirectedCanonicalizationBuffer,
    graph::GC.DirectedGCGraph,
)::Bool
    n = graph.num_vertices
    @inbounds for canonical_source in 1:n
        old_source = buffer.canonical_to_old[canonical_source]
        buffer.old_to_canonical[old_source] == canonical_source || return false
        for canonical_target in 1:n
            old_target = buffer.canonical_to_old[canonical_target]
            buffer.canonical_multiplicities[GC._directed_slot(
                canonical_source, canonical_target, n
            )] == graph.multiplicities[GC._directed_slot(old_source, old_target, n)] ||
                return false
        end
    end
    return true
end

function certify_incremental_n3()
    n = 3
    reference_workspace = IncrementalReference.PackedLevelwiseOrbitWorkspace(
        n; frontier_capacity=256
    )
    candidate_workspace = IncrementalCandidate.PackedLevelwiseIncrementalWorkspace(
        n; frontier_capacity=256
    )
    reference = GC.DirectedCanonicalizationBuffer(n)
    base_candidate = GC.DirectedCanonicalizationBuffer(n)
    relabeled_candidate = GC.DirectedCanonicalizationBuffer(n)
    cases = 0
    relabelings = 0
    convention_changes = 0

    for mask in UInt64(0):((UInt64(1) << (n * n)) - UInt64(1))
        graph = incremental_graph_from_mask(n, mask)
        for colors_tuple in INCREMENTAL_N3_COLORINGS
            colors = collect(colors_tuple)
            IncrementalReference.canonicalize_levelwise_frontier_orbits!(
                reference, reference_workspace, graph, colors
            )
            IncrementalCandidate.canonicalize_levelwise_incremental!(
                base_candidate, candidate_workspace, graph, colors
            )
            base_candidate.automorphism_order == reference.automorphism_order ||
                error("incremental order mismatch: mask=$mask colors=$colors")
            incremental_witness_reconstructs(base_candidate, graph) ||
                error("incremental witness mismatch: mask=$mask colors=$colors")
            incremental_same_image(reference, base_candidate, n) ||
                (convention_changes += 1)
            cases += 1

            for mapping_tuple in INCREMENTAL_N3_PERMUTATIONS
                mapping = collect(mapping_tuple)
                relabeled_graph = GC._relabel_directed_graph(graph, mapping)
                relabeled_colors = incremental_relabel_colors(colors, mapping)
                IncrementalCandidate.canonicalize_levelwise_incremental!(
                    relabeled_candidate,
                    candidate_workspace,
                    relabeled_graph,
                    relabeled_colors,
                )
                incremental_same_image(base_candidate, relabeled_candidate, n) ||
                    error("incremental canonical image changed under relabeling")
                relabeled_candidate.automorphism_order == base_candidate.automorphism_order ||
                    error("incremental automorphism order changed under relabeling")
                incremental_witness_reconstructs(relabeled_candidate, relabeled_graph) ||
                    error("incremental relabeled witness mismatch")
                relabelings += 1
            end
        end
    end

    println("INCREMENTAL-CERT|n3-base|", cases)
    println("INCREMENTAL-CERT|n3-relabelings|", relabelings)
    println("INCREMENTAL-CERT|convention-changes|", convention_changes)
    return nothing
end

function incremental_bidirected(n::Int, undirected_edges::Vector{Pair{Int,Int}})
    directed = Pair{Int,Int}[]
    for edge in undirected_edges
        source = first(edge)
        target = last(edge)
        push!(directed, source => target)
        source == target || push!(directed, target => source)
    end
    return GC.DirectedGCGraph(directed, n)
end

function incremental_cycle(n::Int)
    edges = Pair{Int,Int}[]
    for vertex in 1:(n - 1)
        push!(edges, vertex => vertex + 1)
    end
    push!(edges, 1 => n)
    return incremental_bidirected(n, edges), ones(Int, n)
end

function incremental_petersen()
    edges = Pair{Int,Int}[]
    for vertex in 1:5
        push!(edges, vertex => mod1(vertex + 1, 5))
        push!(edges, vertex => 5 + vertex)
    end
    for vertex in 1:5
        push!(edges, (5 + vertex) => (5 + mod1(vertex + 2, 5)))
    end
    return incremental_bidirected(10, edges), ones(Int, 10)
end

function incremental_triangular(base_n::Int)
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
    return incremental_bidirected(n, edges), ones(Int, n)
end

function incremental_rook(size::Int)
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
    return incremental_bidirected(n, edges), ones(Int, n)
end

function incremental_hypercube(dimension::Int)
    n = 1 << dimension
    edges = Pair{Int,Int}[]
    for zero_vertex in 0:(n - 1), bit in 0:(dimension - 1)
        neighbor = zero_vertex ⊻ (1 << bit)
        zero_vertex < neighbor || continue
        push!(edges, zero_vertex + 1 => neighbor + 1)
    end
    return incremental_bidirected(n, edges), ones(Int, n)
end

function incremental_shrikhande()
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
    return incremental_bidirected(n, edges), ones(Int, n)
end

function incremental_minimum_ns(f, repetitions::Int)
    best = typemax(Int)
    for _ in 1:repetitions
        start = time_ns()
        f()
        best = min(best, Int(time_ns() - start))
    end
    return best
end

function benchmark_incremental_fixture(name::String, fixture; repetitions::Int=30)
    graph, colors = fixture
    n = graph.num_vertices
    capacity = max(4096, 16 * max(n, 1)^2)
    reference_workspace = IncrementalReference.PackedLevelwiseOrbitWorkspace(
        n; frontier_capacity=capacity
    )
    candidate_workspace = IncrementalCandidate.PackedLevelwiseIncrementalWorkspace(
        n; frontier_capacity=capacity
    )
    reference = GC.DirectedCanonicalizationBuffer(n)
    candidate = GC.DirectedCanonicalizationBuffer(n)

    IncrementalReference.canonicalize_levelwise_frontier_orbits!(
        reference, reference_workspace, graph, colors
    )
    IncrementalCandidate.canonicalize_levelwise_incremental!(
        candidate, candidate_workspace, graph, colors
    )
    candidate.automorphism_order == reference.automorphism_order ||
        error("order mismatch for $name")
    incremental_witness_reconstructs(candidate, graph) || error("witness mismatch for $name")

    candidate_alloc = @allocated IncrementalCandidate.canonicalize_levelwise_incremental!(
        candidate, candidate_workspace, graph, colors
    )
    iszero(candidate_alloc) || error("candidate allocated $candidate_alloc bytes for $name")

    reference_ns = incremental_minimum_ns(repetitions) do
        IncrementalReference.canonicalize_levelwise_frontier_orbits!(
            reference, reference_workspace, graph, colors
        )
    end
    candidate_ns = incremental_minimum_ns(repetitions) do
        IncrementalCandidate.canonicalize_levelwise_incremental!(
            candidate, candidate_workspace, graph, colors
        )
    end

    base = candidate_workspace.orbit.base
    println(
        "INCREMENTAL-BENCH|", name,
        "|reference_ns=", reference_ns,
        "|candidate_ns=", candidate_ns,
        "|ratio=", round(candidate_ns / reference_ns; digits=3),
        "|reference_generated=", reference_workspace.base.generated_nodes,
        "|candidate_generated=", base.generated_nodes,
        "|reference_paths=", reference_workspace.base.experimental_paths,
        "|candidate_paths=", base.experimental_paths,
        "|candidate_splitter_steps=", base.traced.packed.active_splitter_steps,
        "|candidate_cell_splits=", base.traced.packed.active_cell_splits,
        "|generated=", base.generated_nodes,
        "|retained=", base.retained_nodes,
        "|order=", candidate.automorphism_order,
        "|allocated=", candidate_alloc,
    )
    return nothing
end

certify_incremental_n3()
benchmark_incremental_fixture("cycle-31", incremental_cycle(31); repetitions=20)
benchmark_incremental_fixture("petersen", incremental_petersen())
benchmark_incremental_fixture("triangular-6", incremental_triangular(6))
benchmark_incremental_fixture("rook-4", incremental_rook(4))
benchmark_incremental_fixture("hypercube-5", incremental_hypercube(5); repetitions=20)
benchmark_incremental_fixture("shrikhande", incremental_shrikhande())
