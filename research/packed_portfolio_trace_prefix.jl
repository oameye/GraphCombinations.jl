import GraphCombinations as GC

module PrefixLevelwise
include(joinpath(@__DIR__, "packed_levelwise_workspace.jl"))
end

function prefix_bidirected(n::Int, undirected_edges::Vector{Pair{Int,Int}})
    directed = Pair{Int,Int}[]
    for edge in undirected_edges
        source = first(edge)
        target = last(edge)
        push!(directed, source => target)
        source == target || push!(directed, target => source)
    end
    return GC.DirectedGCGraph(directed, n)
end

function prefix_complete(n::Int)
    edges = Pair{Int,Int}[]
    for left in 1:n, right in (left + 1):n
        push!(edges, left => right)
    end
    return prefix_bidirected(n, edges), ones(Int, n)
end

prefix_empty(n::Int) = (GC.DirectedGCGraph(Pair{Int,Int}[], n), ones(Int, n))

function prefix_complete_bipartite(left_size::Int, right_size::Int)
    n = left_size + right_size
    edges = Pair{Int,Int}[]
    for left in 1:left_size, right in (left_size + 1):n
        push!(edges, left => right)
    end
    return prefix_bidirected(n, edges), ones(Int, n)
end

function prefix_cycle(n::Int)
    edges = Pair{Int,Int}[]
    for vertex in 1:(n - 1)
        push!(edges, vertex => (vertex + 1))
    end
    push!(edges, 1 => n)
    return prefix_bidirected(n, edges), ones(Int, n)
end

function prefix_petersen()
    edges = Pair{Int,Int}[]
    for vertex in 1:5
        push!(edges, vertex => mod1(vertex + 1, 5))
        push!(edges, vertex => (5 + vertex))
    end
    for vertex in 1:5
        push!(edges, (5 + vertex) => (5 + mod1(vertex + 2, 5)))
    end
    return prefix_bidirected(10, edges), ones(Int, 10)
end

function prefix_triangular(base_n::Int)
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
    return prefix_bidirected(n, edges), ones(Int, n)
end

function prefix_rook(size::Int)
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
    return prefix_bidirected(n, edges), ones(Int, n)
end

function prefix_hypercube(dimension::Int)
    n = 1 << dimension
    edges = Pair{Int,Int}[]
    for zero_vertex in 0:(n - 1)
        for bit in 0:(dimension - 1)
            neighbor = zero_vertex ⊻ (1 << bit)
            zero_vertex < neighbor || continue
            push!(edges, (zero_vertex + 1) => (neighbor + 1))
        end
    end
    return prefix_bidirected(n, edges), ones(Int, n)
end

function prefix_paley13()
    p = 13
    residues = Set((1, 3, 4, 9, 10, 12))
    edges = Pair{Int,Int}[]
    for zero_left in 0:(p - 1), zero_right in (zero_left + 1):(p - 1)
        mod(zero_right - zero_left, p) in residues &&
            push!(edges, (zero_left + 1) => (zero_right + 1))
    end
    return prefix_bidirected(p, edges), ones(Int, p)
end

function prefix_shrikhande()
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
    return prefix_bidirected(n, edges), ones(Int, n)
end

function prefix_repeated_directed_cycles(count::Int, size::Int)
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

function prefix_asymmetric(n::Int)
    edges = Pair{Int,Int}[]
    for source in 1:n, target in 1:n
        source == target && continue
        value = mod(37source + 53target + 7source * target + 11source^2 + 3target^2, 97)
        value < 18 && push!(edges, source => target)
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function prefix_multiplicity_sum(workspace, count::Int)::Int
    total = 0
    @inbounds for node in 1:count
        total = Base.Checked.checked_add(total, workspace.next_multiplicities[node])
    end
    return total
end

function prefix_current_multiplicity_sum(workspace, count::Int)::Int
    total = 0
    @inbounds for node in 1:count
        total = Base.Checked.checked_add(total, workspace.current_multiplicities[node])
    end
    return total
end

