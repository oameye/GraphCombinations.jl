using BenchmarkTools
import GraphCombinations as GC

const VARIANT = get(ENV, "GC_VARIANT", "unknown")

if VARIANT == "candidate"
    @eval GC begin
        @inline function _research_prefix_column_less(
            packed::PackedDirectedCanonicalizationWorkspace,
            left::Int,
            right::Int,
            prefix_rows::Int,
        )::Bool
            left == right && return false
            left_bit = _packed_directed_vertex_bit(left)
            right_bit = _packed_directed_vertex_bit(right)
            @inbounds for source_position in 1:prefix_rows
                source_mask = packed.cell_masks[source_position]
                source = trailing_zeros(source_mask) + 1
                row = packed.out_rows[source]
                left_value = !iszero(row & left_bit)
                right_value = !iszero(row & right_bit)
                left_value == right_value && continue
                return !left_value && right_value
            end
            return left < right
        end

        function _packed_directed_canonical_prefix_prunable!(
            packed::PackedDirectedCanonicalizationWorkspace,
            graph::DirectedGCGraph,
            num_colors::Int,
        )::Bool
            workspace = packed.workspace
            workspace.has_best || return false

            prefix_rows = 0
            @inbounds for color in 1:num_colors
                count_ones(packed.cell_masks[color]) == 1 || break
                prefix_rows += 1
            end
            iszero(prefix_rows) && return false
            packed.canonical_prefix_checks += 1

            target_position = 0
            @inbounds for target_color in 1:num_colors
                cell_mask = packed.cell_masks[target_color]
                cell_start = target_position + 1
                members = cell_mask
                while !iszero(members)
                    vertex = trailing_zeros(members) + 1
                    target_position += 1
                    workspace.order[target_position] = vertex
                    members &= members - UInt64(1)
                end

                for index in (cell_start + 1):target_position
                    vertex = workspace.order[index]
                    position = index - 1
                    while position >= cell_start && _research_prefix_column_less(
                        packed, vertex, workspace.order[position], prefix_rows
                    )
                        workspace.order[position + 1] = workspace.order[position]
                        position -= 1
                    end
                    workspace.order[position + 1] = vertex
                end
            end

            n = graph.num_vertices
            @inbounds for source_position in 1:prefix_rows
                source = trailing_zeros(packed.cell_masks[source_position]) + 1
                candidate_row = packed.out_rows[source]
                best_source = workspace.best_inverse_mapping[source_position]
                best_row = packed.out_rows[best_source]
                for position in 1:n
                    target = workspace.order[position]
                    candidate_value = !iszero(
                        candidate_row & _packed_directed_vertex_bit(target)
                    )
                    best_target = workspace.best_inverse_mapping[position]
                    best_value = !iszero(best_row & _packed_directed_vertex_bit(best_target))
                    candidate_value == best_value && continue
                    if candidate_value && !best_value
                        packed.canonical_prefix_prunes += 1
                        return true
                    end
                    return false
                end
            end
            return false
        end
    end
end

function directed_cycle(n::Int)
    return GC.DirectedGCGraph([v => mod1(v + 1, n) for v in 1:n], n), ones(Int, n)
end

function bidirectional_cycle(n::Int)
    edges = Pair{Int,Int}[]
    for v in 1:n
        w = mod1(v + 1, n)
        push!(edges, v => w)
        push!(edges, w => v)
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function fixed_star(n::Int)
    edges = Pair{Int,Int}[]
    for leaf in 2:n
        push!(edges, 1 => leaf)
        push!(edges, leaf => 1)
    end
    colors = ones(Int, n)
    colors[1] = 2
    return GC.DirectedGCGraph(edges, n), colors
end

function paired_color_cycle(num_cells::Int)
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

function circulant(n::Int, offsets::Tuple{Vararg{Int}})
    edges = Pair{Int,Int}[]
    for source in 1:n, offset in offsets
        push!(edges, source => mod1(source + offset, n))
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function almost_discrete(n::Int)
    graph, _ = circulant(n, (1, 5, 11))
    colors = collect(1:n)
    colors[n - 1] = n - 1
    colors[n] = n - 1
    return graph, colors
end

