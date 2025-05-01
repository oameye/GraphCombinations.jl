module GraphCombinatorics

using Graphs
using Combinatorics
using Memoization # Seems to be newer Memoize.jl

include("utils.jl")
include("WickContractions.jl")
include("reduction.jl")
include("generation.jl")

export allgraphs

end # module GraphCombinatorics
