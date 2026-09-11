import GraphCombinations as GC

function _port_occurrences(counts::Matrix{Int})
    occurrences = Tuple{Int,Int,Int}[]
    for vertex in axes(counts, 1)
        for color in axes(counts, 2)
            for occurrence in 1:counts[vertex, color]
                push!(occurrences, (vertex, color, occurrence))
            end
        end
    end
    return occurrences
end

function _completed_port_key(problem, edges)
    state = GC._PortMatchingState(
        copy(edges),
        zeros(Int, size(problem.source_ports)),
        zeros(Int, size(problem.target_ports)),
    )
    key, _, _ = GC._canonicalize_port_state(problem, state)
    return key
end

function _brute_port_matchings(problem)
    sources = _port_occurrences(problem.source_ports)
    targets = _port_occurrences(problem.target_ports)
    length(sources) == length(targets) || error("invalid brute-force port problem")

    weights = Dict{GC._PortStateKey,BigInt}()
    permutation = collect(eachindex(targets))
    isempty(permutation) && return weights

    while true
        edges = GC._PortEdge[]
        valid = true
        for i in eachindex(sources)
            source_vertex, source_color, _ = sources[i]
            target_vertex, target_color, _ = targets[permutation[i]]
            if !problem.compatibility[
                source_vertex, source_color, target_vertex, target_color
            ]
                valid = false
                break
            end
            push!(
                edges,
                GC._PortEdge(source_vertex, target_vertex, source_color, target_color),
            )
        end
        if valid
            key = _completed_port_key(problem, edges)
            weights[key] = get(weights, key, big(0)) + 1
        end
        GC._next_permutation!(permutation) || break
    end
    return weights
end

function _generated_port_matchings(problem)
    weights = Dict{GC._PortStateKey,BigInt}()
    for (edges, weight) in GC._weighted_port_matchings(problem)
        key = _completed_port_key(problem, edges)
        weights[key] = get(weights, key, big(0)) + weight
    end
    return weights
end

@testset "problem validation" begin
    @test_throws ArgumentError GC._PortMatchingProblem(
        [1, 1], zeros(Int, 1, 1), zeros(Int, 2, 1), trues(1, 1)
    )
    @test_throws ArgumentError GC._PortMatchingProblem(
        [1], reshape([-1], 1, 1), reshape([-1], 1, 1), trues(1, 1)
    )
    @test_throws ArgumentError GC._PortMatchingProblem(
        [1], reshape([1], 1, 1), reshape([0], 1, 1), trues(1, 1)
    )
    @test_throws ArgumentError GC._PortMatchingProblem(
        [1], zeros(Int, 1, 1), zeros(Int, 1, 1), trues(2, 1)
    )
    @test_throws ArgumentError GC._PortMatchingProblem(
        [1], zeros(Int, 1, 1), zeros(Int, 1, 1), trues(1, 1), 2
    )
    @test_throws ArgumentError GC._PortMatchingProblem(
        [1], zeros(Int, 1, 1), zeros(Int, 1, 1), falses(1, 1, 1, 2)
    )
end

@testset "partial-state canonicalization" begin
    problem = GC._PortMatchingProblem(
        [9, 1, 1], zeros(Int, 3, 1), zeros(Int, 3, 1), trues(1, 1), 1
    )
    state_a = GC._PortMatchingState(
        [GC._PortEdge(1, 2, 1, 1)], reshape([0, 0, 1], 3, 1), reshape([0, 1, 0], 3, 1)
    )
    state_b = GC._PortMatchingState(
        [GC._PortEdge(1, 3, 1, 1)], reshape([0, 1, 0], 3, 1), reshape([0, 0, 1], 3, 1)
    )
    key_a, canonical_a, _ = GC._canonicalize_port_state(problem, state_a)
    key_b, canonical_b, _ = GC._canonicalize_port_state(problem, state_b)
    @test key_a == key_b
    @test canonical_a.edges == canonical_b.edges
    @test canonical_a.source_ports == canonical_b.source_ports
    @test canonical_a.target_ports == canonical_b.target_ports

    fixed_problem = GC._PortMatchingProblem(
        [1, 1, 1], zeros(Int, 3, 1), zeros(Int, 3, 1), trues(1, 1), 2
    )
    fixed_a = GC._PortMatchingState(
        [GC._PortEdge(1, 3, 1, 1)], zeros(Int, 3, 1), zeros(Int, 3, 1)
    )
    fixed_b = GC._PortMatchingState(
        [GC._PortEdge(2, 3, 1, 1)], zeros(Int, 3, 1), zeros(Int, 3, 1)
    )
    fixed_key_a, _, fixed_map_a = GC._canonicalize_port_state(fixed_problem, fixed_a)
    fixed_key_b, _, fixed_map_b = GC._canonicalize_port_state(fixed_problem, fixed_b)
    @test fixed_key_a != fixed_key_b
    @test fixed_map_a[1:2] == [1, 2]
    @test fixed_map_b[1:2] == [1, 2]

    residual_problem = GC._PortMatchingProblem(
        [1, 2], zeros(Int, 2, 1), zeros(Int, 2, 1), trues(1, 1), 0
    )
    residual_a = GC._PortMatchingState(
        GC._PortEdge[], reshape([1, 0], 2, 1), reshape([0, 1], 2, 1)
    )
    residual_b = GC._PortMatchingState(
        GC._PortEdge[], reshape([0, 1], 2, 1), reshape([1, 0], 2, 1)
    )
    residual_key_a, _, _ = GC._canonicalize_port_state(residual_problem, residual_a)
    residual_key_b, _, _ = GC._canonicalize_port_state(residual_problem, residual_b)
    @test residual_key_a != residual_key_b
