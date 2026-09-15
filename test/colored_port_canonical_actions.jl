using Test
using GraphCombinations

const GCPortActions = GraphCombinations

@testset "compiled colored-port canonical actions" begin
    problem = @inferred GCPortActions._PortMatchingProblem(
        [9, 1, 1], [0 0; 1 2; 2 1], reshape([0, 3, 3], 3, 1), trues(2, 1), 1
    )
    state = GCPortActions._PortMatchingState(
        [GCPortActions._PortEdge(1, 3, 1, 1)], [0 0; 1 2; 1 1], reshape([0, 2, 3], 3, 1)
    )

    automorphisms = @inferred GCPortActions._port_automorphisms(problem)
    actions = @inferred GCPortActions._port_canonicalization_actions(problem, automorphisms)
    @test length(actions) == length(automorphisms) == 2
    @test actions[1].mapping === automorphisms[1]
    @test actions[2].mapping === automorphisms[2]

    raw_workspace = GCPortActions._PortCanonicalizationWorkspace(state)
    action_workspace = GCPortActions._PortCanonicalizationWorkspace(state)
    raw_key, raw_state, raw_mapping = @inferred GCPortActions._canonicalize_port_state(
        state, automorphisms, raw_workspace
    )
    action_key, action_state, action_mapping = @inferred GCPortActions._canonicalize_port_state(
        state, actions, action_workspace
    )

    @test action_key == raw_key
    @test action_state.edges == raw_state.edges
    @test action_state.source_ports == raw_state.source_ports
    @test action_state.target_ports == raw_state.target_ports
    @test action_mapping == raw_mapping

    for (mapping, action) in zip(automorphisms, actions)
        raw_key = @inferred GCPortActions._mapped_port_key(state, mapping)
        action_key = @inferred GCPortActions._mapped_port_key(state, action)
        @test action_key == raw_key
    end
end
