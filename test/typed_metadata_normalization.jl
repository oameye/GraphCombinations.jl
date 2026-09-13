using Test
using GraphCombinations

const GCTypedNormalization = GraphCombinations

struct _NormalizationAcceptAll end
@inline (::_NormalizationAcceptAll)(::Vector{Int})::Bool = true

function _normalization_mapped_int_vector(
    values::Vector{Int}, mapping::Vector{Int}
)::Vector{Int}
    mapped = similar(values)
    @inbounds for old_vertex in eachindex(values)
        mapped[mapping[old_vertex]] = values[old_vertex]
    end
    return mapped
end

function _normalization_mapped_square_matrix(
    matrix::BitMatrix, mapping::Vector{Int}
)::BitMatrix
    n = size(matrix, 1)
    mapped = falses(n, n)
    @inbounds for old_u in 1:n
        new_u = mapping[old_u]
        for old_v in 1:n
            mapped[new_u, mapping[old_v]] = matrix[old_u, old_v]
        end
    end
    return mapped
end

function _normalization_lexless_int_vector(a::Vector{Int}, b::Vector{Int})::Bool
    @inbounds for index in eachindex(a, b)
        a[index] == b[index] && continue
        return a[index] < b[index]
    end
    return length(a) < length(b)
end

function _normalization_lexless_bitmatrix(a::BitMatrix, b::BitMatrix)::Bool
    @inbounds for index in eachindex(a, b)
        a[index] == b[index] && continue
        return !a[index] && b[index]
    end
    return false
end

function _normalization_metadata_less(
    degrees::Vector{Int},
    allowed::BitMatrix,
    best_degrees::Vector{Int},
    best_allowed::BitMatrix,
)::Bool
    degrees == best_degrees ||
        return _normalization_lexless_int_vector(degrees, best_degrees)
    return _normalization_lexless_bitmatrix(allowed, best_allowed)
end

function _exhaustive_typed_normalization(
    degrees::Vector{Int}, colors::Vector{Int}, allowed::BitMatrix, num_fixed::Int
)::Tuple{Vector{Int},Vector{Int},BitMatrix}
    n = length(degrees)
    n <= num_fixed + 1 && return copy(degrees), copy(colors), copy(allowed)

    nonfixed = collect((num_fixed + 1):n)
    sort!(nonfixed; by=v -> colors[v])
    color_mapping = collect(1:n)
    @inbounds for (offset, old_vertex) in enumerate(nonfixed)
        color_mapping[old_vertex] = num_fixed + offset
    end

    reordered_degrees = _normalization_mapped_int_vector(degrees, color_mapping)
    reordered_colors = _normalization_mapped_int_vector(colors, color_mapping)
    reordered_allowed = _normalization_mapped_square_matrix(allowed, color_mapping)
    mappings = GCTypedNormalization._problem_relabelings(
        reordered_colors, num_fixed, _NormalizationAcceptAll()
    )

    best_degrees = reordered_degrees
    best_allowed = reordered_allowed
    best_mapping = first(mappings)
    @inbounds for mapping in @view mappings[2:end]
        candidate_degrees = _normalization_mapped_int_vector(reordered_degrees, mapping)
        candidate_allowed = _normalization_mapped_square_matrix(reordered_allowed, mapping)
        if _normalization_metadata_less(
            candidate_degrees, candidate_allowed, best_degrees, best_allowed
        )
            best_degrees = candidate_degrees
            best_allowed = candidate_allowed
            best_mapping = mapping
        end
    end

    normalized_colors = _normalization_mapped_int_vector(reordered_colors, best_mapping)
    return best_degrees, normalized_colors, best_allowed
end

function _assert_typed_normalization_matches_oracle(
    degrees::Vector{Int}, colors::Vector{Int}, allowed::BitMatrix; num_fixed::Int=0
)::Nothing
    original_degrees = copy(degrees)
    original_colors = copy(colors)
    original_allowed = copy(allowed)

    optimized = @inferred GCTypedNormalization._normalize_typed_problem(
        copy(degrees), copy(colors), copy(allowed), num_fixed
    )
    exhaustive = _exhaustive_typed_normalization(degrees, colors, allowed, num_fixed)
    @test optimized == exhaustive

    @test degrees == original_degrees
    @test colors == original_colors
    @test allowed == original_allowed
    return nothing
