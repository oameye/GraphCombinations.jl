# --- Native colored directed relational canonicalization ---

"""
    DirectedRelationGraph(num_vertices, num_relations, multiplicities)

Exact finite directed relational structure. Relation labels are fixed opaque coordinates and only
vertices are relabeled. `multiplicities` is stored relation-major, then source-major, then target:
`M[relation, source, target] >= 0`.
"""
struct DirectedRelationGraph
    num_vertices::Int
    num_relations::Int
    multiplicities::Vector{Int}

    function DirectedRelationGraph(
        num_vertices::Integer,
        num_relations::Integer,
        multiplicities::AbstractVector{<:Integer},
    )
        n = Int(num_vertices)
        nr = Int(num_relations)
        n >= 0 || throw(ArgumentError("num_vertices must be non-negative."))
        nr >= 0 || throw(ArgumentError("num_relations must be non-negative."))
        expected = Base.Checked.checked_mul(n * n, nr)
        length(multiplicities) >= expected || throw(
            DimensionMismatch("relation multiplicities must contain num_relations * num_vertices^2 entries"),
        )
        values = Vector{Int}(undef, expected)
        @inbounds for index in 1:expected
            value = Int(multiplicities[index])
            value >= 0 || throw(ArgumentError("relation multiplicities must be non-negative."))
            values[index] = value
        end
        return new(n, nr, values)
    end

    function DirectedRelationGraph(
        num_vertices::Int,
        num_relations::Int,
        multiplicities::Vector{Int},
        ::Val{:borrow},
    )
        expected = Base.Checked.checked_mul(num_vertices * num_vertices, num_relations)
        length(multiplicities) >= expected || throw(
            DimensionMismatch("borrowed relation storage is smaller than the active graph"),
        )
        return new(num_vertices, num_relations, multiplicities)
    end
end

@inline function _directed_relation_slot(
    relation::Int, source::Int, target::Int, num_vertices::Int
)::Int
    return ((relation - 1) * num_vertices + source - 1) * num_vertices + target
end

@inline function _directed_relation_multiplicity(
    graph::DirectedRelationGraph, relation::Int, source::Int, target::Int
)::Int
    return graph.multiplicities[
        _directed_relation_slot(relation, source, target, graph.num_vertices)
    ]
end

function DirectedRelationGraph(
    edges::AbstractVector{<:Tuple{<:Integer,<:Integer,<:Integer}},
    num_vertices::Integer,
    num_relations::Integer,
)::DirectedRelationGraph
    n = Int(num_vertices)
    nr = Int(num_relations)
    n >= 0 || throw(ArgumentError("num_vertices must be non-negative."))
    nr >= 0 || throw(ArgumentError("num_relations must be non-negative."))
    multiplicities = zeros(Int, Base.Checked.checked_mul(n * n, nr))
    @inbounds for edge in edges
        relation = Int(edge[1])
        source = Int(edge[2])
        target = Int(edge[3])
        1 <= relation <= nr ||
            throw(ArgumentError("Relation $relation is outside 1:$nr."))
        1 <= source <= n || throw(ArgumentError("Source vertex $source is outside 1:$n."))
        1 <= target <= n || throw(ArgumentError("Target vertex $target is outside 1:$n."))
        slot = _directed_relation_slot(relation, source, target, n)
        multiplicities[slot] = Base.Checked.checked_add(multiplicities[slot], 1)
    end
    return DirectedRelationGraph(n, nr, multiplicities)
end

function Base.isequal(a::DirectedRelationGraph, b::DirectedRelationGraph)
    return a.num_vertices == b.num_vertices &&
           a.num_relations == b.num_relations &&
           isequal(a.multiplicities, b.multiplicities)
end
Base.:(==)(a::DirectedRelationGraph, b::DirectedRelationGraph) = isequal(a, b)
function Base.hash(graph::DirectedRelationGraph, h::UInt)
    h = hash(DirectedRelationGraph, h)
    h = hash(graph.num_vertices, h)
    h = hash(graph.num_relations, h)
    return hash(graph.multiplicities, h)
