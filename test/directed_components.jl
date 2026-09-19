function _component_test_relabel(
    graph::DirectedGCGraph, colors::Vector{Int}, old_to_new::Vector{Int}
)
    n = graph.num_vertices
    multiplicities = zeros(Int, n * n)
    relabeled_colors = similar(colors)
    @inbounds for old_vertex in 1:n
        relabeled_colors[old_to_new[old_vertex]] = colors[old_vertex]
    end
    @inbounds for old_source in 1:n, old_target in 1:n
        new_source = old_to_new[old_source]
        new_target = old_to_new[old_target]
        multiplicities[(new_source - 1) * n + new_target] = graph.multiplicities[(old_source - 1) * n + old_target]
    end
    return DirectedGCGraph(n, multiplicities), relabeled_colors
end

function _component_test_canonical_colors(
    buffer::DirectedCanonicalizationBuffer, colors::Vector{Int}
)::Vector{Int}
    return [
        colors[original_vertex(buffer, canonical_vertex)] for
        canonical_vertex in 1:length(colors)
    ]
end

function _component_test_reconstructed_graph(
    graph::DirectedGCGraph, buffer::DirectedCanonicalizationBuffer
)::DirectedGCGraph
    n = graph.num_vertices
    multiplicities = zeros(Int, n * n)
    @inbounds for old_source in 1:n, old_target in 1:n
        canonical_source = canonical_rank(buffer, old_source)
        canonical_target = canonical_rank(buffer, old_target)
        multiplicities[(canonical_source - 1) * n + canonical_target] = graph.multiplicities[(old_source - 1) * n + old_target]
    end
    return DirectedGCGraph(n, multiplicities)
end

function _component_test_repeated_cycles(count::Int, size::Int)::DirectedGCGraph
    n = count * size
    multiplicities = zeros(Int, n * n)
    @inbounds for component in 0:(count - 1)
        offset = component * size
        for local_vertex in 1:size
            source = offset + local_vertex
            target = offset + mod1(local_vertex + 1, size)
            multiplicities[(source - 1) * n + target] = 1
        end
    end
    return DirectedGCGraph(n, multiplicities)
end

@testset "component workspace constructors are concrete" begin
    @test @inferred(DirectedComponentCanonicalizationWorkspace(12)) isa
        DirectedComponentCanonicalizationWorkspace
    @test @inferred(DirectedComponentCanonicalizationWorkspace(12, Val(:general))) isa
        DirectedComponentCanonicalizationWorkspace
    @test @inferred(DirectedComponentCanonicalizationWorkspace(12, Val(:recursive))) isa
        DirectedComponentCanonicalizationWorkspace
    @test @inferred(DirectedComponentCanonicalizationWorkspace(12, Val(:levelwise))) isa
        DirectedComponentCanonicalizationWorkspace
end

@testset "exact directed component decomposition" begin
    n = 10
    multiplicities = zeros(Int, n * n)
    for (source, target, multiplicity) in (
        (1, 2, 1),
        (2, 3, 1),
        (3, 1, 1),
        (4, 5, 2),
        (5, 4, 1),
        (6, 6, 3),
        (7, 8, 1),
        (8, 7, 1),
    )
        multiplicities[(source - 1) * n + target] = multiplicity
    end
    graph = DirectedGCGraph(n, multiplicities)
    colors = Int[1, 1, 1, 2, 2, 3, 4, 4, 5, 5]
    workspace = DirectedComponentCanonicalizationWorkspace(12)
    buffer = DirectedCanonicalizationBuffer(12)

    @test @inferred(canonicalize_directed_components!(buffer, workspace, graph, colors)) ===
        buffer
    @test _component_test_reconstructed_graph(graph, buffer) == canonical_graph(buffer)

    monolithic = canonicalize_directed(graph, colors)
    @test canonical_automorphism_order(buffer) == canonical_automorphism_order(monolithic)

    relabeling = Int[8, 3, 10, 6, 1, 9, 4, 7, 2, 5]
    relabeled_graph, relabeled_colors = _component_test_relabel(graph, colors, relabeling)
    relabeled_buffer = DirectedCanonicalizationBuffer(12)
    canonicalize_directed_components!(
        relabeled_buffer, workspace, relabeled_graph, relabeled_colors
    )
    @test canonical_graph(relabeled_buffer) == canonical_graph(buffer)
    @test _component_test_canonical_colors(relabeled_buffer, relabeled_colors) ==
        _component_test_canonical_colors(buffer, colors)
    @test canonical_automorphism_order(relabeled_buffer) ==
        canonical_automorphism_order(buffer)
end

