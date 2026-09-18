include(joinpath(@__DIR__, "packed_depth2_stabilizer_orbits.jl"))

function colored_cycle_product(n_first::Int, n_second::Int; connected::Bool=false)
    n = n_first + n_second + (connected ? 1 : 0)
    edges = Pair{Int,Int}[]

    for vertex in 1:n_first
        push!(edges, vertex => mod1(vertex + 1, n_first))
    end

    offset = n_first
    for local_vertex in 1:n_second
        source = offset + local_vertex
        target = offset + mod1(local_vertex + 1, n_second)
        push!(edges, source => target)
    end

    colors = Vector{Int}(undef, n)
    fill!(@view(colors[1:n_first]), 1)
    fill!(@view(colors[(n_first + 1):(n_first + n_second)]), 2)

    if connected
        anchor = n
        colors[anchor] = 3
        for vertex in 1:(n - 1)
            push!(edges, anchor => vertex)
            push!(edges, vertex => anchor)
        end
    end

    return GC.DirectedGCGraph(edges, n), colors
end

function colored_circulant_product(
    n_first::Int,
    first_offsets::Tuple{Vararg{Int}},
    n_second::Int,
    second_offsets::Tuple{Vararg{Int}},
)
    n = n_first + n_second
    edges = Pair{Int,Int}[]

    for source in 1:n_first, delta in first_offsets
        push!(edges, source => mod1(source + delta, n_first))
    end

    offset = n_first
    for local_source in 1:n_second, delta in second_offsets
        source = offset + local_source
        target = offset + mod1(local_source + delta, n_second)
        push!(edges, source => target)
    end

    colors = vcat(fill(1, n_first), fill(2, n_second))
    return GC.DirectedGCGraph(edges, n), colors
end

product_fixtures = (
    ("two-cycles-7x13", colored_cycle_product(7, 13)...),
    ("two-cycles-11x17", colored_cycle_product(11, 17)...),
    ("anchored-two-cycles-7x13", colored_cycle_product(7, 13; connected=true)...),
    ("anchored-two-cycles-11x17", colored_cycle_product(11, 17; connected=true)...),
    ("two-circulants-7x13", colored_circulant_product(7, (1, 3), 13, (1, 4))...),
    ("two-circulants-11x17", colored_circulant_product(11, (1, 3), 17, (1, 5))...),
)

println("PRODUCT-STABILIZER-FIXTURES")
for (name, graph, colors) in product_fixtures
    benchmark_fixture(name, graph, colors)
end
