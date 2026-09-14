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

Sort edges within a graph representation canonically.
"""
function sort_graph_edges(graph::GraphRep)::GraphRep
    sorted_props = [Edge(minmax(p.first, p.second)...) for p in graph]
    return sort(sorted_props)
end

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
        if length(candidate) <= 32
            sort!(candidate; alg=Base.Sort.InsertionSort)
        else
            sort!(candidate)
        end
        _compare_graph_reps(candidate, current_canonical) < 0 &&
            copyto!(current_canonical, candidate)
        _next_permutation!(perm) || break
    end

    return current_canonical
end

"""
    canonical_form(graph::GraphRep, internal_indices::UnitRange{Int})::GraphRep

Return the lexicographically smallest representation under permutations of `internal_indices`.
"""
function canonical_form(graph::GraphRep, internal_indices::UnitRange{Int})::GraphRep
    return _canonical_form_inplace_permutations(graph, internal_indices)
end

@inline function _is_connected_graph_rep_u64(graph::GraphRep, num_vertices::Int)::Bool
    visited = UInt64(1)
    frontier = visited

    while !iszero(frontier)
        next_frontier = UInt64(0)
        @inbounds for edge in graph
            u = edge.first
            v = edge.second
            u == v && continue

            u_bit = UInt64(1) << (u - 1)
            v_bit = UInt64(1) << (v - 1)
            !iszero(frontier & u_bit) && iszero(visited & v_bit) && (next_frontier |= v_bit)
            !iszero(frontier & v_bit) && iszero(visited & u_bit) && (next_frontier |= u_bit)
        end
        next_frontier &= ~visited
        iszero(next_frontier) && break
        visited |= next_frontier
        frontier = next_frontier
    end

    target = num_vertices == 64 ? typemax(UInt64) : (UInt64(1) << num_vertices) - UInt64(1)
    return visited == target
end

function _is_connected_graph_rep_large(graph::GraphRep, num_vertices::Int)::Bool
    seen = falses(num_vertices)
    stack = Vector{Int}(undef, num_vertices)
    seen[1] = true
    stack[1] = 1
    stack_size = 1
    reached = 1

    while stack_size > 0
        vertex = stack[stack_size]
        stack_size -= 1
        @inbounds for edge in graph
            neighbor = if edge.first == vertex
                edge.second
            elseif edge.second == vertex
                edge.first
            else
                continue
            end
            seen[neighbor] && continue
            seen[neighbor] = true
            reached += 1
            stack_size += 1
            stack[stack_size] = neighbor
        end
    end
    return reached == num_vertices
end

function _is_connected_graph_rep(graph::GraphRep, num_vertices::Int)::Bool
    num_vertices > 0 || return false
    num_vertices == 1 && return true
    return if num_vertices <= 64
        _is_connected_graph_rep_u64(graph, num_vertices)
    else
        _is_connected_graph_rep_large(graph, num_vertices)
    end
end

"""Calculate the total degree from `n[k] = number of degree-k vertices`."""
total_degree(n::AbstractVector{<:Integer}) = sum(k * nk for (k, nk) in enumerate(n))
