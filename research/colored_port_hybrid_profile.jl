include(joinpath(@__DIR__, "colored_port_profile.jl"))

# Same search depth, different symmetry classes. These cases measure the
# residual-count-only versus vertex-orbit crossover without conflating it
# with perturbation order.
profile_case("order3_2plus1", [1, 1, 2])
profile_case("order4_3plus1", [1, 1, 1, 2])
profile_case("order4_2plus1plus1", [1, 1, 2, 3])
profile_case("order5_4plus1", [1, 1, 1, 1, 2])
profile_case("order5_3plus2", [1, 1, 1, 2, 2])
profile_case("order5_3plus1plus1", [1, 1, 1, 2, 3])
profile_case("order5_2plus2plus1", [1, 1, 2, 2, 3])
profile_case("order5_2plus1plus1plus1", [1, 1, 2, 3, 4])
profile_case("order5_all_distinct", collect(1:5))
