using Test
using GraphCombinations

@testset "DegreeSequenceProblem" begin
    @testset "construction owns and validates input" begin
        degrees = [1, 1, 4, 4]
        problem = @inferred DegreeSequenceProblem(degrees; num_fixed=2)
        @test problem isa DegreeSequenceProblem
        @test isconcretetype(typeof(problem))
        @test @inferred(vertex_degrees(problem)) == degrees
        @test @inferred(fixed_vertex_count(problem)) == 2

        degrees[1] = 9
        @test vertex_degrees(problem) == [1, 1, 4, 4]

        returned = vertex_degrees(problem)
        returned[1] = 8
        @test vertex_degrees(problem) == [1, 1, 4, 4]

        @test_throws ArgumentError DegreeSequenceProblem([1, -1])
        @test_throws ArgumentError DegreeSequenceProblem([1, 1]; num_fixed=-1)
        @test_throws ArgumentError DegreeSequenceProblem([1, 1]; num_fixed=3)
    end

    @testset "legacy degree histogram equivalence" begin
        n = [2, 0, 0, 2]
        problem = DegreeSequenceProblem([1, 1, 4, 4]; num_fixed=2)
        @test @inferred(generate_multigraphs(problem)) == allgraphs(n)
        @test @inferred(generate_multigraphs(problem; connected=false)) ==
            allgraphs(n; connected=false)
        @test all(last(result) isa BigInt for result in generate_multigraphs(problem))
    end

    @testset "quotient labels ignore nonfixed input order" begin
        sorted = DegreeSequenceProblem([1, 1, 4, 4])
        permuted = DegreeSequenceProblem([4, 1, 4, 1])
        @test generate_multigraphs(permuted) == generate_multigraphs(sorted)
        @test generate_multigraphs(permuted; connected=false) ==
            generate_multigraphs(sorted; connected=false)
    end

    @testset "fixed-label semantics" begin
        @test generate_multigraphs(DegreeSequenceProblem([1, 1]; num_fixed=2)) ==
            [([1 => 2], big(1))]
        @test generate_multigraphs(DegreeSequenceProblem([1, 1]; num_fixed=0)) ==
            [([1 => 2], big(2))]

        problem = DegreeSequenceProblem([2, 2, 2]; num_fixed=2)
        results = generate_multigraphs(problem; connected=false)
        left_fixed = ([1 => 1, 2 => 3, 2 => 3], big(4))
        right_fixed = ([1 => 3, 1 => 3, 2 => 2], big(4))
        @test left_fixed in results
        @test right_fixed in results
    end

    @testset "degenerate and isolated vertices" begin
        @test isempty(generate_multigraphs(DegreeSequenceProblem(Int[])))
        @test isempty(generate_multigraphs(DegreeSequenceProblem([1])))
        @test generate_multigraphs(DegreeSequenceProblem([0])) == [([], big(1))]
        @test isempty(generate_multigraphs(DegreeSequenceProblem([0, 0])))
        @test generate_multigraphs(DegreeSequenceProblem([0, 0]); connected=false) ==
            [([], big(2))]
    end
end
