using GraphCombinations
using Statistics

import GraphCombinations as GC

function canonicalization_problem(order::Int)
    num_vertices = order + 2
    vertex_colors = vcat([1, 2], fill(3, order))
    source_ports = zeros(Int, num_vertices, 1)
    target_ports = zeros(Int, num_vertices, 1)
    source_ports[1, 1] = 1
    target_ports[2, 1] = 1
    for vertex in 3:num_vertices
        source_ports[vertex, 1] = 2
        target_ports[vertex, 1] = 2
    end
    compatibility = trues(num_vertices, 1, num_vertices, 1)
    compatibility[1, 1, 2, 1] = false
    return GC._PortMatchingProblem(
        vertex_colors, source_ports, target_ports, compatibility, 2
    )
end

@inline function insertion_sort_port_edges!(edges::Vector{GC._PortEdge})
    @inbounds for i in 2:length(edges)
        value = edges[i]
        j = i - 1
        while j >= 1 && isless(value, edges[j])
            edges[j + 1] = edges[j]
            j -= 1
        end
        edges[j + 1] = value
    end
    return edges
end

function write_mapped_port_edges_noalloc!(
    destination::Vector{GC._PortEdge}, state::GC._PortMatchingState, mapping::Vector{Int}
)
    @inbounds for i in eachindex(state.edges)
        edge = state.edges[i]
        destination[i] = GC._PortEdge(
            mapping[edge.source], mapping[edge.target], edge.source_color, edge.target_color
        )
    end
    insertion_sort_port_edges!(destination)
    return nothing
end

function canonicalize_noalloc_sort(
    state::GC._PortMatchingState,
    automorphisms::Vector{Vector{Int}},
    workspace::GC._PortCanonicalizationWorkspace,
)
    first_mapping = first(automorphisms)
    best_key = GC._mapped_port_key(state, first_mapping)
    best_mapping = first_mapping
    length(automorphisms) == 1 &&
        return best_key, GC._state_from_port_key(state, best_key), best_mapping

    GC._prepare_port_workspace!(workspace, state)
    @inbounds for i in 2:length(automorphisms)
        mapping = automorphisms[i]
        write_mapped_port_edges_noalloc!(workspace.edges, state, mapping)
        GC._write_mapped_port_counts!(workspace.source_ports, state.source_ports, mapping)
        GC._write_mapped_port_counts!(workspace.target_ports, state.target_ports, mapping)
        if GC._scratch_port_key_is_lexless(workspace, best_key)
            copyto!(best_key.edges, workspace.edges)
            copyto!(best_key.source_ports, workspace.source_ports)
            copyto!(best_key.target_ports, workspace.target_ports)
            best_mapping = mapping
        end
    end
    return best_key, GC._state_from_port_key(state, best_key), best_mapping
end

function representative_state(problem)
    # A deterministic 13-edge state is enough to isolate the canonicalization
    # kernel. It need not be a completed matching; the key operation depends
    # only on edge/residual storage dimensions and the problem automorphisms.
    edges = GC._PortEdge[]
    num_vertices = length(problem.vertex_colors)
    for i in 1:13
        source = 1 + mod(i - 1, num_vertices)
        target = 1 + mod(3 * i - 1, num_vertices)
        push!(edges, GC._PortEdge(source, target, 1, 1))
    end
    return GC._PortMatchingState(
        edges, copy(problem.source_ports), copy(problem.target_ports)
    )
end

function sample_kernel(label, f; samples=7)
    f()
    measurements = [@timed f() for _ in 1:samples]
    times = getproperty.(measurements, :time)
    bytes = getproperty.(measurements, :bytes)
    return println(
        "CANON\t",
        label,
        "\tbest_seconds=",
        minimum(times),
        "\tmedian_seconds=",
        median(times),
        "\tbest_bytes=",
        minimum(bytes),
        "\tmedian_bytes=",
        median(bytes),
    )
end

problem = canonicalization_problem(6)
automorphisms = GC._port_automorphisms(problem)
state = representative_state(problem)
workspace = GC._PortCanonicalizationWorkspace(state)

expected = GC._canonicalize_port_state(state, automorphisms, workspace)
actual = canonicalize_noalloc_sort(state, automorphisms, workspace)
first(expected) == first(actual) || error("no-allocation sort changed the canonical key")

sample_kernel("current", () -> GC._canonicalize_port_state(state, automorphisms, workspace))
sample_kernel(
    "insertion_sort", () -> canonicalize_noalloc_sort(state, automorphisms, workspace)
)
