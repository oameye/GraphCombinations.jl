"""
$(DocStringExtensions.README)
"""
module GraphCombinations

using DocStringExtensions

using Graphs, Multigraphs
using Combinatorics
using Memoization # Seems to be newer then Memoize.jl

include("MultiGraphWrap.jl")
include("utils.jl")
include("WickContractions.jl")
include("reduction.jl")
include("generation.jl")

export allgraphs, combinatoric_factor, build_graph, total_degree, canonical_form

end # module GraphCombinations
