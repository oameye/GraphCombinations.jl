# --- Exact weak-component decomposition for directed canonicalization ---

abstract type AbstractDirectedComponentKernel end

mutable struct DirectedGeneralComponentKernel <: AbstractDirectedComponentKernel
    workspace::DirectedCanonicalizationWorkspace
end

mutable struct DirectedRecursiveComponentKernel <: AbstractDirectedComponentKernel
    workspace::DirectedRecursive.PackedRecursiveStabilizerWorkspace
end

mutable struct DirectedLevelwiseComponentKernel <: AbstractDirectedComponentKernel
    workspace::DirectedLevelwise.PackedLevelwiseIncrementalWorkspace
end

@inline function _canonicalize_directed_component!(
    buffer::DirectedCanonicalizationBuffer,
    kernel::DirectedGeneralComponentKernel,
    graph::DirectedGCGraph,
    colors::AbstractVector{<:Integer},
)::DirectedCanonicalizationBuffer
    return canonicalize_directed!(buffer, kernel.workspace, graph, colors)
end

@inline function _canonicalize_directed_component!(
    buffer::DirectedCanonicalizationBuffer,
    kernel::DirectedRecursiveComponentKernel,
    graph::DirectedGCGraph,
    colors::AbstractVector{<:Integer},
)::DirectedCanonicalizationBuffer
    return DirectedRecursive.canonicalize_recursive_stabilizers!(
        buffer, kernel.workspace, graph, colors
    )
end

@inline function _canonicalize_directed_component!(
    buffer::DirectedCanonicalizationBuffer,
    kernel::DirectedLevelwiseComponentKernel,
    graph::DirectedGCGraph,
    colors::AbstractVector{<:Integer},
)::DirectedCanonicalizationBuffer
    return DirectedLevelwise.canonicalize_levelwise_incremental!(
        buffer, kernel.workspace, graph, colors
    )
end

"""
    DirectedComponentCanonicalizationWorkspace(capacity)
    DirectedComponentCanonicalizationWorkspace(capacity, Val(:general))
    DirectedComponentCanonicalizationWorkspace(capacity, Val(:recursive))
    DirectedComponentCanonicalizationWorkspace(capacity, Val(:levelwise))

Reusable scratch for exact weak-component decomposition of colored directed multigraphs with at
most `capacity` vertices. Components are canonicalized independently, ordered by their exact
colored canonical certificates, and recombined into one global witness and automorphism order.

The default and `Val(:general)` constructors accept the complete directed-multigraph semantics.
`Val(:recursive)` and `Val(:levelwise)` select the word-sized simple-directed production kernels.
The policy is carried in the workspace type, so prepared canonicalization remains fully inferred.
The kernel choice affects performance and the private canonical convention, never exactness.
"""
mutable struct DirectedComponentCanonicalizationWorkspace{
    K<:AbstractDirectedComponentKernel
}
    component_labels::Vector{Int}
    stack::Vector{Int}
    component_vertices::Vector{Int}
    component_offsets::Vector{Int}
    component_sizes::Vector{Int}
    component_order::Vector{Int}
    global_to_local::Vector{Int}
    input_colors::Vector{Int}
    local_colors::Vector{Int}
    local_graph::DirectedGCGraphBuffer
    local_result::DirectedCanonicalizationBuffer
    kernel::K
    canonical_global_vertices::Vector{Int}
    certificate_colors::Vector{Int}
    certificate_multiplicities::Vector{Int}
    certificate_multiplicity_offsets::Vector{Int}
    component_automorphism_orders::Vector{Int}
    num_components::Int
end

function _directed_component_workspace(
    capacity::Int, kernel::K
)::DirectedComponentCanonicalizationWorkspace{K} where {K<:AbstractDirectedComponentKernel}
    return DirectedComponentCanonicalizationWorkspace{K}(
        Vector{Int}(undef, capacity),
        Vector{Int}(undef, capacity),
        Vector{Int}(undef, capacity),
        Vector{Int}(undef, capacity + 1),
        Vector{Int}(undef, capacity),
        Vector{Int}(undef, capacity),
        Vector{Int}(undef, capacity),
        Vector{Int}(undef, capacity),
        Vector{Int}(undef, capacity),
        DirectedGCGraphBuffer(capacity),
        DirectedCanonicalizationBuffer(capacity),
        kernel,
        Vector{Int}(undef, capacity),
        Vector{Int}(undef, capacity),
        Vector{Int}(undef, capacity * capacity),
        Vector{Int}(undef, capacity),
        Vector{Int}(undef, capacity),
        0,
    )
