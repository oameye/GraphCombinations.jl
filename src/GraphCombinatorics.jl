"""
$(DocStringExtensions.README)
"""
module GraphCombinatorics
using DocStringExtensions

using Graphs
using Combinatorics
using Memoization # Seems to be newer then Memoize.jl

include("utils.jl")
include("WickContractions.jl")
include("reduction.jl")
include("generation.jl")

export allgraphs

end # module GraphCombinatorics
