# --- Compact weighted colored-port matching candidate ---

struct _CompactPortLayout
    num_vertices::Int
    num_source_colors::Int
    num_target_colors::Int
    edge_count::Int
    source_count::Int
    target_count::Int
    source_offset::Int
    target_offset::Int
    total_length::Int
end

function _CompactPortLayout(problem::_PortMatchingProblem)::_CompactPortLayout
    num_vertices = length(problem.vertex_colors)
    num_source_colors = size(problem.source_ports, 2)
    num_target_colors = size(problem.target_ports, 2)
    edge_count = num_vertices^2 * num_source_colors * num_target_colors
    source_count = num_vertices * num_source_colors
    target_count = num_vertices * num_target_colors
    source_offset = edge_count
    target_offset = source_offset + source_count
    return _CompactPortLayout(
        num_vertices,
        num_source_colors,
        num_target_colors,
        edge_count,
        source_count,
        target_count,
        source_offset,
        target_offset,
        target_offset + target_count,
    )
end

@inline function _compact_port_edge_index(
    layout::_CompactPortLayout,
    source_vertex::Int,
    target_vertex::Int,
    source_color::Int,
    target_color::Int,
)::Int
    return (
        (
            ((source_vertex - 1) * layout.num_vertices + (target_vertex - 1)) *
            layout.num_source_colors + (source_color - 1)
        ) * layout.num_target_colors + target_color
    )
end

@inline function _compact_source_local_index(
    layout::_CompactPortLayout, vertex::Int, color::Int
)::Int
    return vertex + (color - 1) * layout.num_vertices
end

@inline function _compact_target_local_index(
    layout::_CompactPortLayout, vertex::Int, color::Int
)::Int
    return vertex + (color - 1) * layout.num_vertices
end

struct _CompactPortAction
    edge_destinations::Vector{Int}
    source_destinations::Vector{Int}
    target_destinations::Vector{Int}
end

function _compact_port_actions(
    layout::_CompactPortLayout, automorphisms::Vector{Vector{Int}}
)::Vector{_CompactPortAction}
    actions = Vector{_CompactPortAction}(undef, length(automorphisms))
    for (action_index, mapping) in pairs(automorphisms)
        edge_destinations = Vector{Int}(undef, layout.edge_count)
        source_destinations = Vector{Int}(undef, layout.source_count)
        target_destinations = Vector{Int}(undef, layout.target_count)

        @inbounds for source_vertex in 1:layout.num_vertices
            for target_vertex in 1:layout.num_vertices
                for source_color in 1:layout.num_source_colors
                    for target_color in 1:layout.num_target_colors
                        old_index = _compact_port_edge_index(
                            layout, source_vertex, target_vertex, source_color, target_color
                        )
                        edge_destinations[old_index] = _compact_port_edge_index(
                            layout,
                            mapping[source_vertex],
                            mapping[target_vertex],
                            source_color,
                            target_color,
                        )
                    end
                end
            end
        end

        @inbounds for vertex in 1:layout.num_vertices
            mapped_vertex = mapping[vertex]
            for color in 1:layout.num_source_colors
                old_index = _compact_source_local_index(layout, vertex, color)
                source_destinations[old_index] = _compact_source_local_index(
                    layout, mapped_vertex, color
                )
            end
            for color in 1:layout.num_target_colors
                old_index = _compact_target_local_index(layout, vertex, color)
                target_destinations[old_index] = _compact_target_local_index(
                    layout, mapped_vertex, color
                )
            end
        end

        actions[action_index] = _CompactPortAction(
            edge_destinations, source_destinations, target_destinations
        )
    end
    return actions
end

function _compact_port_initial_data(
    problem::_PortMatchingProblem, layout::_CompactPortLayout
)::Vector{Int}
    data = zeros(Int, layout.total_length)
    @inbounds for vertex in 1:layout.num_vertices
        for color in 1:layout.num_source_colors
            local_index = _compact_source_local_index(layout, vertex, color)
            data[layout.source_offset + local_index] = problem.source_ports[vertex, color]
        end
        for color in 1:layout.num_target_colors
            local_index = _compact_target_local_index(layout, vertex, color)
            data[layout.target_offset + local_index] = problem.target_ports[vertex, color]
        end
    end
    return data
