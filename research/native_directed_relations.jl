import GraphCombinations as GC

# Independent research model for finite colored directed relational structures.
# Relation labels are fixed coordinates; only vertices are relabeled.
struct ResearchDirectedRelationGraph
    num_vertices::Int
    num_relations::Int
    multiplicities::Vector{Int}
end

@inline function relation_slot(
    relation::Int, source::Int, target::Int, n::Int
)::Int
    return ((relation - 1) * n + source - 1) * n + target
end

function ResearchDirectedRelationGraph(
    num_vertices::Integer,
    num_relations::Integer,
    edges::AbstractVector{<:Tuple{<:Integer,<:Integer,<:Integer}},
)::ResearchDirectedRelationGraph
    n = Int(num_vertices)
    nr = Int(num_relations)
    n >= 0 || throw(ArgumentError("num_vertices must be non-negative"))
    nr >= 0 || throw(ArgumentError("num_relations must be non-negative"))
    multiplicities = zeros(Int, nr * n * n)
    @inbounds for edge in edges
        relation = Int(edge[1])
        source = Int(edge[2])
        target = Int(edge[3])
        1 <= relation <= nr || throw(ArgumentError("relation outside 1:num_relations"))
        1 <= source <= n || throw(ArgumentError("source outside 1:num_vertices"))
        1 <= target <= n || throw(ArgumentError("target outside 1:num_vertices"))
        multiplicities[relation_slot(relation, source, target, n)] += 1
    end
    return ResearchDirectedRelationGraph(n, nr, multiplicities)
end

@inline function relation_multiplicity(
    graph::ResearchDirectedRelationGraph, relation::Int, source::Int, target::Int
)::Int
    return graph.multiplicities[
        relation_slot(relation, source, target, graph.num_vertices)
    ]
end

function initial_color_ranks(vertex_colors::Vector{Int})::Vector{Int}
    isempty(vertex_colors) && return Int[]
    values = sort!(unique(copy(vertex_colors)))
    return Int[searchsortedfirst(values, color) for color in vertex_colors]
end

@inline function signature_less(left::Vector{Int}, right::Vector{Int})::Bool
    @inbounds for index in eachindex(left, right)
        left[index] == right[index] && continue
        return left[index] < right[index]
    end
    return false
end

function relation_refine_once(
    graph::ResearchDirectedRelationGraph, colors::Vector{Int}
)::Vector{Int}
    n = graph.num_vertices
    nr = graph.num_relations
    num_colors = isempty(colors) ? 0 : maximum(colors)
    signature_length = 1 + 2 * nr * num_colors
    signatures = [zeros(Int, signature_length) for _ in 1:n]

    @inbounds for vertex in 1:n
        signature = signatures[vertex]
        signature[1] = colors[vertex]
        for relation in 1:nr, other in 1:n
            cell = colors[other]
            base = 2 + 2 * ((relation - 1) * num_colors + cell - 1)
            signature[base] += relation_multiplicity(graph, relation, vertex, other)
            signature[base + 1] += relation_multiplicity(graph, relation, other, vertex)
        end
    end

    order = collect(1:n)
    sort!(order; lt=(left, right) -> signature_less(signatures[left], signatures[right]))
    refined = similar(colors)
    next_color = 0
    previous = 0
    @inbounds for vertex in order
        if iszero(previous) || signatures[vertex] != signatures[previous]
            next_color += 1
        end
        refined[vertex] = next_color
        previous = vertex
    end
    return refined
end

function relation_refined_colors(
    graph::ResearchDirectedRelationGraph, vertex_colors::Vector{Int}
)::Vector{Int}
    colors = initial_color_ranks(vertex_colors)
    while true
        refined = relation_refine_once(graph, colors)
        refined == colors && return colors
        colors = refined
    end
end

function relation_cells(colors::Vector{Int})::Vector{Vector{Int}}
    num_colors = isempty(colors) ? 0 : maximum(colors)
    cells = [Int[] for _ in 1:num_colors]
    @inbounds for vertex in eachindex(colors)
        push!(cells[colors[vertex]], vertex)
    end
    return cells
end

function relation_target_cell(cells::Vector{Vector{Int}})::Int
    target = 0
    target_size = 1
    @inbounds for cell in eachindex(cells)
        size = length(cells[cell])
        if size > target_size
            target = cell
            target_size = size
        end
    end
    return target
end

