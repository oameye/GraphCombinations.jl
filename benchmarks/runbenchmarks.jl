using BenchmarkTools
using GraphCombinations

const SUITE = BenchmarkGroup()

include("phi4_graphs.jl")
include("pipeline_stages.jl")
include("profile_row_state.jl")

phi_4_theory!(SUITE)
pipeline_stages!(SUITE)

BenchmarkTools.tune!(SUITE)
results = BenchmarkTools.run(SUITE; verbose=true)
display(median(results))

BenchmarkTools.save("benchmarks_output.json", median(results))

# Temporary scaling/profiling tranche for #98. This runs after the tracked benchmark output has been
# saved so the normal benchmark history remains unchanged while we inspect orders beyond the current
# permanent suite.
profile_row_state_scaling()
