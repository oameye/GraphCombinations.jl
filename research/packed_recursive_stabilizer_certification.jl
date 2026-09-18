include(joinpath(@__DIR__, "packed_recursive_stabilizer_orbits.jl"))

function graph_from_mask(n::Int, mask::UInt64)
    edges = Pair{Int,Int}[]
    bit_index = 0
    for source in 1:n, target in 1:n
        if !iszero(mask & (UInt64(1) << bit_index))
            push!(edges, source => target)
        end
        bit_index += 1
    end
    return GC.DirectedGCGraph(edges, n)
end

function restricted_growth_colorings(n::Int)
    n == 0 && return [Int[]]
    result = Vector{Vector{Int}}()
    current = ones(Int, n)

    function visit(position::Int, current_max::Int)
        if position > n
            push!(result, copy(current))
            return
        end
        for color in 1:(current_max + 1)
            current[position] = color
            visit(position + 1, max(current_max, color))
        end
        return
    end

    current[1] = 1
    visit(2, 1)
    return result
end

function assert_recursive_matches!(
    label::String,
    graph::GC.DirectedGCGraph,
    colors::Vector{Int},
    base_buffer::GC.DirectedCanonicalizationBuffer,
    base_workspace::GC.PackedDirectedCanonicalizationWorkspace,
    recursive_buffer::GC.DirectedCanonicalizationBuffer,
    recursive_workspace::RecursiveStabilizerWorkspace;
    independent::Bool=false,
)
    n = graph.num_vertices
    GC.canonicalize_directed_packed!(base_buffer, base_workspace, graph, colors)
    canonicalize_recursive_stabilizers!(
        recursive_buffer, recursive_workspace, graph, colors
    )

    @inbounds for coordinate in 1:(n * n)
        base_buffer.canonical_multiplicities[coordinate] ==
            recursive_buffer.canonical_multiplicities[coordinate] ||
            error("canonical image mismatch: $label")
    end
    @inbounds for vertex in 1:n
        base_buffer.old_to_canonical[vertex] == recursive_buffer.old_to_canonical[vertex] ||
            error("canonical witness mismatch: $label")
        base_buffer.canonical_to_old[vertex] == recursive_buffer.canonical_to_old[vertex] ||
            error("inverse witness mismatch: $label")
    end
    base_buffer.automorphism_order == recursive_buffer.automorphism_order ||
        error("automorphism-order mismatch: $label")

    if independent
        oracle = GC.canonicalize_directed(graph, colors)
        oracle_graph = GC.canonical_graph(oracle)
        oracle_mapping = GC.vertex_mapping(GC.canonical_relabeling(oracle))
        @inbounds for coordinate in 1:(n * n)
            oracle_graph.multiplicities[coordinate] ==
                recursive_buffer.canonical_multiplicities[coordinate] ||
                error("independent canonical image mismatch: $label")
        end
        oracle_mapping == recursive_buffer.old_to_canonical[1:n] ||
            error("independent canonical witness mismatch: $label")
        GC.canonical_automorphism_order(oracle) == recursive_buffer.automorphism_order ||
            error("independent automorphism-order mismatch: $label")
    end
    return nothing
end

function certify_n3_exhaustive()
    n = 3
    colorings = restricted_growth_colorings(n)
    base_workspace = GC.PackedDirectedCanonicalizationWorkspace(n)
    base_buffer = GC.DirectedCanonicalizationBuffer(n)
    recursive_workspace = RecursiveStabilizerWorkspace(n)
    recursive_buffer = GC.DirectedCanonicalizationBuffer(n)
    cases = 0

    for mask in UInt64(0):(UInt64(1) << (n * n)) - UInt64(1)
        graph = graph_from_mask(n, mask)
        for colors in colorings
            cases += 1
            assert_recursive_matches!(
                "n3 mask=$mask colors=$colors",
                graph,
                colors,
                base_buffer,
                base_workspace,
                recursive_buffer,
                recursive_workspace;
                independent=true,
            )
        end
    end
    println("CERT|n3-all-graphs-all-color-partitions|", cases)
    return cases
end

function certify_n4_uniform_exhaustive()
    n = 4
    colors = ones(Int, n)
    base_workspace = GC.PackedDirectedCanonicalizationWorkspace(n)
    base_buffer = GC.DirectedCanonicalizationBuffer(n)
    recursive_workspace = RecursiveStabilizerWorkspace(n)
    recursive_buffer = GC.DirectedCanonicalizationBuffer(n)
    cases = 0

    for mask in UInt64(0):(UInt64(1) << (n * n)) - UInt64(1)
        graph = graph_from_mask(n, mask)
        cases += 1
        assert_recursive_matches!(
            "n4 uniform mask=$mask",
            graph,
            colors,
            base_buffer,
            base_workspace,
            recursive_buffer,
            recursive_workspace,
        )
    end
    println("CERT|n4-all-graphs-uniform-color|", cases)
    return cases
end

function certify_n4_color_partitions_sample()
    n = 4
    colorings = restricted_growth_colorings(n)
    base_workspace = GC.PackedDirectedCanonicalizationWorkspace(n)
    base_buffer = GC.DirectedCanonicalizationBuffer(n)
    recursive_workspace = RecursiveStabilizerWorkspace(n)
    recursive_buffer = GC.DirectedCanonicalizationBuffer(n)
    cases = 0

    # 4096 distinct masks, permuted through the 16-bit space by an odd multiplier.
    for index in UInt64(0):UInt64(4095)
        mask = (index * UInt64(40503)) & UInt64(0xffff)
        graph = graph_from_mask(n, mask)
        for colors in colorings
            cases += 1
            assert_recursive_matches!(
                "n4 sample mask=$mask colors=$colors",
                graph,
                colors,
                base_buffer,
                base_workspace,
                recursive_buffer,
                recursive_workspace,
            )
        end
    end
    println("CERT|n4-4096-masks-all-color-partitions|", cases)
    return cases
end

@inline function xorshift64(value::UInt64)::UInt64
    value ⊻= value << 13
    value ⊻= value >> 7
    value ⊻= value << 17
    return value
end

function certify_n5_deterministic_sample()
    n = 5
    colorings = (
        ones(Int, n),
        [1, 1, 1, 2, 2],
        [1, 1, 2, 2, 3],
        [1, 2, 1, 2, 1],
        collect(1:n),
    )
    base_workspace = GC.PackedDirectedCanonicalizationWorkspace(n)
    base_buffer = GC.DirectedCanonicalizationBuffer(n)
    recursive_workspace = RecursiveStabilizerWorkspace(n)
    recursive_buffer = GC.DirectedCanonicalizationBuffer(n)
    state = UInt64(0x9e3779b97f4a7c15)
    mask_limit = (UInt64(1) << (n * n)) - UInt64(1)
    cases = 0

    for sample in 1:4096
        state = xorshift64(state)
        graph_mask = state & mask_limit
        graph = graph_from_mask(n, graph_mask)
        for colors in colorings
            cases += 1
            assert_recursive_matches!(
                "n5 sample=$sample mask=$graph_mask colors=$colors",
                graph,
                colors,
                base_buffer,
                base_workspace,
                recursive_buffer,
                recursive_workspace,
            )
        end
    end
    println("CERT|n5-4096-masks-five-color-patterns|", cases)
    return cases
end

total = 0
total += certify_n3_exhaustive()
total += certify_n4_uniform_exhaustive()
total += certify_n4_color_partitions_sample()
total += certify_n5_deterministic_sample()
println("CERT|total|", total)
