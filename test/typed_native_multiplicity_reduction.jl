using Test
using GraphCombinations

const GCNativeTyped = GraphCombinations

function _native_bipartite_problem(num_per_color::Int)
    num_vertices = 2 * num_per_color
    allowed = falses(num_vertices, num_vertices)
    @inbounds for left in 1:num_per_color
        for right in (num_per_color + 1):num_vertices
            allowed[left, right] = true
            allowed[right, left] = true
        end
    end
    return TypedMultigraphProblem(
        fill(2, num_vertices), vcat(fill(1, num_per_color), fill(2, num_per_color)); allowed
    )
end

function _native_fixed_species_problem()
    allowed = trues(6, 6)
    @inbounds for vertex in 1:6
        allowed[vertex, vertex] = false
    end
    @inbounds for vertex in 5:6
        allowed[1, vertex] = false
        allowed[vertex, 1] = false
    end
    @inbounds for vertex in 3:4
        allowed[2, vertex] = false
        allowed[vertex, 2] = false
    end
    return TypedMultigraphProblem(
        [1, 1, 3, 3, 3, 3], [10, 11, 1, 1, 2, 2]; num_fixed=2, allowed
    )
end

function _native_loop_subset_problem()
    allowed = trues(6, 6)
    @inbounds for vertex in 4:6
        allowed[vertex, vertex] = false
    end
    return TypedMultigraphProblem(fill(2, 6), [1, 1, 1, 2, 2, 2]; allowed)
end

function _native_identity_group_problem()
    allowed = trues(6, 6)
    @inbounds for vertex in 1:6
        allowed[vertex, vertex] = false
    end
    return TypedMultigraphProblem(fill(2, 6), collect(1:6); allowed)
end

@testset "native triangular multiplicity recursion" begin
    workloads = (
        _native_bipartite_problem(4),
        _native_fixed_species_problem(),
        _native_loop_subset_problem(),
    )

    for problem in workloads
        @test GCNativeTyped._generate_typed_native_multiplicity(problem) ==
            GCNativeTyped._generate_typed_packed_row_reduced(problem)
        @test GCNativeTyped._generate_typed_native_multiplicity(problem; connected=false) ==
            GCNativeTyped._generate_typed_packed_row_reduced(problem; connected=false)
    end
end

@testset "identity typed relabeling group" begin
    problem = _native_identity_group_problem()
    @test length(GCNativeTyped._typed_problem_relabelings(problem)) == 1
    @test GCNativeTyped._generate_typed_native_multiplicity(problem) ==
        GCNativeTyped.generate_multigraphs(problem)
    @test GCNativeTyped._generate_typed_native_multiplicity(problem; connected=false) ==
        GCNativeTyped.generate_multigraphs(problem; connected=false)
end

@testset "native triangular state canonicalization" begin
    problem = _native_bipartite_problem(3)
    mappings = GCNativeTyped._typed_problem_relabelings(problem)
    actions = GCNativeTyped._triangular_relabeling_actions(mappings, 6)
    graph = [1 => 4, 1 => 5, 2 => 4, 2 => 6, 3 => 5, 3 => 6]
    multiplicities = GCNativeTyped._graph_triangular_multiplicities(graph, 6)
    bits = GCNativeTyped._triangular_multiplicity_bits(2)

    key, best_action_index, automorphism_order = GCNativeTyped._canonicalize_native_triangular_state(
        multiplicities, actions, bits
    )
    packed = GCNativeTyped._canonicalize_packed_triangular_actions(graph, actions, 6, bits)

    @test key == packed.key
    @test best_action_index == packed.best_action_index
    @test automorphism_order == packed.automorphism_order
end
