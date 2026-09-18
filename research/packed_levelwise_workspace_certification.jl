import GraphCombinations as GC

module LevelwiseReference
include(joinpath(@__DIR__, "packed_levelwise_exact_multiplicity.jl"))
end

module LevelwiseCandidate
include(joinpath(@__DIR__, "packed_levelwise_workspace.jl"))
end

const WORKSPACE_N3_PERMUTATIONS = (
    [1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]
)

const WORKSPACE_N3_COLORINGS = ([1, 1, 1], [1, 1, 2], [1, 2, 1], [1, 2, 2], [1, 2, 3])

function workspace_graph_from_mask(n::Int, mask::UInt64)
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

function workspace_relabel_colors(colors::Vector{Int}, mapping::Vector{Int})
    result = similar(colors)
    @inbounds for old_vertex in eachindex(colors)
        result[mapping[old_vertex]] = colors[old_vertex]
    end
    return result
end

function workspace_same_image(
    left::GC.DirectedCanonicalizationBuffer,
    right::GC.DirectedCanonicalizationBuffer,
    n::Int,
)::Bool
    @inbounds for slot in 1:(n * n)
        left.canonical_multiplicities[slot] == right.canonical_multiplicities[slot] ||
            return false
    end
    return true
end

function workspace_witness_reconstructs(
    buffer::GC.DirectedCanonicalizationBuffer, graph::GC.DirectedGCGraph
)::Bool
    n = graph.num_vertices
    @inbounds for canonical_source in 1:n
        old_source = buffer.canonical_to_old[canonical_source]
        buffer.old_to_canonical[old_source] == canonical_source || return false
        for canonical_target in 1:n
            old_target = buffer.canonical_to_old[canonical_target]
            buffer.canonical_multiplicities[GC._directed_slot(
                canonical_source, canonical_target, n
            )] == graph.multiplicities[GC._directed_slot(old_source, old_target, n)] ||
                return false
        end
    end
    return true
end

function certify_workspace_n3()
    n = 3
    workspace = LevelwiseCandidate.PackedLevelwiseWorkspace(n; frontier_capacity=256)
    buffer = GC.DirectedCanonicalizationBuffer(n)
    cases = 0
    relabelings = 0

    for mask in UInt64(0):((UInt64(1) << (n * n)) - UInt64(1))
        graph = workspace_graph_from_mask(n, mask)
        for colors_tuple in WORKSPACE_N3_COLORINGS
            colors = collect(colors_tuple)
            reference, reference_stats, reference_experimental = LevelwiseReference.levelwise_trace_exact_buffer(
                graph, colors
            )
            LevelwiseCandidate.canonicalize_levelwise_workspace!(
                buffer, workspace, graph, colors
            )
            workspace_same_image(reference, buffer, n) ||
                error("workspace image mismatch: mask=$mask colors=$colors")
            buffer.automorphism_order == reference.automorphism_order ||
                error("workspace order mismatch: mask=$mask colors=$colors")
            workspace.generated_nodes == reference_stats.generated_nodes ||
                error("workspace generated-node mismatch")
            workspace.quotient_discards == reference_experimental.quotient_discards ||
                error("workspace quotient-discard mismatch")
            workspace_witness_reconstructs(buffer, graph) ||
                error("workspace witness mismatch")
            cases += 1

            for mapping_tuple in WORKSPACE_N3_PERMUTATIONS
                mapping = collect(mapping_tuple)
                relabeled_graph = GC._relabel_directed_graph(graph, mapping)
                relabeled_colors = workspace_relabel_colors(colors, mapping)
                LevelwiseCandidate.canonicalize_levelwise_workspace!(
                    buffer, workspace, relabeled_graph, relabeled_colors
                )
                workspace_same_image(reference, buffer, n) ||
                    error("workspace relabeling changed canonical image")
                buffer.automorphism_order == reference.automorphism_order ||
                    error("workspace relabeling changed automorphism order")
                workspace_witness_reconstructs(buffer, relabeled_graph) ||
                    error("workspace relabeled witness mismatch")
                relabelings += 1
            end
        end
    end

    println("LEVELWISE-WORKSPACE-CERT|n3-base|", cases)
    println("LEVELWISE-WORKSPACE-CERT|n3-relabelings|", relabelings)
    return nothing
end

function workspace_interleaved_anchored_cycles(sizes::Tuple{Vararg{Int}})
    component_count = length(sizes)
    n = sum(sizes) + 1
    ids = [zeros(Int, size) for size in sizes]
    next_vertex = 1
    for local_index in 1:maximum(sizes)
        for component in 1:component_count
            local_index <= sizes[component] || continue
            ids[component][local_index] = next_vertex
            next_vertex += 1
        end
    end

    anchor = n
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
    return GC.DirectedGCGraph(edges, n), colors
end

function certify_workspace_product(name::String, sizes::Tuple{Vararg{Int}})
    graph, colors = workspace_interleaved_anchored_cycles(sizes)
    n = graph.num_vertices
    reference, reference_stats, reference_experimental = LevelwiseReference.levelwise_trace_exact_buffer(
        graph, colors
    )
    workspace = LevelwiseCandidate.PackedLevelwiseWorkspace(n; frontier_capacity=4096)
    buffer = GC.DirectedCanonicalizationBuffer(n)
    LevelwiseCandidate.canonicalize_levelwise_workspace!(buffer, workspace, graph, colors)

    workspace_same_image(reference, buffer, n) ||
        error("workspace image mismatch for $name")
    buffer.automorphism_order == reference.automorphism_order ||
        error("workspace order mismatch for $name")
    workspace.generated_nodes == reference_stats.generated_nodes ||
        error("workspace generated-node mismatch for $name")
    workspace.quotient_discards == reference_experimental.quotient_discards ||
        error("workspace quotient mismatch for $name")

    # Warm once more before the allocation gate.
    LevelwiseCandidate.canonicalize_levelwise_workspace!(buffer, workspace, graph, colors)
    allocated = @allocated LevelwiseCandidate.canonicalize_levelwise_workspace!(
        buffer, workspace, graph, colors
    )
    iszero(allocated) ||
        error("prepared levelwise path allocated $allocated bytes for $name")

    println(
        "LEVELWISE-WORKSPACE|",
        name,
        "|order=",
        buffer.automorphism_order,
        "|generated=",
        workspace.generated_nodes,
        "|retained=",
        workspace.retained_nodes,
        "|leaves=",
        workspace.leaves,
        "|paths=",
        workspace.experimental_paths,
        "|quotient_discards=",
        workspace.quotient_discards,
        "|allocated=",
        allocated,
    )
    return nothing
end

certify_workspace_n3()
certify_workspace_product("anchored-cycles-7x9", (7, 9))
certify_workspace_product("anchored-cycles-5x7x11", (5, 7, 11))
certify_workspace_product("anchored-cycles-5x7x9x11", (5, 7, 9, 11))
certify_workspace_product("anchored-cycles-5x7x9x11x13", (5, 7, 9, 11, 13))
