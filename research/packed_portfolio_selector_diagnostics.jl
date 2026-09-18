import GraphCombinations as GC

function selector_bidirected(n::Int, undirected_edges::Vector{Pair{Int,Int}})
    directed = Pair{Int,Int}[]
    for edge in undirected_edges
        source = first(edge)
        target = last(edge)
        push!(directed, source => target)
        source == target || push!(directed, target => source)
    end
    return GC.DirectedGCGraph(directed, n)
end

function selector_complete(n::Int)
    edges = Pair{Int,Int}[]
    for left in 1:n, right in (left + 1):n
        push!(edges, left => right)
    end
    return selector_bidirected(n, edges), ones(Int, n)
end

selector_empty(n::Int) = (GC.DirectedGCGraph(Pair{Int,Int}[], n), ones(Int, n))

function selector_complete_bipartite(left_size::Int, right_size::Int)
    n = left_size + right_size
    edges = Pair{Int,Int}[]
    for left in 1:left_size, right in (left_size + 1):n
        push!(edges, left => right)
    end
    return selector_bidirected(n, edges), ones(Int, n)
end

function selector_cycle(n::Int)
    edges = Pair{Int,Int}[]
    for vertex in 1:(n - 1)
        push!(edges, vertex => (vertex + 1))
    end
    push!(edges, 1 => n)
    return selector_bidirected(n, edges), ones(Int, n)
end

function selector_petersen()
    edges = Pair{Int,Int}[]
    for vertex in 1:5
        push!(edges, vertex => mod1(vertex + 1, 5))
        push!(edges, vertex => (5 + vertex))
    end
    for vertex in 1:5
        push!(edges, (5 + vertex) => (5 + mod1(vertex + 2, 5)))
    end
    return selector_bidirected(10, edges), ones(Int, 10)
end

function selector_triangular(base_n::Int)
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
    return selector_bidirected(n, edges), ones(Int, n)
end

function selector_rook(size::Int)
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
    return selector_bidirected(n, edges), ones(Int, n)
end

function selector_hypercube(dimension::Int)
    n = 1 << dimension
    edges = Pair{Int,Int}[]
    for zero_vertex in 0:(n - 1)
        for bit in 0:(dimension - 1)
            neighbor = zero_vertex ⊻ (1 << bit)
            zero_vertex < neighbor || continue
            push!(edges, (zero_vertex + 1) => (neighbor + 1))
        end
    end
    return selector_bidirected(n, edges), ones(Int, n)
end

function selector_paley13()
    p = 13
    residues = Set((1, 3, 4, 9, 10, 12))
    edges = Pair{Int,Int}[]
    for zero_left in 0:(p - 1), zero_right in (zero_left + 1):(p - 1)
        difference = mod(zero_right - zero_left, p)
        difference in residues && push!(edges, (zero_left + 1) => (zero_right + 1))
    end
    return selector_bidirected(p, edges), ones(Int, p)
end

function selector_shrikhande()
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
    return selector_bidirected(n, edges), ones(Int, n)
end

function selector_repeated_directed_cycles(count::Int, size::Int)
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

function selector_asymmetric(n::Int)
    edges = Pair{Int,Int}[]
    for source in 1:n, target in 1:n
        source == target && continue
        value = mod(37source + 53target + 7source * target + 11source^2 + 3target^2, 97)
        value < 18 && push!(edges, source => target)
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function selector_partition_stats(
    workspace::GC.DirectedCanonicalizationWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
)::Tuple{Int,Int,Int,Int,Int}
    n = graph.num_vertices
    max_color = 0
    @inbounds for vertex in 1:n
        max_color = max(max_color, workspace.color_stack[vertex, depth])
    end
    cell_sizes = zeros(Int, max_color)
    @inbounds for vertex in 1:n
        cell_sizes[workspace.color_stack[vertex, depth]] += 1
    end
    nontrivial_cells = 0
    largest_cell = 0
    quadratic_mass = 0
    @inbounds for size in cell_sizes
        if size > 1
            nontrivial_cells += 1
            largest_cell = max(largest_cell, size)
            quadratic_mass += size * (size - 1) ÷ 2
        end
    end
    unresolved = n - max_color
    return max_color, unresolved, nontrivial_cells, largest_cell, quadratic_mass
end

function selector_target_mask(
    workspace::GC.DirectedCanonicalizationWorkspace,
    graph::GC.DirectedGCGraph,
    depth::Int,
    target_color::Int,
)::UInt64
    mask = UInt64(0)
    @inbounds for vertex in 1:graph.num_vertices
        workspace.color_stack[vertex, depth] == target_color || continue
        mask |= UInt64(1) << (vertex - 1)
    end
    return mask
end

function selector_exact_twin_pairs(graph::GC.DirectedGCGraph, mask::UInt64)::Int
    result = 0
    lefts = mask
    while !iszero(lefts)
        left = trailing_zeros(lefts) + 1
        lefts &= lefts - UInt64(1)
        rights = lefts
        while !iszero(rights)
            right = trailing_zeros(rights) + 1
            rights &= rights - UInt64(1)
            result += GC._directed_workspace_exact_twins(graph, left, right)
        end
    end
    return result
