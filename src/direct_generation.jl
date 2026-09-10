# --- Direct Multigraph Generation ---

# Expand `n[k] = number of degree-k vertices` into one degree per labelled vertex. Degree-1
# vertices come first and are therefore the fixed external vertices used by `canonical_form`.
function _vertex_degrees(n::Vector{Int})
    degrees = Int[]
    sizehint!(degrees, sum(n))
    for (degree, count) in enumerate(n)
        append!(degrees, fill(degree, count))
    end
    return degrees
end

# Enumerate each labelled undirected multigraph with the prescribed degree sequence exactly once.
# The recursion fixes one upper-triangular row of the edge-multiplicity matrix at a time. A loop
# consumes two half-edges at its vertex; an off-diagonal edge consumes one half-edge at each end.
function _foreach_labeled_multigraph(f::F, degrees::Vector{Int}) where {F}
    residual = copy(degrees)
    graph = Edge[]
    _enumerate_vertex!(f, residual, graph, 1)
    return nothing
end

function _enumerate_vertex!(f::F, residual::Vector{Int}, graph::GraphRep, i::Int) where {F}
    num_vertices = length(residual)
    if i > num_vertices
        f(copy(graph))
        return nothing
    elseif i == num_vertices
        remaining = residual[i]
        iseven(remaining) || return nothing

        old_length = length(graph)
        loops = remaining ÷ 2
        for _ in 1:loops
            push!(graph, Edge(i, i))
        end
        residual[i] = 0
        f(copy(graph))
        residual[i] = remaining
        resize!(graph, old_length)
        return nothing
    end

    degree_i = residual[i]
    future_capacity = sum(@view residual[(i + 1):end])
    for loops in 0:(degree_i ÷ 2)
        remaining = degree_i - 2loops
        remaining <= future_capacity || continue

        old_length = length(graph)
        for _ in 1:loops
            push!(graph, Edge(i, i))
        end
        _distribute_vertex_edges!(f, residual, graph, i, i + 1, remaining)
        resize!(graph, old_length)
    end
    return nothing
end

function _distribute_vertex_edges!(
    f::F, residual::Vector{Int}, graph::GraphRep, i::Int, j::Int, remaining::Int
) where {F}
    num_vertices = length(residual)
    if j > num_vertices
        if iszero(remaining)
            old_residual = residual[i]
            residual[i] = 0
            _enumerate_vertex!(f, residual, graph, i + 1)
            residual[i] = old_residual
        end
        return nothing
    end

    # Enough half-edges must remain after `j` to absorb whatever is not connected to `j`.
    capacity_after_j = j == num_vertices ? 0 : sum(@view residual[(j + 1):end])
    min_multiplicity = max(0, remaining - capacity_after_j)
    max_multiplicity = min(remaining, residual[j])
    min_multiplicity <= max_multiplicity || return nothing

    for multiplicity in min_multiplicity:max_multiplicity
        old_length = length(graph)
        residual[j] -= multiplicity
        for _ in 1:multiplicity
            push!(graph, Edge(i, j))
        end

        _distribute_vertex_edges!(f, residual, graph, i, j + 1, remaining - multiplicity)

        residual[j] += multiplicity
        resize!(graph, old_length)
    end
    return nothing
end

function _internal_vertex_permutation_factor(n::Vector{Int})
    factor = big(1)
    for count in @view n[2:end]
        factor *= factorial(big(count))
    end
    return factor
end

function _edge_symmetry_factor(graph::GraphRep)
    multiplicities = Dict{Edge,Int}()
    for edge in graph
        multiplicities[edge] = get(multiplicities, edge, 0) + 1
    end

    factor = big(1)
    for (edge, multiplicity) in multiplicities
        factor *= factorial(big(multiplicity))
        edge.first == edge.second && (factor *= big(2)^multiplicity)
    end
    return factor
end

"""
    _allgraphs_direct(n::Vector{Int}; connected=true)

Experimental direct graph generator used to validate the replacement for Wick-pairing
enumeration. It enumerates degree-constrained labelled multigraphs directly, canonicalizes them,
and obtains the internal automorphism factor from orbit--stabilizer. Production `allgraphs`
continues to use `_allgraphs_wick_reference` until the two implementations are certified
identical on the reference domain.
"""
function _allgraphs_direct(n::Vector{Int}; connected=true)
    isodd(total_degree(n)) && return Vector{Tuple{GraphRep,BigInt}}()

    degrees = _vertex_degrees(n)
    isempty(degrees) && return Vector{Tuple{GraphRep,BigInt}}()

    num_vertices = length(degrees)
    num_external = n[1]
    internal_indices = (num_external + 1):num_vertices
    orbit_counts = Dict{GraphRep,Int}()

    _foreach_labeled_multigraph(degrees) do graph
        if connected && !is_connected(build_internal_graph(graph, num_vertices))
            return nothing
        end
        canonical = canonical_form(graph, internal_indices)
        orbit_counts[canonical] = get(orbit_counts, canonical, 0) + 1
        return nothing
    end

    vertex_permutations = _internal_vertex_permutation_factor(n)
    results = Vector{Tuple{GraphRep,BigInt}}()
    sizehint!(results, length(orbit_counts))
    for (graph, orbit_size) in orbit_counts
        automorphisms, remainder = divrem(vertex_permutations, orbit_size)
        iszero(remainder) || error(
            "Internal error: labelled orbit size $(orbit_size) does not divide the internal vertex permutation factor $(vertex_permutations).",
        )
        push!(results, (graph, automorphisms * _edge_symmetry_factor(graph)))
    end

    sort!(results; by=first)
    return results
end

function _count_labeled_multigraphs(n::Vector{Int})
    count = Ref(0)
    _foreach_labeled_multigraph(_vertex_degrees(n)) do _
        return count[] += 1
    end
    return count[]
end
