import GraphCombinations as GC

function colored_port_problem(order::Int)
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
    return GC._PortMatchingProblem(
        vertex_colors, source_ports, target_ports, compatibility, 2
    )
end

function colored_port_generation!(SUITE)
    order4 = colored_port_problem(4)
    order5 = colored_port_problem(5)

    SUITE["Colored port generation"]["order 4"] = @benchmarkable GC._weighted_port_matchings(
        $order4
    ) seconds = 5
    SUITE["Colored port generation"]["order 5"] = @benchmarkable GC._weighted_port_matchings(
        $order5
    ) seconds = 5

    return nothing
end
