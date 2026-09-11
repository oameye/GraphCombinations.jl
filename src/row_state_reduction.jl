# --- Isomorphism Reduction at Completed Row Boundaries ---

# Row-state quotienting has a fixed canonicalization cost. Same-run benchmarks show it becomes
# profitable once the labelled construction carries at least 24 internal relabelings (phi^4 order 4:
# 4! = 24), while a factor of 6 (phi^4 order 3) is still too small. Base the crossover on the actual
# degree-preserving label redundancy rather than raw vertex count so mixed-valence inputs do not pay
# for isomorphism reduction when there is little duplicate labelled work to remove.
const _ROW_REDUCTION_MIN_INTERNAL_PERMUTATIONS = 24

mutable struct RowReductionStats
    states::Int
    duplicate_states::Int
    canonicalization_calls::Int
    complete_topologies::Int
end

RowReductionStats() = RowReductionStats(0, 0, 0, 0)

function _row_state_colors(
    target_degrees::Vector{Int}, num_external::Int, row::Int
)::Vector{Int}
    colors = copy(target_degrees)
    isempty(colors) && return colors

    # Closed rows and the still-open suffix have different continuation rules. Encode that frontier
    # explicitly so the canonical state quotient never identifies partial graphs with inequivalent
    # extension spaces. External vertices remain individually fixed by `_partition_canonicalize`.
    open_offset = maximum(target_degrees) + 1
    @inbounds for vertex in (num_external + 1):length(colors)
        vertex >= row && (colors[vertex] += open_offset)
    end
    return colors
end

function _row_state_key(
    graph::GraphRep, target_degrees::Vector{Int}, num_external::Int, row::Int
)::PartitionCanonicalizationResult
    colors = _row_state_colors(target_degrees, num_external, row)
    return _partition_canonicalize(graph, colors, num_external)
end

function _foreach_row_reduced_multigraph(
    f::F, target_degrees::Vector{Int}, num_external::Int
) where {F}
    num_vertices = length(target_degrees)
    state_colors = [
        _row_state_colors(target_degrees, num_external, row) for row in 1:(num_vertices + 1)
    ]
    seen = [Set{GraphRep}() for _ in 1:(num_vertices + 1)]
    stats = RowReductionStats()
    residual = copy(target_degrees)
    graph = Edge[]
    _enumerate_reduced_vertex!(
        f, residual, graph, 1, num_external, state_colors, seen, stats
    )
    return stats
end

function _accept_row_state!(
    graph::GraphRep,
    row::Int,
    num_external::Int,
    state_colors::Vector{Vector{Int}},
    seen::Vector{Set{GraphRep}},
    stats::RowReductionStats,
)::Union{Nothing,PartitionCanonicalizationResult}
    stats.states += 1
    stats.canonicalization_calls += 1
    state = _partition_canonicalize(graph, state_colors[row], num_external)
    if state.key in seen[row]
        stats.duplicate_states += 1
        return nothing
    end
    push!(seen[row], state.key)
    return state
end

function _enumerate_reduced_vertex!(
    f::F,
    residual::Vector{Int},
    graph::GraphRep,
    row::Int,
    num_external::Int,
    state_colors::Vector{Vector{Int}},
    seen::Vector{Set{GraphRep}},
    stats::RowReductionStats,
) where {F}
    num_vertices = length(residual)
    state = _accept_row_state!(graph, row, num_external, state_colors, seen, stats)
    isnothing(state) && return nothing

    if row > num_vertices
        stats.complete_topologies += 1
        f(state)
        return nothing
    elseif row == num_vertices
        remaining = residual[row]
        iseven(remaining) || return nothing

        old_length = length(graph)
        loops = remaining ÷ 2
        for _ in 1:loops
            push!(graph, Edge(row, row))
        end
        residual[row] = 0
        _enumerate_reduced_vertex!(
            f, residual, graph, row + 1, num_external, state_colors, seen, stats
        )
        residual[row] = remaining
        resize!(graph, old_length)
        return nothing
    end

    degree_row = residual[row]
    future_capacity = sum(@view residual[(row + 1):end])
    for loops in 0:(degree_row ÷ 2)
        remaining = degree_row - 2loops
        remaining <= future_capacity || continue

        old_length = length(graph)
        for _ in 1:loops
            push!(graph, Edge(row, row))
        end
        _distribute_reduced_vertex_edges!(
            f,
            residual,
            graph,
            row,
            row + 1,
            remaining,
            num_external,
            state_colors,
            seen,
            stats,
        )
        resize!(graph, old_length)
    end
    return nothing
