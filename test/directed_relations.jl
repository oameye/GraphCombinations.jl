function _relation_test_slot(relation::Int, source::Int, target::Int, n::Int)::Int
    return ((relation - 1) * n + source - 1) * n + target
end

function _relation_test_graph_from_code(n::Int, nr::Int, radix::Int, code::Int)
    multiplicities = zeros(Int, nr * n * n)
    value = code
    @inbounds for slot in eachindex(multiplicities)
        multiplicities[slot] = value % radix
        value ÷= radix
    end
    return DirectedRelationGraph(n, nr, multiplicities)
end

function _relation_test_relabel(
    graph::DirectedRelationGraph, colors::Vector{Int}, old_to_new::Vector{Int}
)
    n = graph.num_vertices
    nr = graph.num_relations
    multiplicities = zeros(Int, nr * n * n)
    relabeled_colors = similar(colors)
    @inbounds for old_vertex in 1:n
        relabeled_colors[old_to_new[old_vertex]] = colors[old_vertex]
    end
    @inbounds for relation in 1:nr, old_source in 1:n, old_target in 1:n
        new_source = old_to_new[old_source]
        new_target = old_to_new[old_target]
        multiplicities[_relation_test_slot(relation, new_source, new_target, n)] =
            graph.multiplicities[_relation_test_slot(relation, old_source, old_target, n)]
    end
    return DirectedRelationGraph(n, nr, multiplicities), relabeled_colors
end

function _relation_test_permutations(n::Int)
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

function _relation_test_is_automorphism(
    graph::DirectedRelationGraph, colors::Vector{Int}, old_to_new::Vector{Int}
)::Bool
    n = graph.num_vertices
    @inbounds for vertex in 1:n
        colors[vertex] == colors[old_to_new[vertex]] || return false
    end
    @inbounds for relation in 1:(graph.num_relations), source in 1:n, target in 1:n
        graph.multiplicities[_relation_test_slot(relation, source, target, n)] ==
            graph.multiplicities[
                _relation_test_slot(
                    relation, old_to_new[source], old_to_new[target], n
                )
            ] || return false
    end
    return true
end

function _relation_test_automorphism_order(
    graph::DirectedRelationGraph, colors::Vector{Int}
)::Int
    return count(
        permutation -> _relation_test_is_automorphism(graph, colors, permutation),
        _relation_test_permutations(graph.num_vertices),
    )
end

function _relation_test_canonical_colors(
    buffer::DirectedRelationCanonicalizationBuffer, colors::Vector{Int}
)
    return [
        colors[original_vertex(buffer, canonical_vertex)] for
        canonical_vertex in 1:buffer.num_vertices
    ]
end

@testset "native directed relations exhaustive n=2" begin
    for code in 0:(2^8 - 1), colors in (Int[1, 1], Int[1, 2])
        graph = _relation_test_graph_from_code(2, 2, 2, code)
        workspace = DirectedRelationCanonicalizationWorkspace(2, 2)
        buffer = DirectedRelationCanonicalizationBuffer(2, 2)
        @test @inferred(canonicalize_directed_relations!(
            buffer, workspace, graph, colors
        )) === buffer
        @test canonical_automorphism_order(buffer) ==
            _relation_test_automorphism_order(graph, colors)

        relabeled, relabeled_colors = _relation_test_relabel(graph, colors, Int[2, 1])
        other = DirectedRelationCanonicalizationBuffer(2, 2)
        canonicalize_directed_relations!(other, workspace, relabeled, relabeled_colors)
        @test canonical_graph(other) == canonical_graph(buffer)
        @test _relation_test_canonical_colors(other, relabeled_colors) ==
            _relation_test_canonical_colors(buffer, colors)
    end
end

@testset "native relation multiplicities" begin
    for code in 0:(3^4 - 1), colors in (Int[1, 1], Int[1, 2])
        graph = _relation_test_graph_from_code(2, 1, 3, code)
        workspace = DirectedRelationCanonicalizationWorkspace(2, 1)
        buffer = DirectedRelationCanonicalizationBuffer(2, 1)
        canonicalize_directed_relations!(buffer, workspace, graph, colors)
        @test canonical_automorphism_order(buffer) ==
            _relation_test_automorphism_order(graph, colors)
    end
end

@testset "native relation one-shot result" begin
    graph = DirectedRelationGraph(
        [(1, 1, 2), (1, 1, 2), (2, 2, 3), (2, 3, 1), (2, 3, 3)], 3, 2
    )
    colors = Int[1, 1, 2]
    result = canonicalize_directed_relations(graph, colors)
    @test canonical_automorphism_order(result) ==
        _relation_test_automorphism_order(graph, colors)
    @test canonical_graph(result).num_relations == 2
    @test sort(vertex_mapping(canonical_relabeling(result))) == collect(1:3)
end

@testset "native relation reusable buffers" begin
    graph = DirectedRelationGraphBuffer(8, 4)
    workspace = DirectedRelationCanonicalizationWorkspace(8, 4)
    buffer = DirectedRelationCanonicalizationBuffer(8, 4; materialize_canonical=false)
    colors = ones(Int, 8)
    edges = [(1, 1, 2), (2, 2, 3), (3, 3, 1), (3, 3, 1)]

    load_directed_relations!(graph, edges, 3, 3)
    canonicalize_directed_relations!(buffer, workspace, graph, colors)
    @test buffer.num_vertices == 3
    @test buffer.num_relations == 3
    @test sort(buffer.old_to_canonical[1:3]) == collect(1:3)
    @test_throws ArgumentError canonical_graph(buffer)

    allocated = @allocated begin
        load_directed_relations!(graph, edges, 3, 3)
        canonicalize_directed_relations!(buffer, workspace, graph, colors)
    end
    @test !iszero(Base.JLOptions().code_coverage) || allocated == 0
end
