import GraphCombinations as GC

function native_connectivity!(SUITE)
    connected = Pair{Int,Int}[
        1 => 3,
        2 => 4,
        3 => 4,
        3 => 5,
        3 => 6,
        4 => 5,
        4 => 7,
        5 => 6,
        5 => 7,
        6 => 7,
        6 => 7,
    ]
    disconnected = Pair{Int,Int}[1 => 2, 1 => 2, 3 => 4, 4 => 5, 5 => 6, 6 => 7]
    num_vertices = 7

    SUITE["Connectivity"]["Graphs connected"] = @benchmarkable GC.is_connected(
        GC.build_internal_graph($connected, $num_vertices)
    ) seconds = 5
    SUITE["Connectivity"]["native connected"] = @benchmarkable GC._is_connected_graph_rep(
        $connected, $num_vertices
    ) seconds = 5
    SUITE["Connectivity"]["Graphs disconnected"] = @benchmarkable GC.is_connected(
        GC.build_internal_graph($disconnected, $num_vertices)
    ) seconds = 5
    SUITE["Connectivity"]["native disconnected"] = @benchmarkable GC._is_connected_graph_rep(
        $disconnected, $num_vertices
    ) seconds = 5

    return nothing
end
