include(joinpath(@__DIR__, "packed_levelwise_trace_search.jl"))

const LEVELWISE_N3_PERMUTATIONS = (
    [1, 2, 3],
    [1, 3, 2],
    [2, 1, 3],
    [2, 3, 1],
    [3, 1, 2],
    [3, 2, 1],
)

const LEVELWISE_N3_COLORINGS = (
    [1, 1, 1],
    [1, 1, 2],
    [1, 2, 1],
    [1, 2, 2],
    [1, 2, 3],
)

function levelwise_graph_from_mask(n::Int, mask::UInt64)
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

function levelwise_relabel_colors(colors::Vector{Int}, mapping::Vector{Int})
    result = similar(colors)
    @inbounds for old_vertex in eachindex(colors)
        result[mapping[old_vertex]] = colors[old_vertex]
    end
    return result
end

function certify_levelwise_n3()
    n = 3
    cases = 0
    convention_changes = 0
    for mask in UInt64(0):((UInt64(1) << (n * n)) - UInt64(1))
        graph = levelwise_graph_from_mask(n, mask)
        for colors_tuple in LEVELWISE_N3_COLORINGS
            colors = collect(colors_tuple)
            base_buffer, _ = levelwise_trace_canonical_buffer(graph, colors)

            legacy = GC.canonicalize_directed(graph, colors)
            legacy_graph = GC.canonical_graph(legacy)
            @view(base_buffer.canonical_multiplicities[1:(n * n)]) == legacy_graph.multiplicities ||
                (convention_changes += 1)

            for mapping_tuple in LEVELWISE_N3_PERMUTATIONS
                mapping = collect(mapping_tuple)
                relabeled_graph = GC._relabel_directed_graph(graph, mapping)
                mapped_colors = levelwise_relabel_colors(colors, mapping)
                mapped_buffer, _ = levelwise_trace_canonical_buffer(
                    relabeled_graph, mapped_colors
                )
                @view(mapped_buffer.canonical_multiplicities[1:(n * n)]) ==
                    @view(base_buffer.canonical_multiplicities[1:(n * n)]) ||
                    error(
                        "trace-defined canonical form changed under relabeling: mask=$mask colors=$colors map=$mapping"
                    )
                cases += 1
            end
        end
    end
    println("LEVELWISE-CERT|n3-relabelings|", cases)
    println("LEVELWISE-CERT|legacy-convention-changes|", convention_changes)
    return nothing
end

certify_levelwise_n3()
