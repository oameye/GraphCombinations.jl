using Test, GraphCombinatorics

if VERSION < v"1.12.0-beta"
    @testset "Code linting" begin
        using JET
        JET.test_package(GraphCombinatorics; target_defined_modules=true)
    end
end

@testset "ExplicitImports" begin
    using ExplicitImports
    @test check_no_stale_explicit_imports(GraphCombinatorics) == nothing
    @test check_all_explicit_imports_via_owners(GraphCombinatorics) == nothing
end

@testset "best practices" begin
    using Aqua

    Aqua.test_ambiguities([GraphCombinatorics]; broken=false)
    Aqua.test_all(GraphCombinatorics; ambiguities=false)
end

@testset "wick_contractions" begin
    include("wick_contractions.jl")
end

@testset "wick_contractions" begin
    include("reduction.jl")
end

@testset "graph_generation" begin
    include("generation.jl")
end
