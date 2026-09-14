import GraphCombinations as GC

function colored_port_data(vertex_colors::AbstractVector{<:Integer})
    num_vertices = length(vertex_colors)
    source_ports = zeros(Int, num_vertices, 1)
    target_ports = zeros(Int, num_vertices, 1)
    source_ports[1, 1] = 1
    target_ports[2, 1] = 1
    for vertex in 3:num_vertices
        source_ports[vertex, 1] = 2
        target_ports[vertex, 1] = 2
    end

    compatibility = trues(num_vertices, 1, num_vertices, 1)
    compatibility[1, 1, 2, 1] = false
    return collect(Int, vertex_colors), source_ports, target_ports, compatibility
end

function colored_port_data(order::Int)
    return colored_port_data(vcat([1, 2], fill(3, order)))
end

function colored_port_problem(order::Int)
    vertex_colors, source_ports, target_ports, compatibility = colored_port_data(order)
    return GC._PortMatchingProblem(
        vertex_colors, source_ports, target_ports, compatibility, 2
    )
end

function public_colored_port_problem(vertex_colors::AbstractVector{<:Integer})
    colors, source_ports, target_ports, compatibility = colored_port_data(vertex_colors)
    return GC.ColoredPortProblem(colors, source_ports, target_ports, compatibility, 2)
end

function public_colored_port_problem(order::Int)
    vertex_colors, source_ports, target_ports, compatibility = colored_port_data(order)
    return GC.ColoredPortProblem(
        vertex_colors, source_ports, target_ports, compatibility, 2
    )
end

struct ParityPortTransport end

@inline function relabeling_parity(witness::GC.PortRelabeling)::Int
    mapping = witness.vertex_map
    odd = false
    @inbounds for i in firstindex(mapping):(lastindex(mapping) - 1)
        for j in (i + 1):lastindex(mapping)
            odd = xor(odd, mapping[i] > mapping[j])
        end
    end
    return odd ? -1 : 1
end

function GC.initial_port_weight(
    ::ParityPortTransport,
    ::GC.ColoredPortState,
    ::GC.ColoredPortState,
    witness::GC.PortRelabeling,
)::BigInt
    return BigInt(relabeling_parity(witness))
end

function GC.transport_port_weight(
    ::ParityPortTransport,
    parent_weight::BigInt,
    multiplicity::Int,
    ::GC.ColoredPortEdge,
    ::GC.ColoredPortState,
    ::GC.ColoredPortState,
    witness::GC.PortRelabeling,
)::BigInt
    return parent_weight * multiplicity * relabeling_parity(witness)
end

function add_colored_port_profile_fixture!(
    profile::BenchmarkGroup, name::String, vertex_colors::Vector{Int}
)
    data = colored_port_data(vertex_colors)
    problem = public_colored_port_problem(vertex_colors)
    internal = problem._problem
    automorphisms = GC._port_automorphisms(internal)
    initial_state = GC._PortMatchingState(
        GC._PortEdge[], copy(internal.source_ports), copy(internal.target_ports)
    )
    workspace = GC._PortCanonicalizationWorkspace(initial_state)
    initial_key, _, _ = GC._canonicalize_port_state(initial_state, automorphisms, workspace)
    internal_results, stats = GC._weighted_port_matchings_with_stats(internal)

    group = profile[name] = BenchmarkGroup()
    colors, source_ports, target_ports, compatibility = data
    group["problem construction"] = @benchmarkable GC.ColoredPortProblem(
        $colors, $source_ports, $target_ports, $compatibility, 2
    )
    group["relabeling setup"] = @benchmarkable GC._port_automorphisms($internal)
    group["initial canonicalization"] = @benchmarkable GC._canonicalize_port_state(
        $initial_state, $automorphisms, $workspace
    )
    group["canonical key hash"] = @benchmarkable hash($initial_key)
    group["internal traversal + stats"] = @benchmarkable GC._weighted_port_matchings_with_stats(
        $internal
    ) seconds = 5
    group["compact traversal + stats"] = @benchmarkable GC._weighted_port_matchings_compact_with_stats(
        $internal
    ) seconds = 5
    group["public materialization"] = @benchmarkable GC._public_port_results(
        $internal_results
    )
    group["public generation"] = @benchmarkable GC.generate_weighted($problem) seconds = 5

    println(
        "Colored-port fixture [$name]: automorphisms=$(stats.automorphisms), " *
        "layers=$(stats.layer_states), transitions=$(stats.transitions), " *
        "canonicalization calls=$(stats.canonicalization_calls), " *
        "merged=$(stats.merged_transitions), completions=$(length(internal_results))",
    )
    return problem
end

function colored_port_generation!(SUITE)
    order4 = colored_port_problem(4)
    order5 = colored_port_problem(5)
    public_order4 = public_colored_port_problem(4)

    SUITE["Colored port generation"]["order 4"] = @benchmarkable GC._weighted_port_matchings(
        $order4
    ) seconds = 5
    SUITE["Colored port generation"]["order 5"] = @benchmarkable GC._weighted_port_matchings(
        $order5
    ) seconds = 5
    SUITE["Colored port generation"]["order 4 public"] = @benchmarkable GC.generate_weighted(
        $public_order4
    ) seconds = 5

    profile = SUITE["Colored port profile"] = BenchmarkGroup()
    add_colored_port_profile_fixture!(profile, "high-color low-symmetry", collect(1:6))
    add_colored_port_profile_fixture!(profile, "repeated-color order 3", [1, 2, 3, 3, 3])
    repeated_order4 = add_colored_port_profile_fixture!(
        profile, "repeated-color order 4", [1, 2, 3, 3, 3, 3]
    )

    signed_group = profile["signed witness transport"] = BenchmarkGroup()
    parity_transport = ParityPortTransport()
    _, signed_stats = GC.generate_weighted_with_stats(
        repeated_order4; transport=parity_transport
    )
    signed_group["public generation"] = @benchmarkable GC.generate_weighted(
        $repeated_order4; transport=($parity_transport)
    ) seconds = 5
    signed_group["public generation + stats"] = @benchmarkable GC.generate_weighted_with_stats(
        $repeated_order4; transport=($parity_transport)
    ) seconds = 5
    println(
        "Colored-port fixture [signed witness transport]: " *
        "automorphisms=$(signed_stats.automorphisms), layers=$(signed_stats.layer_states), " *
        "transitions=$(signed_stats.transitions), " *
        "canonicalization calls=$(signed_stats.canonicalization_calls), " *
        "merged=$(signed_stats.merged_transitions)",
    )

    return nothing
end
