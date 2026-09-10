using BenchmarkTools
using GraphCombinations

const SUITE = BenchmarkGroup()

include("phi4_graphs.jl")
include("pipeline_stages.jl")

phi_4_theory!(SUITE)
pipeline_stages!(SUITE)

BenchmarkTools.tune!(SUITE)
results = BenchmarkTools.run(SUITE; verbose=true)
display(median(results))

BenchmarkTools.save("benchmarks_output.json", median(results))
