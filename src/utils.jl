# --- Core Definitions and Helpers ---

const Edge = Pair{Int,Int} # Represents Δ[a, b] with a ≤ b
const GraphRep = Vector{Edge}

struct CanonicalizationResult
    canonical::GraphRep
    automorphism_order::Int
end

@inline _checked_increment(counter::Int)::Int = Base.Checked.checked_add(counter, 1)

"""
    sort_graph_edges(graph::GraphRep)::GraphRep

Sorts edges within a graph representation canonically.
Ensures `a ≤ b` in each `a => b` and then sorts the vector of edges.
"""
function sort_graph_edges(graph::GraphRep)::GraphRep
    # Ensure a ≤ b in each propagator and sort the edges
    sorted_props = [Edge(minmax(p.first, p.second)...) for p in graph]
    return sort(sorted_props) # Sorts based on pairs, first element then second
end

# Advance a permutation in-place to its lexicographic successor. The vector must contain distinct
# ordered values. Returns `false` after the final descending permutation, leaving it unchanged.
function _next_permutation!(p::Vector{Int})::Bool
    length(p) < 2 && return false

    i = length(p) - 1
    while i >= 1 && p[i] >= p[i + 1]
        i -= 1
    end
    i == 0 && return false

    j = length(p)
    while p[j] <= p[i]
        j -= 1
    end
    p[i], p[j] = p[j], p[i]

    lo = i + 1
    hi = length(p)
    while lo < hi
        p[lo], p[hi] = p[hi], p[lo]
        lo += 1
        hi -= 1
    end
    return true
end

@inline function _compare_graph_reps(a::GraphRep, b::GraphRep)::Int
    @inbounds for i in eachindex(a, b)
        ai = a[i]
        bi = b[i]
        isless(ai, bi) && return -1
        isless(bi, ai) && return 1
    end
    return 0
end

# Canonicalize a graph and count the internal automorphism group during the same exhaustive
# permutation traversal. Every orbit representative has exactly |Aut(G)| preimages under the
# group action, so the number of permutations yielding the final canonical minimum is the
# automorphism order. External vertices remain fixed because only `internal_indices` are permuted.
function _canonicalize_with_automorphisms(
    graph::GraphRep, internal_indices::UnitRange{Int}
)::CanonicalizationResult
    if length(internal_indices) < 2
        return CanonicalizationResult(sort_graph_edges(graph), 1)
    end

    perm = collect(internal_indices)
    first_internal = first(internal_indices)
    last_internal = last(internal_indices)
    current_canonical = sort_graph_edges(graph)
    candidate = similar(graph)
    automorphism_order = 0

    while true
        @inbounds for i in eachindex(graph)
            prop = graph[i]
            u, v = prop.first, prop.second
            u_new = first_internal <= u <= last_internal ? perm[u - first_internal + 1] : u
            v_new = first_internal <= v <= last_internal ? perm[v - first_internal + 1] : v
            candidate[i] = Edge(minmax(u_new, v_new)...)
        end
        sort!(candidate)

        comparison = _compare_graph_reps(candidate, current_canonical)
        if comparison < 0
            copyto!(current_canonical, candidate)
            automorphism_order = 1
        elseif iszero(comparison)
            automorphism_order = _checked_increment(automorphism_order)
        end

        _next_permutation!(perm) || break
    end

    automorphism_order > 0 ||
        error("Internal error: canonical orbit has no representative.")
    return CanonicalizationResult(current_canonical, automorphism_order)
end

# Production exhaustive canonicalizer. Keep the graph-only fast path separate from automorphism
# counting: most callers need only the canonical label, and direct generation computes
# automorphism orders once per unique topology after deduplication.
function _canonical_form_inplace_permutations(
    graph::GraphRep, internal_indices::UnitRange{Int}
)::GraphRep
    if length(internal_indices) < 2
        return sort_graph_edges(graph)
    end

    perm = collect(internal_indices)
    first_internal = first(internal_indices)
    last_internal = last(internal_indices)
    current_canonical = sort_graph_edges(graph)
    candidate = similar(graph)

    while true
        @inbounds for i in eachindex(graph)
            prop = graph[i]
            u, v = prop.first, prop.second
            u_new = first_internal <= u <= last_internal ? perm[u - first_internal + 1] : u
            v_new = first_internal <= v <= last_internal ? perm[v - first_internal + 1] : v
            candidate[i] = Edge(minmax(u_new, v_new)...)
        end
        sort!(candidate)
        candidate < current_canonical && copyto!(current_canonical, candidate)
        _next_permutation!(perm) || break
    end

    return current_canonical
end

"""
    canonical_form(graph::GraphRep, internal_indices::UnitRange{Int})::GraphRep

Finds the canonical representation of a graph under permutations of internal vertices.
The canonical form is the lexicographically smallest graph representation achievable
through permutation of `internal_indices`.
"""
function canonical_form(graph::GraphRep, internal_indices::UnitRange{Int})::GraphRep
    return _canonical_form_inplace_permutations(graph, internal_indices)
end

"""
    build_internal_graph(graph_rep::GraphRep, num_vertices::Int)::SimpleGraph

Builds a Graphs.SimpleGraph from an edges list.
"""
function build_internal_graph(graph_rep::GraphRep, num_vertices::Int)::SimpleGraph
    g = SimpleGraph(num_vertices)
    for prop in graph_rep
        # Check if edge already exists can be useful for debugging, but add_edge handles it
        add_edge!(g, prop.first, prop.second)
    end
    return g
end

"""
    $(TYPEDSIGNATURES)

Builds a [`MultigraphWrap`](@ref) from an edges list and an explicit number of vertices.

Vertex labels must lie in `1:num_vertices`. Parallel edges and self-loops are preserved exactly.
"""
function build_graph(graph_rep::GraphRep, num_vertices::Int)::MultigraphWrap
    num_vertices >= 0 || throw(ArgumentError("num_vertices must be non-negative."))

    adjacency = zeros(Int, num_vertices, num_vertices)
    for prop in graph_rep
        u, v = prop.first, prop.second
        1 <= u <= num_vertices ||
            throw(ArgumentError("Vertex label $u is outside 1:$num_vertices."))
        1 <= v <= num_vertices ||
            throw(ArgumentError("Vertex label $v is outside 1:$num_vertices."))

        adjacency[u, v] += 1
        u == v || (adjacency[v, u] += 1)
    end
    return MultigraphWrap(Multigraph(adjacency))
end

"""
    $(TYPEDSIGNATURES)

Builds a [`MultigraphWrap`](@ref) from an edges list.

Vertex labels are interpreted as one-based vertex indices, so the graph contains all vertices
from `1` through the largest label appearing in `graph_rep`. This preserves non-contiguous
labels such as `1 => 3`, for which vertex `2` is an isolated vertex.
"""
function build_graph(graph_rep::GraphRep)::MultigraphWrap
    num_vertices =
        isempty(graph_rep) ? 0 : maximum(max(p.first, p.second) for p in graph_rep)
    return build_graph(graph_rep, num_vertices)
end

"""
    $(TYPEDSIGNATURES)

Calculates the total degree of a graph topology represented by a vector of the degrees of vertices.
"""
total_degree(n::AbstractVector{<:Integer}) = sum(k * nk for (k, nk) in enumerate(n))
