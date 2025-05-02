using Test, GraphCombinatorics
using GraphCombinatorics: Edge

# Helper function to sort allgraphs results for comparison
sort_allgraphs_results(results) = sort(results, by=x -> x[1]) # Sort by canonical graph

@testset "Graph Generation (allgraphs)" begin
    # Test case 1: Invalid input - odd total degree
    @test isempty(allgraphs([1]))
    @test isempty(allgraphs([3]))
    @test isempty(allgraphs([1, 1]))
    @test isempty(allgraphs([2, 0, 1]))

    # Test case 2: Base case n = [2]
    expected_2_0 = [([Edge(1, 2)], 1.0)]
    @test allgraphs([2]) == expected_2_0
    @test allgraphs([2, 0, 0]) == expected_2_0

    # Test case 4: n = [2, 1]
    expected_2_1 = [([(1 => 3), (2 => 3)], 1.0)]
    @test allgraphs([2, 1]) == expected_2_1
    @test allgraphs([2, 1, 0]) == expected_2_1

    # Test case 5: n = [0, 0, 2]
    expected_0_0_2 = [([1 => 2, 1 => 2, 1 => 2], 12.0), ([1 => 1, 1 => 2, 2 => 2], 8.0)]
    @test allgraphs([0, 0, 2]) == expected_0_0_2

    # Test case 6: n = [2, 0, 0, 1]
    expected_2_0_0_1 = [([Edge(1, 3), Edge(2, 3), Edge(3, 3)], 2.0)]
    result_2_0_0_1 = allgraphs([2, 0, 0, 1])
    @test length(result_2_0_0_1) == 1 # Expect 1 unique tadpole graph
    @test sort_allgraphs_results(result_2_0_0_1) == sort_allgraphs_results(expected_2_0_0_1)

    # Test case 7: n = [2, 0, 0, 2]
    expected_2_0_0_2 = [
        ([Edge(1, 3), Edge(2, 3), Edge(3, 4), Edge(3, 4), Edge(4, 4)], 4.0),
        ([Edge(1, 3), Edge(2, 4), Edge(3, 3), Edge(3, 4), Edge(4, 4)], 4.0),
        ([Edge(1, 3), Edge(2, 4), Edge(3, 4), Edge(3, 4), Edge(3, 4)], 6.0),
    ]
    result_2_0_0_2 = allgraphs([2, 0, 0, 2])
    @test length(result_2_0_0_2) == 3
    # Sort both expected and actual results before comparison
    @test sort_allgraphs_results(result_2_0_0_2) == sort_allgraphs_results(expected_2_0_0_2)
end
