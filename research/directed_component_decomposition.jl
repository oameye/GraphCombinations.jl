import GraphCombinations as GC

const RecursiveGC = GC.DirectedRecursive

struct ResearchComponentCanonicalization
    canonical_to_global::Vector{Int}
    canonical_colors::Vector{Int}
    canonical_multiplicities::Vector{Int}
    automorphism_order::Int
end

struct ResearchDecomposedCanonicalization
    canonical_graph::GC.DirectedGCGraph
    old_to_canonical::Vector{Int}
    canonical_to_old::Vector{Int}
    canonical_colors::Vector{Int}
    automorphism_order::Int
end

@inline function _research_lexless(left::Vector{Int}, right::Vector{Int})::Bool
    common = min(length(left), length(right))
    @inbounds for index in 1:common
        left_value = left[index]
        right_value = right[index]
        left_value == right_value && continue
        return left_value < right_value
    end
    return length(left) < length(right)
end

function _research_component_less(
    left::ResearchComponentCanonicalization, right::ResearchComponentCanonicalization
)::Bool
    left_size = length(left.canonical_to_global)
    right_size = length(right.canonical_to_global)
    left_size == right_size || return left_size < right_size
    left.canonical_colors == right.canonical_colors ||
        return _research_lexless(left.canonical_colors, right.canonical_colors)
    left.canonical_multiplicities == right.canonical_multiplicities && return false
    return _research_lexless(left.canonical_multiplicities, right.canonical_multiplicities)
end

@inline function _research_same_component_type(
    left::ResearchComponentCanonicalization, right::ResearchComponentCanonicalization
)::Bool
    return length(left.canonical_to_global) == length(right.canonical_to_global) &&
           left.canonical_colors == right.canonical_colors &&
           left.canonical_multiplicities == right.canonical_multiplicities
end

function _research_checked_factorial(value::Int)::Int
    result = 1
    for factor in 2:value
        result = Base.Checked.checked_mul(result, factor)
    end
    return result
end

function _research_weak_components(graph::GC.DirectedGCGraph)::Vector{Vector{Int}}
    n = graph.num_vertices
    seen = falses(n)
    stack = Vector{Int}(undef, n)
    components = Vector{Vector{Int}}()

    for seed in 1:n
        seen[seed] && continue
        component = Int[]
        stack_size = 1
        stack[1] = seed
        seen[seed] = true

        while stack_size > 0
            vertex = stack[stack_size]
            stack_size -= 1
            push!(component, vertex)
            @inbounds for other in 1:n
                seen[other] && continue
                forward = graph.multiplicities[(vertex - 1) * n + other]
                backward = graph.multiplicities[(other - 1) * n + vertex]
                iszero(forward) && iszero(backward) && continue
                seen[other] = true
                stack_size += 1
                stack[stack_size] = other
            end
        end
        sort!(component)
        push!(components, component)
    end
    return components
end

function _research_extract_component(
    graph::GC.DirectedGCGraph, colors::Vector{Int}, vertices::Vector{Int}
)::Tuple{GC.DirectedGCGraph,Vector{Int}}
    n = graph.num_vertices
    k = length(vertices)
    multiplicities = zeros(Int, k * k)
    component_colors = Vector{Int}(undef, k)
    @inbounds for local_source in 1:k
        global_source = vertices[local_source]
        component_colors[local_source] = colors[global_source]
        for local_target in 1:k
            global_target = vertices[local_target]
            multiplicities[(local_source - 1) * k + local_target] = graph.multiplicities[(global_source - 1) * n + global_target]
        end
    end
    return GC.DirectedGCGraph(k, multiplicities), component_colors
end

function _research_canonicalize_component(
    graph::GC.DirectedGCGraph, colors::Vector{Int}, vertices::Vector{Int}
)::ResearchComponentCanonicalization
    component_graph, component_colors = _research_extract_component(graph, colors, vertices)
    result = GC.canonicalize_directed(component_graph, component_colors)
    mapping = GC.vertex_mapping(GC.canonical_relabeling(result))
    k = length(vertices)
    canonical_to_global = Vector{Int}(undef, k)
    canonical_colors = Vector{Int}(undef, k)
    @inbounds for local_vertex in 1:k
        canonical_vertex = mapping[local_vertex]
        canonical_to_global[canonical_vertex] = vertices[local_vertex]
        canonical_colors[canonical_vertex] = component_colors[local_vertex]
    end
    canonical = GC.canonical_graph(result)
    return ResearchComponentCanonicalization(
        canonical_to_global,
        canonical_colors,
        copy(canonical.multiplicities),
        GC.canonical_automorphism_order(result),
    )
end

