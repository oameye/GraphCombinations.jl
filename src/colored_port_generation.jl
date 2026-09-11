# --- Weighted colored port matching ---

"""
Internal directed edge used by the colored-port research generator.

`source_color` and `target_color` are opaque integer port colors. Their physical meaning is
owned by the caller; the generator only preserves them under vertex relabeling.
"""
struct _PortEdge
    source::Int
    target::Int
    source_color::Int
    target_color::Int
end

function Base.isequal(a::_PortEdge, b::_PortEdge)
    return a.source == b.source &&
           a.target == b.target &&
           a.source_color == b.source_color &&
           a.target_color == b.target_color
end
Base.:(==)(a::_PortEdge, b::_PortEdge) = isequal(a, b)
function Base.hash(edge::_PortEdge, h::UInt)
    return hash(
        edge.target_color,
        hash(edge.source_color, hash(edge.target, hash(edge.source, hash(_PortEdge, h)))),
    )
end
function Base.isless(a::_PortEdge, b::_PortEdge)
    a.source == b.source || return a.source < b.source
    a.target == b.target || return a.target < b.target
    a.source_color == b.source_color || return a.source_color < b.source_color
    return a.target_color < b.target_color
end

"""
Internal specification for a directed colored-port matching problem.

Rows of `source_ports` and `target_ports` are vertices; columns are opaque source/target port
colors. `compatibility[vₛ, cₛ, vₜ, cₜ]` is the complete pair-local admissibility relation. The
first `num_fixed` vertices are fixed individually. Remaining vertices may be relabeled only within
equal `vertex_colors`, and only by permutations preserving the admissibility relation.
"""
struct _PortMatchingProblem
    vertex_colors::Vector{Int}
    source_ports::Matrix{Int}
    target_ports::Matrix{Int}
    compatibility::BitArray{4}
    num_fixed::Int

    function _PortMatchingProblem(
        vertex_colors::AbstractVector{<:Integer},
        source_ports::AbstractMatrix{<:Integer},
        target_ports::AbstractMatrix{<:Integer},
        compatibility::AbstractArray{Bool,4},
        num_fixed::Integer=0,
    )
        colors = collect(Int, vertex_colors)
        sources = Matrix{Int}(source_ports)
        targets = Matrix{Int}(target_ports)
        compatible = BitArray(compatibility)

        num_vertices = length(colors)
        size(sources, 1) == num_vertices ||
            throw(ArgumentError("source-port rows must match the number of vertices."))
        size(targets, 1) == num_vertices ||
            throw(ArgumentError("target-port rows must match the number of vertices."))
        size(compatible) ==
        (num_vertices, size(sources, 2), num_vertices, size(targets, 2)) || throw(
            ArgumentError(
                "compatibility dimensions must be vertex/source-color/vertex/target-color.",
            ),
        )
        any(x -> x < 0, sources) &&
            throw(ArgumentError("source-port counts must be non-negative."))
        any(x -> x < 0, targets) &&
            throw(ArgumentError("target-port counts must be non-negative."))
        sum(sources) == sum(targets) ||
            throw(ArgumentError("source and target port totals must agree."))
        0 <= num_fixed <= num_vertices ||
            throw(ArgumentError("num_fixed must lie in 0:num_vertices."))

        return new(colors, sources, targets, compatible, Int(num_fixed))
    end
end

function _PortMatchingProblem(
    vertex_colors::AbstractVector{<:Integer},
    source_ports::AbstractMatrix{<:Integer},
    target_ports::AbstractMatrix{<:Integer},
    compatibility::AbstractMatrix{Bool},
    num_fixed::Integer=0,
)
    num_vertices = length(vertex_colors)
    num_source_colors = size(source_ports, 2)
    num_target_colors = size(target_ports, 2)
    size(compatibility) == (num_source_colors, num_target_colors) ||
        throw(ArgumentError("compatibility dimensions must match source/target colors."))

    compatible = BitArray(
        undef, num_vertices, num_source_colors, num_vertices, num_target_colors
    )
    @inbounds for source_vertex in 1:num_vertices
        for source_color in 1:num_source_colors
            for target_vertex in 1:num_vertices
                for target_color in 1:num_target_colors
                    compatible[source_vertex, source_color, target_vertex, target_color] = compatibility[
                        source_color, target_color
                    ]
                end
            end
        end
    end
    return _PortMatchingProblem(
        vertex_colors, source_ports, target_ports, compatible, num_fixed
    )