end

"""
    DirectedRelationGraphBuffer(vertex_capacity, relation_capacity)

Reusable compact input storage for native directed relations. Active relation data always occupy
the first `num_relations * num_vertices^2` entries, so changing the active size does not allocate.
"""
mutable struct DirectedRelationGraphBuffer
    num_vertices::Int
    num_relations::Int
    vertex_capacity::Int
    relation_capacity::Int
    multiplicities::Vector{Int}
end

function DirectedRelationGraphBuffer(
    vertex_capacity::Integer, relation_capacity::Integer
)
    n = Int(vertex_capacity)
    nr = Int(relation_capacity)
    n >= 0 || throw(ArgumentError("vertex_capacity must be non-negative."))
    nr >= 0 || throw(ArgumentError("relation_capacity must be non-negative."))
    storage = zeros(Int, Base.Checked.checked_mul(n * n, nr))
    return DirectedRelationGraphBuffer(n, nr, n, nr, storage)
end

function _prepare_directed_relation_graph_buffer!(
    graph::DirectedRelationGraphBuffer, num_vertices::Int, num_relations::Int
)::Nothing
    0 <= num_vertices <= graph.vertex_capacity ||
        throw(DimensionMismatch("directed relation graph vertex capacity is too small"))
    0 <= num_relations <= graph.relation_capacity ||
        throw(DimensionMismatch("directed relation graph relation capacity is too small"))
    active = Base.Checked.checked_mul(num_vertices * num_vertices, num_relations)
    @inbounds for slot in 1:active
        graph.multiplicities[slot] = 0
    end
    graph.num_vertices = num_vertices
    graph.num_relations = num_relations
    return nothing
end

"""
    load_directed_relations!(buffer, edges, num_vertices, num_relations)

Replace the active native relation graph in reusable storage. Each edge tuple is
`(relation, source, target)`; repeated tuples accumulate exact multiplicity.
"""
function load_directed_relations!(
    graph::DirectedRelationGraphBuffer,
    edges::AbstractVector{<:Tuple{<:Integer,<:Integer,<:Integer}},
    num_vertices::Integer=graph.num_vertices,
    num_relations::Integer=graph.num_relations,
)::DirectedRelationGraphBuffer
    n = Int(num_vertices)
    nr = Int(num_relations)
    _prepare_directed_relation_graph_buffer!(graph, n, nr)
    @inbounds for edge in edges
        relation = Int(edge[1])
        source = Int(edge[2])
        target = Int(edge[3])
        1 <= relation <= nr ||
            throw(ArgumentError("Relation $relation is outside 1:$nr."))
        1 <= source <= n || throw(ArgumentError("Source vertex $source is outside 1:$n."))
        1 <= target <= n || throw(ArgumentError("Target vertex $target is outside 1:$n."))
        slot = _directed_relation_slot(relation, source, target, n)
        graph.multiplicities[slot] = Base.Checked.checked_add(graph.multiplicities[slot], 1)
    end
    return graph
end

@inline function _directed_relation_graph_view(
    graph::DirectedRelationGraphBuffer
)::DirectedRelationGraph
    return DirectedRelationGraph(
        graph.num_vertices, graph.num_relations, graph.multiplicities, Val(:borrow)
    )
end

"""
Reusable output storage for native relation canonicalization. Witness, inverse and exact
automorphism order are always retained. Relation-major canonical-image storage is optional.
"""
mutable struct DirectedRelationCanonicalizationBuffer
    canonical_multiplicities::Vector{Int}
    old_to_canonical::Vector{Int}
    canonical_to_old::Vector{Int}
    automorphism_order::Int
    num_vertices::Int
    num_relations::Int
    vertex_capacity::Int
    relation_capacity::Int
end