end

struct _CompactPortKey
    data::Vector{Int}
end

Base.isequal(a::_CompactPortKey, b::_CompactPortKey) = isequal(a.data, b.data)
Base.:(==)(a::_CompactPortKey, b::_CompactPortKey) = isequal(a, b)
Base.hash(key::_CompactPortKey, h::UInt) = hash(key.data, hash(_CompactPortKey, h))

function _write_compact_port_action!(
    destination::Vector{Int},
    source::Vector{Int},
    action::_CompactPortAction,
    layout::_CompactPortLayout,
)::Nothing
    @inbounds for old_index in 1:layout.edge_count
        destination[action.edge_destinations[old_index]] = source[old_index]
    end
    @inbounds for old_index in 1:layout.source_count
        destination[layout.source_offset + action.source_destinations[old_index]] = source[layout.source_offset + old_index]
    end
    @inbounds for old_index in 1:layout.target_count
        destination[layout.target_offset + action.target_destinations[old_index]] = source[layout.target_offset + old_index]
    end
    return nothing
end

function _compact_port_is_lexless(
    candidate::Vector{Int}, best::Vector{Int}, layout::_CompactPortLayout
)::Bool
    @inbounds for index in 1:layout.edge_count
        candidate_value = candidate[index]
        best_value = best[index]
        candidate_value == best_value && continue
        # Expanded sorted edge lists are lexicographically smaller when the first differing
        # edge slot occurs more often: the candidate repeats the smaller edge while the other
        # representation has already advanced to a larger edge.
        return candidate_value > best_value
    end
    @inbounds for index in (layout.source_offset + 1):layout.target_offset
        candidate_value = candidate[index]
        best_value = best[index]
        candidate_value == best_value && continue
        return candidate_value < best_value
    end
    @inbounds for index in (layout.target_offset + 1):layout.total_length
        candidate_value = candidate[index]
        best_value = best[index]
        candidate_value == best_value && continue
        return candidate_value < best_value
    end
    return false
end

function _canonicalize_compact_port_state(
    data::Vector{Int},
    actions::Vector{_CompactPortAction},
    layout::_CompactPortLayout,
    scratch::Vector{Int},
)::_CompactPortKey
    best = similar(data)
    _write_compact_port_action!(best, data, first(actions), layout)
    length(actions) == 1 && return _CompactPortKey(best)

    @inbounds for action_index in 2:length(actions)
        _write_compact_port_action!(scratch, data, actions[action_index], layout)
        if _compact_port_is_lexless(scratch, best, layout)
            copyto!(best, scratch)
        end
    end
    return _CompactPortKey(best)
end

function _first_remaining_compact_source(
    data::Vector{Int}, layout::_CompactPortLayout
)::_PortSourceCursor
    @inbounds for vertex in 1:layout.num_vertices
        for color in 1:layout.num_source_colors
            local_index = _compact_source_local_index(layout, vertex, color)
            data[layout.source_offset + local_index] > 0 &&
                return _PortSourceCursor(true, vertex, color)
        end
    end
    return _PortSourceCursor(false, 0, 0)
end

function _materialize_compact_port_edges(
    key::_CompactPortKey, layout::_CompactPortLayout
)::Vector{_PortEdge}
    num_edges = 0
    @inbounds for edge_index in 1:layout.edge_count
        num_edges += key.data[edge_index]
    end

    edges = Vector{_PortEdge}()
    sizehint!(edges, num_edges)
    @inbounds for source_vertex in 1:layout.num_vertices
        for target_vertex in 1:layout.num_vertices
            for source_color in 1:layout.num_source_colors
                for target_color in 1:layout.num_target_colors
                    edge_index = _compact_port_edge_index(
                        layout, source_vertex, target_vertex, source_color, target_color
                    )
                    multiplicity = key.data[edge_index]
                    for _ in 1:multiplicity
                        push!(
                            edges,
                            _PortEdge(
                                source_vertex, target_vertex, source_color, target_color
                            ),
                        )
                    end
                end
            end
        end
    end
    return edges
