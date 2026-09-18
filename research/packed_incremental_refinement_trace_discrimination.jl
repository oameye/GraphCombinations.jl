include(joinpath(@__DIR__, "packed_incremental_refinement_trace.jl"))

function interleaved_anchored_cycles_with_orbits(sizes::Tuple{Vararg{Int}})
    component_count = length(sizes)
    component_vertices = sum(sizes)
    n = component_vertices + 1
    ids = [zeros(Int, size) for size in sizes]
    component_of = zeros(Int, n)
    next_vertex = 1
    for local_index in 1:maximum(sizes)
        for component in 1:component_count
            local_index <= sizes[component] || continue
            ids[component][local_index] = next_vertex
            component_of[next_vertex] = component
            next_vertex += 1
        end
    end

    anchor = n
    component_of[anchor] = 0
    edges = Pair{Int,Int}[]
    colors = ones(Int, n)
    colors[anchor] = 2
    for component in 1:component_count
        size = sizes[component]
        for local_index in 1:size
            source = ids[component][local_index]
            target = ids[component][mod1(local_index + 1, size)]
            push!(edges, source => target)
            push!(edges, source => anchor)
            push!(edges, anchor => source)
        end
    end
    return GC.DirectedGCGraph(edges, n), colors, component_of
end

function root_target_vertices(graph::GC.DirectedGCGraph, colors::Vector{Int})
    n = graph.num_vertices
    packed = GC.PackedDirectedCanonicalizationWorkspace(n)
    GC._prepare_packed_directed_rows!(packed, graph) || error("simple graph expected")
    workspace = packed.workspace
    @inbounds for vertex in 1:n
        workspace.colors[vertex] = colors[vertex]
    end
    GC._reset_directed_workspace_search!(workspace)
    GC._directed_workspace_initialize_colors!(workspace, n)
    GC._packed_directed_workspace_refine!(packed, graph, 1)
    target_color = GC._directed_workspace_target_color!(workspace, graph, 1)
    iszero(target_color) && return Int[]
    return [vertex for vertex in 1:n if workspace.color_stack[vertex, 1] == target_color]
end

function first_trace_difference(left::Vector{Int}, right::Vector{Int})
    common = min(length(left), length(right))
    @inbounds for index in 1:common
        left[index] == right[index] || return index
    end
    return length(left) == length(right) ? 0 : common + 1
end

function measure_trace_discrimination(name::String, sizes::Tuple{Vararg{Int}})
    graph, colors, component_of = interleaved_anchored_cycles_with_orbits(sizes)
    traced = IncrementalRefinementTraceWorkspace(graph.num_vertices)
    targets = root_target_vertices(graph, colors)

    traces = Vector{Vector{Int}}()
    vertices = Int[]
    components = Int[]
    for chosen in targets
        refine_individualized_trace!(traced, graph, colors, chosen)
        push!(traces, collect(trace_view(traced)))
        push!(vertices, chosen)
        push!(components, component_of[chosen])
    end

    class_representatives = Int[]
    class_members = Vector{Vector{Int}}()
    for index in eachindex(traces)
        found = 0
        for class_index in eachindex(class_representatives)
            representative = class_representatives[class_index]
            if traces[index] == traces[representative]
                found = class_index
                break
            end
        end
        if iszero(found)
            push!(class_representatives, index)
            push!(class_members, [index])
        else
            push!(class_members[found], index)
        end
    end

    minimum_difference = typemax(Int)
    maximum_difference = 0
    for left_class in 1:length(class_representatives)
        for right_class in (left_class + 1):length(class_representatives)
            difference = first_trace_difference(
                traces[class_representatives[left_class]],
                traces[class_representatives[right_class]],
            )
            iszero(difference) && continue
            minimum_difference = min(minimum_difference, difference)
            maximum_difference = max(maximum_difference, difference)
        end
    end
    isempty(class_representatives) && (minimum_difference = 0)
    minimum_difference == typemax(Int) && (minimum_difference = 0)

    print("TRACE-DISCRIM|", name, "|targets=", length(targets))
    print("|true_orbits=", length(unique(components)))
    print("|trace_classes=", length(class_representatives))
    print("|first_diff_min=", minimum_difference)
    print("|first_diff_max=", maximum_difference)
    print("|classes=")
    for class_index in eachindex(class_members)
        indices = class_members[class_index]
        class_components = sort(unique(components[index] for index in indices))
        print(
            class_index == 1 ? "" : ";",
            length(indices),
            ":",
            join(class_components, ","),
            ":len",
            length(traces[class_representatives[class_index]]),
        )
    end
    println()

    # Different traces are a proof of different rooted isomorphism classes.
    # For these fixtures the known components are non-isomorphic cycles of
    # distinct lengths, so the ideal trace partition is exactly the component
    # orbit partition.
    length(class_representatives) == length(sizes) ||
        error("trace failed to separate known rooted orbit classes for $name")
    for indices in class_members
        length(unique(components[index] for index in indices)) == 1 ||
            error("trace class mixed known rooted orbit classes for $name")
    end
    return nothing
end

measure_trace_discrimination("anchored-cycles-7x9", (7, 9))
measure_trace_discrimination("anchored-cycles-5x7x11", (5, 7, 11))
measure_trace_discrimination("anchored-cycles-5x7x9x11", (5, 7, 9, 11))
measure_trace_discrimination("anchored-cycles-5x7x9x11x13", (5, 7, 9, 11, 13))
