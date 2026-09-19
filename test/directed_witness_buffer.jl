const WitnessRecursiveGC = GraphCombinations.DirectedRecursive

function _test_same_directed_witness(
    full::DirectedCanonicalizationBuffer,
    witness::DirectedCanonicalizationBuffer,
    n::Int,
)::Nothing
    @test canonical_automorphism_order(witness) == canonical_automorphism_order(full)
    @test witness.old_to_canonical[1:n] == full.old_to_canonical[1:n]
    @test witness.canonical_to_old[1:n] == full.canonical_to_old[1:n]
    @inbounds for old_vertex in 1:n
        rank = canonical_rank(witness, old_vertex)
        @test rank == canonical_rank(full, old_vertex)
        @test original_vertex(witness, rank) == old_vertex
    end
    return nothing
end

@testset "directed witness-only result mode" begin
    edges = [1 => 1, 1 => 3, 2 => 4, 3 => 2, 4 => 1, 4 => 3]
    graph = DirectedGCGraph(edges, 4)
    colors = Int[1, 1, 2, 3]
    workspace = DirectedCanonicalizationWorkspace(8)
    full = DirectedCanonicalizationBuffer(8)
    witness = DirectedCanonicalizationBuffer(8; materialize_canonical=false)

    @test isempty(witness.canonical_multiplicities)
    canonicalize_directed!(full, workspace, graph, colors)
    @test @inferred(canonicalize_directed!(witness, workspace, graph, colors)) === witness
    _test_same_directed_witness(full, witness, 4)
    @test_throws ArgumentError canonical_graph(witness)

    allocated = @allocated canonicalize_directed!(witness, workspace, graph, colors)
    @test !iszero(Base.JLOptions().code_coverage) || allocated == 0
end

@testset "levelwise witness-only result mode" begin
    graph = DirectedGCGraph(
        vcat(
            [vertex => mod1(vertex + 1, 12) for vertex in 1:12],
            [mod1(vertex + 1, 12) => vertex for vertex in 1:12],
        ),
        12,
    )
    colors = ones(Int, 12)
    workspace = DirectedSimpleCanonicalizationWorkspace(16; frontier_capacity=4096)
    full = DirectedCanonicalizationBuffer(16)
    witness = DirectedCanonicalizationBuffer(16; materialize_canonical=false)

    canonicalize_directed_simple!(full, workspace, graph, colors)
    @test @inferred(canonicalize_directed_simple!(witness, workspace, graph, colors)) ===
        witness
    _test_same_directed_witness(full, witness, 12)

    allocated = @allocated canonicalize_directed_simple!(witness, workspace, graph, colors)
    @test !iszero(Base.JLOptions().code_coverage) || allocated == 0
end

@testset "recursive witness-only result mode" begin
    graph = DirectedGCGraph(
        [
            1 => 2,
            2 => 3,
            3 => 4,
            4 => 5,
            5 => 1,
            1 => 3,
            2 => 4,
            3 => 5,
            4 => 1,
            5 => 2,
        ],
        5,
    )
    colors = ones(Int, 5)
    workspace = WitnessRecursiveGC.PackedRecursiveStabilizerWorkspace(8)
    full = DirectedCanonicalizationBuffer(8)
    witness = DirectedCanonicalizationBuffer(8; materialize_canonical=false)

    WitnessRecursiveGC.canonicalize_recursive_stabilizers!(full, workspace, graph, colors)
    @test @inferred(
        WitnessRecursiveGC.canonicalize_recursive_stabilizers!(
            witness, workspace, graph, colors
        )
    ) === witness
    _test_same_directed_witness(full, witness, 5)

    allocated = @allocated WitnessRecursiveGC.canonicalize_recursive_stabilizers!(
        witness, workspace, graph, colors
    )
    @test !iszero(Base.JLOptions().code_coverage) || allocated == 0
end

@testset "witness-only buffer survives changing active sizes" begin
    graph_buffer = DirectedGCGraphBuffer(12)
    workspace = DirectedSimpleCanonicalizationWorkspace(12; frontier_capacity=4096)
    witness = DirectedCanonicalizationBuffer(12; materialize_canonical=false)
    full = DirectedCanonicalizationBuffer(12)
    colors = ones(Int, 12)

    fixtures = (
        ([1 => 2, 2 => 3, 3 => 1], 3),
        ([1 => 2, 2 => 1, 3 => 4, 4 => 3, 5 => 6, 6 => 5], 6),
        ([1 => 2, 2 => 3, 3 => 4, 4 => 1], 4),
    )

    for (edges, n) in fixtures
        load_directed_graph!(graph_buffer, edges, n)
        canonicalize_directed_simple!(full, workspace, graph_buffer, colors)
        canonicalize_directed_simple!(witness, workspace, graph_buffer, colors)
        _test_same_directed_witness(full, witness, n)
        @test witness.num_vertices == n
        @test isempty(witness.canonical_multiplicities)
    end
end

@testset "empty witness-only canonicalization" begin
    graph = DirectedGCGraph(Pair{Int,Int}[], 0)
    workspace = DirectedCanonicalizationWorkspace(4)
    witness = DirectedCanonicalizationBuffer(4; materialize_canonical=false)
    canonicalize_directed!(witness, workspace, graph, Int[])
    @test canonical_automorphism_order(witness) == 1
    @test canonical_graph(witness) == graph
end