end

@inline function _checked_component_capacity(capacity::Integer)::Int
    n = Int(capacity)
    n >= 0 || throw(ArgumentError("capacity must be non-negative."))
    return n
end

function DirectedComponentCanonicalizationWorkspace(capacity::Integer)
    n = _checked_component_capacity(capacity)
    return _directed_component_workspace(
        n, DirectedGeneralComponentKernel(DirectedCanonicalizationWorkspace(n))
    )
end

function DirectedComponentCanonicalizationWorkspace(capacity::Integer, ::Val{:general})
    return DirectedComponentCanonicalizationWorkspace(capacity)
end

function DirectedComponentCanonicalizationWorkspace(capacity::Integer, ::Val{:recursive})
    n = _checked_component_capacity(capacity)
    n <= 64 || throw(
        ArgumentError("recursive component kernel supports capacities up to 64 vertices"),
    )
    return _directed_component_workspace(
        n,
        DirectedRecursiveComponentKernel(
            DirectedRecursive.PackedRecursiveStabilizerWorkspace(n)
        ),
    )
end

function DirectedComponentCanonicalizationWorkspace(capacity::Integer, ::Val{:levelwise})
    n = _checked_component_capacity(capacity)
    n <= 64 || throw(
        ArgumentError("levelwise component kernel supports capacities up to 64 vertices"),
    )
    frontier_capacity = max(4096, 16 * max(n, 1)^2)
    return _directed_component_workspace(
        n,
        DirectedLevelwiseComponentKernel(
            DirectedLevelwise.PackedLevelwiseIncrementalWorkspace(
                n; frontier_capacity=frontier_capacity
            ),
        ),
    )
end

function DirectedComponentCanonicalizationWorkspace(capacity::Integer, ::Val{K}) where {K}
    _checked_component_capacity(capacity)
    return throw(ArgumentError("unknown directed component kernel: $K"))
end

@inline function _check_directed_component_capacity(
    buffer::DirectedCanonicalizationBuffer,
    workspace::DirectedComponentCanonicalizationWorkspace,
    graph::DirectedGCGraph,
)::Nothing
    n = graph.num_vertices
    length(workspace.component_labels) >= n ||
        throw(DimensionMismatch("directed component workspace capacity is too small"))
    length(buffer.old_to_canonical) >= n ||
        throw(DimensionMismatch("directed canonicalization buffer capacity is too small"))
    length(buffer.canonical_to_old) >= n ||
        throw(DimensionMismatch("directed canonicalization buffer capacity is too small"))
    isempty(buffer.canonical_multiplicities) ||
        length(buffer.canonical_multiplicities) >= n * n ||
        throw(DimensionMismatch("directed canonicalization buffer capacity is too small"))
    return nothing
end

function _discover_directed_components!(
    workspace::DirectedComponentCanonicalizationWorkspace, graph::DirectedGCGraph
)::Int
    n = graph.num_vertices
    @inbounds for vertex in 1:n
        workspace.component_labels[vertex] = 0
    end

    num_components = 0
    vertex_cursor = 1
    @inbounds for seed in 1:n
        iszero(workspace.component_labels[seed]) || continue
        num_components += 1
        workspace.component_offsets[num_components] = vertex_cursor
        stack_size = 1
        workspace.stack[1] = seed
        workspace.component_labels[seed] = num_components

        while stack_size > 0
            vertex = workspace.stack[stack_size]
            stack_size -= 1
            workspace.component_vertices[vertex_cursor] = vertex
            vertex_cursor += 1
            for other in 1:n
                iszero(workspace.component_labels[other]) || continue
                forward = graph.multiplicities[_directed_slot(vertex, other, n)]
                backward = graph.multiplicities[_directed_slot(other, vertex, n)]
                iszero(forward) && iszero(backward) && continue
                workspace.component_labels[other] = num_components
                stack_size += 1
                workspace.stack[stack_size] = other
            end
        end
        workspace.component_sizes[num_components] =
            vertex_cursor - workspace.component_offsets[num_components]
    end
    workspace.component_offsets[num_components + 1] = vertex_cursor
    workspace.num_components = num_components
    return num_components
