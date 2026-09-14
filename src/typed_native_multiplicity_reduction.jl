# --- Native triangular multiplicity recursion for typed multigraph problems ---

@inline function _canonicalize_native_triangular_state(
    multiplicities::Vector{Int}, actions::Vector{Vector{Int}}, bits::Int
)::Tuple{UInt128,Int,Int}
    isempty(actions) && error("Internal error: triangular action group is empty.")

    best_action_index = 1
    automorphism_order = 1
    @inbounds for action_index in 2:length(actions)
        comparison = _compare_triangular_actions(
            multiplicities, actions[action_index], actions[best_action_index]
        )
        if comparison < 0
            best_action_index = action_index
            automorphism_order = 1
        elseif iszero(comparison)
            automorphism_order = _checked_increment(automorphism_order)
        end
    end

    key = _pack_triangular_action(multiplicities, actions[best_action_index], bits)
    return key, best_action_index, automorphism_order
end

@inline function _accept_typed_native_row_state!(
    multiplicities::Vector{Int},
    row::Int,
    row_actions::Vector{Vector{Vector{Int}}},
    bits::Int,
    seen::Vector{Set{UInt128}},
    stats::TypedRowReductionStats,
)::Tuple{Bool,Int,Int}
    stats.states += 1
    stats.canonicalization_calls += 1
    key, best_action_index, automorphism_order = _canonicalize_native_triangular_state(
        multiplicities, row_actions[row], bits
    )
    if key in seen[row]
        stats.duplicate_states += 1
        return false, best_action_index, automorphism_order
    end
    push!(seen[row], key)
    return true, best_action_index, automorphism_order
end

function _foreach_typed_native_multiplicity_multigraph(
    f::F, problem::TypedMultigraphProblem
) where {F}
    num_vertices = length(problem._degrees)
    maximum_multiplicity = maximum(problem._degrees; init=0)
    _can_pack_triangular_key(num_vertices, maximum_multiplicity) || error(
        "Internal error: typed problem does not fit the native packed continuation-key representation.",
    )

    bits = _triangular_multiplicity_bits(maximum_multiplicity)
    mappings = _typed_problem_relabelings(problem)
    row_actions = _typed_row_state_actions(mappings, num_vertices)
    seen = [Set{UInt128}() for _ in 1:(num_vertices + 1)]
    stats = TypedRowReductionStats()
    residual = copy(problem._degrees)
    multiplicities = zeros(Int, (num_vertices * (num_vertices + 1)) ÷ 2)
    _enumerate_typed_native_vertex!(
        f,
        residual,
        multiplicities,
        problem._allowed,
        1,
        row_actions,
        num_vertices,
        bits,
        seen,
        stats,
    )
    return stats
end

function _enumerate_typed_native_vertex!(
    f::F,
    residual::Vector{Int},
    multiplicities::Vector{Int},
    allowed::BitMatrix,
    row::Int,
    row_actions::Vector{Vector{Vector{Int}}},
    num_vertices::Int,
    bits::Int,
    seen::Vector{Set{UInt128}},
    stats::TypedRowReductionStats,
) where {F}
    accepted, best_action_index, automorphism_order = _accept_typed_native_row_state!(
        multiplicities, row, row_actions, bits, seen, stats
    )
    accepted || return nothing

    if row > num_vertices
        stats.complete_topologies += 1
        graph = _materialize_triangular_action(
            multiplicities,
            row_actions[row][best_action_index],
            num_vertices,
            sum(multiplicities),
        )
        f(_MappedGraphCanonicalizationResult(graph, automorphism_order))
        return nothing
    elseif row == num_vertices
        remaining = residual[row]
        iseven(remaining) || return nothing
        (!iszero(remaining) && !allowed[row, row]) && return nothing

        slot = _triangular_multiplicity_index(row, row, num_vertices)
        loops = remaining ÷ 2
        multiplicities[slot] += loops
        residual[row] = 0
        _enumerate_typed_native_vertex!(
            f,
            residual,
            multiplicities,
            allowed,
            row + 1,
            row_actions,
            num_vertices,
            bits,
            seen,
            stats,
        )
        residual[row] = remaining
        multiplicities[slot] -= loops
        return nothing
    end

    degree_row = residual[row]
    loop_range = allowed[row, row] ? (0:(degree_row ÷ 2)) : (0:0)
    future_capacity = _admissible_future_capacity(residual, allowed, row, row + 1)
    loop_slot = _triangular_multiplicity_index(row, row, num_vertices)
    for loops in loop_range
        remaining = degree_row - 2loops
        remaining <= future_capacity || continue

        multiplicities[loop_slot] += loops
        _distribute_typed_native_edges!(
            f,
            residual,
            multiplicities,
            allowed,
            row,
            row + 1,
            remaining,
            row_actions,
            num_vertices,
            bits,
            seen,
            stats,
        )
        multiplicities[loop_slot] -= loops
    end
    return nothing
