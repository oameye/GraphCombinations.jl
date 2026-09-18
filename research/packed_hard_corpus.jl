include(joinpath(@__DIR__, "packed_levelwise_exact_multiplicity.jl"))
include(joinpath(@__DIR__, "packed_recursive_stabilizer_orbits.jl"))

function hard_bidirected_graph(n::Int, undirected_edges::Vector{Pair{Int,Int}})
    directed = Pair{Int,Int}[]
    for edge in undirected_edges
        source = first(edge)
        target = last(edge)
        push!(directed, source => target)
        source == target || push!(directed, target => source)
    end
    return GC.DirectedGCGraph(directed, n)
end

function hard_complete_graph(n::Int)
    edges = Pair{Int,Int}[]
    for left in 1:n, right in (left + 1):n
        push!(edges, left => right)
    end
    return hard_bidirected_graph(n, edges), ones(Int, n), factorial(n)
end

function hard_empty_graph(n::Int)
    return GC.DirectedGCGraph(Pair{Int,Int}[], n), ones(Int, n), factorial(n)
end

function hard_complete_bipartite(left_size::Int, right_size::Int)
    n = left_size + right_size
    edges = Pair{Int,Int}[]
    for left in 1:left_size, right in (left_size + 1):n
        push!(edges, left => right)
    end
    order = factorial(left_size) * factorial(right_size)
    left_size == right_size && (order *= 2)
    return hard_bidirected_graph(n, edges), ones(Int, n), order
end

function hard_cycle(n::Int)
    edges = Pair{Int,Int}[]
    for vertex in 1:n
        next = mod1(vertex + 1, n)
        vertex < next && push!(edges, vertex => next)
    end
    push!(edges, 1 => n)
    return hard_bidirected_graph(n, edges), ones(Int, n), 2n
end

function hard_petersen()
    edges = Pair{Int,Int}[]
    for vertex in 1:5
        push!(edges, vertex => mod1(vertex + 1, 5))
        push!(edges, vertex => (5 + vertex))
    end
    for vertex in 1:5
        push!(edges, (5 + vertex) => (5 + mod1(vertex + 2, 5)))
    end
    return hard_bidirected_graph(10, edges), ones(Int, 10), 120
end

function hard_triangular(base_n::Int)
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
    return hard_bidirected_graph(n, edges), ones(Int, n), factorial(base_n)
end

function hard_rook(size::Int)
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
    order = 2 * factorial(size)^2
    return hard_bidirected_graph(n, edges), ones(Int, n), order
end

function hard_hypercube(dimension::Int)
    n = 1 << dimension
    edges = Pair{Int,Int}[]
    for zero_vertex in 0:(n - 1)
        for bit in 0:(dimension - 1)
            neighbor = zero_vertex ⊻ (1 << bit)
            zero_vertex < neighbor || continue
            push!(edges, (zero_vertex + 1) => (neighbor + 1))
        end
    end
    order = (1 << dimension) * factorial(dimension)
    return hard_bidirected_graph(n, edges), ones(Int, n), order
end

function hard_paley13()
    p = 13
    residues = Set((1, 3, 4, 9, 10, 12))
    edges = Pair{Int,Int}[]
    for zero_left in 0:(p - 1), zero_right in (zero_left + 1):(p - 1)
        difference = mod(zero_right - zero_left, p)
        difference in residues && push!(edges, (zero_left + 1) => (zero_right + 1))
    end
    return hard_bidirected_graph(p, edges), ones(Int, p), p * (p - 1) ÷ 2
end

function hard_shrikhande()
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
    return hard_bidirected_graph(n, edges), ones(Int, n), 192
end

function hard_repeated_directed_cycles(count::Int, size::Int)
    n = count * size
    edges = Pair{Int,Int}[]
    for component in 0:(count - 1)
        offset = component * size
        for local_vertex in 1:size
            source = offset + local_vertex
            target = offset + mod1(local_vertex + 1, size)
            push!(edges, source => target)
        end
    end
    order = size^count * factorial(count)
    return GC.DirectedGCGraph(edges, n), ones(Int, n), order
