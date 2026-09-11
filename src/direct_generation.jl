# --- Direct Multigraph Generation ---

# Exact partition refinement has a fixed setup cost but wins decisively once the exhaustive
# canonical-label search reaches five internal vertices. Keep the small-graph path allocation-lean
# and switch at the measured crossover. The threshold is internal and can be retuned by benchmarks.
const _PARTITION_CANONICALIZATION_MIN_INTERNAL = 5

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

# Exact degree-preserving internal relabeling factor. The validation suite uses it for orbit-size
# identities, and the hybrid production selector uses it as the measured redundancy proxy for
# deciding whether early row-state isomorphism reduction can amortize its canonicalization cost.
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

function _collect_topologies_exhaustive(
    degrees::Vector{Int}, num_external::Int, connected::Bool
)::Dict{GraphRep,Int}
    num_vertices = length(degrees)
    internal_indices = (num_external + 1):num_vertices
    canonical_graphs = Dict{GraphRep,Nothing}()

    _foreach_labeled_multigraph(degrees) do graph
        if connected && !is_connected(build_internal_graph(graph, num_vertices))
            return nothing
        end
        canonical_graphs[canonical_form(graph, internal_indices)] = nothing
        return nothing
    end

    topologies = Dict{GraphRep,Int}()
    sizehint!(topologies, length(canonical_graphs))
    for graph in keys(canonical_graphs)
        canonicalization = _canonicalize_with_automorphisms(graph, internal_indices)
        canonicalization.canonical == graph ||
            error("Internal error: stored topology is not canonical.")
        topologies[graph] = canonicalization.automorphism_order
    end
    return topologies
end

function _collect_topologies_partitioned(
    degrees::Vector{Int}, num_external::Int, connected::Bool
)::Dict{GraphRep,Int}
    num_vertices = length(degrees)
    internal_indices = (num_external + 1):num_vertices
    partitioned_graphs = Dict{GraphRep,Int}()

    _foreach_labeled_multigraph(degrees) do graph
        if connected && !is_connected(build_internal_graph(graph, num_vertices))
            return nothing
        end

        partition = _partition_canonicalize(graph, degrees, num_external)
        if haskey(partitioned_graphs, partition.key)
            partitioned_graphs[partition.key] == partition.automorphism_order || error(
                "Internal error: automorphism order disagrees across one partition-canonical topology.",
            )
        else
            partitioned_graphs[partition.key] = partition.automorphism_order
        end
        return nothing
    end

    topologies = Dict{GraphRep,Int}()
    sizehint!(topologies, length(partitioned_graphs))
    for (key, automorphism_order) in partitioned_graphs
        canonical = canonical_form(key, internal_indices)
        haskey(topologies, canonical) && error(
            "Internal error: distinct partition keys collapsed to one canonical topology.",
        )
        topologies[canonical] = automorphism_order
    end
    return topologies
end

"""
    _allgraphs_direct(n::Vector{Int}; connected=true)

Completed-graph degree-constrained generator retained as the low-redundancy production path and as an
independent benchmark/reference for early row-state reduction. Small graphs use the allocation-lean
exhaustive canonicalizer. At five or more internal vertices, where factorial canonical-label search
dominates, labelled candidates are instead reduced with an exact partition-canonical internal
isomorphism key.

The partition key is used only for topology deduplication. The legacy-compatible `canonical_form` is
evaluated once per surviving topology, preserving the public canonical `GraphRep`. Partition search
also supplies the exact automorphism order, which is combined with edge multiplicities to obtain the
symmetry denominator. The brute-force `_allgraphs_wick_reference` implementation remains as an
independent small-system oracle.
"""
function _allgraphs_direct(n::Vector{Int}; connected=true)
    isodd(total_degree(n)) && return Vector{Tuple{GraphRep,BigInt}}()

    degrees = _vertex_degrees(n)
    isempty(degrees) && return Vector{Tuple{GraphRep,BigInt}}()

    num_external = n[1]
    num_internal = length(degrees) - num_external
    use_partition = num_internal >= _PARTITION_CANONICALIZATION_MIN_INTERNAL
    topologies = if use_partition
        _collect_topologies_partitioned(degrees, num_external, connected)
    else
        _collect_topologies_exhaustive(degrees, num_external, connected)
    end

    results = Vector{Tuple{GraphRep,BigInt}}()
    sizehint!(results, length(topologies))
    for (graph, automorphism_order) in topologies
        symmetry_denominator = big(automorphism_order) * _edge_symmetry_factor(graph)
        push!(results, (graph, symmetry_denominator))
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