end

function _load_directed_component!(
    workspace::DirectedComponentCanonicalizationWorkspace,
    graph::DirectedGCGraph,
    colors::AbstractVector{<:Integer},
    component::Int,
)::Bool
    n = graph.num_vertices
    start = workspace.component_offsets[component]
    size = workspace.component_sizes[component]
    _prepare_directed_graph_buffer!(workspace.local_graph, size)
    simple = true

    @inbounds for local_vertex in 1:size
        global_vertex = workspace.component_vertices[start + local_vertex - 1]
        workspace.global_to_local[global_vertex] = local_vertex
        workspace.local_colors[local_vertex] = Int(colors[global_vertex])
    end
    @inbounds for local_source in 1:size
        global_source = workspace.component_vertices[start + local_source - 1]
        for local_target in 1:size
            global_target = workspace.component_vertices[start + local_target - 1]
            multiplicity = graph.multiplicities[_directed_slot(
                global_source, global_target, n
            )]
            workspace.local_graph.multiplicities[_directed_slot(
                local_source, local_target, size
            )] = multiplicity
            simple &= multiplicity <= 1
        end
    end
    return simple
end

@inline function _check_component_kernel_support(
    ::DirectedGeneralComponentKernel, ::Int, ::Bool
)::Nothing
    return nothing
end

@inline function _check_component_kernel_support(
    ::DirectedRecursiveComponentKernel, size::Int, simple::Bool
)::Nothing
    size <= 64 ||
        throw(ArgumentError("recursive component kernel supports at most 64 vertices"))
    simple || throw(
        ArgumentError("recursive component kernel requires simple directed components")
    )
    return nothing
end

@inline function _check_component_kernel_support(
    ::DirectedLevelwiseComponentKernel, size::Int, simple::Bool
)::Nothing
    size <= 64 ||
        throw(ArgumentError("levelwise component kernel supports at most 64 vertices"))
    simple || throw(
        ArgumentError("levelwise component kernel requires simple directed components")
    )
    return nothing
end

function _store_directed_component_certificate!(
    workspace::DirectedComponentCanonicalizationWorkspace,
    component::Int,
    multiplicity_cursor::Int,
)::Int
    start = workspace.component_offsets[component]
    size = workspace.component_sizes[component]
    workspace.certificate_multiplicity_offsets[component] = multiplicity_cursor
    workspace.component_automorphism_orders[component] = canonical_automorphism_order(
        workspace.local_result
    )

    @inbounds for canonical_vertex in 1:size
        local_vertex = workspace.local_result.canonical_to_old[canonical_vertex]
        global_vertex = workspace.component_vertices[start + local_vertex - 1]
        workspace.canonical_global_vertices[start + canonical_vertex - 1] = global_vertex
        workspace.certificate_colors[start + canonical_vertex - 1] = workspace.local_colors[local_vertex]
    end
    @inbounds for slot in 1:(size * size)
        workspace.certificate_multiplicities[multiplicity_cursor + slot - 1] = workspace.local_result.canonical_multiplicities[slot]
    end
    return multiplicity_cursor + size * size
end

