# --- Production dispatch support for native typed multiplicity recursion ---

function _collect_typed_native_multiplicity(
    problem::TypedMultigraphProblem, connected::Bool, mappings::Vector{Vector{Int}}
)::Tuple{Dict{GraphRep,Int},TypedRowReductionStats}
    num_vertices = length(problem._degrees)
    maximum_multiplicity = maximum(problem._degrees; init=0)
    _can_pack_triangular_key(num_vertices, maximum_multiplicity) || error(
        "Internal error: typed problem does not fit the native packed continuation-key representation.",
    )

    bits = _triangular_multiplicity_bits(maximum_multiplicity)
    row_actions = _typed_row_state_actions(mappings, num_vertices)
    seen = [Set{UInt128}() for _ in 1:(num_vertices + 1)]
    stats = TypedRowReductionStats()
    residual = copy(problem._degrees)
    multiplicities = zeros(Int, (num_vertices * (num_vertices + 1)) ÷ 2)
    num_edges = sum(problem._degrees) ÷ 2
    topologies = Dict{GraphRep,Int}()

    _enumerate_typed_native_vertex!(
        residual,
        multiplicities,
        problem._allowed,
        1,
        row_actions,
        num_vertices,
        bits,
        seen,
        stats,
    ) do state
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
    problem::TypedMultigraphProblem, mappings::Vector{Vector{Int}}; connected::Bool=true
)::Vector{Tuple{GraphRep,BigInt}}
    isempty(problem._degrees) && return Vector{Tuple{GraphRep,BigInt}}()
    isodd(sum(problem._degrees)) && return Vector{Tuple{GraphRep,BigInt}}()

    topologies, _ = _collect_typed_native_multiplicity(problem, connected, mappings)
    results = Vector{Tuple{GraphRep,BigInt}}()
    sizehint!(results, length(topologies))
    for (graph, automorphism_order) in topologies
        push!(results, (graph, big(automorphism_order) * _edge_symmetry_factor(graph)))
    end
    sort!(results; by=first)
    return results
end
