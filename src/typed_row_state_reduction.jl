# --- Exact continuation-state reduction for typed multigraph problems ---

mutable struct TypedRowReductionStats
    states::Int
    duplicate_states::Int
    canonicalization_calls::Int
    complete_topologies::Int
end

TypedRowReductionStats() = TypedRowReductionStats(0, 0, 0, 0)

@inline function _typed_mapping_preserves_frontier(mapping::Vector{Int}, row::Int)::Bool
    @inbounds for vertex in eachindex(mapping)
        (vertex < row) == (mapping[vertex] < row) || return false
    end
    return true
end

function _typed_row_state_mappings(
    mappings::Vector{Vector{Int}}, num_vertices::Int
)::Vector{Vector{Vector{Int}}}
    states = Vector{Vector{Vector{Int}}}(undef, num_vertices + 1)
    for row in 1:(num_vertices + 1)
        row_mappings = Vector{Vector{Int}}()
        sizehint!(row_mappings, length(mappings))
        for mapping in mappings
            _typed_mapping_preserves_frontier(mapping, row) && push!(row_mappings, mapping)
        end
        isempty(row_mappings) &&
            error("Internal error: typed row-state mapping group is empty.")
        states[row] = row_mappings
    end
    return states
end

function _accept_typed_row_state!(
    graph::GraphRep,
    row::Int,
    row_mappings::Vector{Vector{Vector{Int}}},
    seen::Vector{Set{GraphRep}},
    stats::TypedRowReductionStats,
)::Tuple{Bool,_MappedGraphCanonicalizationResult}
    stats.states += 1
    stats.canonicalization_calls += 1
    state = _canonicalize_under_mappings(graph, row_mappings[row])
    if state.canonical in seen[row]
        stats.duplicate_states += 1
        return false, state
    end
    push!(seen[row], state.canonical)
    return true, state
end

function _foreach_typed_row_reduced_multigraph(
    f::F, problem::TypedMultigraphProblem
) where {F}
    num_vertices = length(problem._degrees)
    mappings = _typed_problem_relabelings(problem)
    row_mappings = _typed_row_state_mappings(mappings, num_vertices)
    seen = [Set{GraphRep}() for _ in 1:(num_vertices + 1)]
    stats = TypedRowReductionStats()
    residual = copy(problem._degrees)
    graph = Edge[]
    _enumerate_typed_reduced_vertex!(
        f, residual, graph, problem._allowed, 1, row_mappings, seen, stats
    )
    return stats
end

function _enumerate_typed_reduced_vertex!(
    f::F,
    residual::Vector{Int},
    graph::GraphRep,
    allowed::BitMatrix,
    row::Int,
    row_mappings::Vector{Vector{Vector{Int}}},
    seen::Vector{Set{GraphRep}},
    stats::TypedRowReductionStats,
) where {F}
    num_vertices = length(residual)
    accepted, state = _accept_typed_row_state!(graph, row, row_mappings, seen, stats)
    accepted || return nothing

    if row > num_vertices
        stats.complete_topologies += 1
        f(state)
        return nothing
    elseif row == num_vertices
        remaining = residual[row]
        iseven(remaining) || return nothing
        (!iszero(remaining) && !allowed[row, row]) && return nothing

        old_length = length(graph)
        for _ in 1:(remaining ÷ 2)
            push!(graph, Edge(row, row))
        end
        residual[row] = 0
        _enumerate_typed_reduced_vertex!(
            f, residual, graph, allowed, row + 1, row_mappings, seen, stats
        )
        residual[row] = remaining
        resize!(graph, old_length)
        return nothing
    end

    degree_row = residual[row]
    loop_range = allowed[row, row] ? (0:(degree_row ÷ 2)) : (0:0)
    future_capacity = _admissible_future_capacity(residual, allowed, row, row + 1)
    for loops in loop_range
        remaining = degree_row - 2loops
        remaining <= future_capacity || continue

        old_length = length(graph)
        for _ in 1:loops
            push!(graph, Edge(row, row))
        end
        _distribute_typed_reduced_vertex_edges!(
            f, residual, graph, allowed, row, row + 1, remaining, row_mappings, seen, stats
        )
        resize!(graph, old_length)
    end
    return nothing