function DirectedRelationCanonicalizationBuffer(
    vertex_capacity::Integer,
    relation_capacity::Integer;
    materialize_canonical::Bool=true,
)
    n = Int(vertex_capacity)
    nr = Int(relation_capacity)
    n >= 0 || throw(ArgumentError("vertex_capacity must be non-negative."))
    nr >= 0 || throw(ArgumentError("relation_capacity must be non-negative."))
    canonical = if materialize_canonical
        Vector{Int}(undef, Base.Checked.checked_mul(n * n, nr))
    else
        Int[]
    end
    return DirectedRelationCanonicalizationBuffer(
        canonical,
        Vector{Int}(undef, n),
        Vector{Int}(undef, n),
        0,
        n,
        nr,
        n,
        nr,
    )
end

@inline function canonical_rank(
    buffer::DirectedRelationCanonicalizationBuffer, old_vertex::Integer
)::Int
    vertex = Int(old_vertex)
    1 <= vertex <= buffer.num_vertices || throw(BoundsError(buffer.old_to_canonical, vertex))
    return buffer.old_to_canonical[vertex]
end

@inline function original_vertex(
    buffer::DirectedRelationCanonicalizationBuffer, canonical_vertex::Integer
)::Int
    vertex = Int(canonical_vertex)
    1 <= vertex <= buffer.num_vertices || throw(BoundsError(buffer.canonical_to_old, vertex))
    return buffer.canonical_to_old[vertex]
end

canonical_automorphism_order(buffer::DirectedRelationCanonicalizationBuffer)::Int =
    buffer.automorphism_order

function canonical_graph(
    buffer::DirectedRelationCanonicalizationBuffer
)::DirectedRelationGraph
    n = buffer.num_vertices
    nr = buffer.num_relations
    active = nr * n * n
    if active > 0 && isempty(buffer.canonical_multiplicities)
        throw(
            ArgumentError(
                "canonical image was not materialized; construct the buffer with materialize_canonical=true",
            ),
        )
    end
    multiplicities = Vector{Int}(undef, active)
    iszero(active) || copyto!(multiplicities, 1, buffer.canonical_multiplicities, 1, active)
    return DirectedRelationGraph(n, nr, multiplicities)
end

"""Exact immutable one-shot result for native directed relation canonicalization."""
struct DirectedRelationCanonicalizationResult
    _canonical::DirectedRelationGraph
    _relabeling::VertexRelabeling
    _automorphism_order::Int
end

canonical_graph(result::DirectedRelationCanonicalizationResult)::DirectedRelationGraph =
    result._canonical
canonical_relabeling(result::DirectedRelationCanonicalizationResult)::VertexRelabeling =
    result._relabeling
canonical_automorphism_order(result::DirectedRelationCanonicalizationResult)::Int =
    result._automorphism_order

"""
General allocation-free search workspace for relation multigraphs up to fixed vertex/relation
capacities. This is the exact fallback; the word-sized simple-relation kernel is defined
separately.
"""
mutable struct DirectedRelationCanonicalizationWorkspace
    vertex_capacity::Int
    relation_capacity::Int
    signature_stride::Int
    colors::Vector{Int}
    color_stack::Matrix{Int}
    refined_colors::Vector{Int}
    order::Vector{Int}
    signatures::Vector{Int}
    cell_counts::Vector{Int}
    inverse_mapping::Vector{Int}
    best_inverse_mapping::Vector{Int}
    automorphism_order::Int
    has_best::Bool
    search_nodes::Int
    search_leaves::Int
    refinement_rounds::Int
end

