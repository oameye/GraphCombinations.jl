"""
$(DocStringExtensions.README)
"""
module GraphCombinatorics
using DispatchDoctor
@stable default_mode="disable" begin

using DocStringExtensions

using Graphs
using Combinatorics
using Memoization # Seems to be newer then Memoize.jl

include("utils.jl")
include("WickContractions.jl")
include("reduction.jl")
include("generation.jl")

export allgraphs

end # @stable
end # module GraphCombinatorics