function measure_prefix_level!(workspace, graph, current_count::Int)
    n = graph.num_vertices
    next_count = 0
    has_best_trace = false
    workspace.best_trace_length = 0
    generated_before = workspace.generated_nodes
    discarded_before = workspace.discarded_by_trace
    quotient_before = workspace.quotient_discards
    paths_before = workspace.experimental_paths

    @inbounds for node in 1:current_count
        target_color = PrefixLevelwise.levelwise_target_color!(
            workspace, workspace.current_colors, node, n
        )
        iszero(target_color) && error("prefix frontier became discrete unexpectedly")
        for chosen_vertex in 1:n
            workspace.current_colors[
                PrefixLevelwise.levelwise_slot(workspace, node, chosen_vertex)
            ] == target_color || continue
            PrefixLevelwise.levelwise_prepare_child_trace!(
                workspace,
                graph,
                workspace.current_colors,
                node,
                target_color,
                chosen_vertex,
            )
            workspace.generated_nodes += 1
            comparison = has_best_trace ?
                PrefixLevelwise.levelwise_compare_trace_to_best(workspace) : 1
            if comparison > 0
                workspace.discarded_by_trace += next_count
                next_count = 1
                PrefixLevelwise.levelwise_copy_best_trace!(workspace)
                has_best_trace = true
                PrefixLevelwise.levelwise_store_traced_child!(
                    workspace,
                    next_count,
                    workspace.current_multiplicities[node],
                    n,
                )
            elseif iszero(comparison)
                next_count += 1
                PrefixLevelwise.levelwise_store_traced_child!(
                    workspace,
                    next_count,
                    workspace.current_multiplicities[node],
                    n,
                )
            else
                workspace.discarded_by_trace += 1
            end
        end
    end

    trace_survivors = next_count
    trace_multiplicity = prefix_multiplicity_sum(workspace, next_count)
    discrete = iszero(PrefixLevelwise.levelwise_target_color!(
        workspace, workspace.next_colors, 1, n
    ))
    if !discrete
        next_count = PrefixLevelwise.levelwise_quotient_next_frontier!(
            workspace, graph, next_count
        )
    end
    quotient_multiplicity = prefix_multiplicity_sum(workspace, next_count)

    colors_tmp = workspace.current_colors
    workspace.current_colors = workspace.next_colors
    workspace.next_colors = colors_tmp
    multiplicities_tmp = workspace.current_multiplicities
    workspace.current_multiplicities = workspace.next_multiplicities
    workspace.next_multiplicities = multiplicities_tmp

    return (
        count=next_count,
        generated=workspace.generated_nodes - generated_before,
        trace_survivors,
        trace_multiplicity,
        quotient_multiplicity,
        trace_discards=workspace.discarded_by_trace - discarded_before,
        quotient_discards=workspace.quotient_discards - quotient_before,
        paths=workspace.experimental_paths - paths_before,
        trace_length=workspace.best_trace_length,
        discrete,
    )
end

function run_prefix_fixture(name::String, winner::String, fixture)
    graph, colors = fixture
    n = graph.num_vertices
    workspace = PrefixLevelwise.PackedLevelwiseWorkspace(
        n; frontier_capacity=max(4096, 16 * max(n, 1)^2)
    )
    GC._prepare_packed_directed_rows!(workspace.traced.packed, graph) ||
        error("simple graph required")
    GC._prepare_packed_directed_rows!(workspace.path_packed, graph) ||
        error("simple graph required")
    PrefixLevelwise.reset_levelwise_stats!(workspace)
    PrefixLevelwise.prepare_traced_partition!(workspace.traced, graph, colors)
    PrefixLevelwise.traced_refine!(workspace.traced, graph, 1)
    PrefixLevelwise.levelwise_store_root!(workspace, graph)
    root_target = PrefixLevelwise.levelwise_target_color!(
        workspace, workspace.current_colors, 1, n
    )
    if iszero(root_target)
        println("PREFIX|", name, "|winner=", winner, "|n=", n, "|root_discrete=1")
        return nothing
    end

    first = measure_prefix_level!(workspace, graph, 1)
    if first.discrete
        println(
            "PREFIX|", name, "|winner=", winner, "|n=", n,
            "|l1_generated=", first.generated,
            "|l1_trace=", first.trace_survivors,
            "|l1_retained=", first.count,
            "|l1_mult=", first.quotient_multiplicity,
            "|l1_paths=", first.paths,
            "|l1_qdrop=", first.quotient_discards,
            "|l1_tlen=", first.trace_length,
            "|l1_discrete=1",
        )
        return nothing
    end

    second = measure_prefix_level!(workspace, graph, first.count)
    println(
        "PREFIX|", name, "|winner=", winner, "|n=", n,
        "|l1_generated=", first.generated,
        "|l1_trace=", first.trace_survivors,
        "|l1_retained=", first.count,
        "|l1_mult=", first.quotient_multiplicity,
        "|l1_paths=", first.paths,
        "|l1_qdrop=", first.quotient_discards,
        "|l1_tlen=", first.trace_length,
        "|l2_generated=", second.generated,
        "|l2_trace=", second.trace_survivors,
        "|l2_retained=", second.count,
        "|l2_mult=", second.quotient_multiplicity,
        "|l2_paths=", second.paths,
        "|l2_qdrop=", second.quotient_discards,
        "|l2_tlen=", second.trace_length,
        "|l2_discrete=", second.discrete ? 1 : 0,
    )
    return nothing
end

run_prefix_fixture("complete-9", "dfs", prefix_complete(9))
run_prefix_fixture("empty-9", "dfs", prefix_empty(9))
run_prefix_fixture("k6-6", "dfs", prefix_complete_bipartite(6, 6))
run_prefix_fixture("cycle-31", "dfs", prefix_cycle(31))
run_prefix_fixture("petersen", "dfs", prefix_petersen())
run_prefix_fixture("triangular-6", "levelwise", prefix_triangular(6))
run_prefix_fixture("rook-4", "levelwise", prefix_rook(4))
run_prefix_fixture("hypercube-5", "levelwise", prefix_hypercube(5))
run_prefix_fixture("paley-13", "dfs", prefix_paley13())
run_prefix_fixture("shrikhande", "dfs", prefix_shrikhande())
run_prefix_fixture("repeated-directed-c7x4", "component", prefix_repeated_directed_cycles(4, 7))
run_prefix_fixture("asymmetric-24", "dfs", prefix_asymmetric(24))
