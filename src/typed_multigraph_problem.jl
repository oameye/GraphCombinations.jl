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

function _typed_normalization_cells(
    degrees::Vector{Int}, colors::Vector{Int}, num_fixed::Int
)::Vector{Vector{Int}}
    first_nonfixed = num_fixed + 1
    first_nonfixed > length(degrees) && return Vector{Vector{Int}}()

    sorted_colors = sort!(unique(colors[first_nonfixed:end]))
    cells = Vector{Vector{Int}}()
    for color in sorted_colors
        color_vertices = Int[]
        for vertex in first_nonfixed:length(colors)
            colors[vertex] == color && push!(color_vertices, vertex)
        end

        sorted_degrees = sort!(unique(degrees[color_vertices]))
        for degree in sorted_degrees
            cell = Int[]
            for vertex in color_vertices
                degrees[vertex] == degree && push!(cell, vertex)
            end
            push!(cells, cell)
        end
    end
    return cells
end

function _refine_typed_normalization_cells(
    cells::Vector{Vector{Int}}, allowed::BitMatrix, pivot::Int
)::Vector{Vector{Int}}
    refined = Vector{Vector{Int}}()
    sizehint!(refined, 2 * length(cells))
    for cell in cells
        forbidden = Int[]
        admissible = Int[]
        sizehint!(forbidden, length(cell))
        sizehint!(admissible, length(cell))
        @inbounds for vertex in cell
            vertex == pivot && continue
            if allowed[vertex, pivot]
                push!(admissible, vertex)
            else
                push!(forbidden, vertex)
            end
        end
        isempty(forbidden) || push!(refined, forbidden)
        isempty(admissible) || push!(refined, admissible)
    end
    return refined
end

function _typed_normalization_twins(allowed::BitMatrix, a::Int, b::Int)::Bool
    allowed[a, a] == allowed[b, b] || return false
    @inbounds for vertex in axes(allowed, 1)
        (vertex == a || vertex == b) && continue
        allowed[a, vertex] == allowed[b, vertex] || return false
    end
    return true
end

function _compare_mapped_bitmatrix(
    matrix::BitMatrix, candidate_inverse::Vector{Int}, best_inverse::Vector{Int}
)::Int
    n = size(matrix, 1)
    @inbounds for column in 1:n
        candidate_column = candidate_inverse[column]
        best_column = best_inverse[column]
        for row in 1:n
            candidate_value = matrix[candidate_inverse[row], candidate_column]
            best_value = matrix[best_inverse[row], best_column]
            candidate_value == best_value && continue
            return candidate_value ? 1 : -1
        end
    end
    return 0
end

mutable struct _TypedNormalizationSearchState
    inverse_mapping::Vector{Int}
    best_inverse_mapping::Vector{Int}
    has_best::Bool
end

function _typed_normalization_search!(
    state::_TypedNormalizationSearchState,
    allowed::BitMatrix,
    cells::Vector{Vector{Int}},
    target_vertex::Int,
)::Nothing
    n = size(allowed, 1)
    if target_vertex > n
        if !state.has_best ||
            _compare_mapped_bitmatrix(
            allowed, state.inverse_mapping, state.best_inverse_mapping
        ) < 0
            copyto!(state.best_inverse_mapping, state.inverse_mapping)
            state.has_best = true
        end
        return nothing
    end

    isempty(cells) && error("Internal error: typed normalization partition is empty.")
    cell = first(cells)
    minimum_loop = true
    @inbounds for vertex in cell
        if !allowed[vertex, vertex]
            minimum_loop = false
            break
        end
    end

    for (candidate_index, vertex) in pairs(cell)
        allowed[vertex, vertex] == minimum_loop || continue

        equivalent_candidate = false
        @inbounds for previous_index in 1:(candidate_index - 1)
            previous = cell[previous_index]
            allowed[previous, previous] == minimum_loop || continue
            if _typed_normalization_twins(allowed, vertex, previous)
                equivalent_candidate = true
                break
            end
        end
        equivalent_candidate && continue

        state.inverse_mapping[target_vertex] = vertex
        refined = _refine_typed_normalization_cells(cells, allowed, vertex)
        _typed_normalization_search!(state, allowed, refined, target_vertex + 1)
    end
    return nothing
