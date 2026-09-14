using Test
using GraphCombinations

const GCTypedRows = GraphCombinations

function _typed_bipartite_problem(num_per_color::Int)
    num_vertices = 2 * num_per_color
    allowed = falses(num_vertices, num_vertices)
    @inbounds for left in 1:num_per_color
        for right in (num_per_color + 1):num_vertices
            allowed[left, right] = true
            allowed[right, left] = true
        end
    end
    return TypedMultigraphProblem(
        fill(2, num_vertices),
        vcat(fill(1, num_per_color), fill(2, num_per_color));
        allowed,
    )
end

function _typed_fixed_species_problem()
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

function _typed_loop_subset_problem()
    allowed = trues(6, 6)
    @inbounds for vertex in 4:6
        allowed[vertex, vertex] = false
    end
    return TypedMultigraphProblem(fill(2, 6), [1, 1, 1, 2, 2, 2]; allowed)
end

@testset "exact typed continuation-state reduction" begin
    workloads = (
        _typed_bipartite_problem(4),
        _typed_fixed_species_problem(),
        _typed_loop_subset_problem(),
    )

    for problem in workloads
        @test GCTypedRows._generate_typed_row_reduced(problem) == generate_multigraphs(problem)
        @test GCTypedRows._generate_typed_row_reduced(problem; connected=false) ==
            generate_multigraphs(problem; connected=false)
    end

    bipartite = first(workloads)
    stats = GCTypedRows._typed_row_reduction_stats(bipartite)
    @test stats.states > 0
    @test stats.duplicate_states > 0
    @test stats.canonicalization_calls == stats.states
    @test stats.complete_topologies > 0
end

@testset "frontier-preserving typed relabelings" begin
    problem = _typed_bipartite_problem(3)
    mappings = GCTypedRows._typed_problem_relabelings(problem)
    row_mappings = GCTypedRows._typed_row_state_mappings(mappings, 6)

    @test length(first(row_mappings)) == length(mappings)
    @test length(last(row_mappings)) == length(mappings)
    for row in 1:7, mapping in row_mappings[row]
        @test all((vertex < row) == (mapping[vertex] < row) for vertex in eachindex(mapping))
    end
end