end

@testset "pair-local compatibility constrains vertex automorphisms" begin
    symmetric = GC._PortMatchingProblem(
        [1, 1], ones(Int, 2, 1), ones(Int, 2, 1), trues(1, 1)
    )
    @test length(GC._port_automorphisms(symmetric)) == 2

    compatibility = trues(2, 1, 2, 1)
    compatibility[1, 1, 2, 1] = false
    asymmetric = GC._PortMatchingProblem(
        [1, 1], ones(Int, 2, 1), ones(Int, 2, 1), compatibility
    )
    @test length(GC._port_automorphisms(asymmetric)) == 1
    generated = _generated_port_matchings(asymmetric)
    brute = _brute_port_matchings(asymmetric)
    @test generated == brute
    @test sum(values(generated)) == 1
end

@testset "weighted generation matches labelled brute force" begin
    symmetric = GC._PortMatchingProblem(
        [1, 1], ones(Int, 2, 1), ones(Int, 2, 1), trues(1, 1)
    )
    @test _generated_port_matchings(symmetric) == _brute_port_matchings(symmetric)
    symmetric_results = GC._weighted_port_matchings(symmetric)
    @test length(symmetric_results) == 2
    @test sort(last.(symmetric_results)) == [big(1), big(1)]

    repeated = GC._PortMatchingProblem(
        [1, 2], reshape([2, 0], 2, 1), reshape([0, 2], 2, 1), trues(1, 1), 2
    )
    @test _generated_port_matchings(repeated) == _brute_port_matchings(repeated)
    repeated_results = GC._weighted_port_matchings(repeated)
    @test length(repeated_results) == 1
    @test only(repeated_results)[2] == 2

    colored = GC._PortMatchingProblem(
        [10, 11, 20, 20],
        [1 0 0; 0 0 0; 0 1 1; 0 1 1],
        [0 0 0; 1 0 0; 0 1 1; 0 1 1],
        Bool[0 1 1; 1 1 1; 1 1 1],
        2,
    )
    generated = _generated_port_matchings(colored)
    brute = _brute_port_matchings(colored)
    @test generated == brute
    @test sum(values(generated)) == sum(values(brute))
    @test sum(values(generated)) > length(generated)

    diagonal = GC._PortMatchingProblem([1, 2], [1 0; 0 1], [1 0; 0 1], Bool[1 0; 0 1], 2)
    @test _generated_port_matchings(diagonal) == _brute_port_matchings(diagonal)
    @test length(GC._weighted_port_matchings(diagonal)) == 1

    impossible = GC._PortMatchingProblem(
        [1, 2], ones(Int, 2, 1), ones(Int, 2, 1), falses(1, 1), 2
    )
    @test isempty(GC._weighted_port_matchings(impossible))
    @test isempty(_brute_port_matchings(impossible))
end

@testset "state quotient statistics" begin
    problem = GC._PortMatchingProblem(
        fill(1, 3), ones(Int, 3, 1), ones(Int, 3, 1), trues(1, 1)
    )
    results, stats = GC._weighted_port_matchings_with_stats(problem)
    @test _generated_port_matchings(problem) == _brute_port_matchings(problem)
    @test sum(last, results) == factorial(big(3))
    @test stats.automorphisms == factorial(3)
    @test stats.canonicalization_calls == stats.transitions + 1
    @test stats.merged_transitions > 0
    @test first(stats.layer_states) == 1
    @test last(stats.layer_states) == length(results)
end
