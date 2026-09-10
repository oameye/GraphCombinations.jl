import GraphCombinations as GC

function pipeline_stages!(SUITE)
    vertices2 = [2, 0, 0, 2]
    vertices3 = [2, 0, 0, 3]
    vertices4 = [2, 0, 0, 4]
    vertices5 = [2, 0, 0, 5]
    points2 = GC.create_points(vertices2)
    num_vertices2 = sum(vertices2)
    internal_indices2 = (vertices2[1] + 1):num_vertices2

    GC._clear_corr_cache!()
    pairings2 = GC.corr(points2)
    connected2 = GC.filter_graphs(pairings2, num_vertices2)
    representative2 = first(connected2)

    # `corr` is globally memoized. Clear its cache in setup so this benchmark measures the
    # actual Wick-pairing generation cost rather than a lookup from a previous sample.
    SUITE["Pipeline"]["Wick pairings cold"] = @benchmarkable GC.corr($points2) setup = (GC._clear_corr_cache!()) evals =
        1 seconds = 10

    # Populate the cache immediately before each sample to isolate memoized lookup overhead.
    SUITE["Pipeline"]["Wick pairings cached"] = @benchmarkable GC.corr($points2) setup =
        begin
            GC._clear_corr_cache!()
            GC.corr($points2)
        end evals = 1 seconds = 10

    SUITE["Pipeline"]["connected filter"] = @benchmarkable GC.filter_graphs(
        $pairings2, $num_vertices2
    ) seconds = 10

    SUITE["Pipeline"]["canonical form"] = @benchmarkable GC.canonical_form(
        $representative2, $internal_indices2
    ) seconds = 10

    SUITE["Pipeline"]["isomorphism reduction"] = @benchmarkable GC.reduce_isomorphic_graphs(
        $connected2, $internal_indices2
    ) seconds = 10

    # End-to-end production measurement. The historical Phi^4 benchmarks remain untouched and
    # now naturally track the direct production implementation as well.
    SUITE["Pipeline"]["allgraphs production"] = @benchmarkable allgraphs($vertices2) evals =
        1 seconds = 10

    # Isolate direct candidate-space growth from complete topology reduction costs.
    SUITE["Direct"]["labeled candidates - 2 loops"] = @benchmarkable GC._count_labeled_multigraphs(
        $vertices2
    ) seconds = 10
    SUITE["Direct"]["labeled candidates - 3 loops"] = @benchmarkable GC._count_labeled_multigraphs(
        $vertices3
    ) seconds = 10
    SUITE["Direct"]["labeled candidates - 4 loops"] = @benchmarkable GC._count_labeled_multigraphs(
        $vertices4
    ) seconds = 10
    SUITE["Direct"]["labeled candidates - 5 loops"] = @benchmarkable GC._count_labeled_multigraphs(
        $vertices5
    ) seconds = 10
    SUITE["Direct"]["allgraphs - 2 loops"] = @benchmarkable GC._allgraphs_direct($vertices2) seconds =
        10
    SUITE["Direct"]["allgraphs - 3 loops"] = @benchmarkable GC._allgraphs_direct($vertices3) seconds =
        10
    SUITE["Direct"]["allgraphs - 4 loops"] = @benchmarkable GC._allgraphs_direct($vertices4) seconds =
        10
    SUITE["Direct"]["allgraphs - 5 loops"] = @benchmarkable GC._allgraphs_direct($vertices5) seconds =
        10

    # Use fixed connected phi^4 representatives so canonical-label benchmarking itself does not
    # require running the complete order-four/five topology reduction during suite construction.
    canonical2 = [GC.Edge(1, 3), GC.Edge(2, 4), GC.Edge(3, 4), GC.Edge(3, 4), GC.Edge(3, 4)]
    canonical3 = [
        GC.Edge(1, 3),
        GC.Edge(2, 4),
        GC.Edge(3, 4),
        GC.Edge(3, 5),
        GC.Edge(3, 5),
        GC.Edge(4, 5),
        GC.Edge(4, 5),
    ]
    canonical4 = [
        GC.Edge(1, 3),
        GC.Edge(2, 4),
        GC.Edge(3, 4),
        GC.Edge(3, 5),
        GC.Edge(3, 5),
        GC.Edge(4, 6),
        GC.Edge(4, 6),
        GC.Edge(5, 6),
        GC.Edge(5, 6),
    ]
    canonical5 = [
        GC.Edge(1, 3),
        GC.Edge(2, 4),
        GC.Edge(3, 4),
        GC.Edge(3, 5),
        GC.Edge(3, 6),
        GC.Edge(4, 5),
        GC.Edge(4, 7),
        GC.Edge(5, 6),
        GC.Edge(5, 7),
        GC.Edge(6, 7),
        GC.Edge(6, 7),
    ]
    canonical_indices2 = 3:4
    canonical_indices3 = 3:5
    canonical_indices4 = 3:6
    canonical_indices5 = 3:7

    SUITE["Canonical"]["reference - 2 internal"] = @benchmarkable GC.canonical_form(
        $canonical2, $canonical_indices2
    ) seconds = 10
    SUITE["Canonical"]["scratch - 2 internal"] = @benchmarkable GC._canonical_form_scratch(
        $canonical2, $canonical_indices2
    ) seconds = 10
    SUITE["Canonical"]["reference - 3 internal"] = @benchmarkable GC.canonical_form(
        $canonical3, $canonical_indices3
    ) seconds = 10
    SUITE["Canonical"]["scratch - 3 internal"] = @benchmarkable GC._canonical_form_scratch(
        $canonical3, $canonical_indices3
    ) seconds = 10
    SUITE["Canonical"]["reference - 4 internal"] = @benchmarkable GC.canonical_form(
        $canonical4, $canonical_indices4
    ) seconds = 10
    SUITE["Canonical"]["scratch - 4 internal"] = @benchmarkable GC._canonical_form_scratch(
        $canonical4, $canonical_indices4
    ) seconds = 10
    SUITE["Canonical"]["reference - 5 internal"] = @benchmarkable GC.canonical_form(
        $canonical5, $canonical_indices5
    ) seconds = 10
    SUITE["Canonical"]["scratch - 5 internal"] = @benchmarkable GC._canonical_form_scratch(
        $canonical5, $canonical_indices5
    ) seconds = 10

    return nothing
end
