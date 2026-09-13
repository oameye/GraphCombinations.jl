"""
Statistics for the pruned colored-port traversal.

`pruned_transitions` counts admissible children rejected before canonicalization. The pruning
predicate is required to be invariant under admissibility-preserving vertex relabelings and
monotone under extension: once a state is rejected, no completion may become admissible again.
"""
struct _PrunedPortGenerationStats
    automorphisms::Int
    layer_states::Vector{Int}
    transitions::Int
    canonicalization_calls::Int
    merged_transitions::Int
    pruned_transitions::Int
end

"""
Generate weighted colored-port matchings while rejecting proven-invalid partial states before
canonicalization.

`keep_child` must define an automorphism-invariant, extension-monotone property. The generic
GraphCombinations backend does not assign any domain-specific meaning to the predicate.
"""
function _weighted_port_matchings_pruned_with_stats(
    problem::_PortMatchingProblem, keep_child::F
)::Tuple{Vector{Tuple{Vector{_PortEdge},BigInt}},_PrunedPortGenerationStats} where {F}
    return _weighted_port_matchings_pruned_with_stats(
        problem, keep_child, _MultiplicityPortTransport()
    )
end

function _weighted_port_matchings_pruned_with_stats(
    problem::_PortMatchingProblem, keep_child::F, transport::T
)::Tuple{Vector{Tuple{Vector{_PortEdge},BigInt}},_PrunedPortGenerationStats} where {F,T}
    automorphisms = _port_automorphisms(problem)
    initial = _PortMatchingState(
        _PortEdge[], copy(problem.source_ports), copy(problem.target_ports)
    )
    workspace = _PortCanonicalizationWorkspace(initial)
    initial_key, initial_state, initial_mapping = _canonicalize_port_state(
        initial, automorphisms, workspace
    )
    initial_weight = _initial_port_weight(
        transport, initial, initial_state, initial_mapping
    )
    states = Dict(initial_key => _WeightedPortState(initial_state, initial_weight))
    layer_states = Int[1]
    transitions = 0
    canonicalization_calls = 1
    merged_transitions = 0
    pruned_transitions = 0

    while true
        first_state = first(values(states)).state
        source_found, _, _ = _first_remaining_source(first_state)
        source_found || break

        next_states = Dict{_PortStateKey,_WeightedPortState}()
        for weighted in values(states)
            state = weighted.state
            source_found, source_vertex, source_color = _first_remaining_source(state)
            source_found || error("Internal error: port-matching layers are inconsistent.")

            @inbounds for target_vertex in axes(state.target_ports, 1)
                for target_color in axes(state.target_ports, 2)
                    multiplicity = state.target_ports[target_vertex, target_color]
                    iszero(multiplicity) && continue
                    problem.compatibility[
                        source_vertex, source_color, target_vertex, target_color
                    ] || continue

                    transitions += 1
                    child_sources = copy(state.source_ports)
                    child_targets = copy(state.target_ports)
                    child_edges = copy(state.edges)
                    child_sources[source_vertex, source_color] -= 1
                    child_targets[target_vertex, target_color] -= 1
                    push!(
                        child_edges,
                        _PortEdge(source_vertex, target_vertex, source_color, target_color),
                    )
                    child = _PortMatchingState(child_edges, child_sources, child_targets)
                    if !keep_child(child)
                        pruned_transitions += 1
                        continue
                    end

                    key, canonical, mapping = _canonicalize_port_state(
                        child, automorphisms, workspace
                    )
                    canonicalization_calls += 1
                    child_weight = _transport_port_weight(
                        transport, weighted.weight, multiplicity, child, canonical, mapping
                    )
                    merged_transitions += Int(
                        _accumulate_port_state!(next_states, key, canonical, child_weight)
                    )
                end
            end
        end

        push!(layer_states, length(next_states))
        if isempty(next_states)
            stats = _PrunedPortGenerationStats(
                length(automorphisms),
                layer_states,
                transitions,
                canonicalization_calls,
                merged_transitions,
                pruned_transitions,
            )
            return Tuple{Vector{_PortEdge},BigInt}[], stats
        end
        states = next_states
    end

    results = Tuple{Vector{_PortEdge},BigInt}[]
    sizehint!(results, length(states))
    for weighted in values(states)
        iszero(sum(weighted.state.target_ports)) ||
            error("Internal error: unmatched target ports remain at completion.")
        iszero(weighted.weight) || push!(results, (weighted.state.edges, weighted.weight))
    end
    sort!(results; lt=(a, b) -> _lexless_port_edges(first(a), first(b)))
    stats = _PrunedPortGenerationStats(
        length(automorphisms),
        layer_states,
        transitions,
        canonicalization_calls,
        merged_transitions,
        pruned_transitions,
    )
    return results, stats
end