end

struct _PortMatchingState
    edges::Vector{_PortEdge}
    source_ports::Matrix{Int}
    target_ports::Matrix{Int}
end

struct _PortStateKey
    edges::Vector{_PortEdge}
    source_ports::Vector{Int}
    target_ports::Vector{Int}
end

function Base.isequal(a::_PortStateKey, b::_PortStateKey)
    return isequal(a.edges, b.edges) &&
           isequal(a.source_ports, b.source_ports) &&
           isequal(a.target_ports, b.target_ports)
end
Base.:(==)(a::_PortStateKey, b::_PortStateKey) = isequal(a, b)
function Base.hash(key::_PortStateKey, h::UInt)
    return hash(
        key.target_ports, hash(key.source_ports, hash(key.edges, hash(_PortStateKey, h)))
    )
end

function _lexless_port_edges(a::Vector{_PortEdge}, b::Vector{_PortEdge})::Bool
    @inbounds for i in eachindex(a, b)
        isequal(a[i], b[i]) && continue
        return isless(a[i], b[i])
    end
    return length(a) < length(b)
end

function _lexless_port_key(a::_PortStateKey, b::_PortStateKey)::Bool
    if !isequal(a.edges, b.edges)
        return _lexless_port_edges(a.edges, b.edges)
    elseif a.source_ports != b.source_ports
        return _lexless_int_vectors(a.source_ports, b.source_ports)
    end
    return _lexless_int_vectors(a.target_ports, b.target_ports)
end

function _port_vertex_cells(problem::_PortMatchingProblem)::Vector{Vector{Int}}
    first_internal = problem.num_fixed + 1
    first_internal > length(problem.vertex_colors) && return Vector{Vector{Int}}()

    colors = sort!(unique(problem.vertex_colors[first_internal:end]))
    cells = Vector{Vector{Int}}()
    sizehint!(cells, length(colors))
    for color in colors
        cell = Int[]
        for vertex in first_internal:length(problem.vertex_colors)
            problem.vertex_colors[vertex] == color && push!(cell, vertex)
        end
        length(cell) > 1 && push!(cells, cell)
    end
    return cells
end

function _preserves_port_compatibility(
    problem::_PortMatchingProblem, mapping::Vector{Int}
)::Bool
    compatibility = problem.compatibility
    @inbounds for source_vertex in axes(compatibility, 1)
        for source_color in axes(compatibility, 2)
            for target_vertex in axes(compatibility, 3)
                for target_color in axes(compatibility, 4)
                    compatibility[
                        source_vertex, source_color, target_vertex, target_color
                    ] == compatibility[
                        mapping[source_vertex],
                        source_color,
                        mapping[target_vertex],
                        target_color,
                    ] || return false
                end
            end
        end
    end
    return true
end

function _collect_port_automorphisms!(
    automorphisms::Vector{Vector{Int}},
    problem::_PortMatchingProblem,
    cells::Vector{Vector{Int}},
    mapping::Vector{Int},
    cell_index::Int,
)::Nothing
    if cell_index > length(cells)
        _preserves_port_compatibility(problem, mapping) &&
            push!(automorphisms, copy(mapping))
        return nothing
    end

    cell = cells[cell_index]
    permutation = copy(cell)
    while true
        @inbounds for i in eachindex(cell)
            mapping[cell[i]] = permutation[i]
        end
        _collect_port_automorphisms!(automorphisms, problem, cells, mapping, cell_index + 1)
        _next_permutation!(permutation) || break
    end
    return nothing
end

function _port_automorphisms(problem::_PortMatchingProblem)::Vector{Vector{Int}}
    mapping = collect(eachindex(problem.vertex_colors))
    automorphisms = Vector{Vector{Int}}()
    _collect_port_automorphisms!(
        automorphisms, problem, _port_vertex_cells(problem), mapping, 1
    )
    isempty(automorphisms) &&
        error("Internal error: port problem has no identity automorphism.")
    return automorphisms
end

