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

function direct_recursive_states(order::Int)::BigInt
    num_edges = 2 * order + 1
    states = big(1)
    for depth in 1:num_edges
        states +=
            (num_edges - 1) * factorial(big(num_edges - 1)) ÷
            factorial(big(num_edges - depth))
    end
    return states
end

function profile_case(label::String, internal_colors::Vector{Int})
    problem = quartic_port_problem(internal_colors)
    order = length(internal_colors)
    expected_labelled = labelled_matching_count(order)

    GC._weighted_port_matchings_with_stats(problem)
    sample = @timed GC._weighted_port_matchings_with_stats(problem)
    results, stats = sample.value
    labelled = sum(last, results)
    labelled == expected_labelled ||
        error("weighted quotient changed the labelled matching multiplicity")

    quotient_states = sum(stats.layer_states)
    println(
        "PROFILE\t",
        label,
        "\torder=",
        order,
        "\tedges=",
        2 * order + 1,
        "\tautomorphisms=",
        stats.automorphisms,
        "\tdirect_recursive_states=",
        direct_recursive_states(order),
        "\tquotient_layer_states=",
        quotient_states,
        "\ttransitions=",
        stats.transitions,
        "\tmerged_transitions=",
        stats.merged_transitions,
        "\tcanonicalization_calls=",
        stats.canonicalization_calls,
        "\tfinal_states=",
        length(results),
        "\tlabelled_matchings=",
        labelled,
        "\tseconds=",
        sample.time,
        "\tbytes=",
        sample.bytes,
        "\tlayers=",
        join(stats.layer_states, ','),
    )
    return nothing
end

for order in 1:5
    profile_case("identical", fill(1, order))
end

profile_case("order4_2plus2", [1, 1, 2, 2])
profile_case("order4_all_distinct", collect(1:4))