function research_component_canonicalize(
    graph::GC.DirectedGCGraph, colors::Vector{Int}
)::ResearchDecomposedCanonicalization
    n = graph.num_vertices
    length(colors) == n || error("colors must cover every vertex")
    components = ResearchComponentCanonicalization[]
    for vertices in _research_weak_components(graph)
        push!(components, _research_canonicalize_component(graph, colors, vertices))
    end
    sort!(components; lt=_research_component_less)

    old_to_canonical = Vector{Int}(undef, n)
    canonical_to_old = Vector{Int}(undef, n)
    canonical_colors = Vector{Int}(undef, n)
    canonical_multiplicities = zeros(Int, n * n)
    automorphism_order = 1
    offset = 0

    for component in components
        k = length(component.canonical_to_global)
        automorphism_order = Base.Checked.checked_mul(
            automorphism_order, component.automorphism_order
        )
        @inbounds for local_vertex in 1:k
            canonical_vertex = offset + local_vertex
            global_vertex = component.canonical_to_global[local_vertex]
            old_to_canonical[global_vertex] = canonical_vertex
            canonical_to_old[canonical_vertex] = global_vertex
            canonical_colors[canonical_vertex] = component.canonical_colors[local_vertex]
        end
        @inbounds for local_source in 1:k, local_target in 1:k
            global_source = offset + local_source
            global_target = offset + local_target
            canonical_multiplicities[(global_source - 1) * n + global_target] = component.canonical_multiplicities[(local_source - 1) * k + local_target]
        end
        offset += k
    end

    first_index = 1
    while first_index <= length(components)
        last_index = first_index
        while last_index < length(components) && _research_same_component_type(
            components[first_index], components[last_index + 1]
        )
            last_index += 1
        end
        multiplicity = last_index - first_index + 1
        automorphism_order = Base.Checked.checked_mul(
            automorphism_order, _research_checked_factorial(multiplicity)
        )
        first_index = last_index + 1
    end

    return ResearchDecomposedCanonicalization(
        GC.DirectedGCGraph(n, canonical_multiplicities),
        old_to_canonical,
        canonical_to_old,
        canonical_colors,
        automorphism_order,
    )
end

function _research_relabel_colors(colors::Vector{Int}, mapping::Vector{Int})::Vector{Int}
    result = similar(colors)
    @inbounds for old_vertex in eachindex(colors)
        result[mapping[old_vertex]] = colors[old_vertex]
    end
    return result
end

function _research_validate_result(
    graph::GC.DirectedGCGraph,
    colors::Vector{Int},
    result::ResearchDecomposedCanonicalization,
)::Nothing
    n = graph.num_vertices
    sort(result.old_to_canonical) == collect(1:n) ||
        error("old-to-canonical is not a permutation")
    sort(result.canonical_to_old) == collect(1:n) ||
        error("canonical-to-old is not a permutation")
    @inbounds for old_vertex in 1:n
        canonical_vertex = result.old_to_canonical[old_vertex]
        result.canonical_to_old[canonical_vertex] == old_vertex ||
            error("witness orientations are inconsistent")
    end
    relabeled = GC._relabel_directed_graph(graph, result.old_to_canonical)
    relabeled == result.canonical_graph ||
        error("global witness does not reconstruct image")
    mapped_colors = similar(colors)
    @inbounds for old_vertex in 1:n
        mapped_colors[result.old_to_canonical[old_vertex]] = colors[old_vertex]
    end
    mapped_colors == result.canonical_colors ||
        error("global witness does not reconstruct colors")
    monolithic = GC.canonicalize_directed(graph, colors)
    GC.canonical_automorphism_order(monolithic) == result.automorphism_order ||
        error("component automorphism order disagrees with monolithic oracle")
    return nothing
end

function _research_exhaustive_small()::Int
    n = 3
    colorings = (ones(Int, n), Int[1, 1, 2], Int[1, 2, 1], Int[1, 2, 3])
    checked = 0
    for mask in 0:((1 << (n * n)) - 1)
        multiplicities = zeros(Int, n * n)
        @inbounds for slot in 1:(n * n)
            multiplicities[slot] = (mask >> (slot - 1)) & 1
        end
        graph = GC.DirectedGCGraph(n, multiplicities)
        for colors in colorings
            result = research_component_canonicalize(graph, colors)
            _research_validate_result(graph, colors, result)
            reverse_mapping = collect(n:-1:1)
            relabeled_graph = GC._relabel_directed_graph(graph, reverse_mapping)
            relabeled_colors = _research_relabel_colors(colors, reverse_mapping)
            relabeled_result = research_component_canonicalize(
                relabeled_graph, relabeled_colors
            )
            result.canonical_graph == relabeled_result.canonical_graph ||
                error("component image changed under relabeling")
            result.canonical_colors == relabeled_result.canonical_colors ||
                error("component colors changed under relabeling")
            result.automorphism_order == relabeled_result.automorphism_order ||
                error("component order changed under relabeling")
            checked += 1
        end
    end
    return checked
end

function _research_repeated_directed_cycles(count::Int, size::Int)
    n = count * size
    multiplicities = zeros(Int, n * n)
    for component in 0:(count - 1)
        offset = component * size
        for local_vertex in 1:size
            source = offset + local_vertex
            target = offset + mod1(local_vertex + 1, size)
            multiplicities[(source - 1) * n + target] = 1
        end
    end
    return GC.DirectedGCGraph(n, multiplicities), ones(Int, n)
end