function _write_mapped_port_edges!(
    destination::Vector{_PortEdge}, state::_PortMatchingState, mapping::Vector{Int}
)::Nothing
    @inbounds for i in eachindex(state.edges)
        edge = state.edges[i]
        destination[i] = _PortEdge(
            mapping[edge.source], mapping[edge.target], edge.source_color, edge.target_color
        )
    end
    sort!(destination)
    return nothing
end

function _write_mapped_port_counts!(
    destination::Vector{Int}, counts::Matrix{Int}, mapping::Vector{Int}
)::Nothing
    num_vertices = size(counts, 1)
    @inbounds for old_vertex in axes(counts, 1)
        new_vertex = mapping[old_vertex]
        for color in axes(counts, 2)
            destination[new_vertex + (color - 1) * num_vertices] = counts[old_vertex, color]
        end
    end
    return nothing
end

function _mapped_port_key(state::_PortMatchingState, mapping::Vector{Int})::_PortStateKey
    edges = Vector{_PortEdge}(undef, length(state.edges))
    source_ports = Vector{Int}(undef, length(state.source_ports))
    target_ports = Vector{Int}(undef, length(state.target_ports))
    _write_mapped_port_edges!(edges, state, mapping)
    _write_mapped_port_counts!(source_ports, state.source_ports, mapping)
    _write_mapped_port_counts!(target_ports, state.target_ports, mapping)
    return _PortStateKey(edges, source_ports, target_ports)
end

function _state_from_port_key(
    state::_PortMatchingState, key::_PortStateKey
)::_PortMatchingState
    source_ports = similar(state.source_ports)
    target_ports = similar(state.target_ports)
    copyto!(source_ports, key.source_ports)
    copyto!(target_ports, key.target_ports)
    return _PortMatchingState(key.edges, source_ports, target_ports)
end

function _mapped_port_state(
    state::_PortMatchingState, mapping::Vector{Int}
)::Tuple{_PortStateKey,_PortMatchingState}
    key = _mapped_port_key(state, mapping)
    return key, _state_from_port_key(state, key)
end

mutable struct _PortCanonicalizationWorkspace
    edges::Vector{_PortEdge}
    source_ports::Vector{Int}
    target_ports::Vector{Int}
end

function _PortCanonicalizationWorkspace(state::_PortMatchingState)
    return _PortCanonicalizationWorkspace(
        Vector{_PortEdge}(undef, length(state.edges)),
        Vector{Int}(undef, length(state.source_ports)),
        Vector{Int}(undef, length(state.target_ports)),
    )
end

function _prepare_port_workspace!(
    workspace::_PortCanonicalizationWorkspace, state::_PortMatchingState
)::Nothing
    resize!(workspace.edges, length(state.edges))
    length(workspace.source_ports) == length(state.source_ports) ||
        resize!(workspace.source_ports, length(state.source_ports))
    length(workspace.target_ports) == length(state.target_ports) ||
        resize!(workspace.target_ports, length(state.target_ports))
    return nothing
end

function _scratch_port_key_is_lexless(
    workspace::_PortCanonicalizationWorkspace, best::_PortStateKey
)::Bool
    if workspace.edges != best.edges
        return _lexless_port_edges(workspace.edges, best.edges)
    elseif workspace.source_ports != best.source_ports
        return _lexless_int_vectors(workspace.source_ports, best.source_ports)
    end
    return _lexless_int_vectors(workspace.target_ports, best.target_ports)
end

function _canonicalize_port_state(
    state::_PortMatchingState,
    automorphisms::Vector{Vector{Int}},
    workspace::_PortCanonicalizationWorkspace,
)::Tuple{_PortStateKey,_PortMatchingState,Vector{Int}}
    first_mapping = first(automorphisms)
    best_key = _mapped_port_key(state, first_mapping)
    best_mapping = first_mapping
    length(automorphisms) == 1 &&
        return best_key, _state_from_port_key(state, best_key), best_mapping

    _prepare_port_workspace!(workspace, state)
    @inbounds for i in 2:length(automorphisms)
        mapping = automorphisms[i]
        _write_mapped_port_edges!(workspace.edges, state, mapping)
        _write_mapped_port_counts!(workspace.source_ports, state.source_ports, mapping)
        _write_mapped_port_counts!(workspace.target_ports, state.target_ports, mapping)
        if _scratch_port_key_is_lexless(workspace, best_key)
            copyto!(best_key.edges, workspace.edges)
            copyto!(best_key.source_ports, workspace.source_ports)
            copyto!(best_key.target_ports, workspace.target_ports)
            best_mapping = mapping
        end
    end
    return best_key, _state_from_port_key(state, best_key), best_mapping