function DirectedRelationCanonicalizationWorkspace(
    vertex_capacity::Integer, relation_capacity::Integer
)
    n = Int(vertex_capacity)
    nr = Int(relation_capacity)
    n >= 0 || throw(ArgumentError("vertex_capacity must be non-negative."))
    nr >= 0 || throw(ArgumentError("relation_capacity must be non-negative."))
    stride = Base.Checked.checked_add(1, Base.Checked.checked_mul(2 * n, nr))
    signatures = Vector{Int}(undef, Base.Checked.checked_mul(n, stride))
    return DirectedRelationCanonicalizationWorkspace(
        n,
        nr,
        stride,
        Vector{Int}(undef, n),
        Matrix{Int}(undef, n, n + 1),
        Vector{Int}(undef, n),
        Vector{Int}(undef, n),
        signatures,
        Vector{Int}(undef, n),
        Vector{Int}(undef, n),
        Vector{Int}(undef, n),
        0,
        false,
        0,
        0,
        0,
    )
end

function _check_directed_relation_capacity(
    buffer::DirectedRelationCanonicalizationBuffer,
    workspace::DirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
)::Nothing
    n = graph.num_vertices
    nr = graph.num_relations
    n <= workspace.vertex_capacity ||
        throw(DimensionMismatch("directed relation workspace vertex capacity is too small"))
    nr <= workspace.relation_capacity ||
        throw(DimensionMismatch("directed relation workspace relation capacity is too small"))
    n <= buffer.vertex_capacity ||
        throw(DimensionMismatch("directed relation result vertex capacity is too small"))
    nr <= buffer.relation_capacity ||
        throw(DimensionMismatch("directed relation result relation capacity is too small"))
    isempty(buffer.canonical_multiplicities) ||
        length(buffer.canonical_multiplicities) >= nr * n * n ||
        throw(DimensionMismatch("directed relation result image capacity is too small"))
    return nothing
end

function _relation_initialize_colors!(
    workspace::DirectedRelationCanonicalizationWorkspace, n::Int
)::Nothing
    @inbounds for vertex in 1:n
        workspace.order[vertex] = vertex
    end
    @inbounds for index in 2:n
        vertex = workspace.order[index]
        value = workspace.colors[vertex]
        position = index - 1
        while position >= 1 && value < workspace.colors[workspace.order[position]]
            workspace.order[position + 1] = workspace.order[position]
            position -= 1
        end
        workspace.order[position + 1] = vertex
    end

    next_color = 0
    previous_value = 0
    @inbounds for index in 1:n
        vertex = workspace.order[index]
        value = workspace.colors[vertex]
        if index == 1 || value != previous_value
            next_color += 1
            previous_value = value
        end
        workspace.color_stack[vertex, 1] = next_color
    end
    return nothing
end

@inline function _relation_signature_less(
    workspace::DirectedRelationCanonicalizationWorkspace,
    left_vertex::Int,
    right_vertex::Int,
    signature_length::Int,
)::Bool
    stride = workspace.signature_stride
    left_offset = (left_vertex - 1) * stride
    right_offset = (right_vertex - 1) * stride
    @inbounds for coordinate in 1:signature_length
        left = workspace.signatures[left_offset + coordinate]
        right = workspace.signatures[right_offset + coordinate]
        left == right && continue
        return left < right
    end
    return false
end

function _relation_sort_signatures!(
    workspace::DirectedRelationCanonicalizationWorkspace,
    n::Int,
    signature_length::Int,
)::Nothing
    @inbounds for vertex in 1:n
        workspace.order[vertex] = vertex
    end
    @inbounds for index in 2:n
        vertex = workspace.order[index]
        position = index - 1
        while position >= 1 && _relation_signature_less(
            workspace, vertex, workspace.order[position], signature_length
        )
            workspace.order[position + 1] = workspace.order[position]
            position -= 1
        end
        workspace.order[position + 1] = vertex
    end
    return nothing
end