@inline function _directed_component_certificate_less(
    workspace::DirectedComponentCanonicalizationWorkspace, left::Int, right::Int
)::Bool
    left_size = workspace.component_sizes[left]
    right_size = workspace.component_sizes[right]
    left_size == right_size || return left_size < right_size

    left_start = workspace.component_offsets[left]
    right_start = workspace.component_offsets[right]
    @inbounds for index in 0:(left_size - 1)
        left_color = workspace.certificate_colors[left_start + index]
        right_color = workspace.certificate_colors[right_start + index]
        left_color == right_color || return left_color < right_color
    end

    left_multiplicity = workspace.certificate_multiplicity_offsets[left]
    right_multiplicity = workspace.certificate_multiplicity_offsets[right]
    @inbounds for index in 0:(left_size * left_size - 1)
        left_value = workspace.certificate_multiplicities[left_multiplicity + index]
        right_value = workspace.certificate_multiplicities[right_multiplicity + index]
        left_value == right_value || return left_value < right_value
    end
    return false
end

@inline function _same_directed_component_certificate(
    workspace::DirectedComponentCanonicalizationWorkspace, left::Int, right::Int
)::Bool
    size = workspace.component_sizes[left]
    size == workspace.component_sizes[right] || return false
    left_start = workspace.component_offsets[left]
    right_start = workspace.component_offsets[right]
    @inbounds for index in 0:(size - 1)
        workspace.certificate_colors[left_start + index] ==
        workspace.certificate_colors[right_start + index] || return false
    end
    left_multiplicity = workspace.certificate_multiplicity_offsets[left]
    right_multiplicity = workspace.certificate_multiplicity_offsets[right]
    @inbounds for index in 0:(size * size - 1)
        workspace.certificate_multiplicities[left_multiplicity + index] ==
        workspace.certificate_multiplicities[right_multiplicity + index] || return false
    end
    return true
end

function _sort_directed_components!(
    workspace::DirectedComponentCanonicalizationWorkspace
)::Nothing
    count = workspace.num_components
    @inbounds for component in 1:count
        workspace.component_order[component] = component
    end
    @inbounds for index in 2:count
        component = workspace.component_order[index]
        position = index - 1
        while position >= 1 && _directed_component_certificate_less(
            workspace, component, workspace.component_order[position]
        )
            workspace.component_order[position + 1] = workspace.component_order[position]
            position -= 1
        end
        workspace.component_order[position + 1] = component
    end
    return nothing
end

@inline function _checked_component_factorial(value::Int)::Int
    result = 1
    @inbounds for factor in 2:value
        result = Base.Checked.checked_mul(result, factor)
    end
    return result
end

function _write_directed_component_result!(
    buffer::DirectedCanonicalizationBuffer,
    workspace::DirectedComponentCanonicalizationWorkspace,
    n::Int,
)::DirectedCanonicalizationBuffer
    if !isempty(buffer.canonical_multiplicities)
        @inbounds for slot in 1:(n * n)
            buffer.canonical_multiplicities[slot] = 0
        end
    end

    automorphism_order = 1
    canonical_offset = 0
    @inbounds for position in 1:(workspace.num_components)
        component = workspace.component_order[position]
        size = workspace.component_sizes[component]
        start = workspace.component_offsets[component]
        multiplicity_start = workspace.certificate_multiplicity_offsets[component]
        automorphism_order = Base.Checked.checked_mul(
            automorphism_order, workspace.component_automorphism_orders[component]
        )

        for local_vertex in 1:size
            canonical_vertex = canonical_offset + local_vertex
            old_vertex = workspace.canonical_global_vertices[start + local_vertex - 1]
            buffer.canonical_to_old[canonical_vertex] = old_vertex
            buffer.old_to_canonical[old_vertex] = canonical_vertex
        end
        if !isempty(buffer.canonical_multiplicities)
            for local_source in 1:size, local_target in 1:size
                canonical_source = canonical_offset + local_source
                canonical_target = canonical_offset + local_target
                local_slot = (local_source - 1) * size + local_target
                buffer.canonical_multiplicities[_directed_slot(canonical_source, canonical_target, n)] = workspace.certificate_multiplicities[multiplicity_start + local_slot - 1]
            end
        end
        canonical_offset += size
    end

    position = 1
    while position <= workspace.num_components
        first_component = workspace.component_order[position]
        final_position = position
        while final_position < workspace.num_components &&
              _same_directed_component_certificate(
            workspace, first_component, workspace.component_order[final_position + 1]
        )
            final_position += 1
        end
        multiplicity = final_position - position + 1
        automorphism_order = Base.Checked.checked_mul(
            automorphism_order, _checked_component_factorial(multiplicity)
        )
        position = final_position + 1
    end

    buffer.automorphism_order = automorphism_order
    buffer.num_vertices = n
    return buffer
