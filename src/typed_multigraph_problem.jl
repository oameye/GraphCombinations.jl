# --- Typed constrained undirected multigraph problems ---

"""
    TypedMultigraphProblem(degrees, vertex_colors; num_fixed=0, allowed=trues(n, n))

Concrete undirected multigraph-generation problem with explicit vertex degrees, opaque vertex
colors/types, a fixed vertex prefix, and symmetric pair-local edge admissibility.

`degrees[v]` is the prescribed degree of vertex `v`. `vertex_colors[v]` determines which nonfixed
vertices may be considered for relabeling. The first `num_fixed` vertices are individually fixed.
`allowed[u, v]` controls whether an undirected edge between vertices `u` and `v` is admissible;
loops require `allowed[v, v] == true`.

Problem metadata is copied and normalized on construction so later caller mutation cannot alter the
problem and nonfixed input ordering does not become hidden vertex identity.
"""
struct TypedMultigraphProblem
    _degrees::Vector{Int}
    _vertex_colors::Vector{Int}
    _allowed::BitMatrix
    num_fixed::Int
end

struct _TypedAcceptAllRelabeling end
@inline (::_TypedAcceptAllRelabeling)(::Vector{Int})::Bool = true

function _mapped_int_vector(values::Vector{Int}, mapping::Vector{Int})::Vector{Int}
    mapped = similar(values)
    @inbounds for old_vertex in eachindex(values)
        mapped[mapping[old_vertex]] = values[old_vertex]
    end
    return mapped
end

function _mapped_square_matrix(matrix::BitMatrix, mapping::Vector{Int})::BitMatrix
    n = size(matrix, 1)
    mapped = falses(n, n)
    @inbounds for old_u in 1:n
        new_u = mapping[old_u]
        for old_v in 1:n
            mapped[new_u, mapping[old_v]] = matrix[old_u, old_v]
        end
    end
    return mapped
end

function _lexless_bitmat(a::BitMatrix, b::BitMatrix)::Bool
    @inbounds for index in eachindex(a, b)
        ai = a[index]
        bi = b[index]
        ai == bi && continue
        return !ai && bi
    end
    return false
end

function _typed_metadata_less(
    degrees::Vector{Int},
    allowed::BitMatrix,
    best_degrees::Vector{Int},
    best_allowed::BitMatrix,
)::Bool
    degrees == best_degrees || return _lexless_int_vectors(degrees, best_degrees)
    return _lexless_bitmat(allowed, best_allowed)
end

function _normalize_typed_problem(
    degrees::Vector{Int}, colors::Vector{Int}, allowed::BitMatrix, num_fixed::Int
)::Tuple{Vector{Int},Vector{Int},BitMatrix}
    n = length(degrees)
    n <= num_fixed + 1 && return degrees, colors, allowed

    # Put nonfixed color classes in a deterministic order independent of caller labels.
    nonfixed = collect((num_fixed + 1):n)
    sort!(nonfixed; by=v -> colors[v])
    color_mapping = collect(1:n)
    @inbounds for (offset, old_vertex) in enumerate(nonfixed)
        color_mapping[old_vertex] = num_fixed + offset
    end

    reordered_degrees = _mapped_int_vector(degrees, color_mapping)
    reordered_colors = _mapped_int_vector(colors, color_mapping)
    reordered_allowed = _mapped_square_matrix(allowed, color_mapping)

    # Canonicalize the complete nonfixed metadata within equal-color cells. Degrees are part of
    # the problem semantics just as much as pair-local admissibility; caller ordering must not
    # become hidden vertex identity.
    mappings = _problem_relabelings(
        reordered_colors, num_fixed, _TypedAcceptAllRelabeling()
    )
    best_degrees = reordered_degrees
    best_allowed = reordered_allowed
    best_mapping = first(mappings)
    @inbounds for mapping in @view mappings[2:end]
        candidate_degrees = _mapped_int_vector(reordered_degrees, mapping)
        candidate_allowed = _mapped_square_matrix(reordered_allowed, mapping)
        if _typed_metadata_less(
            candidate_degrees, candidate_allowed, best_degrees, best_allowed
        )
            best_degrees = candidate_degrees
            best_allowed = candidate_allowed
            best_mapping = mapping
        end
    end

    normalized_colors = _mapped_int_vector(reordered_colors, best_mapping)
    return best_degrees, normalized_colors, best_allowed
end

