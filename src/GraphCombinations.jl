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
    include("directed_canonicalization.jl")
    include("directed_refinement.jl")
    include("directed_workspace.jl")
    include("directed_input_buffer.jl")
    include("directed_packed_workspace.jl")
    include("directed_levelwise/DirectedLevelwise.jl")
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

const DirectedSimpleCanonicalizationWorkspace =
    DirectedLevelwise.PackedLevelwiseIncrementalWorkspace

"""
    canonicalize_directed_simple!(buffer, workspace, graph, vertex_colors)

Canonicalize a simple colored directed graph with at most 64 vertices using the prepared
one-word levelwise kernel. The caller owns `buffer` and `workspace`; repeated warmed calls reuse
all search, trace, frontier, and automorphism scratch.

The result is written into the existing `DirectedCanonicalizationBuffer`, preserving its exact
old-to-canonical witness, inverse order, canonical image, and automorphism-order contract.
Unsupported graph shapes remain the responsibility of the general `canonicalize_directed!`
path.
"""
function canonicalize_directed_simple!(
    buffer::DirectedCanonicalizationBuffer,
    workspace::DirectedSimpleCanonicalizationWorkspace,
    graph::DirectedGCGraph,
    vertex_colors::AbstractVector{<:Integer},
)::DirectedCanonicalizationBuffer
    return DirectedLevelwise.canonicalize_levelwise_incremental!(
        buffer, workspace, graph, vertex_colors
    )
end

function canonicalize_directed_simple!(
    buffer::DirectedCanonicalizationBuffer,
    workspace::DirectedSimpleCanonicalizationWorkspace,
    graph::DirectedGCGraphBuffer,
    vertex_colors::AbstractVector{<:Integer},
)::DirectedCanonicalizationBuffer
    n = graph.num_vertices
    length(vertex_colors) >= n ||
        throw(ArgumentError("vertex_colors must cover every active vertex."))
    return canonicalize_directed_simple!(
        buffer, workspace, _directed_graph_view(graph), @view(vertex_colors[1:n])
    )
end

export allgraphs,
    combinatoric_factor,
    build_graph,
    total_degree,
    canonical_form,
    GCGraph,
    DirectedGCGraph,
    DirectedGCGraphBuffer,
    DirectedCanonicalizationResult,
    DirectedCanonicalizationWorkspace,
    DirectedCanonicalizationBuffer,
    PackedDirectedCanonicalizationWorkspace,
    DirectedSimpleCanonicalizationWorkspace,
    VertexRelabeling,
    load_directed_graph!,
    canonicalize_directed,
    canonicalize_directed!,
    canonicalize_directed_packed!,
    canonicalize_directed_simple!,
    canonical_graph,
    canonical_automorphism_order,
    canonical_rank,
    original_vertex,
    vertex_mapping
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
