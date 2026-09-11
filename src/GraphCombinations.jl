"""
$(DocStringExtensions.README)
"""
module GraphCombinations

using DocStringExtensions

using Graphs, Multigraphs

include("MultiGraphWrap.jl")
include("utils.jl")
include("partition_canonicalization.jl")
include("matrix_canonicalization.jl")
include("direct_generation.jl")
include("row_state_reduction.jl")
include("generation.jl")
include("colored_port_generation.jl")

export allgraphs, combinatoric_factor, build_graph, total_degree, canonical_form

end # module GraphCombinations
