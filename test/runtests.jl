using Test, GraphCombinatorics

@testset "wick_contractions" begin
    include("test_wick_contractions.jl")
end

@testset "wick_contractions" begin
    include("test_reduction.jl")
end

@testset "graph_generation" begin
    include("test_generation.jl")
end
