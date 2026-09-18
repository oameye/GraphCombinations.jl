include(joinpath(@__DIR__, "packed_portfolio_trace_prefix.jl"))

function run_trace_profile(name::String, winner::String, fixture; max_levels::Int=8)
    graph, colors = fixture
    n = graph.num_vertices
    workspace = PrefixLevelwise.PackedLevelwiseWorkspace(
        n; frontier_capacity=max(4096, 16 * max(n, 1)^2)
    )
    GC._prepare_packed_directed_rows!(workspace.traced.packed, graph) ||
        error("simple graph required")
    GC._prepare_packed_directed_rows!(workspace.path_packed, graph) ||
        error("simple graph required")
    PrefixLevelwise.reset_levelwise_stats!(workspace)
    PrefixLevelwise.prepare_traced_partition!(workspace.traced, graph, colors)
    PrefixLevelwise.traced_refine!(workspace.traced, graph, 1)
    PrefixLevelwise.levelwise_store_root!(workspace, graph)

    current_count = 1
    previous_multiplicity = 1
    print("PROFILE|", name, "|winner=", winner, "|n=", n)
    for level in 1:max_levels
        target = PrefixLevelwise.levelwise_target_color!(
            workspace, workspace.current_colors, 1, n
        )
        if iszero(target)
            print("|done_at=", level - 1)
            break
        end
        result = measure_prefix_level!(workspace, graph, current_count)
        growth = result.quotient_multiplicity ÷ previous_multiplicity
        print(
            "|l", level, "g=", result.generated,
            ",t=", result.trace_survivors,
            ",r=", result.count,
            ",m=", result.quotient_multiplicity,
            ",x=", growth,
            ",p=", result.paths,
            ",q=", result.quotient_discards,
            ",z=", result.trace_length,
            ",d=", result.discrete ? 1 : 0,
        )
        current_count = result.count
        previous_multiplicity = result.quotient_multiplicity
        result.discrete && (print("|done_at=", level); break)
    end
    println()
    return nothing
end

run_trace_profile("petersen", "dfs", prefix_petersen())
run_trace_profile("triangular-6", "levelwise", prefix_triangular(6))
run_trace_profile("rook-4", "levelwise", prefix_rook(4))
run_trace_profile("hypercube-5", "levelwise", prefix_hypercube(5))
run_trace_profile("paley-13", "dfs", prefix_paley13())
run_trace_profile("shrikhande", "dfs", prefix_shrikhande())
run_trace_profile("repeated-directed-c7x4", "component", prefix_repeated_directed_cycles(4, 7))
