# Load the fixture/kernel definitions from the first external-benchmark draft.
# NautyGraphs v0.7.3 predates the documented NautyBuffer API, so that draft
# intentionally fails at its first top-level benchmark call after defining all
# fixtures and helpers.  Catch only that known version-mismatch failure here.
try
    include(joinpath(@__DIR__, "packed_external_nauty_benchmark.jl"))
catch error
    message = sprint(showerror, error)
    occursin("NautyBuffer", message) || rethrow()
end

function run_external_v073_benchmark(name::String, fixture; repetitions::Int=40)
    graph, colors = fixture
    n = graph.num_vertices

    dfs_workspace = ExternalDFS.RecursiveStabilizerWorkspace(n)
    dfs_buffer = GC.DirectedCanonicalizationBuffer(n)
    level_workspace = ExternalLevelwise.PackedLevelwiseWorkspace(
        n; frontier_capacity=max(4096, 16 * max(n, 1)^2)
    )
    level_buffer = GC.DirectedCanonicalizationBuffer(n)

    ExternalDFS.canonicalize_recursive_stabilizers!(
        dfs_buffer, dfs_workspace, graph, colors
    )
    ExternalLevelwise.canonicalize_levelwise_workspace!(
        level_buffer, level_workspace, graph, colors
    )
    dfs_buffer.automorphism_order == level_buffer.automorphism_order ||
        error("GC exact-order disagreement for $name")

    dense = to_nauty(NautyGraphs.NautyDiGraph, graph, colors)
    sparse = to_nauty(NautyGraphs.SpNautyDiGraph, graph, colors)

    _, dense_group = NautyGraphs.nauty(dense)
    _, sparse_group = NautyGraphs.nauty(sparse)
    dense_group.n == Float64(dfs_buffer.automorphism_order) ||
        error("dense Nauty group-size disagreement for $name")
    sparse_group.n == Float64(dfs_buffer.automorphism_order) ||
        error("sparse Nauty group-size disagreement for $name")

    # Warm every measured path.  GC returns exact canonical image, witness and
    # integer automorphism order.  Nauty v0.7.3 returns the canonical
    # permutation plus a Float64 group size; canonical_permutation is also
    # measured as a strictly cheaper canonization-only baseline.
    ExternalDFS.canonicalize_recursive_stabilizers!(
        dfs_buffer, dfs_workspace, graph, colors
    )
    ExternalLevelwise.canonicalize_levelwise_workspace!(
        level_buffer, level_workspace, graph, colors
    )
    NautyGraphs.nauty(dense)
    NautyGraphs.nauty(sparse)
    NautyGraphs.canonical_permutation(dense)
    NautyGraphs.canonical_permutation(sparse)

    dfs_alloc = @allocated ExternalDFS.canonicalize_recursive_stabilizers!(
        dfs_buffer, dfs_workspace, graph, colors
    )
    level_alloc = @allocated ExternalLevelwise.canonicalize_levelwise_workspace!(
        level_buffer, level_workspace, graph, colors
    )
    dense_nauty_alloc = @allocated NautyGraphs.nauty(dense)
    sparse_nauty_alloc = @allocated NautyGraphs.nauty(sparse)
    dense_canon_alloc = @allocated NautyGraphs.canonical_permutation(dense)
    sparse_canon_alloc = @allocated NautyGraphs.canonical_permutation(sparse)

    dfs_ns = minimum_call_ns(repetitions) do
        ExternalDFS.canonicalize_recursive_stabilizers!(
            dfs_buffer, dfs_workspace, graph, colors
        )
    end
    level_ns = minimum_call_ns(repetitions) do
        ExternalLevelwise.canonicalize_levelwise_workspace!(
            level_buffer, level_workspace, graph, colors
        )
    end
    dense_nauty_ns = minimum_call_ns(repetitions) do
        NautyGraphs.nauty(dense)
    end
    sparse_nauty_ns = minimum_call_ns(repetitions) do
        NautyGraphs.nauty(sparse)
    end
    dense_canon_ns = minimum_call_ns(repetitions) do
        NautyGraphs.canonical_permutation(dense)
    end
    sparse_canon_ns = minimum_call_ns(repetitions) do
        NautyGraphs.canonical_permutation(sparse)
    end

    best_gc = min(dfs_ns, level_ns)
    best_nauty = min(dense_nauty_ns, sparse_nauty_ns)
    best_canon = min(dense_canon_ns, sparse_canon_ns)
    gc_kernel = level_ns < dfs_ns ? "levelwise" : "dfs"
    nauty_backend = sparse_nauty_ns < dense_nauty_ns ? "sparse" : "dense"
    canon_backend = sparse_canon_ns < dense_canon_ns ? "sparse" : "dense"

    println(
        "EXTERNAL073|", name,
        "|n=", n,
        "|order=", dfs_buffer.automorphism_order,
        "|gc_kernel=", gc_kernel,
        "|gc_ns=", best_gc,
        "|dfs_ns=", dfs_ns,
        "|level_ns=", level_ns,
        "|nauty_backend=", nauty_backend,
        "|nauty_ns=", best_nauty,
        "|canon_backend=", canon_backend,
        "|canon_ns=", best_canon,
        "|gc_over_nauty=", round(best_gc / best_nauty; digits=3),
        "|gc_over_canon=", round(best_gc / best_canon; digits=3),
        "|dfs_alloc=", dfs_alloc,
        "|level_alloc=", level_alloc,
        "|dense_nauty_alloc=", dense_nauty_alloc,
        "|sparse_nauty_alloc=", sparse_nauty_alloc,
        "|dense_canon_alloc=", dense_canon_alloc,
        "|sparse_canon_alloc=", sparse_canon_alloc,
    )
    return nothing
end

run_external_v073_benchmark("complete-9", fixture_complete(9))
run_external_v073_benchmark("empty-9", fixture_empty(9))
run_external_v073_benchmark("k6-6", fixture_complete_bipartite(6, 6))
run_external_v073_benchmark("cycle-31", fixture_cycle(31); repetitions=20)
run_external_v073_benchmark("petersen", fixture_petersen())
run_external_v073_benchmark("triangular-6", fixture_triangular(6))
run_external_v073_benchmark("rook-4", fixture_rook(4))
run_external_v073_benchmark("hypercube-5", fixture_hypercube(5); repetitions=20)
run_external_v073_benchmark("paley-13", fixture_paley13())
run_external_v073_benchmark("shrikhande", fixture_shrikhande())
run_external_v073_benchmark(
    "repeated-directed-c7x4", fixture_repeated_directed_cycles(4, 7); repetitions=20
)
run_external_v073_benchmark("asymmetric-24", fixture_asymmetric(24); repetitions=20)