function relation_individualize(
    colors::Vector{Int}, target_color::Int, chosen_vertex::Int
)::Vector{Int}
    result = similar(colors)
    @inbounds for vertex in eachindex(colors)
        color = colors[vertex]
        result[vertex] = if color < target_color
            color
        elseif color > target_color
            color + 1
        elseif vertex == chosen_vertex
            target_color
        else
            target_color + 1
        end
    end
    return result
end

mutable struct RelationSearchState
    graph::ResearchDirectedRelationGraph
    inverse::Vector{Int}
    best_inverse::Vector{Int}
    automorphism_order::Int
    has_best::Bool
    nodes::Int
    leaves::Int
end

function compare_relation_inverse(
    graph::ResearchDirectedRelationGraph,
    candidate::Vector{Int},
    best::Vector{Int},
)::Int
    n = graph.num_vertices
    @inbounds for relation in 1:(graph.num_relations)
        for canonical_source in 1:n
            candidate_source = candidate[canonical_source]
            best_source = best[canonical_source]
            for canonical_target in 1:n
                candidate_value = relation_multiplicity(
                    graph, relation, candidate_source, candidate[canonical_target]
                )
                best_value = relation_multiplicity(
                    graph, relation, best_source, best[canonical_target]
                )
                candidate_value == best_value && continue
                return candidate_value < best_value ? -1 : 1
            end
        end
    end
    return 0
end

function record_relation_leaf!(state::RelationSearchState)::Nothing
    state.leaves += 1
    if !state.has_best
        copyto!(state.best_inverse, state.inverse)
        state.automorphism_order = 1
        state.has_best = true
        return nothing
    end
    comparison = compare_relation_inverse(state.graph, state.inverse, state.best_inverse)
    if comparison < 0
        copyto!(state.best_inverse, state.inverse)
        state.automorphism_order = 1
    elseif iszero(comparison)
        state.automorphism_order = Base.Checked.checked_add(state.automorphism_order, 1)
    end
    return nothing
end

function search_relations!(state::RelationSearchState, colors::Vector{Int})::Nothing
    state.nodes += 1
    refined = relation_refined_colors(state.graph, colors)
    cells = relation_cells(refined)
    target = relation_target_cell(cells)
    if iszero(target)
        @inbounds for canonical_vertex in eachindex(cells)
            state.inverse[canonical_vertex] = only(cells[canonical_vertex])
        end
        record_relation_leaf!(state)
        return nothing
    end
    @inbounds for chosen_vertex in cells[target]
        search_relations!(
            state, relation_individualize(refined, target, chosen_vertex)
        )
    end
    return nothing
end

struct ResearchRelationResult
    old_to_canonical::Vector{Int}
    canonical_to_old::Vector{Int}
    canonical_colors::Vector{Int}
    canonical_multiplicities::Vector{Int}
    automorphism_order::Int
    nodes::Int
    leaves::Int
end

function canonicalize_relations(
    graph::ResearchDirectedRelationGraph, vertex_colors::AbstractVector{<:Integer}
)::ResearchRelationResult
    n = graph.num_vertices
    length(vertex_colors) == n || throw(ArgumentError("wrong vertex color count"))
    colors = collect(Int, vertex_colors)
    inverse = Vector{Int}(undef, n)
    best_inverse = similar(inverse)
    state = RelationSearchState(graph, inverse, best_inverse, 0, false, 0, 0)
    search_relations!(state, colors)
    state.has_best || error("relation search produced no candidate")

    old_to_canonical = Vector{Int}(undef, n)
    @inbounds for canonical_vertex in 1:n
        old_to_canonical[state.best_inverse[canonical_vertex]] = canonical_vertex
    end
    canonical_colors = [colors[state.best_inverse[index]] for index in 1:n]
    canonical_multiplicities = Vector{Int}(undef, length(graph.multiplicities))
    cursor = 1
    @inbounds for relation in 1:(graph.num_relations), canonical_source in 1:n,
        canonical_target in 1:n
        canonical_multiplicities[cursor] = relation_multiplicity(
            graph,
            relation,
            state.best_inverse[canonical_source],
            state.best_inverse[canonical_target],
        )
        cursor += 1
    end
    return ResearchRelationResult(
        old_to_canonical,
        copy(state.best_inverse),
        canonical_colors,
        canonical_multiplicities,
        state.automorphism_order,
        state.nodes,
        state.leaves,
    )