end

function _compact_port_targets_are_empty(
    key::_CompactPortKey, layout::_CompactPortLayout
)::Bool
    @inbounds for index in (layout.target_offset + 1):layout.total_length
        iszero(key.data[index]) || return false
    end
    return true
end

"""
Experimental allocation-reduced weighted colored-port traversal for the default multiplicity
transport. The existing `_weighted_port_matchings_with_stats` implementation remains the
independent correctness oracle until this path is fully certified and selected for production.
"""
function _weighted_port_matchings_compact_with_stats(
    problem::_PortMatchingProblem
)::Tuple{Vector{Tuple{Vector{_PortEdge},BigInt}},_PortGenerationStats}
    automorphisms = _port_automorphisms(problem)
    layout = _CompactPortLayout(problem)
    actions = _compact_port_actions(layout, automorphisms)
    initial_data = _compact_port_initial_data(problem, layout)
    canonical_scratch = similar(initial_data)
    initial_key = _canonicalize_compact_port_state(
        initial_data, actions, layout, canonical_scratch
    )

    states = Dict(initial_key => big(1))
    layer_states = Int[1]
    transitions = 0
    canonicalization_calls = 1
    merged_transitions = 0
    child = similar(initial_data)

    while true
        first_key = first(keys(states))
        first_source = _first_remaining_compact_source(first_key.data, layout)
        first_source.found || break

        next_states = Dict{_CompactPortKey,BigInt}()
        for (key, parent_weight) in states
            source = _first_remaining_compact_source(key.data, layout)
            source.found ||
                error("Internal error: compact port-matching layers are inconsistent.")
            source_vertex = source.vertex
            source_color = source.color
            source_local = _compact_source_local_index(layout, source_vertex, source_color)

            copyto!(child, key.data)
            child[layout.source_offset + source_local] -= 1

            @inbounds for target_vertex in 1:layout.num_vertices
                for target_color in 1:layout.num_target_colors
                    target_local = _compact_target_local_index(
                        layout, target_vertex, target_color
                    )
                    target_index = layout.target_offset + target_local
                    multiplicity = child[target_index]
                    iszero(multiplicity) && continue
                    problem.compatibility[
                        source_vertex, source_color, target_vertex, target_color
                    ] || continue

                    transitions += 1
                    edge_index = _compact_port_edge_index(
                        layout, source_vertex, target_vertex, source_color, target_color
                    )
                    child[target_index] -= 1
                    child[edge_index] += 1
                    canonical = _canonicalize_compact_port_state(
                        child, actions, layout, canonical_scratch
                    )
                    canonicalization_calls += 1
                    child_weight = parent_weight * multiplicity

                    if haskey(next_states, canonical)
                        next_states[canonical] += child_weight
                        merged_transitions += 1
                    else
                        next_states[canonical] = child_weight
                    end

                    child[edge_index] -= 1
                    child[target_index] += 1
                end
            end
        end

        push!(layer_states, length(next_states))
        if isempty(next_states)
            stats = _PortGenerationStats(
                length(automorphisms),
                layer_states,
                transitions,
                canonicalization_calls,
                merged_transitions,
            )
            return Tuple{Vector{_PortEdge},BigInt}[], stats
        end
        states = next_states
    end

    results = Tuple{Vector{_PortEdge},BigInt}[]
    sizehint!(results, length(states))
    for (key, weight) in states
        _compact_port_targets_are_empty(key, layout) ||
            error("Internal error: unmatched target ports remain at compact completion.")
        iszero(weight) ||
            push!(results, (_materialize_compact_port_edges(key, layout), weight))
    end
    sort!(results; lt=(a, b) -> _lexless_port_edges(first(a), first(b)))
    stats = _PortGenerationStats(
        length(automorphisms),
        layer_states,
        transitions,
        canonicalization_calls,
        merged_transitions,
    )
    return results, stats
end

function _weighted_port_matchings_compact(
    problem::_PortMatchingProblem
)::Vector{Tuple{Vector{_PortEdge},BigInt}}
    results, _ = _weighted_port_matchings_compact_with_stats(problem)
    return results
end
