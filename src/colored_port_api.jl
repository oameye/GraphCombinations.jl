"""
    ColoredPortEdge

Directed colored edge in a generated port matching. `source_color` and `target_color` are opaque
integer labels whose meaning is owned by the caller.
"""
const ColoredPortEdge = _PortEdge

struct _ReadOnlyArray{T,N,A<:AbstractArray{T,N}} <: AbstractArray{T,N}
    _parent::A
end

Base.size(array::_ReadOnlyArray) = size(array._parent)
Base.axes(array::_ReadOnlyArray) = axes(array._parent)
Base.IndexStyle(::Type{<:_ReadOnlyArray{T,N,A}}) where {T,N,A} = Base.IndexStyle(A)
@inline Base.getindex(array::_ReadOnlyArray, indices...) =
    getindex(array._parent, indices...)

"""
    ColoredPortProblem(vertex_colors, source_ports, target_ports, allowed[, num_fixed])

Concrete directed colored-port matching problem.

Rows of `source_ports` and `target_ports` are vertices and columns are opaque port colors. `allowed`
may either be a source-color/target-color matrix or the full pair-local relation
`allowed[source_vertex, source_color, target_vertex, target_color]`. The first `num_fixed` vertices
are individually fixed under canonical relabeling.
"""
struct ColoredPortProblem
    _problem::_PortMatchingProblem
end

function ColoredPortProblem(
    vertex_colors::AbstractVector{<:Integer},
    source_ports::AbstractMatrix{<:Integer},
    target_ports::AbstractMatrix{<:Integer},
    allowed::AbstractArray{Bool,4},
    num_fixed::Integer=0,
)::ColoredPortProblem
    return ColoredPortProblem(
        _PortMatchingProblem(vertex_colors, source_ports, target_ports, allowed, num_fixed)
    )
end

function ColoredPortProblem(
    vertex_colors::AbstractVector{<:Integer},
    source_ports::AbstractMatrix{<:Integer},
    target_ports::AbstractMatrix{<:Integer},
    allowed::AbstractMatrix{Bool},
    num_fixed::Integer=0,
)::ColoredPortProblem
    return ColoredPortProblem(
        _PortMatchingProblem(vertex_colors, source_ports, target_ports, allowed, num_fixed)
    )
end

"""
    ColoredPortState(edges, source_ports, target_ports)

Read-only view of a partial colored-port matching state. Consumers may inspect this object in
pruning and weight-transport policies, while its traversal-owned arrays are exposed only through
non-mutating array views.
"""
struct ColoredPortState
    _state::_PortMatchingState
end

function ColoredPortState(
    edges::AbstractVector{ColoredPortEdge},
    source_ports::AbstractMatrix{<:Integer},
    target_ports::AbstractMatrix{<:Integer},
)::ColoredPortState
    return ColoredPortState(
        _PortMatchingState(
            collect(ColoredPortEdge, edges),
            Matrix{Int}(source_ports),
            Matrix{Int}(target_ports),
        ),
    )
end

"""Return a read-only view of the completed colored edges of a partial colored-port state."""
port_edges(state::ColoredPortState) = _ReadOnlyArray(state._state.edges)

"""Return a read-only view of the residual source-port counts of a partial colored-port state."""
source_port_counts(state::ColoredPortState) = _ReadOnlyArray(state._state.source_ports)

"""Return a read-only view of the residual target-port counts of a partial colored-port state."""
target_port_counts(state::ColoredPortState) = _ReadOnlyArray(state._state.target_ports)

"""
    PortRelabeling

Domain-neutral vertex relabeling witness. `vertex_map[v]` is the canonical vertex label assigned
to original vertex `v`. Fixed external vertices map to themselves. The mapping is exposed as a
read-only vector.
"""
struct PortRelabeling
    vertex_map::_ReadOnlyArray{Int,1,Vector{Int}}
end

function PortRelabeling(vertex_map::AbstractVector{<:Integer})
    return PortRelabeling(_ReadOnlyArray(collect(Int, vertex_map)))
end

@inline _port_relabeling_view(vertex_map::Vector{Int}) =
    PortRelabeling(_ReadOnlyArray(vertex_map))