end

function _materialize_typed_metadata(
    degrees::Vector{Int},
    colors::Vector{Int},
    allowed::BitMatrix,
    inverse_mapping::Vector{Int},
)::Tuple{Vector{Int},Vector{Int},BitMatrix}
    n = length(degrees)
    normalized_degrees = similar(degrees)
    normalized_colors = similar(colors)
    normalized_allowed = falses(n, n)

    @inbounds for new_vertex in 1:n
        old_vertex = inverse_mapping[new_vertex]
        normalized_degrees[new_vertex] = degrees[old_vertex]
        normalized_colors[new_vertex] = colors[old_vertex]
    end
    @inbounds for new_u in 1:n
        old_u = inverse_mapping[new_u]
        for new_v in 1:n
            normalized_allowed[new_u, new_v] = allowed[old_u, inverse_mapping[new_v]]
        end
    end
    return normalized_degrees, normalized_colors, normalized_allowed
end

function _normalize_typed_problem(
    degrees::Vector{Int}, colors::Vector{Int}, allowed::BitMatrix, num_fixed::Int
)::Tuple{Vector{Int},Vector{Int},BitMatrix}
    n = length(degrees)
    n <= num_fixed + 1 && return degrees, colors, allowed

    # The legacy representation first sorts nonfixed colors, then minimizes the complete degree
    # vector, and only then minimizes the admissibility matrix. Color/degree cells therefore have
    # a fixed target order. Within those cells we refine by matrix bits in the exact order in which
    # they enter the lexicographic comparison, so refinement never changes the canonical bytes.
    cells = _typed_normalization_cells(degrees, colors, num_fixed)
    for fixed_vertex in 1:num_fixed
        cells = _refine_typed_normalization_cells(cells, allowed, fixed_vertex)
    end

    inverse_mapping = collect(1:n)
    best_inverse_mapping = similar(inverse_mapping)
    state = _TypedNormalizationSearchState(inverse_mapping, best_inverse_mapping, false)
    _typed_normalization_search!(state, allowed, cells, num_fixed + 1)
    state.has_best || error("Internal error: typed normalization orbit is empty.")

    return _materialize_typed_metadata(degrees, colors, allowed, state.best_inverse_mapping)
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

    num_vertices = length(first(mappings))
    matrix = _graph_multiplicity_matrix(graph, num_vertices)
    inverse_mapping = Vector{Int}(undef, num_vertices)
    best_inverse_mapping = similar(inverse_mapping)
    automorphism_order = 0

    for (mapping_index, mapping) in pairs(mappings)
        length(mapping) == num_vertices ||
            error("Internal error: canonicalization mappings have inconsistent sizes.")
        _write_inverse_permutation!(inverse_mapping, mapping, 1)

        if mapping_index == 1
            copyto!(best_inverse_mapping, inverse_mapping)
            automorphism_order = 1
            continue
        end

        comparison = _compare_mapped_multiplicity(
            matrix, inverse_mapping, best_inverse_mapping, 1, num_vertices
        )
        if comparison < 0
            copyto!(best_inverse_mapping, inverse_mapping)
            automorphism_order = 1
        elseif iszero(comparison)
            automorphism_order = _checked_increment(automorphism_order)
        end
    end

    canonical = _materialize_mapped_graph(
        matrix, best_inverse_mapping, 1, num_vertices, length(graph)
    )
    return _MappedGraphCanonicalizationResult(canonical, automorphism_order)
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
    if _use_typed_row_state_reduction(length(mappings))
        return _generate_typed_row_reduced(problem, mappings; connected)
    end

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
