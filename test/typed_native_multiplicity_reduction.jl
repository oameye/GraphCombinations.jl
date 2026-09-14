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
        native = GCNativeTyped._generate_typed_native_multiplicity(problem)
        native_disconnected = GCNativeTyped._generate_typed_native_multiplicity(
            problem; connected=false
        )
        @test native == GCNativeTyped._generate_typed_packed_row_reduced(problem)
        @test native_disconnected ==
            GCNativeTyped._generate_typed_packed_row_reduced(problem; connected=false)
        @test GCNativeTyped.generate_multigraphs(problem) == native
        @test GCNativeTyped.generate_multigraphs(problem; connected=false) ==
            native_disconnected
    end
end

@testset "measured typed production crossover" begin
    fixed_species = _native_fixed_species_problem()
    fixed_mappings = GCNativeTyped._typed_problem_relabelings(fixed_species)
    @test length(fixed_mappings) == 4
    @test GCNativeTyped._use_typed_native_multiplicity(fixed_species, fixed_mappings)

    identity = _native_identity_group_problem()
    identity_mappings = GCNativeTyped._typed_problem_relabelings(identity)
    @test length(identity_mappings) == 1
    @test !GCNativeTyped._use_typed_native_multiplicity(identity, identity_mappings)
    @test GCNativeTyped._generate_typed_native_multiplicity(identity) ==
        GCNativeTyped.generate_multigraphs(identity)
    @test GCNativeTyped._generate_typed_native_multiplicity(identity; connected=false) ==
        GCNativeTyped.generate_multigraphs(identity; connected=false)
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