function _relation_refine_once!(
    workspace::DirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    depth::Int,
)::Bool
    n = graph.num_vertices
    nr = graph.num_relations
    iszero(n) && return true
    num_colors = 0
    @inbounds for vertex in 1:n
        num_colors = max(num_colors, workspace.color_stack[vertex, depth])
    end
    signature_length = 1 + 2 * nr * num_colors
    stride = workspace.signature_stride

    @inbounds for vertex in 1:n
        offset = (vertex - 1) * stride
        for coordinate in 1:signature_length
            workspace.signatures[offset + coordinate] = 0
        end
        workspace.signatures[offset + 1] = workspace.color_stack[vertex, depth]
        for relation in 1:nr, other in 1:n
            cell = workspace.color_stack[other, depth]
            base = offset + 2 + 2 * ((relation - 1) * num_colors + cell - 1)
            workspace.signatures[base] +=
                _directed_relation_multiplicity(graph, relation, vertex, other)
            workspace.signatures[base + 1] +=
                _directed_relation_multiplicity(graph, relation, other, vertex)
        end
    end

    _relation_sort_signatures!(workspace, n, signature_length)
    next_color = 0
    previous_vertex = 0
    @inbounds for index in 1:n
        vertex = workspace.order[index]
        if iszero(previous_vertex) || _relation_signature_less(
            workspace, previous_vertex, vertex, signature_length
        )
            next_color += 1
        end
        workspace.refined_colors[vertex] = next_color
        previous_vertex = vertex
    end

    stable = true
    @inbounds for vertex in 1:n
        refined = workspace.refined_colors[vertex]
        stable &= refined == workspace.color_stack[vertex, depth]
        workspace.color_stack[vertex, depth] = refined
    end
    workspace.refinement_rounds += 1
    return stable
end

function _relation_refine!(
    workspace::DirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    depth::Int,
)::Nothing
    while !_relation_refine_once!(workspace, graph, depth)
    end
    return nothing
end

function _relation_target_color!(
    workspace::DirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    depth::Int,
)::Int
    n = graph.num_vertices
    @inbounds for color in 1:n
        workspace.cell_counts[color] = 0
    end
    num_colors = 0
    @inbounds for vertex in 1:n
        color = workspace.color_stack[vertex, depth]
        workspace.cell_counts[color] += 1
        num_colors = max(num_colors, color)
    end
    target_color = 0
    target_size = typemax(Int)
    @inbounds for color in 1:num_colors
        count = workspace.cell_counts[color]
        if 1 < count < target_size
            target_color = color
            target_size = count
        end
    end
    return target_color
end

@inline function _relation_exact_twins(
    graph::DirectedRelationGraph, left::Int, right::Int
)::Bool
    left == right && return true
    n = graph.num_vertices
    @inbounds for relation in 1:(graph.num_relations)
        _directed_relation_multiplicity(graph, relation, left, left) ==
            _directed_relation_multiplicity(graph, relation, right, right) || return false
        _directed_relation_multiplicity(graph, relation, left, right) ==
            _directed_relation_multiplicity(graph, relation, right, left) || return false
        for other in 1:n
            (other == left || other == right) && continue
            _directed_relation_multiplicity(graph, relation, left, other) ==
                _directed_relation_multiplicity(graph, relation, right, other) || return false
            _directed_relation_multiplicity(graph, relation, other, left) ==
                _directed_relation_multiplicity(graph, relation, other, right) || return false
        end
    end
    return true
end

@inline function _compare_relation_inverse_mappings(
    graph::DirectedRelationGraph, candidate::Vector{Int}, best::Vector{Int}
)::Int
    n = graph.num_vertices
    @inbounds for relation in 1:(graph.num_relations), canonical_source in 1:n
        candidate_source = candidate[canonical_source]
        best_source = best[canonical_source]
        for canonical_target in 1:n
            candidate_target = candidate[canonical_target]
            best_target = best[canonical_target]
            left = _directed_relation_multiplicity(
                graph, relation, candidate_source, candidate_target
            )
            right = _directed_relation_multiplicity(
                graph, relation, best_source, best_target
            )
            left == right && continue
            return left < right ? -1 : 1
        end
    end
    return 0
