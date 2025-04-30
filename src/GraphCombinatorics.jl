module GraphCombinatorics

using Graphs
using Combinatorics
using Memoization
using Printf # Keep if needed by included files (e.g., for debugging)
using Plots  # Keep if plotting functions are added back or used internally

# Include the separated code files
include("utils.jl")
include("WickContractions.jl")
include("reduction.jl")
include("generation.jl")

# Export functions/modules as needed
export allgraphs

end # module GraphCombinatorics
