using Test, GraphCombinations
using GraphCombinations: Edge

# Helper function to sort allgraphs results for comparison
sort_allgraphs_results(results) = sort(results; by=x -> x[1]) # Sort by canonical graph

@testset "Graph Generation (allgraphs)" begin
    @testset "input contract" begin
        @test_throws ErrorException allgraphs(Int[])
        @test_throws ErrorException allgraphs([2, -1])

        n = [2, 0, 0, 1, 0, 0]
        original_n = copy(n)
        @test allgraphs(n) == allgraphs([2, 0, 0, 1])
        @test n == original_n

        @test allgraphs(Int32[2, 0, 0, 1]) == allgraphs([2, 0, 0, 1])
        @test total_degree(Int32[2, 1]) == 4
    end

    @testset "exact combinatorial factors" begin
        @test combinatoric_factor([0, 0, 2]) == big(72)
        @test combinatoric_factor([0, 0, 2]) isa BigInt
        @test combinatoric_factor([0, 0, 25]) == factorial(big(25)) * factorial(big(3))^25
        @test_throws ArgumentError combinatoric_factor([0, -1])
    end

    # Test case 1: Invalid input - odd total degree
    @test isempty(allgraphs([1]))
    @test isempty(allgraphs([3]))
    @test isempty(allgraphs([1, 1]))
    @test isempty(allgraphs([2, 0, 1]))

    # Test case 2: Base case n = [2]
    expected_2_0 = [([Edge(1, 2)], big(1))]
    @test allgraphs([2]) == expected_2_0
    @test allgraphs([2, 0, 0]) == expected_2_0

    # Test case 4: n = [2, 1]
    expected_2_1 = [([(1 => 3), (2 => 3)], big(1))]
    @test allgraphs([2, 1]) == expected_2_1
    @test allgraphs([2, 1, 0]) == expected_2_1

    # Test case 5: n = [0, 0, 2]
    expected_0_0_2 = [
        ([1 => 2, 1 => 2, 1 => 2], big(12)), ([1 => 1, 1 => 2, 2 => 2], big(8))
    ]
    @test sort_allgraphs_results(allgraphs([0, 0, 2])) ==
        sort_allgraphs_results(expected_0_0_2)

    # Test case 6: n = [2, 0, 0, 1]
    expected_2_0_0_1 = [([Edge(1, 3), Edge(2, 3), Edge(3, 3)], big(2))]
    result_2_0_0_1 = allgraphs([2, 0, 0, 1])
    @test length(result_2_0_0_1) == 1 # Expect 1 unique tadpole graph
    @test sort_allgraphs_results(result_2_0_0_1) == sort_allgraphs_results(expected_2_0_0_1)

    # Test case 7: n = [2, 0, 0, 2]
    expected_2_0_0_2 = [
        ([Edge(1, 3), Edge(2, 3), Edge(3, 4), Edge(3, 4), Edge(4, 4)], big(4)),
        ([Edge(1, 3), Edge(2, 4), Edge(3, 3), Edge(3, 4), Edge(4, 4)], big(4)),
        ([Edge(1, 3), Edge(2, 4), Edge(3, 4), Edge(3, 4), Edge(3, 4)], big(6)),
    ]
    result_2_0_0_2 = allgraphs([2, 0, 0, 2])
    @test length(result_2_0_0_2) == 3
    @test all(result -> last(result) isa BigInt, result_2_0_0_2)
    # Sort both expected and actual results before comparison
    @test sort_allgraphs_results(result_2_0_0_2) == sort_allgraphs_results(expected_2_0_0_2)
end
