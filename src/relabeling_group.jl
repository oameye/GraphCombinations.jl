# --- Generic problem-preserving vertex relabelings ---

function _vertex_color_cells(
    vertex_colors::Vector{Int}, num_fixed::Int
)::Vector{Vector{Int}}
    first_internal = num_fixed + 1
    first_internal > length(vertex_colors) && return Vector{Vector{Int}}()

    colors = sort!(unique(vertex_colors[first_internal:end]))
    cells = Vector{Vector{Int}}()
    sizehint!(cells, length(colors))
    for color in colors
        cell = Int[]
        for vertex in first_internal:length(vertex_colors)
            vertex_colors[vertex] == color && push!(cell, vertex)
        end
        length(cell) > 1 && push!(cells, cell)
    end
    return cells
end

function _collect_problem_relabelings!(
    relabelings::Vector{Vector{Int}},
    preserves::F,
    cells::Vector{Vector{Int}},
    mapping::Vector{Int},
    cell_index::Int,
)::Nothing where {F}
    if cell_index > length(cells)
        preserves(mapping) && push!(relabelings, copy(mapping))
        return nothing
    end

    cell = cells[cell_index]
    permutation = copy(cell)
    while true
        @inbounds for i in eachindex(cell)
            mapping[cell[i]] = permutation[i]
        end
        _collect_problem_relabelings!(
            relabelings, preserves, cells, mapping, cell_index + 1
        )
        _next_permutation!(permutation) || break
    end
    return nothing
end

function _problem_relabelings(
    vertex_colors::Vector{Int}, num_fixed::Int, preserves::F
)::Vector{Vector{Int}} where {F}
    0 <= num_fixed <= length(vertex_colors) ||
        throw(ArgumentError("num_fixed must lie in 0:length(vertex_colors)."))

    mapping = collect(eachindex(vertex_colors))
    relabelings = Vector{Vector{Int}}()
    _collect_problem_relabelings!(
        relabelings,
        preserves,
        _vertex_color_cells(vertex_colors, num_fixed),
        mapping,
        1,
    )
    isempty(relabelings) &&
        error("Internal error: problem-preserving relabeling group is empty.")
    return relabelings
end