end

function _distribute_reduced_vertex_edges!(
    f::F,
    residual::Vector{Int},
    graph::GraphRep,
    row::Int,
    column::Int,
    remaining::Int,
    num_external::Int,
    state_colors::Vector{Vector{Int}},
    seen::Vector{Set{GraphRep}},
    stats::RowReductionStats,
) where {F}
    num_vertices = length(residual)
    if column > num_vertices
        if iszero(remaining)
            old_residual = residual[row]
            residual[row] = 0
            _enumerate_reduced_vertex!(
                f, residual, graph, row + 1, num_external, state_colors, seen, stats
            )
            residual[row] = old_residual
        end
        return nothing
    end

    capacity_after_column =
        column == num_vertices ? 0 : sum(@view residual[(column + 1):end])
    min_multiplicity = max(0, remaining - capacity_after_column)
    max_multiplicity = min(remaining, residual[column])
    min_multiplicity <= max_multiplicity || return nothing

    for multiplicity in min_multiplicity:max_multiplicity
        old_length = length(graph)
        residual[column] -= multiplicity
        for _ in 1:multiplicity
            push!(graph, Edge(row, column))
        end

        _distribute_reduced_vertex_edges!(
            f,
            residual,
            graph,
            row,
            column + 1,
            remaining - multiplicity,
            num_external,
            state_colors,
            seen,
            stats,
        )

        residual[column] += multiplicity
        resize!(graph, old_length)
    end
    return nothing
end

function _collect_topologies_row_reduced(
    degrees::Vector{Int}, num_external::Int, connected::Bool
)::Tuple{Dict{GraphRep,Int},RowReductionStats}
    num_vertices = length(degrees)
    internal_indices = (num_external + 1):num_vertices
    topologies = Dict{GraphRep,Int}()

    stats = _foreach_row_reduced_multigraph(degrees, num_external) do state
        graph = state.key
        if connected && !is_connected(build_internal_graph(graph, num_vertices))
            return nothing
        end

        # The complete row state is already an exact isomorphism key. Convert it to the package's
        # legacy public canonical label without rebuilding and sorting an edge vector for every
        # internal-label permutation; the winning sorted GraphRep is materialized only once.
        canonical = _canonical_form_multiplicity_permutations(graph, internal_indices)
        haskey(topologies, canonical) &&
            error("Internal error: row-state reduction generated a topology twice.")
        topologies[canonical] = state.automorphism_order
        return nothing
    end
    return topologies, stats
end

"""
    _allgraphs_row_reduced(n::Vector{Int}; connected=true)

Degree-constrained generator that quotients isomorphic partial states only after a full
upper-triangular multiplicity row has been fixed. The state equivalence includes the closed/open row
frontier as an exact vertex color, so only partial graphs with isomorphic continuation spaces are
identified.

This is deliberately coarser than edge-unit canonical augmentation: it retains the efficient residual
row recursion and amortizes partition canonicalization over a much larger construction step. The
hybrid production selector uses this path only when the degree-preserving internal relabeling factor
is large enough to amortize its fixed cost.
"""
function _allgraphs_row_reduced(n::Vector{Int}; connected=true)
    isodd(total_degree(n)) && return Vector{Tuple{GraphRep,BigInt}}()

    degrees = _vertex_degrees(n)
    isempty(degrees) && return Vector{Tuple{GraphRep,BigInt}}()

    topologies, _ = _collect_topologies_row_reduced(degrees, n[1], connected)
    results = Vector{Tuple{GraphRep,BigInt}}()
    sizehint!(results, length(topologies))
    for (graph, automorphism_order) in topologies
        symmetry_denominator = big(automorphism_order) * _edge_symmetry_factor(graph)
        push!(results, (graph, symmetry_denominator))
    end
    sort!(results; by=first)
    return results
end

@inline function _use_row_state_reduction(n::Vector{Int})::Bool
    return _internal_vertex_permutation_factor(n) >=
           _ROW_REDUCTION_MIN_INTERNAL_PERMUTATIONS
end

function _allgraphs_hybrid(n::Vector{Int}; connected=true)
    if _use_row_state_reduction(n)
        return _allgraphs_row_reduced(n; connected)
    end
    return _allgraphs_direct(n; connected)
end

function _row_reduction_stats(n::Vector{Int}; connected=true)
    isodd(total_degree(n)) && return RowReductionStats()
    degrees = _vertex_degrees(n)
    isempty(degrees) && return RowReductionStats()
    _, stats = _collect_topologies_row_reduced(degrees, n[1], connected)
    return stats
end
