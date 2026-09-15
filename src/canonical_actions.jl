# --- Shared exact coordinate relabeling actions ---

"""
Apply an exact induced coordinate action.

`action[output_index]` is the source coordinate copied into `output_index`. The action itself is
pure combinatorial data: callers own the meaning and ordering of the coordinates.
"""
@inline function _write_coordinate_action!(
    destination::D, source::S, action::Vector{Int}
)::Nothing where {T,D<:AbstractVector{T},S<:AbstractArray{T}}
    length(destination) == length(action) ||
        error("Internal error: coordinate-action destination has the wrong size.")
    length(source) == length(action) ||
        error("Internal error: coordinate-action source has the wrong size.")
    @inbounds for output_index in eachindex(action)
        destination[output_index] = source[action[output_index]]
    end
    return nothing
end

"""
Compare two images of the same exact coordinate vector under induced actions.

Return `-1` when `candidate_action` is preferred, `1` when `best_action` is preferred, and `0`
when both images are identical. `prefer_larger=true` reverses the ordinary lexicographic value
comparison; this is the convention used by multiplicity encodings of sorted edge lists.
"""
@inline function _compare_coordinate_actions(
    values::V, candidate_action::Vector{Int}, best_action::Vector{Int}, ::Val{prefer_larger}
)::Int where {V<:AbstractArray{Int},prefer_larger}
    length(candidate_action) == length(best_action) ||
        error("Internal error: coordinate actions have different sizes.")
    length(values) == length(candidate_action) ||
        error("Internal error: coordinate action has the wrong source size.")
    @inbounds for output_index in eachindex(candidate_action, best_action)
        candidate = values[candidate_action[output_index]]
        best = values[best_action[output_index]]
        candidate == best && continue
        candidate_preferred = prefer_larger ? candidate > best : candidate < best
        return candidate_preferred ? -1 : 1
    end
    return 0
end

"""
Compile the induced action for `num_blocks` repeated vertex-coordinate blocks.

Each block is stored vertex-fast, i.e. `[v₁, …, vₙ]` followed by the next block. The returned
vector follows the output-to-source convention used by `_write_coordinate_action!`.
"""
function _vertex_block_coordinate_action(mapping::Vector{Int}, num_blocks::Int)::Vector{Int}
    num_blocks >= 0 || throw(ArgumentError("num_blocks must be non-negative."))
    num_vertices = length(mapping)
    inverse_mapping = Vector{Int}(undef, num_vertices)
    _write_inverse_permutation!(inverse_mapping, mapping, 1)

    action = Vector{Int}(undef, num_vertices * num_blocks)
    @inbounds for block in 0:(num_blocks - 1)
        offset = block * num_vertices
        for new_vertex in 1:num_vertices
            action[offset + new_vertex] = offset + inverse_mapping[new_vertex]
        end
    end
    return action
end
