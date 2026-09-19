import GraphCombinations as GC

@inline relation_slot(relation::Int, source::Int, target::Int, n::Int)::Int =
    ((relation - 1) * n + source - 1) * n + target

function minimum_ns(f, repetitions::Int=50)::Int
    f()
    best = typemax(Int)
    for _ in 1:repetitions
        start = time_ns()
        f()
        best = min(best, Int(time_ns() - start))
    end
    return best
end

function canonical_colors(colors::Vector{Int}, buffer)::Vector{Int}
    return [colors[GC.original_vertex(buffer, rank)] for rank in 1:buffer.num_vertices]
end

function bucket_gadget(
    graph::GC.DirectedRelationGraph, vertex_colors::Vector{Int}
)::Tuple{GC.DirectedGCGraph,Vector{Int}}
    n = graph.num_vertices
    nr = graph.num_relations
    color_values = sort!(unique(copy(vertex_colors)))
    physical_colors = Int[searchsortedfirst(color_values, color) for color in vertex_colors]
    occupied = 0
    @inbounds for multiplicity in graph.multiplicities
        occupied += !iszero(multiplicity)
    end
    total = n + occupied
    multiplicities = zeros(Int, total * total)
    colors = Vector{Int}(undef, total)
    copyto!(colors, 1, physical_colors, 1, n)
    edge_vertex = n
    num_physical_colors = length(color_values)
    @inbounds for relation in 1:nr, source in 1:n, target in 1:n
        multiplicity = graph.multiplicities[relation_slot(relation, source, target, n)]
        iszero(multiplicity) && continue
        edge_vertex += 1
        colors[edge_vertex] = num_physical_colors + relation
        multiplicities[(source - 1) * total + edge_vertex] = multiplicity
        multiplicities[(edge_vertex - 1) * total + target] = multiplicity
    end
    return GC.DirectedGCGraph(total, multiplicities), colors
end

function instance_gadget(
    graph::GC.DirectedRelationGraph, vertex_colors::Vector{Int}
)::Tuple{GC.DirectedGCGraph,Vector{Int}}
    n = graph.num_vertices
    nr = graph.num_relations
    color_values = sort!(unique(copy(vertex_colors)))
    physical_colors = Int[searchsortedfirst(color_values, color) for color in vertex_colors]
    instances = sum(graph.multiplicities)
    total = n + instances
    multiplicities = zeros(Int, total * total)
    colors = Vector{Int}(undef, total)
    copyto!(colors, 1, physical_colors, 1, n)
    edge_vertex = n
    num_physical_colors = length(color_values)
    @inbounds for relation in 1:nr, source in 1:n, target in 1:n
        multiplicity = graph.multiplicities[relation_slot(relation, source, target, n)]
        for _ in 1:multiplicity
            edge_vertex += 1
            colors[edge_vertex] = num_physical_colors + relation
            multiplicities[(source - 1) * total + edge_vertex] = 1
            multiplicities[(edge_vertex - 1) * total + target] = 1
        end
    end
    return GC.DirectedGCGraph(total, multiplicities), colors
end

function edge_factor(graph::GC.DirectedRelationGraph)::Int
    value = 1
    @inbounds for multiplicity in graph.multiplicities
        value = Base.Checked.checked_mul(value, factorial(multiplicity))
    end
    return value
end

