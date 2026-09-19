function _relation_test_witness_image(
    graph::DirectedRelationGraph, buffer::DirectedRelationCanonicalizationBuffer
)::DirectedRelationGraph
    n = graph.num_vertices
    nr = graph.num_relations
    multiplicities = zeros(Int, nr * n * n)
    @inbounds for relation in 1:nr, old_source in 1:n, old_target in 1:n
        canonical_source = canonical_rank(buffer, old_source)
        canonical_target = canonical_rank(buffer, old_target)
        multiplicities[
            _relation_test_slot(relation, canonical_source, canonical_target, n)
        ] = graph.multiplicities[_relation_test_slot(relation, old_source, old_target, n)]
    end
    return DirectedRelationGraph(n, nr, multiplicities)
end

function _relation_test_inverse_consistent(
    buffer::DirectedRelationCanonicalizationBuffer
)::Bool
    n = buffer.num_vertices
    @inbounds for old_vertex in 1:n
        original_vertex(buffer, canonical_rank(buffer, old_vertex)) == old_vertex || return false
    end
    return true
end

@testset "packed native relations exhaustive n=2" begin
    general_workspace = DirectedRelationCanonicalizationWorkspace(2, 2)
    packed_workspace = PackedDirectedRelationCanonicalizationWorkspace(2, 2)
    general = DirectedRelationCanonicalizationBuffer(2, 2)
    packed = DirectedRelationCanonicalizationBuffer(2, 2)

    for code in 0:(2^8 - 1), colors in (Int[1, 1], Int[1, 2])
        graph = _relation_test_graph_from_code(2, 2, 2, code)
        canonicalize_directed_relations!(general, general_workspace, graph, colors)
        @test @inferred(
            canonicalize_directed_relations!(packed, packed_workspace, graph, colors)
        ) === packed
        @test canonical_graph(packed) == canonical_graph(general)
        @test canonical_automorphism_order(packed) == canonical_automorphism_order(general)
        @test canonical_graph(packed) == _relation_test_witness_image(graph, packed)
        @test _relation_test_inverse_consistent(packed)
        @test _relation_test_canonical_colors(packed, colors) ==
            _relation_test_canonical_colors(general, colors)
    end
end

@testset "packed native relations exhaustive n=3 one relation" begin
    general_workspace = DirectedRelationCanonicalizationWorkspace(3, 1)
    packed_workspace = PackedDirectedRelationCanonicalizationWorkspace(3, 1)
    general = DirectedRelationCanonicalizationBuffer(3, 1)
    packed = DirectedRelationCanonicalizationBuffer(3, 1)
    colorings = (Int[1, 1, 1], Int[1, 1, 2], Int[1, 2, 3])

    for code in 0:(2^9 - 1), colors in colorings
        graph = _relation_test_graph_from_code(3, 1, 2, code)
        canonicalize_directed_relations!(general, general_workspace, graph, colors)
        canonicalize_directed_relations!(packed, packed_workspace, graph, colors)
        @test canonical_graph(packed) == canonical_graph(general)
        @test canonical_automorphism_order(packed) == canonical_automorphism_order(general)
        @test canonical_graph(packed) == _relation_test_witness_image(graph, packed)
        @test _relation_test_inverse_consistent(packed)
    end
end

@testset "packed native relation support boundary" begin
    graph = DirectedRelationGraph([(1, 1, 2), (1, 1, 2)], 2, 1)
    workspace = PackedDirectedRelationCanonicalizationWorkspace(2, 1)
    buffer = DirectedRelationCanonicalizationBuffer(2, 1)
    @test_throws ArgumentError canonicalize_directed_relations!(buffer, workspace, graph)
    @test_throws ArgumentError PackedDirectedRelationCanonicalizationWorkspace(65, 1)
end

@testset "native relation prepared buffer allocation" begin
    graph = DirectedRelationGraphBuffer(8, 4)
    general_workspace = DirectedRelationCanonicalizationWorkspace(8, 4)
    packed_workspace = PackedDirectedRelationCanonicalizationWorkspace(8, 4)
    general = DirectedRelationCanonicalizationBuffer(8, 4; materialize_canonical=false)
    packed = DirectedRelationCanonicalizationBuffer(8, 4; materialize_canonical=false)
    colors = ones(Int, 8)
    edges = [(1, 1, 2), (1, 2, 3), (2, 3, 1), (3, 1, 3), (3, 3, 2)]

    load_directed_relations!(graph, edges, 3, 3)
    canonicalize_directed_relations!(general, general_workspace, graph, colors)
    canonicalize_directed_relations!(packed, packed_workspace, graph, colors)
    @test general.old_to_canonical[1:3] == packed.old_to_canonical[1:3]
    @test canonical_automorphism_order(general) == canonical_automorphism_order(packed)

    general_allocated = @allocated begin
        load_directed_relations!(graph, edges, 3, 3)
        canonicalize_directed_relations!(general, general_workspace, graph, colors)
    end
    packed_allocated = @allocated begin
        load_directed_relations!(graph, edges, 3, 3)
        canonicalize_directed_relations!(packed, packed_workspace, graph, colors)
    end
    @test !iszero(Base.JLOptions().code_coverage) || general_allocated == 0
    @test !iszero(Base.JLOptions().code_coverage) || packed_allocated == 0

    smaller = [(1, 1, 2), (2, 2, 1)]
    load_directed_relations!(graph, smaller, 2, 2)
    canonicalize_directed_relations!(general, general_workspace, graph, colors)
    canonicalize_directed_relations!(packed, packed_workspace, graph, colors)
    @test general.old_to_canonical[1:2] == packed.old_to_canonical[1:2]
    @test canonical_automorphism_order(general) == canonical_automorphism_order(packed)
end
