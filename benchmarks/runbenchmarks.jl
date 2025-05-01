using BenchmarkTools
using GraphCombinatorics

const SUITE = BenchmarkGroup()

include("phi4_graphs.jl")

phi_4_theory!(SUITE)

BenchmarkTools.tune!(SUITE)
results = BenchmarkTools.run(SUITE; verbose=true)
display(median(results))

BenchmarkTools.save("benchmarks_output.json", median(results))