"""
    WeightedPortCompletion

Canonical completed colored-port matching with its exact accumulated integer weight.
"""
struct WeightedPortCompletion
    edges::Vector{ColoredPortEdge}
    weight::BigInt
end

function Base.isequal(a::WeightedPortCompletion, b::WeightedPortCompletion)
    return isequal(a.edges, b.edges) && isequal(a.weight, b.weight)
end
Base.:(==)(a::WeightedPortCompletion, b::WeightedPortCompletion) = isequal(a, b)

"""
    PortGenerationStats

Search statistics for weighted colored-port generation. `pruned_transitions` is zero for the
ordinary traversal and counts children rejected before canonicalization for a pruned traversal.
"""
struct PortGenerationStats
    automorphisms::Int
    layer_states::Vector{Int}
    transitions::Int
    canonicalization_calls::Int
    merged_transitions::Int
    pruned_transitions::Int
end

function PortGenerationStats(stats::_PortGenerationStats)
    return PortGenerationStats(
        stats.automorphisms,
        stats.layer_states,
        stats.transitions,
        stats.canonicalization_calls,
        stats.merged_transitions,
        0,
    )
end

function PortGenerationStats(stats::_PrunedPortGenerationStats)
    return PortGenerationStats(
        stats.automorphisms,
        stats.layer_states,
        stats.transitions,
        stats.canonicalization_calls,
        stats.merged_transitions,
        stats.pruned_transitions,
    )
end

"""
    AcceptAllPortPolicy()

Default concrete pruning policy. It accepts every child and therefore selects the ordinary
unpruned traversal.
"""
struct AcceptAllPortPolicy end
(::AcceptAllPortPolicy)(::ColoredPortState) = true

"""
    MultiplicityPortTransport()

Default weight transport. It preserves the initial unit weight and multiplies by the exact target
port multiplicity at every extension. This reproduces ordinary bosonic/integer multiplicity
accumulation.
"""
const MultiplicityPortTransport = _MultiplicityPortTransport

"""
    initial_port_weight(transport, raw_state, canonical_state, witness) -> BigInt

Weight assigned to the canonicalized initial state for a custom transport. Downstream packages may
extend this function for their own concrete transport type. GraphCombinations assigns no semantic
meaning to the returned sign or representation factor.
"""
function initial_port_weight end

"""
    transport_port_weight(
        transport,
        parent_weight,
        multiplicity,
        added_edge,
        raw_child,
        canonical_child,
        witness,
    ) -> BigInt

Transport one contribution into the canonical child representation before orbit-equivalent
contributions are accumulated. `added_edge` is the extension that produced `raw_child`, exposed
explicitly so consumers do not depend on internal edge-storage order. This is the signed-consumer
seam: GraphCombinations supplies the canonical relabeling witness, while the consumer owns any
representation/sign carried by the extension and relabeling.
"""
function transport_port_weight end

@inline function initial_port_weight(
    ::MultiplicityPortTransport, ::ColoredPortState, ::ColoredPortState, ::PortRelabeling
)::BigInt
    return big(1)
end

@inline function transport_port_weight(
    ::MultiplicityPortTransport,
    parent_weight::BigInt,
    multiplicity::Int,
    ::ColoredPortEdge,
    ::ColoredPortState,
    ::ColoredPortState,
    ::PortRelabeling,
)::BigInt
    return parent_weight * multiplicity
end

@inline function _initial_port_weight(
    transport,
    raw_state::_PortMatchingState,
    canonical_state::_PortMatchingState,
    mapping::Vector{Int},
)::BigInt
    return initial_port_weight(
        transport,
        ColoredPortState(raw_state),
        ColoredPortState(canonical_state),
        _port_relabeling_view(mapping),
    )
end

@inline function _transport_port_weight(
    transport,
    parent_weight::BigInt,
    multiplicity::Int,
    raw_child::_PortMatchingState,
    canonical_child::_PortMatchingState,
    mapping::Vector{Int},
)::BigInt
    isempty(raw_child.edges) &&
        error("Internal error: a transported child must contain the added edge.")
    return transport_port_weight(
        transport,
        parent_weight,
        multiplicity,
        last(raw_child.edges),
        ColoredPortState(raw_child),
        ColoredPortState(canonical_child),
        _port_relabeling_view(mapping),
    )