function two_permutation_regular(permutation::Vector{Int})
    n = length(permutation)
    sort(permutation) == collect(1:n) || error("fixture permutation must be bijective")
    edges = Pair{Int,Int}[]
    for source in 1:n
        first_target = mod1(source + 1, n)
        second_target = permutation[source]
        first_target == second_target && error("fixture contains a repeated edge")
        push!(edges, source => first_target)
        push!(edges, source => second_target)
    end
    return GC.DirectedGCGraph(edges, n), ones(Int, n)
end

function certify_research_override()::Nothing
    VARIANT == "candidate" || return nothing
    general_workspace = GC.DirectedCanonicalizationWorkspace(3)
    packed_workspace = GC.PackedDirectedCanonicalizationWorkspace(3)
    general_buffer = GC.DirectedCanonicalizationBuffer(3)
    packed_buffer = GC.DirectedCanonicalizationBuffer(3)
    colorings = (Int[1, 1, 1], Int[1, 1, 2], Int[1, 2, 3])

    for mask in 0:(2 ^ 9 - 1)
        edges = Pair{Int,Int}[]
        bit = 0
        for source in 1:3, target in 1:3
            isodd(mask >> bit) && push!(edges, source => target)
            bit += 1
        end
        graph = GC.DirectedGCGraph(edges, 3)
        for colors in colorings
            GC.canonicalize_directed!(general_buffer, general_workspace, graph, colors)
            GC.canonicalize_directed_packed!(
                packed_buffer, packed_workspace, graph, colors
            )
            GC.canonical_graph(packed_buffer) == GC.canonical_graph(general_buffer) ||
                error("research prefix override changed the canonical image")
            GC.canonical_automorphism_order(packed_buffer) ==
                GC.canonical_automorphism_order(general_buffer) ||
                error("research prefix override changed the automorphism order")
            for vertex in 1:3
                GC.canonical_rank(packed_buffer, vertex) ==
                    GC.canonical_rank(general_buffer, vertex) ||
                    error("research prefix override changed the canonical witness")
            end
        end
    end
    return nothing
end

function metric(workspace, name::Symbol)
    return hasproperty(workspace, name) ? getproperty(workspace, name) : -1
end

function benchmark_fixture(name::String, graph::GC.DirectedGCGraph, colors::Vector{Int})
    n = graph.num_vertices
    workspace = GC.PackedDirectedCanonicalizationWorkspace(n)
    buffer = GC.DirectedCanonicalizationBuffer(n)
    GC.canonicalize_directed_packed!(buffer, workspace, graph, colors)

    trial = @benchmark GC.canonicalize_directed_packed!(
        $buffer, $workspace, $graph, $colors
    ) samples = 180 seconds = 1 evals = 1
    estimate = minimum(trial)
    search = workspace.workspace

    println(
        "RESULT|",
        VARIANT,
        "|",
        name,
        "|",
        n,
        "|",
        estimate.time,
        "|",
        estimate.memory,
        "|",
        estimate.allocs,
        "|",
        search.search_nodes,
        "|",
        search.search_leaves,
        "|",
        search.refinement_rounds,
        "|",
        metric(workspace, :active_splitter_steps),
        "|",
        metric(workspace, :active_cell_splits),
        "|",
        metric(workspace, :canonical_prefix_checks),
        "|",
        metric(workspace, :canonical_prefix_prunes),
    )
    return nothing
end

certify_research_override()

fixtures = (
    ("cycle-15", directed_cycle(15)...),
    ("bidirectional-cycle-15", bidirectional_cycle(15)...),
    ("fixed-star-12", fixed_star(12)...),
    ("paired-color-cycle-12", paired_color_cycle(6)...),
    ("paired-color-cycle-24", paired_color_cycle(12)...),
    ("circulant-24", circulant(24, (1, 5, 7))...),
    ("circulant-40", circulant(40, (1, 7, 13))...),
    ("almost-discrete-40", almost_discrete(40)...),
    (
        "two-permutation-12",
        two_permutation_regular([4, 7, 10, 1, 12, 2, 9, 5, 3, 6, 11, 8])...,
    ),
    (
        "two-permutation-16",
        two_permutation_regular([5, 9, 13, 1, 7, 12, 16, 4, 14, 3, 8, 15, 6, 11, 2, 10])...,
    ),
)

for (name, graph, colors) in fixtures
    benchmark_fixture(name, graph, colors)
end