end

function _symmetric_allowed_from_mask(num_vertices::Int, mask::Int)::BitMatrix
    allowed = falses(num_vertices, num_vertices)
    bit_index = 0
    @inbounds for u in 1:num_vertices
        for v in u:num_vertices
            value = !iszero(mask & (1 << bit_index))
            allowed[u, v] = value
            allowed[v, u] = value
            bit_index += 1
        end
    end
    return allowed
end

@testset "typed metadata normalization" begin
    @testset "exhaustive legacy oracle" begin
        _assert_typed_normalization_matches_oracle(fill(2, 4), fill(1, 4), trues(4, 4))

        loopless6 = trues(6, 6)
        @inbounds for vertex in 1:6
            loopless6[vertex, vertex] = false
        end
        _assert_typed_normalization_matches_oracle(fill(2, 6), fill(1, 6), loopless6)

        mixed_degrees = BitMatrix(
            [
                false true true false;
                true false false true;
                true false true true;
                false true true false
            ],
        )
        _assert_typed_normalization_matches_oracle([2, 1, 3, 1], fill(4, 4), mixed_degrees)

        mixed_colors = BitMatrix(
            [
                true false true true false;
                false false true false true;
                true true false true false;
                true false true true true;
                false true false true false
            ],
        )
        _assert_typed_normalization_matches_oracle(
            [2, 2, 2, 2, 2], [3, 1, 2, 1, 2], mixed_colors
        )

        fixed_prefix = BitMatrix(
            [
                true false true false true;
                false false true true false;
                true true false false true;
                false true false true false;
                true false true false false
            ],
        )
        _assert_typed_normalization_matches_oracle(
            [3, 1, 2, 2, 2], [8, 9, 1, 1, 1], fixed_prefix; num_fixed=2
        )

        disconnected = BitMatrix(
            [
                false true false false false false;
                true false true false false false;
                false true false false false false;
                false false false false true true;
                false false false true false false;
                false false false true false false
            ],
        )
        _assert_typed_normalization_matches_oracle(fill(2, 6), fill(1, 6), disconnected)
    end

    @testset "complete symmetric n4 admissibility space" begin
        degrees = fill(2, 4)
        colors = fill(1, 4)
        for mask in 0:((1 << 10) - 1)
            allowed = _symmetric_allowed_from_mask(4, mask)
            optimized = GCTypedNormalization._normalize_typed_problem(
                copy(degrees), copy(colors), copy(allowed), 0
            )
            @test optimized == _exhaustive_typed_normalization(degrees, colors, allowed, 0)
        end
    end

    @testset "legacy lexicographic representative" begin
        # Diagonal/equitable cell ordering alone would place vertices 1 and 3 contiguously and
        # change the old representative. Prefix refinement must retain the exhaustive minimum.
        allowed = BitMatrix([
            false false true;
            false true false;
            true false false
        ])
        optimized = GCTypedNormalization._normalize_typed_problem(
            fill(2, 3), fill(1, 3), copy(allowed), 0
        )
        @test optimized ==
            _exhaustive_typed_normalization(fill(2, 3), fill(1, 3), allowed, 0)
        @test optimized[3] == allowed
    end

    @testset "consistent input permutations" begin
        degrees = [3, 2, 1, 2, 1]
        colors = [9, 2, 1, 2, 1]
        allowed = BitMatrix(
            [
                true false true false true;
                false false true true false;
                true true false false true;
                false true false true true;
                true false true true false
            ],
        )
        expected = GCTypedNormalization._normalize_typed_problem(
            copy(degrees), copy(colors), copy(allowed), 1
        )

        for order in ([1, 3, 2, 5, 4], [1, 5, 4, 3, 2], [1, 4, 2, 3, 5])
            permuted = GCTypedNormalization._normalize_typed_problem(
                degrees[order], colors[order], allowed[order, order], 1
            )
            @test permuted == expected
            @test permuted == _exhaustive_typed_normalization(
                degrees[order], colors[order], allowed[order, order], 1
            )
        end
    end
end