end

function relabel_relation_graph(
    graph::ResearchDirectedRelationGraph,
    colors::Vector{Int},
    old_to_new::Vector{Int},
)::Tuple{ResearchDirectedRelationGraph,Vector{Int}}
    n = graph.num_vertices
    nr = graph.num_relations
    multiplicities = zeros(Int, length(graph.multiplicities))
    relabeled_colors = similar(colors)
    @inbounds for old_vertex in 1:n
        relabeled_colors[old_to_new[old_vertex]] = colors[old_vertex]
    end
    @inbounds for relation in 1:nr, old_source in 1:n, old_target in 1:n
        new_source = old_to_new[old_source]
        new_target = old_to_new[old_target]
        multiplicities[relation_slot(relation, new_source, new_target, n)] =
            relation_multiplicity(graph, relation, old_source, old_target)
    end
    return ResearchDirectedRelationGraph(n, nr, multiplicities), relabeled_colors
end

function all_permutations(n::Int)::Vector{Vector{Int}}
    result = Vector{Vector{Int}}()
    current = Vector{Int}(undef, n)
    used = falses(n)
    function visit(depth::Int)
        if depth > n
            push!(result, copy(current))
            return
        end
        for value in 1:n
            used[value] && continue
            used[value] = true
            current[depth] = value
            visit(depth + 1)
            used[value] = false
        end
    end
    visit(1)
    return result
end

function relation_is_automorphism(
    graph::ResearchDirectedRelationGraph,
    colors::Vector{Int},
    old_to_new::Vector{Int},
)::Bool
    n = graph.num_vertices
    @inbounds for vertex in 1:n
        colors[vertex] == colors[old_to_new[vertex]] || return false
    end
    @inbounds for relation in 1:(graph.num_relations), source in 1:n, target in 1:n
        relation_multiplicity(graph, relation, source, target) ==
            relation_multiplicity(
                graph, relation, old_to_new[source], old_to_new[target]
            ) || return false
    end
    return true
end

function brute_relation_automorphism_order(
    graph::ResearchDirectedRelationGraph, colors::Vector{Int}
)::Int
    return count(
        permutation -> relation_is_automorphism(graph, colors, permutation),
        all_permutations(graph.num_vertices),
    )
end

struct BucketGadget
    graph::GC.DirectedGCGraph
    colors::Vector{Int}
    bucket_vertex::Vector{Int}
end

function bucket_gadget(
    graph::ResearchDirectedRelationGraph, vertex_colors::Vector{Int}
)::BucketGadget
    n = graph.num_vertices
    nr = graph.num_relations
    color_values = sort!(unique(copy(vertex_colors)))
    physical_colors = Int[searchsortedfirst(color_values, color) for color in vertex_colors]
    bucket_vertex = zeros(Int, nr * n * n)
    bucket_count = 0
    @inbounds for relation in 1:nr, source in 1:n, target in 1:n
        multiplicity = relation_multiplicity(graph, relation, source, target)
        iszero(multiplicity) && continue
        bucket_count += 1
        bucket_vertex[relation_slot(relation, source, target, n)] = n + bucket_count
    end

    total_vertices = n + bucket_count
    multiplicities = zeros(Int, total_vertices * total_vertices)
    colors = Vector{Int}(undef, total_vertices)
    copyto!(colors, 1, physical_colors, 1, n)
    num_physical_colors = length(color_values)

    @inbounds for relation in 1:nr, source in 1:n, target in 1:n
        slot = relation_slot(relation, source, target, n)
        edge_vertex = bucket_vertex[slot]
        iszero(edge_vertex) && continue
        multiplicity = graph.multiplicities[slot]
        colors[edge_vertex] = num_physical_colors + relation
        multiplicities[(source - 1) * total_vertices + edge_vertex] = multiplicity
        multiplicities[(edge_vertex - 1) * total_vertices + target] = multiplicity
    end
    return BucketGadget(
        GC.DirectedGCGraph(total_vertices, multiplicities), colors, bucket_vertex
    )
end