end

@inline function _directed_graph_is_simple(graph::DirectedGCGraph)::Bool
    n = graph.num_vertices
    simple = true
    @inbounds for slot in 1:(n * n)
        simple &= graph.multiplicities[slot] <= 1
    end
    return simple
end

"""
    canonicalize_directed_components!(buffer, workspace, graph, vertex_colors)

Canonicalize a colored directed graph by exact weak-component decomposition. If the graph is
connected, the selected component kernel is applied directly to the original graph. Otherwise,
each weak component is canonicalized independently, components are ordered by exact canonical
colored certificates, and repeated isomorphic components contribute their exact factorial
exchange symmetry to the automorphism order.

The output uses the standard `DirectedCanonicalizationBuffer` contract, including witness-only
buffers created with `materialize_canonical=false`.
"""
function canonicalize_directed_components!(
    buffer::DirectedCanonicalizationBuffer,
    workspace::DirectedComponentCanonicalizationWorkspace,
    graph::DirectedGCGraph,
    vertex_colors::AbstractVector{<:Integer},
)::DirectedCanonicalizationBuffer
    n = graph.num_vertices
    length(vertex_colors) == n ||
        throw(ArgumentError("vertex_colors must have one entry per vertex."))
    _check_directed_component_capacity(buffer, workspace, graph)
    num_components = _discover_directed_components!(workspace, graph)

    if num_components <= 1
        if iszero(n)
            buffer.automorphism_order = 1
            buffer.num_vertices = 0
            return buffer
        end
        simple = _directed_graph_is_simple(graph)
        _check_component_kernel_support(workspace.kernel, n, simple)
        return _canonicalize_directed_component!(
            buffer, workspace.kernel, graph, vertex_colors
        )
    end

    multiplicity_cursor = 1
    @inbounds for component in 1:num_components
        simple = _load_directed_component!(workspace, graph, vertex_colors, component)
        size = workspace.component_sizes[component]
        _check_component_kernel_support(workspace.kernel, size, simple)
        local_graph = _directed_graph_view(workspace.local_graph)
        local_colors = @view workspace.local_colors[1:size]
        _canonicalize_directed_component!(
            workspace.local_result, workspace.kernel, local_graph, local_colors
        )
        multiplicity_cursor = _store_directed_component_certificate!(
            workspace, component, multiplicity_cursor
        )
    end
    _sort_directed_components!(workspace)
    return _write_directed_component_result!(buffer, workspace, n)
end

function canonicalize_directed_components!(
    buffer::DirectedCanonicalizationBuffer,
    workspace::DirectedComponentCanonicalizationWorkspace,
    graph::DirectedGCGraph,
)::DirectedCanonicalizationBuffer
    n = graph.num_vertices
    @inbounds for vertex in 1:n
        workspace.input_colors[vertex] = 1
    end
    return canonicalize_directed_components!(
        buffer, workspace, graph, @view(workspace.input_colors[1:n])
    )
end

function canonicalize_directed_components!(
    buffer::DirectedCanonicalizationBuffer,
    workspace::DirectedComponentCanonicalizationWorkspace,
    graph::DirectedGCGraphBuffer,
    vertex_colors::AbstractVector{<:Integer},
)::DirectedCanonicalizationBuffer
    n = graph.num_vertices
    length(vertex_colors) >= n ||
        throw(ArgumentError("vertex_colors must cover every active vertex."))
    return canonicalize_directed_components!(
        buffer, workspace, _directed_graph_view(graph), @view(vertex_colors[1:n])
    )
end

function canonicalize_directed_components!(
    buffer::DirectedCanonicalizationBuffer,
    workspace::DirectedComponentCanonicalizationWorkspace,
    graph::DirectedGCGraphBuffer,
)::DirectedCanonicalizationBuffer
    return canonicalize_directed_components!(buffer, workspace, _directed_graph_view(graph))
end