@testset "repeated components use wreath-product symmetry" begin
    graph = _component_test_repeated_cycles(4, 7)
    colors = ones(Int, graph.num_vertices)
    recursive_workspace = DirectedComponentCanonicalizationWorkspace(32, Val(:recursive))
    levelwise_workspace = DirectedComponentCanonicalizationWorkspace(32, Val(:levelwise))
    buffer = DirectedCanonicalizationBuffer(32; materialize_canonical=false)

    canonicalize_directed_components!(buffer, recursive_workspace, graph, colors)
    @test canonical_automorphism_order(buffer) == 7^4 * factorial(4) == 57_624
    @test sort(buffer.old_to_canonical[1:28]) == collect(1:28)
    @test sort(buffer.canonical_to_old[1:28]) == collect(1:28)

    canonicalize_directed_components!(buffer, levelwise_workspace, graph, colors)
    @test canonical_automorphism_order(buffer) == 57_624

    allocated = @allocated canonicalize_directed_components!(
        buffer, recursive_workspace, graph, colors
    )
    @test !iszero(Base.JLOptions().code_coverage) || allocated == 0
end

@testset "connected component path preserves selected kernel convention" begin
    graph = DirectedGCGraph([1 => 2, 2 => 3, 3 => 1, 3 => 4, 4 => 2], 4)
    colors = Int[1, 1, 2, 2]
    workspace = DirectedComponentCanonicalizationWorkspace(8)
    buffer = DirectedCanonicalizationBuffer(8)
    reference_workspace = DirectedCanonicalizationWorkspace(8)
    reference = DirectedCanonicalizationBuffer(8)

    canonicalize_directed_components!(buffer, workspace, graph, colors)
    canonicalize_directed!(reference, reference_workspace, graph, colors)
    @test canonical_graph(buffer) == canonical_graph(reference)
    @test buffer.old_to_canonical[1:4] == reference.old_to_canonical[1:4]
    @test canonical_automorphism_order(buffer) == canonical_automorphism_order(reference)
end

@testset "component decomposition handles empty and uncolored graphs" begin
    workspace = DirectedComponentCanonicalizationWorkspace(8)
    buffer = DirectedCanonicalizationBuffer(8; materialize_canonical=false)
    empty_graph = DirectedGCGraph(Pair{Int,Int}[], 0)
    canonicalize_directed_components!(buffer, workspace, empty_graph)
    @test canonical_automorphism_order(buffer) == 1
    @test buffer.num_vertices == 0

    graph = DirectedGCGraph([1 => 2, 2 => 1, 3 => 4, 4 => 3], 4)
    canonicalize_directed_components!(buffer, workspace, graph)
    @test canonical_automorphism_order(buffer) == 8
end

@testset "component kernel support is explicit" begin
    @test_throws ArgumentError DirectedComponentCanonicalizationWorkspace(
        65, Val(:recursive)
    )
    @test_throws ArgumentError DirectedComponentCanonicalizationWorkspace(
        65, Val(:levelwise)
    )
    @test_throws ArgumentError DirectedComponentCanonicalizationWorkspace(8, Val(:unknown))

    graph = DirectedGCGraph([1 => 2, 1 => 2, 3 => 4], 4)
    recursive_workspace = DirectedComponentCanonicalizationWorkspace(8, Val(:recursive))
    levelwise_workspace = DirectedComponentCanonicalizationWorkspace(8, Val(:levelwise))
    buffer = DirectedCanonicalizationBuffer(8)
    @test_throws ArgumentError canonicalize_directed_components!(
        buffer, recursive_workspace, graph, ones(Int, 4)
    )
    @test_throws ArgumentError canonicalize_directed_components!(
        buffer, levelwise_workspace, graph, ones(Int, 4)
    )
end

@testset "component decomposition reuses active-size graph buffers" begin
    graph = DirectedGCGraphBuffer(12)
    workspace = DirectedComponentCanonicalizationWorkspace(12)
    buffer = DirectedCanonicalizationBuffer(12; materialize_canonical=false)
    colors = ones(Int, 12)
    disconnected_edges = [(1, 2), (2, 1), (3, 4), (4, 3)]
    connected_edges = [(1, 2), (2, 3), (3, 1)]

    load_directed_graph!(graph, disconnected_edges, 4)
    canonicalize_directed_components!(buffer, workspace, graph, colors)
    @test buffer.num_vertices == 4
    @test canonical_automorphism_order(buffer) == 8

    load_directed_graph!(graph, connected_edges, 3)
    canonicalize_directed_components!(buffer, workspace, graph, colors)
    @test buffer.num_vertices == 3
    @test canonical_automorphism_order(buffer) == 3

    allocated = @allocated begin
        load_directed_graph!(graph, disconnected_edges, 4)
        canonicalize_directed_components!(buffer, workspace, graph, colors)
    end
    @test !iszero(Base.JLOptions().code_coverage) || allocated == 0
end
