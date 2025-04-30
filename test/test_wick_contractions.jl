using Test, GraphCombinatorics
using GraphCombinatorics: corr

# Helper function to sort terms for comparison
sort_term(term) = sort(term)
sort_terms(terms) = sort(terms, by=sort_term)

@testset "Wick Contractions (corr)" begin
    # Test case: corr([]) - Empty list
    @test corr(Int[]) == [[]]

    # Test case: corr([1, 2])
    @test corr([1, 2]) == [[(1 => 2)]]
    @test corr([2, 1]) == [[(1 => 2)]] # Test input order invariance

    # Test case: corr([1, 2, 3, 4])
    expected_4 = [[(1 => 2), (3 => 4)], [(1 => 3), (2 => 4)], [(1 => 4), (2 => 3)]]
    result_4 = corr([1, 2, 3, 4])
    @test sort_terms(result_4) == sort_terms(expected_4)

    # Test case: corr([4, 1, 3, 2]) - Test input order invariance
    result_4_shuffled = corr([4, 1, 3, 2])
    @test sort_terms(result_4_shuffled) == sort_terms(expected_4)

    # Test case: corr([1, 2, 3, 4, 5, 6])
    # Expected number of terms = (6-1)!! = 5*3*1 = 15
    result_6 = corr(collect(1:6))
    @test length(result_6) == 15
    # Check one specific term (e.g., pairing 1-2, 3-4, 5-6)
    term_12_34_56 = [(1 => 2), (3 => 4), (5 => 6)]
    # Check if this term exists in the result (after sorting individual terms)
    @test any(t -> sort_term(t) == term_12_34_56, result_6)
    # Check another specific term (e.g., pairing 1-6, 2-3, 4-5)
    term_16_23_45 = [(1 => 6), (2 => 3), (4 => 5)]
    @test any(t -> sort_term(t) == term_16_23_45, result_6)

    # Test odd number of points
    @test_throws ErrorException corr([1, 2, 3])
    @test_throws ErrorException corr([1])
end
