# --- Wick Contractions ---

# Memoized function using Memoization.jl
# Input must be immutable and hashable, hence the tuple.
# Points in the tuple are assumed to be sorted beforehand.
@memoize function _corr_memo(points_tuple::NTuple{N,Int}) where {N}
    n = length(points_tuple)
    if n == 0
        # Base case: No points, one term representing coefficient 1 (empty product)
        return [Vector{Propagator}()]
        # n is guaranteed to be even due to checks in the wrapper function `corr`
    elseif n == 2
        # Base case: Two points, single way to pair them
        a, b = points_tuple # Already sorted
        return [[Propagator(a, b)]]
    end

    # Recursive step: pair first element 'a' with others
    a = points_tuple[1]
    all_terms = Vector{Vector{Propagator}}()
    points_vec = collect(points_tuple) # Work with vector internally

    for i in 2:n
        xi = points_vec[i]
        propagator = Propagator(a, xi) # a is the smallest

        # Remaining points excluding a and xi
        # Construct the tuple for the recursive call directly
        remaining_points_vec = vcat(points_vec[2:(i - 1)], points_vec[(i + 1):n])
        remaining_points_tuple = Tuple(remaining_points_vec)

        # Recursively compute pairings for remaining points
        sub_terms = _corr_memo(remaining_points_tuple)

        # Combine the new propagator with each sub-term
        for term in sub_terms
            # Prepend the new propagator
            push!(all_terms, vcat([propagator], term))
        end
    end

    return all_terms
end

"""
    corr(points::Vector{Int})

Computes all possible pairings (Wick contractions) of the given points.
Points are represented by integers. The function returns a list of "terms",
where each term is a list of `Propagator` (Pair{Int, Int}) objects,
representing the product of propagators for a specific pairing.
Propagators `a => b` always have `a < b`.

Example: `corr([1, 2, 3, 4])` might return
`[ [(1=>2), (3=>4)], [(1=>3), (2=>4)], [(1=>4), (2=>3)] ]` (order may vary).
"""
function corr(points::Vector{Int})
    if isodd(length(points))
        error("Cannot compute corr for an odd number of points: $(points)")
    end
    # Sort points for canonical representation for memoization
    sorted_points = sort(points)
    # Call the memoized helper function with a tuple
    return _corr_memo(Tuple(sorted_points))
end
