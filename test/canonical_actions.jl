using Test
using GraphCombinations

const GCCanonicalActions = GraphCombinations

@testset "exact coordinate actions" begin
    mapping = [2, 3, 1]
    action = @inferred GCCanonicalActions._vertex_block_coordinate_action(mapping, 2)
    @test action == [3, 1, 2, 6, 4, 5]

    source = [10, 20, 30, 40, 50, 60]
    destination = similar(source)
    @test @inferred(GCCanonicalActions._write_coordinate_action!(destination, source, action)) ===
          nothing
    @test destination == [30, 10, 20, 60, 40, 50]

    values = [1, 3, 2]
    identity_action = [1, 2, 3]
    swapped_action = [2, 1, 3]
    @test @inferred(
        GCCanonicalActions._compare_coordinate_actions(
            values, swapped_action, identity_action, Val(false)
        )
    ) == 1
    @test @inferred(
        GCCanonicalActions._compare_coordinate_actions(
            values, swapped_action, identity_action, Val(true)
        )
    ) == -1
    @test @inferred(
        GCCanonicalActions._compare_coordinate_actions(
            values, identity_action, identity_action, Val(false)
        )
    ) == 0

    @test isempty(@inferred GCCanonicalActions._vertex_block_coordinate_action([1, 2], 0))
    @test_throws ArgumentError GCCanonicalActions._vertex_block_coordinate_action([1, 2], -1)
end