function edge_instance_gadget(
    graph::ResearchDirectedRelationGraph, vertex_colors::Vector{Int}
)::Tuple{GC.DirectedGCGraph,Vector{Int}}
    n = graph.num_vertices
    nr = graph.num_relations
    color_values = sort!(unique(copy(vertex_colors)))
    physical_colors = Int[searchsortedfirst(color_values, color) for color in vertex_colors]
    edge_instances = sum(graph.multiplicities)
    total_vertices = n + edge_instances
    multiplicities = zeros(Int, total_vertices * total_vertices)
    colors = Vector{Int}(undef, total_vertices)
    copyto!(colors, 1, physical_colors, 1, n)
    num_physical_colors = length(color_values)
    edge_vertex = n
    @inbounds for relation in 1:nr, source in 1:n, target in 1:n
        multiplicity = relation_multiplicity(graph, relation, source, target)
        for _ in 1:multiplicity
            edge_vertex += 1
            colors[edge_vertex] = num_physical_colors + relation
            multiplicities[(source - 1) * total_vertices + edge_vertex] = 1
            multiplicities[(edge_vertex - 1) * total_vertices + target] = 1
        end
    end
    return GC.DirectedGCGraph(total_vertices, multiplicities), colors
end

function bucket_extension_is_automorphism(
    graph::ResearchDirectedRelationGraph,
    colors::Vector{Int},
    old_to_new::Vector{Int},
)::Bool
    gadget = bucket_gadget(graph, colors)
    n = graph.num_vertices
    total = gadget.graph.num_vertices
    mapping = zeros(Int, total)
    @inbounds for vertex in 1:n
        mapping[vertex] = old_to_new[vertex]
    end
    @inbounds for relation in 1:(graph.num_relations), source in 1:n, target in 1:n
        slot = relation_slot(relation, source, target, n)
        old_bucket = gadget.bucket_vertex[slot]
        iszero(old_bucket) && continue
        mapped_slot = relation_slot(
            relation, old_to_new[source], old_to_new[target], n
        )
        new_bucket = gadget.bucket_vertex[mapped_slot]
        iszero(new_bucket) && return false
        mapping[old_bucket] = new_bucket
    end
    sort(mapping) == collect(1:total) || return false
    @inbounds for old_vertex in 1:total
        gadget.colors[old_vertex] == gadget.colors[mapping[old_vertex]] || return false
    end
    @inbounds for source in 1:total, target in 1:total
        old_value = gadget.graph.multiplicities[(source - 1) * total + target]
        new_value = gadget.graph.multiplicities[
            (mapping[source] - 1) * total + mapping[target]
        ]
        old_value == new_value || return false
    end
    return true
end

function certify_relation_graph(
    graph::ResearchDirectedRelationGraph, colors::Vector{Int}; check_gadget::Bool=true
)::Nothing
    result = canonicalize_relations(graph, colors)
    brute_order = brute_relation_automorphism_order(graph, colors)
    result.automorphism_order == brute_order || error("native automorphism mismatch")

    if check_gadget
        gadget = bucket_gadget(graph, colors)
        gadget_result = GC.canonicalize_directed(gadget.graph, gadget.colors)
        GC.canonical_automorphism_order(gadget_result) == brute_order ||
            error("bucket gadget automorphism mismatch")
    end

    @inbounds for permutation in all_permutations(graph.num_vertices)
        relabeled, relabeled_colors = relabel_relation_graph(graph, colors, permutation)
        relabeled_result = canonicalize_relations(relabeled, relabeled_colors)
        relabeled_result.canonical_colors == result.canonical_colors ||
            error("canonical color metamorphic mismatch")
        relabeled_result.canonical_multiplicities == result.canonical_multiplicities ||
            error("canonical relation image metamorphic mismatch")
        relabeled_result.automorphism_order == result.automorphism_order ||
            error("automorphism metamorphic mismatch")

        native_automorphism = relation_is_automorphism(graph, colors, permutation)
        gadget_automorphism = bucket_extension_is_automorphism(graph, colors, permutation)
        native_automorphism == gadget_automorphism ||
            error("native/gadget automorphism-set mismatch")
    end
    return nothing
end

function graph_from_radix(n::Int, nr::Int, radix::Int, code::Int)
    multiplicities = zeros(Int, nr * n * n)
    value = code
    @inbounds for slot in eachindex(multiplicities)
        multiplicities[slot] = value % radix
        value ÷= radix
    end
    return ResearchDirectedRelationGraph(n, nr, multiplicities)
end

simple_n2_cases = 0
for code in 0:(2^(2 * 2 * 2) - 1), colors in (Int[1, 1], Int[1, 2])
    certify_relation_graph(graph_from_radix(2, 2, 2, code), colors)
    global simple_n2_cases += 1