end

function selector_diagnostics(
    name::String,
    graph::GC.DirectedGCGraph,
    colors::Vector{Int},
    winner::String,
)::Nothing
    n = graph.num_vertices
    packed = GC.PackedDirectedCanonicalizationWorkspace(n)
    workspace = packed.workspace
    GC._prepare_packed_directed_rows!(packed, graph) || error("selector corpus requires simple n<=64 graph")
    @inbounds for vertex in 1:n
        workspace.colors[vertex] = colors[vertex]
    end
    GC._reset_directed_workspace_search!(workspace)
    packed.active_splitter_steps = 0
    packed.active_cell_splits = 0
    GC._directed_workspace_initialize_colors!(workspace, n)
    GC._packed_directed_workspace_refine!(packed, graph, 1)

    root_colors, root_unresolved, root_nontrivial, root_largest, root_mass =
        selector_partition_stats(workspace, graph, 1)
    root_rounds = workspace.refinement_rounds
    root_steps = packed.active_splitter_steps
    root_splits = packed.active_cell_splits
    root_target_color = GC._directed_workspace_target_color!(workspace, graph, 1)
    root_target_mask = iszero(root_target_color) ? UInt64(0) :
        selector_target_mask(workspace, graph, 1, root_target_color)
    root_target_size = count_ones(root_target_mask)
    root_twin_pairs = selector_exact_twin_pairs(graph, root_target_mask)

    child_colors = root_colors
    child_unresolved = root_unresolved
    child_nontrivial = root_nontrivial
    child_largest = root_largest
    child_mass = root_mass
    child_target_size = 0
    child_rounds = 0
    child_steps = 0
    child_splits = 0

    if !iszero(root_target_mask)
        chosen_vertex = trailing_zeros(root_target_mask) + 1
        child_depth = 2
        @inbounds for vertex in 1:n
            color = workspace.color_stack[vertex, 1]
            workspace.color_stack[vertex, child_depth] = if color < root_target_color
                color
            elseif color > root_target_color
                color + 1
            elseif vertex == chosen_vertex
                root_target_color
            else
                root_target_color + 1
            end
        end
        before_rounds = workspace.refinement_rounds
        before_steps = packed.active_splitter_steps
        before_splits = packed.active_cell_splits
        GC._packed_directed_workspace_refine!(packed, graph, child_depth)
        child_colors, child_unresolved, child_nontrivial, child_largest, child_mass =
            selector_partition_stats(workspace, graph, child_depth)
        child_rounds = workspace.refinement_rounds - before_rounds
        child_steps = packed.active_splitter_steps - before_steps
        child_splits = packed.active_cell_splits - before_splits
        child_target_color = GC._directed_workspace_target_color!(workspace, graph, child_depth)
        child_target_size = iszero(child_target_color) ? 0 : count_ones(
            selector_target_mask(workspace, graph, child_depth, child_target_color)
        )
    end

    println(
        "SELECTOR-DIAG|",
        name,
        "|winner=",
        winner,
        "|n=",
        n,
        "|root_colors=",
        root_colors,
        "|root_unresolved=",
        root_unresolved,
        "|root_nontrivial=",
        root_nontrivial,
        "|root_largest=",
        root_largest,
        "|root_mass=",
        root_mass,
        "|root_target=",
        root_target_size,
        "|root_twins=",
        root_twin_pairs,
        "|root_rounds=",
        root_rounds,
        "|root_steps=",
        root_steps,
        "|root_splits=",
        root_splits,
        "|child_colors=",
        child_colors,
        "|child_unresolved=",
        child_unresolved,
        "|child_nontrivial=",
        child_nontrivial,
        "|child_largest=",
        child_largest,
        "|child_mass=",
        child_mass,
        "|child_target=",
        child_target_size,
        "|child_rounds=",
        child_rounds,
        "|child_steps=",
        child_steps,
        "|child_splits=",
        child_splits,
        "|collapse=",
        root_unresolved - child_unresolved,
    )
    return nothing
end

selector_diagnostics("complete-9", selector_complete(9)..., "dfs")
selector_diagnostics("empty-9", selector_empty(9)..., "dfs")
selector_diagnostics("k6-6", selector_complete_bipartite(6, 6)..., "dfs")
selector_diagnostics("cycle-31", selector_cycle(31)..., "dfs")
selector_diagnostics("petersen", selector_petersen()..., "dfs")
selector_diagnostics("triangular-6", selector_triangular(6)..., "levelwise")
selector_diagnostics("rook-4", selector_rook(4)..., "levelwise")
selector_diagnostics("hypercube-5", selector_hypercube(5)..., "levelwise")
selector_diagnostics("paley-13", selector_paley13()..., "dfs")
selector_diagnostics("shrikhande", selector_shrikhande()..., "dfs")
selector_diagnostics("repeated-directed-c7x4", selector_repeated_directed_cycles(4, 7)..., "component")
selector_diagnostics("asymmetric-24", selector_asymmetric(24)..., "dfs")
