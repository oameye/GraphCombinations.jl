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
colors. `compatibility[i, j]` says whether source color `i` may contract with target color `j`.
The first `num_fixed` vertices are fixed individually. Remaining vertices may be relabeled only
within equal `vertex_colors`.
"""
struct _PortMatchingProblem
    vertex_colors::Vector{Int}
    source_ports::Matrix{Int}
    target_ports::Matrix{Int}
    compatibility::BitMatrix
    num_fixed::Int

    function _PortMatchingProblem(
        vertex_colors::AbstractVector{<:Integer},
        source_ports::AbstractMatrix{<:Integer},
        target_ports::AbstractMatrix{<:Integer},
        compatibility::AbstractMatrix{Bool},
        num_fixed::Integer=0,
    )
        colors = collect(Int, vertex_colors)
        sources = Matrix{Int}(source_ports)
        targets = Matrix{Int}(target_ports)
        compatible = BitMatrix(compatibility)

        num_vertices = length(colors)
        size(sources, 1) == num_vertices ||
            throw(ArgumentError("source-port rows must match the number of vertices."))
        size(targets, 1) == num_vertices ||
            throw(ArgumentError("target-port rows must match the number of vertices."))
        size(compatible) == (size(sources, 2), size(targets, 2)) || throw(
            ArgumentError("compatibility dimensions must match source/target colors.")
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

function _mapped_port_state(
    state::_PortMatchingState, mapping::Vector{Int}
)::Tuple{_PortStateKey,_PortMatchingState}
    edges = Vector{_PortEdge}(undef, length(state.edges))
    @inbounds for i in eachindex(state.edges)
        edge = state.edges[i]
        edges[i] = _PortEdge(
            mapping[edge.source], mapping[edge.target], edge.source_color, edge.target_color
        )
    end
    sort!(edges)

    source_ports = similar(state.source_ports)
    target_ports = similar(state.target_ports)
    @inbounds for old_vertex in axes(state.source_ports, 1)
        new_vertex = mapping[old_vertex]
        for color in axes(state.source_ports, 2)
            source_ports[new_vertex, color] = state.source_ports[old_vertex, color]
        end
        for color in axes(state.target_ports, 2)
            target_ports[new_vertex, color] = state.target_ports[old_vertex, color]
        end
    end

    key = _PortStateKey(edges, vec(copy(source_ports)), vec(copy(target_ports)))
    return key, _PortMatchingState(edges, source_ports, target_ports)
end

mutable struct _PortCanonicalSearch
    key::_PortStateKey
    state::_PortMatchingState
    mapping::Vector{Int}
end

function _canonical_port_search!(
    search::_PortCanonicalSearch,
    state::_PortMatchingState,
    cells::Vector{Vector{Int}},
    mapping::Vector{Int},
    cell_index::Int,
)::Nothing
    if cell_index > length(cells)
        key, candidate = _mapped_port_state(state, mapping)
        if _lexless_port_key(key, search.key)
            search.key = key
            search.state = candidate
            copyto!(search.mapping, mapping)
        end
        return nothing
    end

    cell = cells[cell_index]
    permutation = copy(cell)
    while true
        @inbounds for i in eachindex(cell)
            mapping[cell[i]] = permutation[i]
        end
        _canonical_port_search!(search, state, cells, mapping, cell_index + 1)
        _next_permutation!(permutation) || break
    end
    return nothing
end

"""
Canonicalize a partial colored-port matching state under permutations of equal-colored internal
vertices. Residual source/target counts are part of the key, so equal keys have identical remaining
matching spaces as well as isomorphic completed edges.
"""
function _canonicalize_port_state(
    problem::_PortMatchingProblem, state::_PortMatchingState
)::Tuple{_PortStateKey,_PortMatchingState,Vector{Int}}
    num_vertices = length(problem.vertex_colors)
    mapping = collect(1:num_vertices)
    initial_key, initial_state = _mapped_port_state(state, mapping)
    cells = _port_vertex_cells(problem)
    isempty(cells) && return initial_key, initial_state, mapping

    search = _PortCanonicalSearch(initial_key, initial_state, copy(mapping))
    _canonical_port_search!(search, state, cells, mapping, 1)
    return search.key, search.state, search.mapping
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
)::Nothing
    if haskey(states, key)
        states[key].weight += weight
    else
        states[key] = _WeightedPortState(state, weight)
    end
    return nothing
end

"""
Generate canonical directed colored-port matchings and their exact labelled matching
multiplicities.

This is an internal research backend for #91. It deliberately uses exhaustive canonicalization of
same-colored internal vertices; production partition refinement and a measured hybrid crossover are
follow-up work once the semantics are certified.
"""
function _weighted_port_matchings(
    problem::_PortMatchingProblem
)::Vector{Tuple{Vector{_PortEdge},BigInt}}
    initial = _PortMatchingState(
        _PortEdge[], copy(problem.source_ports), copy(problem.target_ports)
    )
    initial_key, initial_state, _ = _canonicalize_port_state(problem, initial)
    states = Dict(initial_key => _WeightedPortState(initial_state, big(1)))

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
                    problem.compatibility[source_color, target_color] || continue

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
                    key, canonical, _ = _canonicalize_port_state(problem, child)
                    child_weight = weighted.weight * multiplicity
                    _accumulate_port_state!(next_states, key, canonical, child_weight)
                end
            end
        end

        isempty(next_states) && return Tuple{Vector{_PortEdge},BigInt}[]
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
    return results
end
