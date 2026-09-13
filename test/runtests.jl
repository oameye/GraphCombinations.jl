using Preferences: set_preferences!

const STATIC_ANALYSIS = "static" in ARGS
set_preferences!(
    "GraphCombinations", "dispatch_doctor_mode" => (STATIC_ANALYSIS ? "disable" : "error")
)

using Test, GraphCombinations

if STATIC_ANALYSIS
    @testset "Code linting" begin
        using JET
        report = JET.report_package(GraphCombinations; target_modules=(GraphCombinations,))
        @test isempty(JET.get_reports(report))
    end

    @testset "ExplicitImports" begin
        using ExplicitImports
        @test check_no_stale_explicit_imports(GraphCombinations) == nothing
        @test check_all_explicit_imports_via_owners(GraphCombinations) == nothing
    end
else
    @testset "best practices" begin
        using Aqua

        Aqua.test_ambiguities([GraphCombinations]; broken=false)
        Aqua.test_all(GraphCombinations; ambiguities=false)
    end

    include(joinpath(@__DIR__, "..", "reference", "ReferenceGraphCombinations.jl"))
    const ReferenceGC = ReferenceGraphCombinations

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

    @testset "Wick reference oracle" begin
        include("reference_oracle.jl")
    end

    @testset "direct generation" begin
        include("direct_generation.jl")
    end

    @testset "row-state reduction" begin
        include("row_state_reduction.jl")
    end

    @testset "colored port generation" begin
        include("colored_port_generation.jl")
    end

    @testset "colored port pruning" begin
        include("colored_port_pruning.jl")
    end

    @testset "colored port public API" begin
        include("colored_port_api.jl")
    end

    @testset "phi-four" begin
        include("phi-four.jl")
    end

    @testset "unconnected graphs" begin
        include("unconnected_graphs.jl")
    end

    @testset "Doctests" begin
        using Documenter
        Documenter.doctest(GraphCombinations)
    end
end
