import GraphCombinations as GC

const WitnessRecursiveGC = GC.DirectedRecursive

function witness_bench_graph(n::Int)
    edges = Pair{Int,Int}[]
    for source in 1:n, target in 1:n
        source == target && continue
        value = mod(37source + 53target + 7source * target + 11source^2 + 3target^2, 97)
        value < 18 && push!(edges, source => target)
    end
    return GC.DirectedGCGraph(edges, n)
end

function witness_bench_cycle(n::Int)
    edges = Pair{Int,Int}[]
    for vertex in 1:n
        next = mod1(vertex + 1, n)
        push!(edges, vertex => next)
        push!(edges, next => vertex)
    end
    return GC.DirectedGCGraph(edges, n)
end

function witness_bench_hypercube(dimension::Int)
    n = 1 << dimension
    edges = Pair{Int,Int}[]
    for zero_vertex in 0:(n - 1)
        for bit in 0:(dimension - 1)
            neighbor = zero_vertex ⊻ (1 << bit)
            zero_vertex < neighbor || continue
            push!(edges, (zero_vertex + 1) => (neighbor + 1))
            push!(edges, (neighbor + 1) => (zero_vertex + 1))
        end
    end
    return GC.DirectedGCGraph(edges, n)
end

function minimum_ns(f, repetitions::Int)::Int
    best = typemax(Int)
    for _ in 1:repetitions
        start = time_ns()
        f()
        best = min(best, Int(time_ns() - start))
    end
    return best
end

function benchmark_levelwise(
    name::String,
    graph::GC.DirectedGCGraph,
    colors::Vector{Int};
    capacity::Int=graph.num_vertices,
    repetitions::Int=50,
)::Nothing
    full = GC.DirectedCanonicalizationBuffer(capacity)
    witness = GC.DirectedCanonicalizationBuffer(capacity; materialize_canonical=false)
    workspace = GC.DirectedSimpleCanonicalizationWorkspace(
        capacity; frontier_capacity=max(4096, 16 * max(capacity, 1)^2)
    )

    GC.canonicalize_directed_simple!(full, workspace, graph, colors)
    GC.canonicalize_directed_simple!(witness, workspace, graph, colors)
    full.old_to_canonical[1:(graph.num_vertices)] ==
    witness.old_to_canonical[1:(graph.num_vertices)] ||
        error("levelwise witness mismatch: $name")
    full.canonical_to_old[1:(graph.num_vertices)] ==
    witness.canonical_to_old[1:(graph.num_vertices)] ||
        error("levelwise inverse mismatch: $name")
    GC.canonical_automorphism_order(full) == GC.canonical_automorphism_order(witness) ||
        error("levelwise automorphism mismatch: $name")

    full_alloc = @allocated GC.canonicalize_directed_simple!(full, workspace, graph, colors)
    witness_alloc = @allocated GC.canonicalize_directed_simple!(
        witness, workspace, graph, colors
    )
    iszero(full_alloc) || error("levelwise full path allocated $full_alloc bytes: $name")
    iszero(witness_alloc) ||
        error("levelwise witness path allocated $witness_alloc bytes: $name")

    full_ns = minimum_ns(
        () -> GC.canonicalize_directed_simple!(full, workspace, graph, colors), repetitions
    )
    witness_ns = minimum_ns(
        () -> GC.canonicalize_directed_simple!(witness, workspace, graph, colors),
        repetitions,
    )
    println(
        "WITNESS|levelwise|",
        name,
        "|n=",
        graph.num_vertices,
        "|capacity=",
        capacity,
        "|full_ns=",
        full_ns,
        "|witness_ns=",
        witness_ns,
        "|full_over_witness=",
        round(full_ns / witness_ns; digits=3),
        "|full_alloc=",
        full_alloc,
        "|witness_alloc=",
        witness_alloc,
        "|full_image_bytes=",
        sizeof(full.canonical_multiplicities),
        "|witness_image_bytes=",
        sizeof(witness.canonical_multiplicities),
    )
    return nothing
end

function benchmark_recursive(
    name::String,
    graph::GC.DirectedGCGraph,
    colors::Vector{Int};
    capacity::Int=graph.num_vertices,
    repetitions::Int=50,
)::Nothing
    full = GC.DirectedCanonicalizationBuffer(capacity)
    witness = GC.DirectedCanonicalizationBuffer(capacity; materialize_canonical=false)
    workspace = WitnessRecursiveGC.PackedRecursiveStabilizerWorkspace(capacity)

    WitnessRecursiveGC.canonicalize_recursive_stabilizers!(full, workspace, graph, colors)
    WitnessRecursiveGC.canonicalize_recursive_stabilizers!(
        witness, workspace, graph, colors
    )
    full.old_to_canonical[1:(graph.num_vertices)] ==
    witness.old_to_canonical[1:(graph.num_vertices)] ||
        error("recursive witness mismatch: $name")
    full.canonical_to_old[1:(graph.num_vertices)] ==
    witness.canonical_to_old[1:(graph.num_vertices)] ||
        error("recursive inverse mismatch: $name")
    GC.canonical_automorphism_order(full) == GC.canonical_automorphism_order(witness) ||
        error("recursive automorphism mismatch: $name")

    full_alloc = @allocated WitnessRecursiveGC.canonicalize_recursive_stabilizers!(
        full, workspace, graph, colors
    )
    witness_alloc = @allocated WitnessRecursiveGC.canonicalize_recursive_stabilizers!(
        witness, workspace, graph, colors
    )
    iszero(full_alloc) || error("recursive full path allocated $full_alloc bytes: $name")
    iszero(witness_alloc) ||
        error("recursive witness path allocated $witness_alloc bytes: $name")

    full_ns = minimum_ns(
        () -> WitnessRecursiveGC.canonicalize_recursive_stabilizers!(
            full, workspace, graph, colors
        ),
        repetitions,
    )
    witness_ns = minimum_ns(
        () -> WitnessRecursiveGC.canonicalize_recursive_stabilizers!(
            witness, workspace, graph, colors
        ),
        repetitions,
    )
    println(
        "WITNESS|recursive|",
        name,
        "|n=",
        graph.num_vertices,
        "|capacity=",
        capacity,
        "|full_ns=",
        full_ns,
        "|witness_ns=",
        witness_ns,
        "|full_over_witness=",
        round(full_ns / witness_ns; digits=3),
        "|full_alloc=",
        full_alloc,
        "|witness_alloc=",
        witness_alloc,
        "|full_image_bytes=",
        sizeof(full.canonical_multiplicities),
        "|witness_image_bytes=",
        sizeof(witness.canonical_multiplicities),
    )
    return nothing
end

for (name, graph, colors, repetitions) in (
    ("asymmetric-24", witness_bench_graph(24), ones(Int, 24), 50),
    ("unique-41", witness_bench_graph(41), collect(1:41), 50),
    ("unique-64", witness_bench_graph(64), collect(1:64), 30),
    ("cycle-31", witness_bench_cycle(31), ones(Int, 31), 30),
    ("hypercube-5", witness_bench_hypercube(5), ones(Int, 32), 20),
)
    benchmark_levelwise(name, graph, colors; repetitions)
    benchmark_recursive(name, graph, colors; repetitions)
end

for capacity in (41, 64)
    graph = witness_bench_graph(41)
    colors = collect(1:41)
    benchmark_levelwise("unique-41-capacity", graph, colors; capacity, repetitions=50)
    benchmark_recursive("unique-41-capacity", graph, colors; capacity, repetitions=50)
end