function _research_mixed_fixture()
    cycle_a, _ = _research_repeated_directed_cycles(1, 3)
    cycle_b, _ = _research_repeated_directed_cycles(1, 4)
    n = 10
    multiplicities = zeros(Int, n * n)
    for source in 1:3, target in 1:3
        multiplicities[(source - 1) * n + target] = cycle_a.multiplicities[(source - 1) * 3 + target]
    end
    for source in 1:4, target in 1:4
        multiplicities[((source + 3) - 1) * n + (target + 3)] = cycle_b.multiplicities[(source - 1) * 4 + target]
    end
    multiplicities[(8 - 1) * n + 8] = 2
    colors = Int[1, 1, 1, 1, 1, 1, 1, 2, 3, 3]
    return GC.DirectedGCGraph(n, multiplicities), colors
end

function _research_minimum_ns(f, repetitions::Int)::Int
    best = typemax(Int)
    for _ in 1:repetitions
        start = time_ns()
        f()
        best = min(best, Int(time_ns() - start))
    end
    return best
end

function _research_prepared_component_graphs(
    graph::GC.DirectedGCGraph, colors::Vector{Int}
)::Tuple{Vector{GC.DirectedGCGraph},Vector{Vector{Int}}}
    graphs = GC.DirectedGCGraph[]
    component_colors = Vector{Int}[]
    for vertices in _research_weak_components(graph)
        local_graph, local_colors = _research_extract_component(graph, colors, vertices)
        push!(graphs, local_graph)
        push!(component_colors, local_colors)
    end
    return graphs, component_colors
end

function _research_benchmark_repeated_cycles(count::Int, size::Int)::Nothing
    graph, colors = _research_repeated_directed_cycles(count, size)
    n = graph.num_vertices
    result = research_component_canonicalize(graph, colors)
    expected_order = Base.Checked.checked_mul(
        size^count, _research_checked_factorial(count)
    )
    result.automorphism_order == expected_order ||
        error("known repeated-cycle order mismatch")
    _research_validate_result(graph, colors, result)

    levelwise_workspace = GC.DirectedSimpleCanonicalizationWorkspace(
        n; frontier_capacity=max(4096, 16 * n^2)
    )
    levelwise_buffer = GC.DirectedCanonicalizationBuffer(n; materialize_canonical=false)
    GC.canonicalize_directed_simple!(levelwise_buffer, levelwise_workspace, graph, colors)

    recursive_workspace = RecursiveGC.PackedRecursiveStabilizerWorkspace(n)
    recursive_buffer = GC.DirectedCanonicalizationBuffer(n; materialize_canonical=false)
    RecursiveGC.canonicalize_recursive_stabilizers!(
        recursive_buffer, recursive_workspace, graph, colors
    )

    local_graphs, local_colors = _research_prepared_component_graphs(graph, colors)
    local_capacity = maximum(local_graph.num_vertices for local_graph in local_graphs)
    local_workspace = RecursiveGC.PackedRecursiveStabilizerWorkspace(local_capacity)
    local_buffer = GC.DirectedCanonicalizationBuffer(
        local_capacity; materialize_canonical=false
    )
    for index in eachindex(local_graphs)
        RecursiveGC.canonicalize_recursive_stabilizers!(
            local_buffer, local_workspace, local_graphs[index], local_colors[index]
        )
    end

    repetitions = 30
    levelwise_ns = _research_minimum_ns(
        () -> GC.canonicalize_directed_simple!(
            levelwise_buffer, levelwise_workspace, graph, colors
        ),
        repetitions,
    )
    recursive_ns = _research_minimum_ns(
        () -> RecursiveGC.canonicalize_recursive_stabilizers!(
            recursive_buffer, recursive_workspace, graph, colors
        ),
        repetitions,
    )
    components_ns = _research_minimum_ns(
        () -> begin
            for index in eachindex(local_graphs)
                RecursiveGC.canonicalize_recursive_stabilizers!(
                    local_buffer,
                    local_workspace,
                    local_graphs[index],
                    local_colors[index],
                )
            end
        end,
        repetitions,
    )

    println(
        "COMPONENT_BENCH|c",
        size,
        "x",
        count,
        "|n=",
        n,
        "|components=",
        count,
        "|order=",
        result.automorphism_order,
        "|levelwise_ns=",
        levelwise_ns,
        "|recursive_ns=",
        recursive_ns,
        "|prepared_components_ns=",
        components_ns,
        "|levelwise_over_components=",
        round(levelwise_ns / components_ns; digits=3),
        "|recursive_over_components=",
        round(recursive_ns / components_ns; digits=3),
    )
    return nothing
end

checked = _research_exhaustive_small()
println("COMPONENT_CERT|exhaustive_n3=", checked)

mixed_graph, mixed_colors = _research_mixed_fixture()
mixed_result = research_component_canonicalize(mixed_graph, mixed_colors)
_research_validate_result(mixed_graph, mixed_colors, mixed_result)
println(
    "COMPONENT_CERT|mixed_n=",
    mixed_graph.num_vertices,
    "|components=",
    length(_research_weak_components(mixed_graph)),
    "|order=",
    mixed_result.automorphism_order,
)

_research_benchmark_repeated_cycles(4, 7)
_research_benchmark_repeated_cycles(8, 7)