end

struct _PublicPortPruningPolicy{P}
    policy::P
end

@inline function (wrapped::_PublicPortPruningPolicy)(state::_PortMatchingState)::Bool
    return wrapped.policy(ColoredPortState(state))
end

function _public_port_results(
    results::Vector{Tuple{Vector{_PortEdge},BigInt}}
)::Vector{WeightedPortCompletion}
    completions = WeightedPortCompletion[]
    sizehint!(completions, length(results))
    for (edges, weight) in results
        iszero(weight) || push!(completions, WeightedPortCompletion(edges, weight))
    end
    return completions
end

function _generate_weighted_with_stats(
    problem::ColoredPortProblem,
    ::AcceptAllPortPolicy,
    ::MultiplicityPortTransport,
)::Tuple{Vector{WeightedPortCompletion},PortGenerationStats}
    results, stats = _weighted_port_matchings_compact_with_stats(problem._problem)
    return _public_port_results(results), PortGenerationStats(stats)
end

function _generate_weighted_with_stats(
    problem::ColoredPortProblem, ::AcceptAllPortPolicy, transport::T
)::Tuple{Vector{WeightedPortCompletion},PortGenerationStats} where {T}
    results, stats = _weighted_port_matchings_with_stats(problem._problem, transport)
    return _public_port_results(results), PortGenerationStats(stats)
end

function _generate_weighted_with_stats(
    problem::ColoredPortProblem, policy::P, transport::T
)::Tuple{Vector{WeightedPortCompletion},PortGenerationStats} where {P,T}
    results, stats = _weighted_port_matchings_pruned_with_stats(
        problem._problem, _PublicPortPruningPolicy(policy), transport
    )
    return _public_port_results(results), PortGenerationStats(stats)
end

"""
    generate_weighted(problem; policy=AcceptAllPortPolicy(), transport=MultiplicityPortTransport())

Generate canonical weighted colored-port completions. `policy` must reject only states whose
invalidity is automorphism-invariant and monotone under extension. A custom `transport` may change
a contribution using the added edge and canonical relabeling witness before equivalent states are
accumulated.
"""
function generate_weighted(
    problem::ColoredPortProblem;
    policy=AcceptAllPortPolicy(),
    transport=MultiplicityPortTransport(),
)::Vector{WeightedPortCompletion}
    results, _ = _generate_weighted_with_stats(problem, policy, transport)
    return results
end

"""
    generate_weighted_with_stats(
        problem; policy=AcceptAllPortPolicy(), transport=MultiplicityPortTransport()
    )

Generate weighted colored-port completions together with exact traversal statistics.
"""
function generate_weighted_with_stats(
    problem::ColoredPortProblem;
    policy=AcceptAllPortPolicy(),
    transport=MultiplicityPortTransport(),
)::Tuple{Vector{WeightedPortCompletion},PortGenerationStats}
    return _generate_weighted_with_stats(problem, policy, transport)
end

"""Run weighted generation and return only its traversal statistics."""
function generation_statistics(
    problem::ColoredPortProblem;
    policy=AcceptAllPortPolicy(),
    transport=MultiplicityPortTransport(),
)::PortGenerationStats
    _, stats = _generate_weighted_with_stats(problem, policy, transport)
    return stats
end

"""
    canonical_relabeling(problem, state)

Canonicalize one partial state and return `(canonical_state, witness)`. The witness is copied from
the canonicalizer so callers may retain it independently of the generator's internal automorphism
workspace.
"""
function canonical_relabeling(
    problem::ColoredPortProblem, state::ColoredPortState
)::Tuple{ColoredPortState,PortRelabeling}
    _, canonical, mapping = _canonicalize_port_state(problem._problem, state._state)
    return ColoredPortState(canonical), _port_relabeling_view(copy(mapping))
end

"""Apply a `PortRelabeling` to a partial colored-port state."""
function relabel_port_state(
    state::ColoredPortState, witness::PortRelabeling
)::ColoredPortState
    _, mapped = _mapped_port_state(state._state, witness.vertex_map._parent)
    return ColoredPortState(mapped)
end
