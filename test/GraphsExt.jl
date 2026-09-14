using Test
using GraphCombinations
import GraphCombinations as GC

@test !any(pkgid -> pkgid.name == "Graphs", keys(Base.loaded_modules))

using Graphs

@testset "native graph core" begin
    graph = GCGraph([1 => 2, 1 => 2, 2 => 3], 3)
    @test graph.num_vertices == 3
    @test graph.multiplicities == [0, 2, 0, 0, 1, 0]
    @test GC._gcgraph_num_edges(graph) == 3
    @test GC._gcgraph_multiplicity(graph, 1, 2) == 2
    @test GC._gcgraph_multiplicity(graph, 2, 1) == 2
    @test GC._is_connected_gcgraph(graph)

    disconnected = GCGraph([1 => 2, 3 => 4], 4)
    @test !GC._is_connected_gcgraph(disconnected)

    @test_throws ArgumentError GCGraph([1 => 3], 2)
    @test_throws ArgumentError GCGraph([0 => 1], 1)
    @test_throws ArgumentError GCGraph(Pair{Int,Int}[], -1)
end

@testset "Graphs extension" begin
    sparse = build_graph([1 => 3])
    @test sparse isa Graphs.AbstractGraph
    @test nv(sparse) == 3
    @test has_vertex(sparse, 2)
    @test has_edge(sparse, 1, 3)
    @test !is_connected(sparse)

    parallel = build_graph([1 => 2, 1 => 2])
    @test ne(parallel) == 2
    @test collect(edges(parallel)) == [Graphs.SimpleEdge(1, 2), Graphs.SimpleEdge(1, 2)]
    @test GC.gen_distances(parallel; inc=0.25) ≈ [-0.25, 0.25]

    loop = build_graph([1 => 1])
    @test nv(loop) == 1
    @test ne(loop) == 1
    @test collect(edges(loop)) == [Graphs.SimpleEdge(1, 1)]
    @test is_connected(loop)

    mixed = build_graph([1 => 2, 1 => 2, 2 => 3, 2 => 3, 2 => 3])
    @test sort(inneighbors(mixed, 2)) == [1, 3]
    dists = GC.gen_distances(mixed; inc=0.25)
    @test length(dists) == 5
    @test count(x -> isapprox(x, -0.25), dists) == 2
    @test count(x -> isapprox(x, 0.0), dists) == 1
    @test count(x -> isapprox(x, 0.25), dists) == 2

    @test_throws ArgumentError build_graph([1 => 3], 2)
    @test_throws ArgumentError build_graph([0 => 1], 1)
    @test_throws ArgumentError build_graph(Pair{Int,Int}[], -1)
end
