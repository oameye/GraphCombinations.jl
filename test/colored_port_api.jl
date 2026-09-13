import GraphCombinations as GC

mutable struct RecordingPortTransport
    calls::Int
    saw_nonidentity::Bool
    valid_added_edges::Bool
end

function _is_identity_relabeling(witness::GC.PortRelabeling)
    return all(i -> witness.vertex_map[i] == i, eachindex(witness.vertex_map))
end

function GC.initial_port_weight(
    transport::RecordingPortTransport,
    ::GC.ColoredPortState,
    ::GC.ColoredPortState,
    witness::GC.PortRelabeling,
)::BigInt
    transport.calls += 1
    transport.saw_nonidentity |= !_is_identity_relabeling(witness)
    return big(1)
end

function GC.transport_port_weight(
    transport::RecordingPortTransport,
    parent_weight::BigInt,
    multiplicity::Int,
    added_edge::GC.ColoredPortEdge,
    raw_child::GC.ColoredPortState,
    ::GC.ColoredPortState,
    witness::GC.PortRelabeling,
)::BigInt
    transport.calls += 1
    transport.saw_nonidentity |= !_is_identity_relabeling(witness)
    transport.valid_added_edges &= any(edge -> edge == added_edge, GC.port_edges(raw_child))
    return parent_weight * multiplicity
end

struct NoSelfPortPolicy end
function (::NoSelfPortPolicy)(state::GC.ColoredPortState)
    return all(edge -> edge.source != edge.target, GC.port_edges(state))
end

@testset "public weighted generation matches internal core" begin
    problem = GC.ColoredPortProblem(
        fill(1, 3), ones(Int, 3, 1), ones(Int, 3, 1), trues(1, 1)
    )
    completions = @inferred GC.generate_weighted(problem)
    with_stats, stats = @inferred GC.generate_weighted_with_stats(problem)
    internal = GC._weighted_port_matchings(problem._problem)

    @test completions == with_stats
    @test [(result.edges, result.weight) for result in completions] == internal
    @test sum(result -> result.weight, completions) == factorial(big(3))
    @test stats.automorphisms == factorial(3)
    @test stats.pruned_transitions == 0
    @test stats.canonicalization_calls == stats.transitions + 1

    stats_only = @inferred GC.generation_statistics(problem)
    @test stats_only.automorphisms == stats.automorphisms
    @test stats_only.layer_states == stats.layer_states
    @test stats_only.transitions == stats.transitions
    @test stats_only.canonicalization_calls == stats.canonicalization_calls
    @test stats_only.merged_transitions == stats.merged_transitions
    @test stats_only.pruned_transitions == 0
end

@testset "canonical relabeling witness" begin
    problem = GC.ColoredPortProblem(
        [9, 1, 1], zeros(Int, 3, 1), zeros(Int, 3, 1), trues(1, 1), 1
    )
    state = GC.ColoredPortState(
        [GC.ColoredPortEdge(1, 3, 1, 1)], reshape([0, 1, 0], 3, 1), reshape([0, 0, 1], 3, 1)
    )
    canonical, witness = @inferred GC.canonical_relabeling(problem, state)
    mapped = @inferred GC.relabel_port_state(state, witness)

    @test witness.vertex_map[1] == 1
    @test GC.port_edges(mapped) == GC.port_edges(canonical)
    @test GC.source_port_counts(mapped) == GC.source_port_counts(canonical)
    @test GC.target_port_counts(mapped) == GC.target_port_counts(canonical)

    compatibility = trues(3, 1, 3, 1)
    compatibility[2, 1, 3, 1] = false
    asymmetric = GC.ColoredPortProblem(
        [9, 1, 1], zeros(Int, 3, 1), zeros(Int, 3, 1), compatibility, 1
    )
    _, asymmetric_witness = GC.canonical_relabeling(asymmetric, state)
    mapping = asymmetric_witness.vertex_map
    allowed = asymmetric._problem.compatibility
    for source_vertex in axes(allowed, 1)
        for target_vertex in axes(allowed, 3)
            @test allowed[source_vertex, 1, target_vertex, 1] ==
                allowed[mapping[source_vertex], 1, mapping[target_vertex], 1]
        end
    end
end

@testset "public policy and transport hooks" begin
    state = GC.ColoredPortState(GC.ColoredPortEdge[], zeros(Int, 1, 1), zeros(Int, 1, 1))
    witness = GC.PortRelabeling([1])
    edge = GC.ColoredPortEdge(1, 1, 1, 1)
    transport = GC.MultiplicityPortTransport()

    @test GC.AcceptAllPortPolicy()(state)
    @test GC.initial_port_weight(transport, state, state, witness) == 1
    @test GC.transport_port_weight(transport, big(2), 3, edge, state, state, witness) == 6

    completion = GC.WeightedPortCompletion(GC.ColoredPortEdge[], big(1))
    @test completion == completion
    @test isequal(completion, completion)

    recording = RecordingPortTransport(0, false, true)
    @test_throws ErrorException GC._transport_port_weight(
        recording, big(1), 1, state._state, state._state, [1]
    )
end

@testset "transport observes every canonical relabeling before accumulation" begin
    problem = GC.ColoredPortProblem(
        fill(1, 3), ones(Int, 3, 1), ones(Int, 3, 1), trues(1, 1)
    )
    transport = RecordingPortTransport(0, false, true)
    transported, stats = @inferred GC.generate_weighted_with_stats(
        problem; transport=transport
    )
    baseline = GC.generate_weighted(problem)

    @test transported == baseline
    @test transport.calls == stats.canonicalization_calls
    @test transport.saw_nonidentity
    @test transport.valid_added_edges
end

@testset "public monotone pruning" begin
    problem = GC.ColoredPortProblem(
        fill(1, 3), ones(Int, 3, 1), ones(Int, 3, 1), trues(1, 1)
    )
    pruned, stats = @inferred GC.generate_weighted_with_stats(
        problem; policy=NoSelfPortPolicy()
    )
    baseline = filter(
        completion -> all(edge -> edge.source != edge.target, completion.edges),
        GC.generate_weighted(problem),
    )

    @test pruned == baseline
    @test stats.pruned_transitions > 0
    @test stats.canonicalization_calls < stats.transitions + 1
end