end

function _distribute_typed_native_edges!(
    f::F,
    residual::Vector{Int},
    multiplicities::Vector{Int},
    allowed::BitMatrix,
    row::Int,
    column::Int,
    remaining::Int,
    row_actions::Vector{Vector{Vector{Int}}},
    num_vertices::Int,
    bits::Int,
    seen::Vector{Set{UInt128}},
    stats::TypedRowReductionStats,
) where {F}
    if column > num_vertices
        if iszero(remaining)
            old_residual = residual[row]
            residual[row] = 0
            _enumerate_typed_native_vertex!(
                f,
                residual,
                multiplicities,
                allowed,
                row + 1,
                row_actions,
                num_vertices,
                bits,
                seen,
                stats,
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
        _distribute_typed_native_edges!(
            f,
            residual,
            multiplicities,
            allowed,
            row,
            column + 1,
            remaining,
            row_actions,
            num_vertices,
            bits,
            seen,
            stats,
        )
        return nothing
    end

    min_multiplicity = max(0, remaining - capacity_after_column)
    max_multiplicity = min(remaining, residual[column])
    min_multiplicity <= max_multiplicity || return nothing
    slot = _triangular_multiplicity_index(row, column, num_vertices)
    for multiplicity in min_multiplicity:max_multiplicity
        residual[column] -= multiplicity
        multiplicities[slot] += multiplicity
        _distribute_typed_native_edges!(
            f,
            residual,
            multiplicities,
            allowed,
            row,
            column + 1,
            remaining - multiplicity,
            row_actions,
            num_vertices,
            bits,
            seen,
            stats,
        )
        multiplicities[slot] -= multiplicity
        residual[column] += multiplicity
    end
    return nothing
end

function _collect_typed_native_multiplicity(
    problem::TypedMultigraphProblem, connected::Bool
)::Tuple{Dict{GraphRep,Int},TypedRowReductionStats}
    num_vertices = length(problem._degrees)
    num_edges = sum(problem._degrees) ÷ 2
    topologies = Dict{GraphRep,Int}()
    stats = _foreach_typed_native_multiplicity_multigraph(problem) do state
        graph = state.canonical
        length(graph) == num_edges || error(
            "Internal error: native multiplicity recursion changed the graph edge count.",
        )
        if connected && !is_connected(build_internal_graph(graph, num_vertices))
            return nothing
        end
        haskey(topologies, graph) && error(
            "Internal error: native typed row-state reduction generated a topology twice.",
        )
        topologies[graph] = state.automorphism_order
        return nothing
    end
    return topologies, stats
end

function _generate_typed_native_multiplicity(
    problem::TypedMultigraphProblem; connected::Bool=true
)::Vector{Tuple{GraphRep,BigInt}}
    isempty(problem._degrees) && return Vector{Tuple{GraphRep,BigInt}}()
    isodd(sum(problem._degrees)) && return Vector{Tuple{GraphRep,BigInt}}()

    num_vertices = length(problem._degrees)
    maximum_multiplicity = maximum(problem._degrees; init=0)
    if !_can_pack_triangular_key(num_vertices, maximum_multiplicity)
        return _generate_typed_packed_row_reduced(problem; connected)
    end

    topologies, _ = _collect_typed_native_multiplicity(problem, connected)
    results = Vector{Tuple{GraphRep,BigInt}}()
    sizehint!(results, length(topologies))
    for (graph, automorphism_order) in topologies
        push!(results, (graph, big(automorphism_order) * _edge_symmetry_factor(graph)))
    end
    sort!(results; by=first)
    return results
end
