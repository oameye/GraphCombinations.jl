function phi_4_theory!(SUITE)
    vertices2 = [2, 0, 0, 2]
    vertices3 = [2, 0, 0, 3]
    SUITE["Phi^4 theory"]["2 loops"] = @benchmarkable allgraphs($vertices2) seconds = 10
    SUITE["Phi^4 theory"]["3 loops"] = @benchmarkable allgraphs($vertices3) seconds = 10

    return nothing
end
