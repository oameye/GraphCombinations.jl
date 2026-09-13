using Test
using GraphCombinations

const GCRelabeling = GraphCombinations

@testset "problem-preserving relabeling groups" begin
    @testset "full color-cell permutation group" begin
        relabelings = @inferred GCRelabeling._problem_relabelings([1, 1, 1], 0, _ -> true)
        @test relabelings ==
            [[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]
    end

    @testset "fixed prefix and color cells" begin
        fixed = @inferred GCRelabeling._problem_relabelings([1, 1, 1], 1, _ -> true)
        @test fixed == [[1, 2, 3], [1, 3, 2]]

        colored = @inferred GCRelabeling._problem_relabelings([1, 2, 1, 2], 0, _ -> true)
        @test colored == [[1, 2, 3, 4], [1, 4, 3, 2], [3, 2, 1, 4], [3, 4, 1, 2]]
    end

    @testset "problem-preserving predicate restricts the group" begin
        preserves_second = mapping -> mapping[2] == 2
        restricted = @inferred GCRelabeling._problem_relabelings(
            [1, 2, 1, 2], 0, preserves_second
        )
        @test restricted == [[1, 2, 3, 4], [3, 2, 1, 4]]
    end

    @test_throws ArgumentError GCRelabeling._problem_relabelings([1, 1], -1, _ -> true)
    @test_throws ArgumentError GCRelabeling._problem_relabelings([1, 1], 3, _ -> true)
end