end

function _distribute_typed_reduced_vertex_edges!(
    f::F,
    residual::Vector{Int},
    graph::GraphRep,
    allowed::BitMatrix,
    row::Int,
    column::Int,
    remaining::Int,
    row_mappings::Vector{Vector{Vector{Int}}},
    seen::Vector{Set{GraphRep}},
    stats::TypedRowReductionStats,
) where {F}
    num_vertices = length(residual)
    if column > num_vertices
        if iszero(remaining)
            old_residual = residual[row]
            residual[row] = 0
            _enumerate_typed_reduced_vertex!(
                f, residual, graph, allowed, row + 1, row_mappings, seen, stats
            )
            residual[row] = old_residual
        end
        return nothing
    end

    capacity_after_column = if column == num_vertices
        0
    else
        _admissible_future_capacity(residual, allowed, row, column + 1)
    end
    if !allowed[row, column]
        remaining <= capacity_after_column || return nothing
        _distribute_typed_reduced_vertex_edges!(
            f,
            residual,
            graph,
            allowed,
            row,
            column + 1,
            remaining,
            row_mappings,
            seen,
            stats,
        )
        return nothing
    end

    min_multiplicity = max(0, remaining - capacity_after_column)
    max_multiplicity = min(remaining, residual[column])
    min_multiplicity <= max_multiplicity || return nothing
    for multiplicity in min_multiplicity:max_multiplicity
        old_length = length(graph)
        residual[column] -= multiplicity
        for _ in 1:multiplicity
            push!(graph, Edge(row, column))
        end
        _distribute_typed_reduced_vertex_edges!(
            f,
            residual,
            graph,
            allowed,
            row,
            column + 1,
            remaining - multiplicity,
            row_mappings,
            seen,
            stats,
        )
        residual[column] += multiplicity
        resize!(graph, old_length)
    end
    return nothing
end

function _collect_typed_row_reduced(
    problem::TypedMultigraphProblem, connected::Bool
)::Tuple{Dict{GraphRep,Int},TypedRowReductionStats}
    num_vertices = length(problem._degrees)
    topologies = Dict{GraphRep,Int}()
    stats = _foreach_typed_row_reduced_multigraph(problem) do state
        graph = state.canonical
        if connected && !is_connected(build_internal_graph(graph, num_vertices))
            return nothing
        end
        haskey(topologies, graph) &&
            error("Internal error: typed row-state reduction generated a topology twice.")
        topologies[graph] = state.automorphism_order
        return nothing
    end
    return topologies, stats
end

function _generate_typed_row_reduced(
    problem::TypedMultigraphProblem; connected::Bool=true
)::Vector{Tuple{GraphRep,BigInt}}
    isempty(problem._degrees) && return Vector{Tuple{GraphRep,BigInt}}()
    isodd(sum(problem._degrees)) && return Vector{Tuple{GraphRep,BigInt}}()

    topologies, _ = _collect_typed_row_reduced(problem, connected)
    results = Vector{Tuple{GraphRep,BigInt}}()
    sizehint!(results, length(topologies))
    for (graph, automorphism_order) in topologies
        push!(results, (graph, big(automorphism_order) * _edge_symmetry_factor(graph)))
    end
    sort!(results; by=first)
    return results
end

function _typed_row_reduction_stats(
    problem::TypedMultigraphProblem; connected::Bool=true
)::TypedRowReductionStats
    isempty(problem._degrees) && return TypedRowReductionStats()
    isodd(sum(problem._degrees)) && return TypedRowReductionStats()
    _, stats = _collect_typed_row_reduced(problem, connected)
    return stats
end
