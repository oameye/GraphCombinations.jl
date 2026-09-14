"""
$(DocStringExtensions.README)
"""
module GraphCombinations

using DocStringExtensions
using DispatchDoctor: @stable

using Graphs, Multigraphs

@stable default_mode = "disable" default_codegen_level = "min" begin
    include("MultiGraphWrap.jl")
    include("utils.jl")
    include("relabeling_group.jl")
    include("partition_canonicalization.jl")
    include("matrix_canonicalization.jl")
    include("direct_generation.jl")
    include("row_state_reduction.jl")
    include("colored_port_generation.jl")
    include("colored_port_pruning.jl")
    include("colored_port_api.jl")
    include("degree_sequence_problem.jl")
    include("typed_multigraph_problem.jl")
    include("triangular_canonicalization.jl")
    include("typed_row_state_reduction.jl")
    include("typed_packed_row_state_reduction.jl")
    include("typed_native_multiplicity_reduction.jl")
    include("generation.jl")
end

export allgraphs, combinatoric_factor, build_graph, total_degree, canonical_form
export DegreeSequenceProblem,
    TypedMultigraphProblem,
    generate_multigraphs,
    vertex_degrees,
    vertex_colors,
    edge_admissibility,
    fixed_vertex_count
export ColoredPortEdge,
    ColoredPortProblem,
    ColoredPortState,
    PortRelabeling,
    WeightedPortCompletion,
    PortGenerationStats,
    AcceptAllPortPolicy,
    MultiplicityPortTransport,
    generate_weighted,
    generate_weighted_with_stats,
    generation_statistics,
    canonical_relabeling,
    relabel_port_state,
    port_edges,
    source_port_counts,
    target_port_counts,
    initial_port_weight,
    transport_port_weight

end # module GraphCombinations