end
println("RELATION_CERT|simple_n2_r2=", simple_n2_cases)

multiplicity_n2_cases = 0
for code in 0:(3^(2 * 2) - 1), colors in (Int[1, 1], Int[1, 2])
    certify_relation_graph(graph_from_radix(2, 1, 3, code), colors)
    global multiplicity_n2_cases += 1
end
println("RELATION_CERT|multiplicity_n2_r1=", multiplicity_n2_cases)

simple_n3_cases = 0
for code in 0:(2^(3 * 3) - 1), colors in (Int[1, 1, 1], Int[1, 1, 2], Int[1, 2, 3])
    certify_relation_graph(graph_from_radix(3, 1, 2, code), colors; check_gadget=false)
    global simple_n3_cases += 1
end
println("RELATION_CERT|simple_n3_r1=", simple_n3_cases)

# Structured multirelation/multiplicity fixtures with the exact bucket-gadget oracle enabled.
structured = [
    ResearchDirectedRelationGraph(
        3,
        2,
        [(1, 1, 2), (1, 1, 2), (2, 2, 3), (2, 3, 1), (1, 3, 3)],
    ),
    ResearchDirectedRelationGraph(
        3,
        3,
        [
            (1, 1, 2),
            (1, 2, 3),
            (1, 3, 1),
            (2, 1, 3),
            (2, 2, 1),
            (2, 3, 2),
            (3, 1, 1),
            (3, 2, 2),
        ],
    ),
]
for graph in structured, colors in (Int[1, 1, 1], Int[1, 1, 2])
    certify_relation_graph(graph, colors)
end
println("RELATION_CERT|structured=", length(structured) * 2)

function minimum_ns(f, repetitions::Int)::Int
    best = typemax(Int)
    for _ in 1:repetitions
        start = time_ns()
        f()
        best = min(best, Int(time_ns() - start))
    end
    return best
end

function benchmark_relation_fixture(
    name::String, graph::ResearchDirectedRelationGraph, colors::Vector{Int}
)::Nothing
    bucket = bucket_gadget(graph, colors)
    instance_graph, instance_colors = edge_instance_gadget(graph, colors)

    native_result = canonicalize_relations(graph, colors)
    bucket_result = GC.canonicalize_directed(bucket.graph, bucket.colors)
    instance_result = GC.canonicalize_directed(instance_graph, instance_colors)
    native_result.automorphism_order == GC.canonical_automorphism_order(bucket_result) ||
        error("benchmark bucket order mismatch")

    native_ns = minimum_ns(() -> canonicalize_relations(graph, colors), 20)
    bucket_ns = minimum_ns(
        () -> GC.canonicalize_directed(bucket.graph, bucket.colors), 20
    )
    instance_ns = minimum_ns(
        () -> GC.canonicalize_directed(instance_graph, instance_colors), 20
    )
    instance_order = GC.canonical_automorphism_order(instance_result)
    edge_factor = 1
    @inbounds for multiplicity in graph.multiplicities
        edge_factor = Base.Checked.checked_mul(edge_factor, factorial(multiplicity))
    end
    instance_order == native_result.automorphism_order * edge_factor ||
        error("edge-instance gadget factorial relation failed")

    println(
        "RELATION_BENCH|",
        name,
        "|native_n=",
        graph.num_vertices,
        "|relations=",
        graph.num_relations,
        "|bucket_n=",
        bucket.graph.num_vertices,
        "|instance_n=",
        instance_graph.num_vertices,
        "|native_order=",
        native_result.automorphism_order,
        "|instance_order=",
        instance_order,
        "|native_nodes=",
        native_result.nodes,
        "|native_leaves=",
        native_result.leaves,
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
    )
    return nothing
end

benchmark_relation_fixture(
    "three-relation-circulant",
    ResearchDirectedRelationGraph(
        6,
        3,
        vcat(
            [(1, v, mod1(v + 1, 6)) for v in 1:6],
            [(2, v, mod1(v + 2, 6)) for v in 1:6],
            [(3, v, mod1(v + 3, 6)) for v in 1:6],
        ),
    ),
    ones(Int, 6),
)

benchmark_relation_fixture(
    "parallel-multirelation",
    ResearchDirectedRelationGraph(
        5,
        4,
        [
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
        ],
    ),
    Int[1, 1, 1, 1, 1],
)