end

function _relation_record_candidate!(
    workspace::DirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    multiplicity::Int,
)::Nothing
    n = graph.num_vertices
    if !workspace.has_best
        iszero(n) || copyto!(workspace.best_inverse_mapping, 1, workspace.inverse_mapping, 1, n)
        workspace.automorphism_order = multiplicity
        workspace.has_best = true
        return nothing
    end
    comparison = _compare_relation_inverse_mappings(
        graph, workspace.inverse_mapping, workspace.best_inverse_mapping
    )
    if comparison < 0
        iszero(n) || copyto!(workspace.best_inverse_mapping, 1, workspace.inverse_mapping, 1, n)
        workspace.automorphism_order = multiplicity
    elseif iszero(comparison)
        workspace.automorphism_order = Base.Checked.checked_add(
            workspace.automorphism_order, multiplicity
        )
    end
    return nothing
end

function _relation_record_leaf!(
    workspace::DirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    depth::Int,
    multiplicity::Int,
)::Nothing
    n = graph.num_vertices
    @inbounds for vertex in 1:n
        canonical_vertex = workspace.color_stack[vertex, depth]
        workspace.inverse_mapping[canonical_vertex] = vertex
    end
    workspace.search_leaves += 1
    _relation_record_candidate!(workspace, graph, multiplicity)
    return nothing
end

function _search_relation_workspace!(
    workspace::DirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    depth::Int,
    multiplicity::Int,
)::Nothing
    workspace.search_nodes += 1
    _relation_refine!(workspace, graph, depth)
    target_color = _relation_target_color!(workspace, graph, depth)
    if iszero(target_color)
        _relation_record_leaf!(workspace, graph, depth, multiplicity)
        return nothing
    end

    n = graph.num_vertices
    child_depth = depth + 1
    @inbounds for chosen_vertex in 1:n
        workspace.color_stack[chosen_vertex, depth] == target_color || continue
        has_earlier_twin = false
        for earlier_vertex in 1:(chosen_vertex - 1)
            workspace.color_stack[earlier_vertex, depth] == target_color || continue
            if _relation_exact_twins(graph, chosen_vertex, earlier_vertex)
                has_earlier_twin = true
                break
            end
        end
        has_earlier_twin && continue

        twin_class_size = 1
        for later_vertex in (chosen_vertex + 1):n
            workspace.color_stack[later_vertex, depth] == target_color || continue
            twin_class_size += _relation_exact_twins(graph, chosen_vertex, later_vertex)
        end
        child_multiplicity = Base.Checked.checked_mul(multiplicity, twin_class_size)

        for vertex in 1:n
            color = workspace.color_stack[vertex, depth]
            workspace.color_stack[vertex, child_depth] = if color < target_color
                color
            elseif color > target_color
                color + 1
            elseif vertex == chosen_vertex
                target_color
            else
                target_color + 1
            end
        end
        _search_relation_workspace!(workspace, graph, child_depth, child_multiplicity)
    end
    return nothing
end

function _reset_relation_workspace!(
    workspace::DirectedRelationCanonicalizationWorkspace
)::Nothing
    workspace.automorphism_order = 0
    workspace.has_best = false
    workspace.search_nodes = 0
    workspace.search_leaves = 0
    workspace.refinement_rounds = 0
    return nothing
end

function _write_relation_buffer!(
    buffer::DirectedRelationCanonicalizationBuffer,
    graph::DirectedRelationGraph,
    best_inverse::Vector{Int},
    automorphism_order::Int,
)::Nothing
    n = graph.num_vertices
    nr = graph.num_relations
    iszero(n) || copyto!(buffer.canonical_to_old, 1, best_inverse, 1, n)
    @inbounds for canonical_vertex in 1:n
        old_vertex = best_inverse[canonical_vertex]
        buffer.old_to_canonical[old_vertex] = canonical_vertex
    end
    if !isempty(buffer.canonical_multiplicities)
        @inbounds for relation in 1:nr, canonical_source in 1:n, canonical_target in 1:n
            old_source = best_inverse[canonical_source]
            old_target = best_inverse[canonical_target]
            buffer.canonical_multiplicities[
                _directed_relation_slot(relation, canonical_source, canonical_target, n)
            ] = _directed_relation_multiplicity(graph, relation, old_source, old_target)
        end
    end
    buffer.automorphism_order = automorphism_order
    buffer.num_vertices = n
    buffer.num_relations = nr
    return nothing
