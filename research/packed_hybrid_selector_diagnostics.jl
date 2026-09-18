import GraphCombinations as GC

function diag_cycle(n::Int)
    return GC.DirectedGCGraph([v => mod1(v + 1, n) for v in 1:n], n), ones(Int, n)
end

function diag_bidirectional_cycle(n::Int)
    edges = Pair{Int,Int}[]
    for v in 1:n
        w = mod1(v + 1, n)
        push!(edges, v => w)
        push!(edges, w => v)
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function diag_circulant(n::Int, offsets::Tuple{Vararg{Int}})
    edges = Pair{Int,Int}[]
    for source in 1:n, offset in offsets
        push!(edges, source => mod1(source + offset, n))
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function diag_fixed_star(n::Int)
    edges = Pair{Int,Int}[]
    for leaf in 2:n
        push!(edges, 1 => leaf)
        push!(edges, leaf => 1)
    end
    colors = ones(Int, n)
    colors[1] = 2
    return GC.DirectedGCGraph(edges, n), colors
end

function diag_paired_color_cycle(num_cells::Int)
    n = 2 * num_cells
    edges = Pair{Int,Int}[]
    for cell in 1:num_cells
        next_cell = mod1(cell + 1, num_cells)
        current = (2 * cell - 1, 2 * cell)
        following = (2 * next_cell - 1, 2 * next_cell)
        for source in current, target in following
            push!(edges, source => target)
        end
    end
    colors = repeat(collect(1:num_cells); inner=2)
    return GC.DirectedGCGraph(edges, n), colors
end

function diag_almost_discrete(n::Int)
    graph, _ = diag_circulant(n, (1, 5, 11))
    colors = collect(1:n)
    colors[n] = n - 1
    return graph, colors
end

function diag_cycle_product(sizes::Tuple{Vararg{Int}}; anchor::Bool=false)
    component_vertices = sum(sizes)
    n = component_vertices + (anchor ? 1 : 0)
    edges = Pair{Int,Int}[]
    colors = Vector{Int}(undef, n)
    offset = 0
    for (color, size) in enumerate(sizes)
        for local_vertex in 1:size
            source = offset + local_vertex
            target = offset + mod1(local_vertex + 1, size)
            push!(edges, source => target)
            colors[source] = color
        end
        offset += size
    end
    if anchor
        fixed = n
        colors[fixed] = length(sizes) + 1
        for vertex in 1:component_vertices
            push!(edges, fixed => vertex)
            push!(edges, vertex => fixed)
        end
    end
    return GC.DirectedGCGraph(edges, n), colors
end

function diag_circulant_product(
    components::Tuple{Vararg{Tuple{Int,Tuple{Vararg{Int}}}}}
)
    n = sum(first(component) for component in components)
    edges = Pair{Int,Int}[]
    colors = Vector{Int}(undef, n)
    offset = 0
    for (color, (size, offsets)) in enumerate(components)
        for local_source in 1:size
            source = offset + local_source
            colors[source] = color
            for delta in offsets
                target = offset + mod1(local_source + delta, size)
                push!(edges, source => target)
            end
        end
        offset += size
    end
    return GC.DirectedGCGraph(edges, n), colors
end

function post_root_signature(name::String, graph::GC.DirectedGCGraph, colors::Vector{Int})
    n = graph.num_vertices
    packed = GC.PackedDirectedCanonicalizationWorkspace(n)
    workspace = packed.workspace
    GC._prepare_packed_directed_rows!(packed, graph) || error("simple n<=64 fixture required")
    @inbounds for vertex in 1:n
        workspace.colors[vertex] = colors[vertex]
    end
    GC._reset_directed_workspace_search!(workspace)
    GC._directed_workspace_initialize_colors!(workspace, n)
    GC._packed_directed_workspace_refine!(packed, graph, 1)
    root_target = GC._directed_workspace_target_color!(workspace, graph, 1)

    if iszero(root_target)
        println("SIGNATURE|", name, "|discrete-root")
        return nothing
    end

    chosen = 0
    @inbounds for vertex in 1:n
        if workspace.color_stack[vertex, 1] == root_target
            chosen = vertex
            break
        end
    end
    child_depth = 2
    @inbounds for vertex in 1:n
        color = workspace.color_stack[vertex, 1]
        workspace.color_stack[vertex, child_depth] = if color < root_target
            color
        elseif color > root_target
            color + 1
        elseif vertex == chosen
            root_target
        else
            root_target + 1
        end
    end
    GC._packed_directed_workspace_refine!(packed, graph, child_depth)
    child_target = GC._directed_workspace_target_color!(workspace, graph, child_depth)

    max_color = 0
    @inbounds for vertex in 1:n
        max_color = max(max_color, workspace.color_stack[vertex, child_depth])
    end
    counts = zeros(Int, max_color)
    @inbounds for vertex in 1:n
        counts[workspace.color_stack[vertex, child_depth]] += 1
    end
    nonsingleton = sort!([count for count in counts if count > 1]; rev=true)
    unresolved_vertices = sum(nonsingleton; init=0)
    excess_vertices = sum((count - 1 for count in nonsingleton); init=0)
    max_cell = isempty(nonsingleton) ? 1 : first(nonsingleton)
    target_size = iszero(child_target) ? 1 : counts[child_target]
    symmetry_score = sum((count * count for count in nonsingleton); init=0)

    println(
        "SIGNATURE|",
        name,
        "|",
        length(nonsingleton),
        "|",
        unresolved_vertices,
        "|",
        excess_vertices,
        "|",
        max_cell,
        "|",
        target_size,
        "|",
        symmetry_score,
        "|",
        join(nonsingleton, ","),
    )
    return nothing
end

fixtures = (
    ("cycle-15", diag_cycle(15)...),
    ("bidirectional-cycle-15", diag_bidirectional_cycle(15)...),
    ("fixed-star-12", diag_fixed_star(12)...),
    ("paired-color-cycle-12", diag_paired_color_cycle(6)...),
    ("paired-color-cycle-24", diag_paired_color_cycle(12)...),
    ("circulant-24", diag_circulant(24, (1, 5, 7))...),
    ("circulant-40", diag_circulant(40, (1, 7, 13))...),
    ("almost-discrete-40", diag_almost_discrete(40)...),
    ("two-cycles-7x13", diag_cycle_product((7, 13))...),
    ("two-cycles-11x17", diag_cycle_product((11, 17))...),
    ("three-cycles-5x7x11", diag_cycle_product((5, 7, 11))...),
    ("three-cycles-7x11x13", diag_cycle_product((7, 11, 13))...),
    ("anchored-three-cycles-7x11x13", diag_cycle_product((7, 11, 13); anchor=true)...),
    ("four-cycles-5x7x11x13", diag_cycle_product((5, 7, 11, 13))...),
    (
        "three-circulants-7x11x13",
        diag_circulant_product(((7, (1, 3)), (11, (1, 4)), (13, (1, 5))))...,
    ),
    (
        "four-circulants-5x7x11x13",
        diag_circulant_product(
            ((5, (1, 2)), (7, (1, 3)), (11, (1, 4)), (13, (1, 5)))
        )...,
    ),
)

for (name, graph, colors) in fixtures
    post_root_signature(name, graph, colors)
end
