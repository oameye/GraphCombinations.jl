include(joinpath(@__DIR__, "packed_incremental_refinement_trace.jl"))

const N3_PERMUTATIONS = ([1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1])

const N3_COLORINGS = ([1, 1, 1], [1, 1, 2], [1, 2, 1], [1, 2, 2], [1, 2, 3])

function graph_from_mask(n::Int, mask::UInt64)
    edges = Pair{Int,Int}[]
    bit = 0
    for source in 1:n
        for target in 1:n
            if !iszero(mask & (UInt64(1) << bit))
                push!(edges, source => target)
            end
            bit += 1
        end
    end
    return GC.DirectedGCGraph(edges, n)
end

function relabel_colors(colors::Vector{Int}, mapping::Vector{Int})
    result = similar(colors)
    @inbounds for old_vertex in eachindex(colors)
        result[mapping[old_vertex]] = colors[old_vertex]
    end
    return result
end

function assert_same_trace(
    left::IncrementalRefinementTraceWorkspace,
    right::IncrementalRefinementTraceWorkspace,
    label::String,
)::Nothing
    left.trace_length == right.trace_length || error("trace length mismatch: $label")
    @inbounds for index in 1:left.trace_length
        left.trace[index] == right.trace[index] ||
            error("trace mismatch at event coordinate $index: $label")
    end
    left.split_events == right.split_events || error("split-event mismatch: $label")
    return nothing
end

function assert_root_refinement_matches_reference!(
    traced::IncrementalRefinementTraceWorkspace,
    graph::GC.DirectedGCGraph,
    colors::Vector{Int},
    label::String,
)::Nothing
    n = graph.num_vertices
    reference = GC.PackedDirectedCanonicalizationWorkspace(n)
    GC._prepare_packed_directed_rows!(reference, graph) || error("simple graph expected")
    reference_workspace = reference.workspace
    @inbounds for vertex in 1:n
        reference_workspace.colors[vertex] = colors[vertex]
    end
    GC._reset_directed_workspace_search!(reference_workspace)
    GC._directed_workspace_initialize_colors!(reference_workspace, n)
    GC._packed_directed_workspace_refine!(reference, graph, 1)

    traced_workspace = traced.packed.workspace
    @inbounds for vertex in 1:n
        traced_workspace.color_stack[vertex, 1] ==
        reference_workspace.color_stack[vertex, 1] ||
            error("root refined partition mismatch at vertex $vertex: $label")
    end
    return nothing
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

function certify_n3_root_and_child_trace_invariance()
    n = 3
    base = IncrementalRefinementTraceWorkspace(n)
    relabeled = IncrementalRefinementTraceWorkspace(n)
    root_cases = 0
    child_cases = 0

    for mask in UInt64(0):((UInt64(1) << (n * n)) - UInt64(1))
        graph = graph_from_mask(n, mask)
        for colors_tuple in N3_COLORINGS
            colors = collect(colors_tuple)
            refine_root_trace!(base, graph, colors)
            assert_root_refinement_matches_reference!(
                base, graph, colors, "mask=$mask colors=$colors"
            )
            base_root_trace = collect(trace_view(base))
            base_root_splits = base.split_events

            targets = root_target_vertices(graph, colors)
            for mapping_tuple in N3_PERMUTATIONS
                mapping = collect(mapping_tuple)
                relabeled_graph = GC._relabel_directed_graph(graph, mapping)
                mapped_colors = relabel_colors(colors, mapping)

                refine_root_trace!(relabeled, relabeled_graph, mapped_colors)
                length(base_root_trace) == relabeled.trace_length || error(
                    "root trace length mismatch mask=$mask colors=$colors map=$mapping"
                )
                @inbounds for index in eachindex(base_root_trace)
                    base_root_trace[index] == relabeled.trace[index] || error(
                        "root trace mismatch mask=$mask colors=$colors map=$mapping index=$index",
                    )
                end
                base_root_splits == relabeled.split_events || error(
                    "root split count mismatch mask=$mask colors=$colors map=$mapping"
                )
                root_cases += 1

                for chosen in targets
                    refine_individualized_trace!(base, graph, colors, chosen)
                    refine_individualized_trace!(
                        relabeled, relabeled_graph, mapped_colors, mapping[chosen]
                    )
                    assert_same_trace(
                        base,
                        relabeled,
                        "child mask=$mask colors=$colors chosen=$chosen map=$mapping",
                    )
                    child_cases += 1
                end
            end
        end
    end

    println("TRACE-CERT|n3-root|", root_cases)
    println("TRACE-CERT|n3-child|", child_cases)
    return nothing
end

certify_n3_root_and_child_trace_invariance()