function TypedMultigraphProblem(
    degrees::AbstractVector{<:Integer},
    vertex_colors::AbstractVector{<:Integer};
    num_fixed::Integer=0,
    allowed::AbstractMatrix{Bool}=trues(length(degrees), length(degrees)),
)::TypedMultigraphProblem
    normalized_degrees = collect(Int, degrees)
    colors = collect(Int, vertex_colors)
    any(x -> x < 0, normalized_degrees) &&
        throw(ArgumentError("Vertex degrees must be non-negative integers."))
    length(colors) == length(normalized_degrees) ||
        throw(ArgumentError("vertex_colors must have one entry per vertex."))

    n = length(normalized_degrees)
    size(allowed) == (n, n) || throw(
        ArgumentError("allowed must be a square matrix with one row/column per vertex.")
    )
    allowed == transpose(allowed) ||
        throw(ArgumentError("allowed must be symmetric for undirected graph generation."))

    fixed = Int(num_fixed)
    0 <= fixed <= n || throw(ArgumentError("num_fixed must lie in 0:length(degrees)."))
    normalized_allowed = BitMatrix(allowed)
    normalized_degrees, colors, normalized_allowed = _normalize_typed_problem(
        normalized_degrees, colors, normalized_allowed, fixed
    )
    return TypedMultigraphProblem(normalized_degrees, colors, normalized_allowed, fixed)
end

vertex_degrees(problem::TypedMultigraphProblem)::Vector{Int} = copy(problem._degrees)

"""Return a copy of the opaque vertex colors/types."""
vertex_colors(problem::TypedMultigraphProblem)::Vector{Int} = copy(problem._vertex_colors)

"""Return a copy of the symmetric pair-local edge-admissibility matrix."""
edge_admissibility(problem::TypedMultigraphProblem)::BitMatrix = copy(problem._allowed)

fixed_vertex_count(problem::TypedMultigraphProblem)::Int = problem.num_fixed

struct _TypedProblemPreserver
    degrees::Vector{Int}
    allowed::BitMatrix
end

function (preserver::_TypedProblemPreserver)(mapping::Vector{Int})::Bool
    degrees = preserver.degrees
    @inbounds for vertex in eachindex(degrees)
        degrees[vertex] == degrees[mapping[vertex]] || return false
    end

    allowed = preserver.allowed
    @inbounds for u in axes(allowed, 1)
        for v in axes(allowed, 2)
            allowed[u, v] == allowed[mapping[u], mapping[v]] || return false
        end
    end
    return true
end

function _typed_problem_relabelings(problem::TypedMultigraphProblem)::Vector{Vector{Int}}
    return _problem_relabelings(
        problem._vertex_colors,
        problem.num_fixed,
        _TypedProblemPreserver(problem._degrees, problem._allowed),
    )
end

struct _MappedGraphCanonicalizationResult
    canonical::GraphRep
    automorphism_order::Int
end

function _canonicalize_under_mappings(
    graph::GraphRep, mappings::Vector{Vector{Int}}
)::_MappedGraphCanonicalizationResult
    isempty(mappings) && error("Internal error: canonicalization mapping group is empty.")
    best = similar(graph)
    candidate = similar(graph)
    automorphism_order = 0

    for (mapping_index, mapping) in pairs(mappings)
        _write_mapped_graph!(candidate, graph, mapping)
        if mapping_index == 1
            copyto!(best, candidate)
            automorphism_order = 1
            continue
        end
        comparison = _compare_graph_reps(candidate, best)
        if comparison < 0
            copyto!(best, candidate)
            automorphism_order = 1
        elseif iszero(comparison)
            automorphism_order = _checked_increment(automorphism_order)
        end
    end
    return _MappedGraphCanonicalizationResult(best, automorphism_order)
end

function _foreach_admissible_labeled_multigraph(
    f::F, degrees::Vector{Int}, allowed::BitMatrix
) where {F}
    residual = copy(degrees)
    graph = Edge[]
    _enumerate_admissible_vertex!(f, residual, graph, allowed, 1)
    return nothing
end

function _admissible_future_capacity(
    residual::Vector{Int}, allowed::BitMatrix, i::Int, first_future::Int
)::Int
    capacity = 0
    @inbounds for j in first_future:length(residual)
        allowed[i, j] && (capacity += residual[j])
    end
    return capacity
end