end

"""
    canonicalize_directed_relations!(buffer, workspace, graph, vertex_colors)

Exact prepared native relation canonicalization for arbitrary non-negative multiplicities. Search
scratch and output storage are caller-owned and reusable.
"""
function canonicalize_directed_relations!(
    buffer::DirectedRelationCanonicalizationBuffer,
    workspace::DirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
    vertex_colors::AbstractVector{<:Integer},
)::DirectedRelationCanonicalizationBuffer
    n = graph.num_vertices
    length(vertex_colors) == n ||
        throw(ArgumentError("vertex_colors must have one entry per vertex."))
    _check_directed_relation_capacity(buffer, workspace, graph)
    @inbounds for vertex in 1:n
        workspace.colors[vertex] = Int(vertex_colors[vertex])
    end
    _reset_relation_workspace!(workspace)
    _relation_initialize_colors!(workspace, n)
    _search_relation_workspace!(workspace, graph, 1, 1)
    workspace.has_best || error("directed relation canonical search produced no candidate")
    _write_relation_buffer!(
        buffer, graph, workspace.best_inverse_mapping, workspace.automorphism_order
    )
    return buffer
end

function canonicalize_directed_relations!(
    buffer::DirectedRelationCanonicalizationBuffer,
    workspace::DirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraph,
)::DirectedRelationCanonicalizationBuffer
    n = graph.num_vertices
    _check_directed_relation_capacity(buffer, workspace, graph)
    @inbounds for vertex in 1:n
        workspace.colors[vertex] = 1
    end
    _reset_relation_workspace!(workspace)
    _relation_initialize_colors!(workspace, n)
    _search_relation_workspace!(workspace, graph, 1, 1)
    workspace.has_best || error("directed relation canonical search produced no candidate")
    _write_relation_buffer!(
        buffer, graph, workspace.best_inverse_mapping, workspace.automorphism_order
    )
    return buffer
end

function canonicalize_directed_relations!(
    buffer::DirectedRelationCanonicalizationBuffer,
    workspace::DirectedRelationCanonicalizationWorkspace,
    graph::DirectedRelationGraphBuffer,
    vertex_colors::AbstractVector{<:Integer},
)::DirectedRelationCanonicalizationBuffer
    n = graph.num_vertices
    length(vertex_colors) >= n ||
        throw(ArgumentError("vertex_colors must cover every active vertex."))
    return canonicalize_directed_relations!(
        buffer, workspace, _directed_relation_graph_view(graph), @view(vertex_colors[1:n])
    )
end

function canonicalize_directed_relations(
    graph::DirectedRelationGraph,
    vertex_colors::AbstractVector{<:Integer}=ones(Int, graph.num_vertices),
)::DirectedRelationCanonicalizationResult
    workspace = DirectedRelationCanonicalizationWorkspace(
        graph.num_vertices, graph.num_relations
    )
    buffer = DirectedRelationCanonicalizationBuffer(
        graph.num_vertices, graph.num_relations
    )
    canonicalize_directed_relations!(buffer, workspace, graph, vertex_colors)
    canonical = canonical_graph(buffer)
    relabeling = VertexRelabeling(copy(buffer.old_to_canonical[1:(graph.num_vertices)]))
    return DirectedRelationCanonicalizationResult(
        canonical, relabeling, buffer.automorphism_order
    )
end