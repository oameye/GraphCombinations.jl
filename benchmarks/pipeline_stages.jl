import GraphCombinations as GC

function pipeline_stages!(SUITE)
    vertices2 = [2, 0, 0, 2]
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

    # Keep a separate cold end-to-end measurement. The historical Phi^4 benchmarks remain
    # untouched, preserving the existing benchmark time series.
    SUITE["Pipeline"]["allgraphs cold"] = @benchmarkable allgraphs($vertices2) setup = (GC._clear_corr_cache!()) evals =
        1 seconds = 10

    return nothing
end