end

function _canonicalize_port_state(
    state::_PortMatchingState, automorphisms::Vector{Vector{Int}}
)::Tuple{_PortStateKey,_PortMatchingState,Vector{Int}}
    workspace = _PortCanonicalizationWorkspace(state)
    return _canonicalize_port_state(state, automorphisms, workspace)
end

"""
Canonicalize a partial colored-port matching state under color-preserving automorphisms of the
pair-local admissibility relation. Residual source/target counts are part of the key, so equal keys
have identical remaining matching spaces as well as isomorphic completed edges.
"""
function _canonicalize_port_state(
    problem::_PortMatchingProblem, state::_PortMatchingState
)::Tuple{_PortStateKey,_PortMatchingState,Vector{Int}}
    return _canonicalize_port_state(state, _port_automorphisms(problem))
end

function _first_remaining_source(state::_PortMatchingState)::Union{Nothing,Tuple{Int,Int}}
    @inbounds for vertex in axes(state.source_ports, 1)
        for color in axes(state.source_ports, 2)
            state.source_ports[vertex, color] > 0 && return (vertex, color)
        end
    end
    return nothing
end

mutable struct _WeightedPortState
    state::_PortMatchingState
    weight::BigInt
end

function _accumulate_port_state!(
    states::Dict{_PortStateKey,_WeightedPortState},
    key::_PortStateKey,
    state::_PortMatchingState,
    weight::BigInt,
)::Bool
    if haskey(states, key)
        states[key].weight += weight
        return true
    end
    states[key] = _WeightedPortState(state, weight)
    return false
end

struct _PortGenerationStats
    automorphisms::Int
    layer_states::Vector{Int}
    transitions::Int
    canonicalization_calls::Int
    merged_transitions::Int
end

"""
Generate canonical directed colored-port matchings and their exact labelled matching
multiplicities, together with search-state statistics.

This is an internal research backend for #91. It deliberately uses exhaustive enumeration of the
problem automorphism group; production partition refinement and a measured hybrid crossover are
follow-up work once the semantics are certified.
"""
function _weighted_port_matchings_with_stats(
    problem::_PortMatchingProblem
)::Tuple{Vector{Tuple{Vector{_PortEdge},BigInt}},_PortGenerationStats}
    automorphisms = _port_automorphisms(problem)
    initial = _PortMatchingState(
        _PortEdge[], copy(problem.source_ports), copy(problem.target_ports)
    )
    workspace = _PortCanonicalizationWorkspace(initial)
    initial_key, initial_state, _ = _canonicalize_port_state(
        initial, automorphisms, workspace
    )
    states = Dict(initial_key => _WeightedPortState(initial_state, big(1)))
    layer_states = Int[1]
    transitions = 0
    canonicalization_calls = 1
    merged_transitions = 0

    while true
        first_state = first(values(states)).state
        isnothing(_first_remaining_source(first_state)) && break

        next_states = Dict{_PortStateKey,_WeightedPortState}()
        for weighted in values(states)
            state = weighted.state
            source = _first_remaining_source(state)
            isnothing(source) &&
                error("Internal error: port-matching layers are inconsistent.")
            source_vertex, source_color = source

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
                    key, canonical, _ = _canonicalize_port_state(
                        child, automorphisms, workspace
                    )
                    canonicalization_calls += 1
                    child_weight = weighted.weight * multiplicity
                    merged_transitions += Int(
                        _accumulate_port_state!(next_states, key, canonical, child_weight)
                    )
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
    for weighted in values(states)
        iszero(sum(weighted.state.target_ports)) ||
            error("Internal error: unmatched target ports remain at completion.")
        push!(results, (weighted.state.edges, weighted.weight))
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

function _weighted_port_matchings(
    problem::_PortMatchingProblem
)::Vector{Tuple{Vector{_PortEdge},BigInt}}
    results, _ = _weighted_port_matchings_with_stats(problem)
    return results
end
