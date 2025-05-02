# --- Wick Contractions ---

# Memoized function using Memoization.jl
# by default it caches using IdDict which doesn't work for tuples
# Hence we specify it should use a Dict
@memoize Dict function _corr_memo(points::Vector{Int})
    n = length(points)
    if n == 0
        # Base case: No points, one term representing coefficient 1 (empty product)
        return [Vector{Propagator}()]
        # n is guaranteed to be even due to checks in the wrapper function `corr`
    elseif n == 2
        # Base case: Two points, single way to pair them
        a, b = points # Already sorted
        return [[Propagator(a, b)]]
    end

    # Recursive step: pair first element 'a' with others
    a = points[1]
    all_terms = Vector{Vector{Propagator}}()
    for i in 2:n
        xi = points[i]
        propagator = Propagator(a, xi) # a is the smallest

        # Remaining points excluding a and xi
        # Construct the tuple for the recursive call directly
        remaining_points = vcat(points[2:(i - 1)], points[(i + 1):n])

        # Recursively compute pairings for remaining points
        sub_terms = _corr_memo(remaining_points)

        # Combine the new propagator with each sub-term
        for term in sub_terms
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
    return _corr_memo(sorted_points)
end
