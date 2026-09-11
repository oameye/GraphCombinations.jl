using GraphCombinations

import GraphCombinations as GC

# Re-run this probe after canonicalization-kernel changes; order 6 is the
# first case where scanning the full valid automorphism group is substantial.
function symmetry_scaling_problem(order::Int; asymmetric=false)
    num_vertices = order + 2
    vertex_colors = vcat([1, 2], fill(3, order))
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
    if asymmetric
        # A total-order relation on the same-colored internal vertices has only
        # the identity automorphism. The current implementation still has to
        # inspect every same-color candidate permutation to discover that.
        for source in 3:num_vertices
            for target in 3:num_vertices
                compatibility[source, 1, target, 1] = source <= target
            end
        end
    end
    return GC._PortMatchingProblem(
        vertex_colors, source_ports, target_ports, compatibility, 2
    )
end

function profile_group_discovery(order::Int; asymmetric=false)
    problem = symmetry_scaling_problem(order; asymmetric)
    GC._port_automorphisms(problem)
    sample = @timed GC._port_automorphisms(problem)
    println(
        "GROUP\torder=",
        order,
        "\tasymmetric=",
        asymmetric,
        "\tcandidates=",
        factorial(big(order)),
        "\tautomorphisms=",
        length(sample.value),
        "\tseconds=",
        sample.time,
        "\tbytes=",
        sample.bytes,
    )
    return nothing
end

function profile_orbit(order::Int)
    problem = symmetry_scaling_problem(order)
    GC._weighted_port_matchings_with_stats(problem)
    sample = @timed GC._weighted_port_matchings_with_stats(problem)
    results, stats = sample.value
    println(
        "ORBIT\torder=",
        order,
        "\tedges=",
        2 * order + 1,
        "\tautomorphisms=",
        stats.automorphisms,
        "\tstates=",
        sum(stats.layer_states),
        "\ttransitions=",
        stats.transitions,
        "\tfinal=",
        length(results),
        "\tseconds=",
        sample.time,
        "\tbytes=",
        sample.bytes,
        "\tlayers=",
        join(stats.layer_states, ','),
    )
    return nothing
end

profile_group_discovery(6)
profile_group_discovery(7)
profile_group_discovery(8; asymmetric=true)
profile_group_discovery(9; asymmetric=true)
profile_orbit(6)
