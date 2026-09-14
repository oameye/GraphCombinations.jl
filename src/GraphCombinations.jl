"""
GraphCombinations.jl provides exact generation, canonicalization, symmetry reduction, and
combinatorial utilities for undirected multigraph problems.
"""
module GraphCombinations

using DispatchDoctor: @stable

@stable default_mode = "disable" default_codegen_level = "min" begin
    include("utils.jl")
    include("canonical_actions.jl")
    include("native_graph.jl")
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
    include("typed_native_dispatch.jl")
    include("generation.jl")
end

export allgraphs, combinatoric_factor, build_graph, total_degree, canonical_form, GCGraph
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