function benchmark_simple_fixture(
    name::String,
    graph::GC.DirectedRelationGraph,
    colors::Vector{Int},
    edges::Vector{NTuple{3,Int}},
)::Nothing
    n = graph.num_vertices
    nr = graph.num_relations
    bucket_graph, bucket_colors = bucket_gadget(graph, colors)
    instance_graph, instance_colors = instance_gadget(graph, colors)

    general_workspace = GC.DirectedRelationCanonicalizationWorkspace(n, nr)
    packed_workspace = GC.PackedDirectedRelationCanonicalizationWorkspace(n, nr)
    general = GC.DirectedRelationCanonicalizationBuffer(n, nr; materialize_canonical=false)
    packed = GC.DirectedRelationCanonicalizationBuffer(n, nr; materialize_canonical=false)

    bucket_workspace = GC.DirectedCanonicalizationWorkspace(bucket_graph.num_vertices)
    bucket_buffer = GC.DirectedCanonicalizationBuffer(
        bucket_graph.num_vertices; materialize_canonical=false
    )
    instance_workspace = GC.DirectedCanonicalizationWorkspace(instance_graph.num_vertices)
    instance_buffer = GC.DirectedCanonicalizationBuffer(
        instance_graph.num_vertices; materialize_canonical=false
    )

    GC.canonicalize_directed_relations!(general, general_workspace, graph, colors)
    GC.canonicalize_directed_relations!(packed, packed_workspace, graph, colors)
    GC.canonicalize_directed!(bucket_buffer, bucket_workspace, bucket_graph, bucket_colors)
    GC.canonicalize_directed!(
        instance_buffer, instance_workspace, instance_graph, instance_colors
    )

    GC.canonical_automorphism_order(general) == GC.canonical_automorphism_order(packed) ||
        error("native general/packed order mismatch")
    general.old_to_canonical[1:n] == packed.old_to_canonical[1:n] ||
        error("native general/packed witness mismatch")
    canonical_colors(colors, general) == canonical_colors(colors, packed) ||
        error("native general/packed canonical colors mismatch")
    GC.canonical_automorphism_order(bucket_buffer) ==
    GC.canonical_automorphism_order(packed) || error("bucket/native automorphism mismatch")
    GC.canonical_automorphism_order(instance_buffer) ==
    GC.canonical_automorphism_order(packed) * edge_factor(graph) ||
        error("instance-gadget factorial order mismatch")

    general_call =
        () -> GC.canonicalize_directed_relations!(general, general_workspace, graph, colors)
    packed_call =
        () -> GC.canonicalize_directed_relations!(packed, packed_workspace, graph, colors)
    bucket_call =
        () -> GC.canonicalize_directed!(
            bucket_buffer, bucket_workspace, bucket_graph, bucket_colors
        )
    instance_call =
        () -> GC.canonicalize_directed!(
            instance_buffer, instance_workspace, instance_graph, instance_colors
        )

    general_ns = minimum_ns(general_call)
    packed_ns = minimum_ns(packed_call)
    bucket_ns = minimum_ns(bucket_call)
    instance_ns = minimum_ns(instance_call)
    general_alloc = @allocated general_call()
    packed_alloc = @allocated packed_call()
    bucket_alloc = @allocated bucket_call()
    instance_alloc = @allocated instance_call()
    iszero(general_alloc) || error("prepared general native relation path allocated")
    iszero(packed_alloc) || error("prepared packed native relation path allocated")

    input = GC.DirectedRelationGraphBuffer(n, nr)
    input_colors = copy(colors)
    GC.load_directed_relations!(input, edges, n, nr)
    GC.canonicalize_directed_relations!(packed, packed_workspace, input, input_colors)
    load_call =
        () -> begin
            GC.load_directed_relations!(input, edges, n, nr)
            GC.canonicalize_directed_relations!(
                packed, packed_workspace, input, input_colors
            )
        end
    load_ns = minimum_ns(load_call)
    load_alloc = @allocated load_call()
    iszero(load_alloc) || error("native relation load+packed path allocated")

    println(
        "RELATION_PROD|",
        name,
        "|native_n=",
        n,
        "|relations=",
        nr,
        "|bucket_n=",
        bucket_graph.num_vertices,
        "|instance_n=",
        instance_graph.num_vertices,
        "|order=",
        GC.canonical_automorphism_order(packed),
        "|general_ns=",
        general_ns,
        "|packed_ns=",
        packed_ns,
        "|bucket_ns=",
        bucket_ns,
        "|instance_ns=",
        instance_ns,
        "|load_packed_ns=",
        load_ns,
        "|general_over_packed=",
        round(general_ns / packed_ns; digits=3),
        "|bucket_over_packed=",
        round(bucket_ns / packed_ns; digits=3),
        "|instance_over_packed=",
        round(instance_ns / packed_ns; digits=3),
        "|general_alloc=",
        general_alloc,
        "|packed_alloc=",
        packed_alloc,
        "|bucket_alloc=",
        bucket_alloc,
        "|instance_alloc=",
        instance_alloc,
        "|load_packed_alloc=",
        load_alloc,
    )
    return nothing
end

