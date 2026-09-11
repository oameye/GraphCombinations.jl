using GraphCombinations

import GraphCombinations as GC

function quartic_port_problem(internal_colors::Vector{Int})
    order = length(internal_colors)
    num_vertices = order + 2
    vertex_colors = vcat([1, 2], internal_colors .+ 2)
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
    return GC._PortMatchingProblem(
        vertex_colors, source_ports, target_ports, compatibility, 2
    )
end

function labelled_matching_count(order::Int)::BigInt
    num_edges = 2 * order + 1
    return factorial(big(num_edges)) - factorial(big(num_edges - 1))
end

function labelled_recursive_states(order::Int)::BigInt
    num_edges = 2 * order + 1
    states = big(1)
    for depth in 1:num_edges
        states +=
            (num_edges - 1) * factorial(big(num_edges - 1)) ÷
            factorial(big(num_edges - depth))
    end
    return states
end

function count_compressed_matchings_with_stats(problem::GC._PortMatchingProblem)
    identity = collect(eachindex(problem.vertex_colors))
    automorphisms = [identity]
    initial = GC._PortMatchingState(
        GC._PortEdge[], copy(problem.source_ports), copy(problem.target_ports)
    )
    initial_key, initial_state, _ = GC._canonicalize_port_state(initial, automorphisms)
    states = Dict(initial_key => GC._WeightedPortState(initial_state, big(1)))
    layer_states = Int[1]
    transitions = 0
    canonicalization_calls = 1
    merged_transitions = 0

    while true
        first_state = first(values(states)).state
        isnothing(GC._first_remaining_source(first_state)) && break

        next_states = Dict{GC._PortStateKey,GC._WeightedPortState}()
        for weighted in values(states)
            state = weighted.state
            source = GC._first_remaining_source(state)
            isnothing(source) && error("inconsistent count-compressed matching layer")
            source_vertex, source_color = source

            for target_vertex in axes(state.target_ports, 1)
                for target_color in axes(state.target_ports, 2)
                    multiplicity = state.target_ports[target_vertex, target_color]
                    iszero(multiplicity) && continue
                    problem.compatibility[
                        source_vertex, source_color, target_vertex, target_color
                    ] || continue

                    transitions += 1
                    child_sources = copy(state.source_ports)
                    child_targets = copy(state.target_ports)
                    child_edges = copy(state.edges)
                    child_sources[source_vertex, source_color] -= 1
                    child_targets[target_vertex, target_color] -= 1
                    push!(
                        child_edges,
                        GC._PortEdge(
                            source_vertex, target_vertex, source_color, target_color
                        ),
                    )
                    child = GC._PortMatchingState(child_edges, child_sources, child_targets)
                    key, canonical, _ = GC._canonicalize_port_state(child, automorphisms)
                    canonicalization_calls += 1
                    merged_transitions += Int(
                        GC._accumulate_port_state!(
                            next_states, key, canonical, weighted.weight * multiplicity
                        ),
                    )
                end
            end
        end

        push!(layer_states, length(next_states))
        isempty(next_states) && break
        states = next_states
    end

    results = Tuple{Vector{GC._PortEdge},BigInt}[]
    for weighted in values(states)
        push!(results, (weighted.state.edges, weighted.weight))
    end
    stats = GC._PortGenerationStats(
        1, layer_states, transitions, canonicalization_calls, merged_transitions
    )
    return results, stats
end

function profile_case(label::String, internal_colors::Vector{Int})
    problem = quartic_port_problem(internal_colors)
    order = length(internal_colors)
    expected_labelled = labelled_matching_count(order)

    count_compressed_matchings_with_stats(problem)
    count_sample = @timed count_compressed_matchings_with_stats(problem)
    count_results, count_stats = count_sample.value

    GC._weighted_port_matchings_with_stats(problem)
    orbit_sample = @timed GC._weighted_port_matchings_with_stats(problem)
    orbit_results, orbit_stats = orbit_sample.value

    count_labelled = sum(last, count_results)
    orbit_labelled = sum(last, orbit_results)
    count_labelled == expected_labelled ||
        error("count compression changed the labelled matching multiplicity")
    orbit_labelled == expected_labelled ||
        error("orbit quotient changed the labelled matching multiplicity")

    count_states = sum(count_stats.layer_states)
    orbit_states = sum(orbit_stats.layer_states)
    println(
        "PROFILE\t",
        label,
        "\torder=",
        order,
        "\tedges=",
        2 * order + 1,
        "\tautomorphisms=",
        orbit_stats.automorphisms,
        "\tlabelled_recursive_states=",
        labelled_recursive_states(order),
        "\tcount_states=",
        count_states,
        "\tcount_transitions=",
        count_stats.transitions,
        "\tcount_final=",
        length(count_results),
        "\tcount_seconds=",
        count_sample.time,
        "\tcount_bytes=",
        count_sample.bytes,
        "\torbit_states=",
        orbit_states,
        "\torbit_transitions=",
        orbit_stats.transitions,
        "\torbit_merged=",
        orbit_stats.merged_transitions,
        "\torbit_final=",
        length(orbit_results),
        "\torbit_seconds=",
        orbit_sample.time,
        "\torbit_bytes=",
        orbit_sample.bytes,
        "\tlabelled_matchings=",
        orbit_labelled,
        "\tcount_layers=",
        join(count_stats.layer_states, ','),
        "\torbit_layers=",
        join(orbit_stats.layer_states, ','),
    )
    return nothing
end

for order in 1:5
    profile_case("identical", fill(1, order))
end

profile_case("order4_2plus2", [1, 1, 2, 2])
profile_case("order4_all_distinct", collect(1:4))
