using Profile
import GraphCombinations as GC

function _print_scaling_measurement(label::AbstractString, n::Vector{Int})
    measurement = @timed GC._allgraphs_hybrid(n)
    println(
        "SCALING ",
        label,
        ": time=",
        measurement.time,
        " s bytes=",
        measurement.bytes,
        " gctime=",
        measurement.gctime,
        " topologies=",
        length(measurement.value),
    )
    return measurement
end

function _print_row_stats(label::AbstractString, n::Vector{Int})
    measurement = @timed GC._row_reduction_stats(n)
    stats = measurement.value
    println(
        "ROWSTATS ",
        label,
        ": time=",
        measurement.time,
        " s bytes=",
        measurement.bytes,
        " states=",
        stats.states,
        " duplicates=",
        stats.duplicate_states,
        " canonicalization_calls=",
        stats.canonicalization_calls,
        " complete_topologies=",
        stats.complete_topologies,
    )
    return measurement
end

function profile_row_state_scaling()
    order6 = [2, 0, 0, 6]
    order7 = [2, 0, 0, 7]

    println("=== Row-state scaling probe ===")
    order6_measurement = _print_scaling_measurement("phi4-order6", order6)
    _print_row_stats("phi4-order6", order6)

    Profile.clear()
    Profile.@profile GC._allgraphs_hybrid(order6)
    println("=== CPU profile: phi4-order6 ===")
    Profile.print(stdout; format=:flat, mincount=5)

    # Order 7 has roughly 26.3 million labelled degree-constrained candidates before row-state
    # quotienting. Only probe it when order 6 shows that the merged production path remains in a
    # practical regime; otherwise leave it for an explicit manual stress run.
    if order6_measurement.time <= 2.0
        order7_measurement = _print_scaling_measurement("phi4-order7", order7)
        if order7_measurement.time <= 5.0
            _print_row_stats("phi4-order7", order7)
        else
            println("ROWSTATS phi4-order7: skipped because the one-shot run exceeded 5 s")
        end
    else
        println("SCALING phi4-order7: skipped because phi4-order6 exceeded 2 s")
    end

    println("=== End row-state scaling probe ===")
    return nothing
end