function benchmark_multigraph_fixture(
    name::String, graph::GC.DirectedRelationGraph, colors::Vector{Int}
)::Nothing
    n = graph.num_vertices
    nr = graph.num_relations
    bucket_graph, bucket_colors = bucket_gadget(graph, colors)
    instance_graph, instance_colors = instance_gadget(graph, colors)

    native_workspace = GC.DirectedRelationCanonicalizationWorkspace(n, nr)
    native = GC.DirectedRelationCanonicalizationBuffer(n, nr; materialize_canonical=false)
    bucket_workspace = GC.DirectedCanonicalizationWorkspace(bucket_graph.num_vertices)
    bucket_buffer = GC.DirectedCanonicalizationBuffer(
        bucket_graph.num_vertices; materialize_canonical=false
    )
    instance_workspace = GC.DirectedCanonicalizationWorkspace(instance_graph.num_vertices)
    instance_buffer = GC.DirectedCanonicalizationBuffer(
        instance_graph.num_vertices; materialize_canonical=false
    )

    native_call =
        () -> GC.canonicalize_directed_relations!(native, native_workspace, graph, colors)
    bucket_call =
        () -> GC.canonicalize_directed!(
            bucket_buffer, bucket_workspace, bucket_graph, bucket_colors
        )
    instance_call =
        () -> GC.canonicalize_directed!(
            instance_buffer, instance_workspace, instance_graph, instance_colors
        )
    native_call()
    bucket_call()
    instance_call()
    GC.canonical_automorphism_order(bucket_buffer) ==
    GC.canonical_automorphism_order(native) ||
        error("bucket/native multigraph automorphism mismatch")
    GC.canonical_automorphism_order(instance_buffer) ==
    GC.canonical_automorphism_order(native) * edge_factor(graph) ||
        error("instance-gadget multigraph factorial order mismatch")

    native_ns = minimum_ns(native_call)
    bucket_ns = minimum_ns(bucket_call)
    instance_ns = minimum_ns(instance_call)
    native_alloc = @allocated native_call()
    bucket_alloc = @allocated bucket_call()
    instance_alloc = @allocated instance_call()
    iszero(native_alloc) || error("prepared general native relation path allocated")

    println(
        "RELATION_PROD|",
        name,
        "|native_n=",
        n,
        "|relations=",
        nr,
        "|bucket_n=",
        bucket_graph.num_vertices,
        "|instance_n=",
        instance_graph.num_vertices,
        "|order=",
        GC.canonical_automorphism_order(native),
        "|native_ns=",
        native_ns,
        "|bucket_ns=",
        bucket_ns,
        "|instance_ns=",
        instance_ns,
        "|bucket_over_native=",
        round(bucket_ns / native_ns; digits=3),
        "|instance_over_native=",
        round(instance_ns / native_ns; digits=3),
        "|native_alloc=",
        native_alloc,
        "|bucket_alloc=",
        bucket_alloc,
        "|instance_alloc=",
        instance_alloc,
    )
    return nothing
end

circulant_edges = vcat(
    [(1, v, mod1(v + 1, 6)) for v in 1:6],
    [(2, v, mod1(v + 2, 6)) for v in 1:6],
    [(3, v, mod1(v + 3, 6)) for v in 1:6],
)
circulant = GC.DirectedRelationGraph(circulant_edges, 6, 3)
benchmark_simple_fixture(
    "three-relation-circulant", circulant, ones(Int, 6), circulant_edges
)

asymmetric_edges = [
    (1, 1, 2), (1, 2, 4), (1, 4, 3), (2, 1, 3), (2, 3, 5), (2, 5, 2), (3, 2, 5), (3, 4, 1)
]
asymmetric = GC.DirectedRelationGraph(asymmetric_edges, 5, 3)
benchmark_simple_fixture(
    "asymmetric-three-relation", asymmetric, ones(Int, 5), asymmetric_edges
)

parallel_edges = [
    (1, 1, 2),
    (1, 1, 2),
    (1, 2, 3),
    (2, 1, 3),
    (2, 3, 4),
    (2, 3, 4),
    (3, 4, 5),
    (3, 5, 1),
    (4, 2, 5),
    (4, 5, 2),
]
parallel = GC.DirectedRelationGraph(parallel_edges, 5, 4)
benchmark_multigraph_fixture("parallel-multirelation", parallel, ones(Int, 5))
