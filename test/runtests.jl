using Test, GraphCombinations

if VERSION < v"1.12.0-beta"
    @testset "Code linting" begin
        using JET
        JET.test_package(GraphCombinations; target_defined_modules=true)
    end
end

@testset "ExplicitImports" begin
    using ExplicitImports
    @test check_no_stale_explicit_imports(GraphCombinations) == nothing
    @test check_all_explicit_imports_via_owners(GraphCombinations) == nothing
end

@testset "best practices" begin
    using Aqua

    Aqua.test_ambiguities([GraphCombinations]; broken=false)
    Aqua.test_all(GraphCombinations; ambiguities=false)
end

@testset "Multigraph wrapper" begin
    include("MultiGraphWrap.jl")
end

@testset "wick_contractions" begin
    include("wick_contractions.jl")
end

@testset "reduction" begin
    include("reduction.jl")
end

@testset "graph_generation" begin
    include("generation.jl")
end

@testset "phi-four" begin
    include("phi-four.jl")
end

@testset "Doctests" begin
    using Documenter
    Documenter.doctest(GraphCombinations)
end
