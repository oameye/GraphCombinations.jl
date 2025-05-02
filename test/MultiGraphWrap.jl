using Test
using GraphCombinatorics
import GraphCombinatorics as GC
using Multigraphs
using Graphs
using Graphs.SimpleGraphs

@testset "MultigraphWrap" begin
    # Create a Multigraph
    mg = Multigraph(3)
    add_edge!(mg, 1, 2)
    add_edge!(mg, 1, 2) # Add a parallel edge
    add_edge!(mg, 2, 3)

    # Wrap it
    g = GC.MultigraphWrap(mg)

    @testset "Basic Properties" begin
        @test eltype(g) == Int
        @test edgetype(g) == MultipleEdge{Int,Int}
        @test nv(g) == 3
        @test ne(g) == 3 # Counts multiplicity
        @test sort(vertices(g)) == collect(1:3)
        @test is_directed(g) == false
        @test is_directed(typeof(g)) == false
        @test has_vertex(g, 1)
        @test has_vertex(g, 3)
        @test !has_vertex(g, 4)
    end

    @testset "Edges" begin
        @test has_edge(g, 1, 2)
        @test has_edge(g, 2, 1) # Undirected
        @test has_edge(g, 2, 3)
        @test !has_edge(g, 1, 3)

        # Test edges() function output
        expected_edges = [SimpleEdge(1, 2), SimpleEdge(1, 2), SimpleEdge(2, 3)]
        @test sort(collect(edges(g))) == sort(expected_edges)
    end

    @testset "Neighbors" begin
        @test sort(inneighbors(g, 1)) == [2]
        @test sort(outneighbors(g, 1)) == [2] # Same for undirected
        @test sort(inneighbors(g, 2)) == [1, 3]
        @test sort(outneighbors(g, 2)) == [1, 3]
        @test sort(inneighbors(g, 3)) == [2]
        @test sort(outneighbors(g, 3)) == [2]
    end

    @testset "Connectivity" begin
        @test is_connected(g) == true
        mg2 = Multigraph(4)
        add_edge!(mg2, 1, 2)
        add_edge!(mg2, 3, 4)
        g2 = GC.MultigraphWrap(mg2)
        @test is_connected(g2) == false
    end

    @testset " GC.gen_distances" begin
        # Test case 1: Single edges
        mg_single = Multigraph(3)
        add_edge!(mg_single, 1, 2)
        add_edge!(mg_single, 2, 3)
        g_single = GC.MultigraphWrap(mg_single)
        @test GC.gen_distances(g_single) == [0.0, 0.0]

        # Test case 2: Multiple edges (even multiplicity)
        mg_multi_even = Multigraph(2)
        add_edge!(mg_multi_even, 1, 2)
        add_edge!(mg_multi_even, 1, 2)
        g_multi_even = GC.MultigraphWrap(mg_multi_even)
        # Multiplicity 2 -> m=1 -> range(-0.25, 0.25, length=2) -> [-0.25, 0.25]
        @test GC.gen_distances(g_multi_even; inc=0.25) ≈ [-0.25, 0.25]

        # Test case 3: Multiple edges (odd multiplicity)
        mg_multi_odd = Multigraph(2)
        add_edge!(mg_multi_odd, 1, 2)
        add_edge!(mg_multi_odd, 1, 2)
        add_edge!(mg_multi_odd, 1, 2)
        g_multi_odd = GC.MultigraphWrap(mg_multi_odd)
        # Multiplicity 3 -> m=1 -> range(-0.25, 0.25, length=3) -> [-0.25, 0.0, 0.25]
        @test GC.gen_distances(g_multi_odd; inc=0.25) ≈ [-0.25, 0.0, 0.25]

        # Test case 4: Mixed multiplicities
        mg_mixed = Multigraph(3)
        add_edge!(mg_mixed, 1, 2) # mul=1
        add_edge!(mg_mixed, 1, 2) # mul=2
        add_edge!(mg_mixed, 2, 3) # mul=1
        add_edge!(mg_mixed, 2, 3) # mul=2
        add_edge!(mg_mixed, 2, 3) # mul=3
        g_mixed = GC.MultigraphWrap(mg_mixed)
        # Edge (1,2) mul=2 -> [-0.25, 0.25]
        # Edge (2,3) mul=3 -> [-0.25, 0.0, 0.25]
        # Order depends on internal edge order of Multigraphs
        dists = GC.gen_distances(g_mixed; inc=0.25)
        @test length(dists) == 5
        @test count(x -> isapprox(x, -0.25), dists) == 2
        @test count(x -> isapprox(x, 0.0), dists) == 1
        @test count(x -> isapprox(x, 0.25), dists) == 2
    end
end
