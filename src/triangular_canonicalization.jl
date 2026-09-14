# --- Precomputed triangular multiplicity actions ---

@inline function _triangular_multiplicity_index(u::Int, v::Int, num_vertices::Int)::Int
    first_vertex = min(u, v)
    second_vertex = max(u, v)
    before_row = ((first_vertex - 1) * (2 * num_vertices + 2 - first_vertex)) ÷ 2
    return before_row + second_vertex - first_vertex + 1
end

function _graph_triangular_multiplicities(graph::GraphRep, num_vertices::Int)::Vector{Int}
    multiplicities = zeros(Int, (num_vertices * (num_vertices + 1)) ÷ 2)
    @inbounds for edge in graph
        multiplicities[_triangular_multiplicity_index(
            edge.first, edge.second, num_vertices
        )] += 1
    end
    return multiplicities
end

function _triangular_relabeling_actions(
    mappings::Vector{Vector{Int}}, num_vertices::Int
)::Vector{Vector{Int}}
    actions = Vector{Vector{Int}}(undef, length(mappings))
    inverse_mapping = Vector{Int}(undef, num_vertices)

    for (mapping_index, mapping) in pairs(mappings)
        length(mapping) == num_vertices ||
            error("Internal error: triangular relabeling mapping has the wrong size.")
        _write_inverse_permutation!(inverse_mapping, mapping, 1)
        action = Vector{Int}(undef, (num_vertices * (num_vertices + 1)) ÷ 2)
        output_index = 1
        @inbounds for u in 1:num_vertices
            source_u = inverse_mapping[u]
            for v in u:num_vertices
                source_v = inverse_mapping[v]
                action[output_index] = _triangular_multiplicity_index(
                    source_u, source_v, num_vertices
                )
                output_index += 1
            end
        end
        actions[mapping_index] = action
    end
    return actions
end

@inline function _compare_triangular_actions(
    multiplicities::Vector{Int}, candidate_action::Vector{Int}, best_action::Vector{Int}
)::Int
    @inbounds for output_index in eachindex(candidate_action, best_action)
        candidate = multiplicities[candidate_action[output_index]]
        best = multiplicities[best_action[output_index]]
        candidate == best && continue
        return candidate > best ? -1 : 1
    end
    return 0
end

function _materialize_triangular_action(
    multiplicities::Vector{Int}, action::Vector{Int}, num_vertices::Int, num_edges::Int
)::GraphRep
    graph = Vector{Edge}(undef, num_edges)
    graph_index = 1
    output_index = 1
    @inbounds for u in 1:num_vertices
        for v in u:num_vertices
            multiplicity = multiplicities[action[output_index]]
            for _ in 1:multiplicity
                graph[graph_index] = Edge(u, v)
                graph_index += 1
            end
            output_index += 1
        end
    end
    graph_index == num_edges + 1 ||
        error("Internal error: triangular action changed the graph edge count.")
    return graph
end

function _canonicalize_under_triangular_actions(
    graph::GraphRep, actions::Vector{Vector{Int}}, num_vertices::Int
)::_MappedGraphCanonicalizationResult
    isempty(actions) && error("Internal error: triangular action group is empty.")

    multiplicities = _graph_triangular_multiplicities(graph, num_vertices)
    best_action_index = 1
    automorphism_order = 1
    for action_index in 2:length(actions)
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

    canonical = _materialize_triangular_action(
        multiplicities, actions[best_action_index], num_vertices, length(graph)
    )
    return _MappedGraphCanonicalizationResult(canonical, automorphism_order)
end

@inline function _triangular_multiplicity_bits(maximum_multiplicity::Int)::Int
    maximum_multiplicity >= 0 ||
        error("Internal error: multiplicity bound must be non-negative.")
    iszero(maximum_multiplicity) && return 1
    return 8 * sizeof(UInt) - leading_zeros(UInt(maximum_multiplicity))
end

@inline function _can_pack_triangular_key(
    num_vertices::Int, maximum_multiplicity::Int
)::Bool
    bits = _triangular_multiplicity_bits(maximum_multiplicity)
    slots = (num_vertices * (num_vertices + 1)) ÷ 2
    return slots <= 128 ÷ bits
end

@inline function _pack_triangular_action(
    multiplicities::Vector{Int}, action::Vector{Int}, bits::Int
)::UInt128
    key = UInt128(0)
    shift = 0
    @inbounds for source_index in action
        multiplicity = multiplicities[source_index]
        multiplicity >= 0 || error("Internal error: negative edge multiplicity.")
        key |= UInt128(multiplicity) << shift
        shift += bits
    end
    return key
end

struct _PackedTriangularCanonicalizationResult
    multiplicities::Vector{Int}
    key::UInt128
    best_action_index::Int
    automorphism_order::Int
end

function _canonicalize_packed_triangular_actions(
    graph::GraphRep, actions::Vector{Vector{Int}}, num_vertices::Int, bits::Int
)::_PackedTriangularCanonicalizationResult
    isempty(actions) && error("Internal error: triangular action group is empty.")

    multiplicities = _graph_triangular_multiplicities(graph, num_vertices)
    best_action_index = 1
    automorphism_order = 1
    for action_index in 2:length(actions)
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
    return _PackedTriangularCanonicalizationResult(
        multiplicities, key, best_action_index, automorphism_order
    )
end

function _materialize_packed_triangular_result(
    state::_PackedTriangularCanonicalizationResult,
    actions::Vector{Vector{Int}},
    num_vertices::Int,
    num_edges::Int,
)::_MappedGraphCanonicalizationResult
    canonical = _materialize_triangular_action(
        state.multiplicities, actions[state.best_action_index], num_vertices, num_edges
    )
    return _MappedGraphCanonicalizationResult(canonical, state.automorphism_order)
end