function _enumerate_admissible_vertex!(
    f::F, residual::Vector{Int}, graph::GraphRep, allowed::BitMatrix, i::Int
) where {F}
    n = length(residual)
    if i > n
        f(copy(graph))
        return nothing
    elseif i == n
        remaining = residual[i]
        iseven(remaining) || return nothing
        (!iszero(remaining) && !allowed[i, i]) && return nothing
        old_length = length(graph)
        for _ in 1:(remaining ÷ 2)
            push!(graph, Edge(i, i))
        end
        residual[i] = 0
        f(copy(graph))
        residual[i] = remaining
        resize!(graph, old_length)
        return nothing
    end

    degree_i = residual[i]
    loop_range = allowed[i, i] ? (0:(degree_i ÷ 2)) : (0:0)
    future_capacity = _admissible_future_capacity(residual, allowed, i, i + 1)
    for loops in loop_range
        remaining = degree_i - 2loops
        remaining <= future_capacity || continue
        old_length = length(graph)
        for _ in 1:loops
            push!(graph, Edge(i, i))
        end
        _distribute_admissible_edges!(f, residual, graph, allowed, i, i + 1, remaining)
        resize!(graph, old_length)
    end
    return nothing
end

function _distribute_admissible_edges!(
    f::F,
    residual::Vector{Int},
    graph::GraphRep,
    allowed::BitMatrix,
    i::Int,
    j::Int,
    remaining::Int,
) where {F}
    n = length(residual)
    if j > n
        if iszero(remaining)
            old_residual = residual[i]
            residual[i] = 0
            _enumerate_admissible_vertex!(f, residual, graph, allowed, i + 1)
            residual[i] = old_residual
        end
        return nothing
    end

    capacity_after_j = j == n ? 0 : _admissible_future_capacity(residual, allowed, i, j + 1)
    if !allowed[i, j]
        remaining <= capacity_after_j || return nothing
        _distribute_admissible_edges!(f, residual, graph, allowed, i, j + 1, remaining)
        return nothing
    end

    min_multiplicity = max(0, remaining - capacity_after_j)
    max_multiplicity = min(remaining, residual[j])
    min_multiplicity <= max_multiplicity || return nothing
    for multiplicity in min_multiplicity:max_multiplicity
        old_length = length(graph)
        residual[j] -= multiplicity
        for _ in 1:multiplicity
            push!(graph, Edge(i, j))
        end
        _distribute_admissible_edges!(
            f, residual, graph, allowed, i, j + 1, remaining - multiplicity
        )
        residual[j] += multiplicity
        resize!(graph, old_length)
    end
    return nothing
end

function _typed_is_unrestricted(problem::TypedMultigraphProblem)::Bool
    all(problem._allowed) || return false
    isempty(problem._vertex_colors) && return true
    first_color = first(problem._vertex_colors)
    return all(==(first_color), problem._vertex_colors)
end

"""
    generate_multigraphs(problem::TypedMultigraphProblem; connected=true)

Generate exact non-isomorphic typed/constrained undirected multigraphs satisfying `problem`.

Forbidden edges are excluded during residual-degree generation. Canonical representatives and
`|Aut_problem(G)|` are computed only under relabelings preserving fixed labels, vertex colors,
prescribed degrees, and the full admissibility relation. The returned symmetry denominator is the
exact `BigInt` product `|Aut_problem(G)| * edge_factor(G)`.
"""
function generate_multigraphs(
    problem::TypedMultigraphProblem; connected::Bool=true
)::Vector{Tuple{GraphRep,BigInt}}
    isempty(problem._degrees) && return Vector{Tuple{GraphRep,BigInt}}()
    isodd(sum(problem._degrees)) && return Vector{Tuple{GraphRep,BigInt}}()

    if _typed_is_unrestricted(problem)
        return _generate_degree_sequence(problem._degrees, problem.num_fixed, connected)
    end

    mappings = _typed_problem_relabelings(problem)
    topologies = Dict{GraphRep,Int}()
    n = length(problem._degrees)
    _foreach_admissible_labeled_multigraph(problem._degrees, problem._allowed) do graph
        if connected && !is_connected(build_internal_graph(graph, n))
            return nothing
        end
        canonicalization = _canonicalize_under_mappings(graph, mappings)
        if haskey(topologies, canonicalization.canonical)
            topologies[canonicalization.canonical] == canonicalization.automorphism_order ||
                error(
                    "Internal error: typed automorphism order disagrees within one topology.",
                )
        else
            topologies[canonicalization.canonical] = canonicalization.automorphism_order
        end
        return nothing
    end

    results = Vector{Tuple{GraphRep,BigInt}}()
    sizehint!(results, length(topologies))
    for (graph, automorphism_order) in topologies
        push!(results, (graph, big(automorphism_order) * _edge_symmetry_factor(graph)))
    end
    sort!(results; by=first)
    return results
end