end

function hard_deterministic_asymmetric(n::Int)
    edges = Pair{Int,Int}[]
    for source in 1:n, target in 1:n
        source == target && continue
        value = mod(37source + 53target + 7source * target + 11source^2 + 3target^2, 97)
        value < 18 && push!(edges, source => target)
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n), nothing
end

function hard_fixture(name::String)
    name == "complete-9" && return hard_complete_graph(9)
    name == "empty-9" && return hard_empty_graph(9)
    name == "k6-6" && return hard_complete_bipartite(6, 6)
    name == "cycle-31" && return hard_cycle(31)
    name == "petersen" && return hard_petersen()
    name == "triangular-6" && return hard_triangular(6)
    name == "rook-4" && return hard_rook(4)
    name == "hypercube-5" && return hard_hypercube(5)
    name == "paley-13" && return hard_paley13()
    name == "shrikhande" && return hard_shrikhande()
    name == "repeated-directed-c7x4" && return hard_repeated_directed_cycles(4, 7)
    name == "asymmetric-24" && return hard_deterministic_asymmetric(24)
    error("unknown hard-corpus fixture: $name")
end

function hard_relabel_colors(colors::Vector{Int}, mapping::Vector{Int})
    result = similar(colors)
    @inbounds for old_vertex in eachindex(colors)
        result[mapping[old_vertex]] = colors[old_vertex]
    end
    return result
end

function hard_same_image(
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

function run_hard_fixture(name::String)
    graph, colors, expected_order = hard_fixture(name)
    n = graph.num_vertices

    start = time_ns()
    exact_buffer, exact_stats, experimental = levelwise_trace_exact_buffer(graph, colors)
    exact_ns = time_ns() - start

    reverse_mapping = collect(n:-1:1)
    relabeled_graph = GC._relabel_directed_graph(graph, reverse_mapping)
    relabeled_colors = hard_relabel_colors(colors, reverse_mapping)
    relabeled_buffer, _, _ = levelwise_trace_exact_buffer(relabeled_graph, relabeled_colors)
    hard_same_image(exact_buffer, relabeled_buffer, n) ||
        error("trace-defined image changed under reversal for $name")
    exact_buffer.automorphism_order == relabeled_buffer.automorphism_order ||
        error("automorphism order changed under reversal for $name")

    recursive = RecursiveStabilizerWorkspace(n)
    recursive_buffer = GC.DirectedCanonicalizationBuffer(n)
    start = time_ns()
    canonicalize_recursive_stabilizers!(recursive_buffer, recursive, graph, colors)
    recursive_ns = time_ns() - start

    exact_buffer.automorphism_order == recursive_buffer.automorphism_order ||
        error(
            "exact order mismatch for $name: levelwise=$(exact_buffer.automorphism_order) recursive=$(recursive_buffer.automorphism_order)"
        )
    if expected_order !== nothing
        exact_buffer.automorphism_order == expected_order ||
            error(
                "known order mismatch for $name: got $(exact_buffer.automorphism_order), expected $expected_order"
            )
    end

    println(
        "HARD|",
        name,
        "|n=",
        n,
        "|order=",
        exact_buffer.automorphism_order,
        "|level_generated=",
        exact_stats.generated_nodes,
        "|level_retained=",
        exact_stats.retained_nodes,
        "|level_leaves=",
        exact_stats.leaves,
        "|level_max_frontier=",
        exact_stats.maximum_frontier,
        "|paths=",
        experimental.paths,
        "|aut_proofs=",
        experimental.proven_frontier_automorphisms,
        "|quotient_discards=",
        experimental.quotient_discards,
        "|dfs_nodes=",
        recursive.packed.workspace.search_nodes,
        "|dfs_leaves=",
        recursive.packed.workspace.search_leaves,
        "|level_ms=",
        round(exact_ns / 1e6; digits=3),
        "|dfs_ms=",
        round(recursive_ns / 1e6; digits=3),
    )
    return nothing
end

length(ARGS) == 1 || error("usage: packed_hard_corpus.jl FIXTURE")
run_hard_fixture(ARGS[1])
