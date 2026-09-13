# GraphCombinations.jl

[![docs](https://img.shields.io/badge/docs-online-blue.svg)](https://oameye.github.io/GraphCombinations.jl/)
[![codecov](https://codecov.io/gh/oameye/GraphCombinations.jl/branch/main/graph/badge.svg)](https://app.codecov.io/gh/oameye/GraphCombinations.jl)
[![Benchmarks](https://github.com/oameye/GraphCombinations.jl/actions/workflows/Benchmarks.yaml/badge.svg?branch=main)](https://oameye.github.io/GraphCombinations.jl/benchmarks/)

[![Code Style: Blue](https://img.shields.io/badge/blue%20style%20-%20blue-4495d1.svg)](https://github.com/JuliaDiff/BlueStyle)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![jet](https://img.shields.io/badge/%F0%9F%9B%A9%EF%B8%8F_tested_with_JET.jl-233f9a)](https://github.com/aviatesk/JET.jl)
[![DispatchDoctor](https://img.shields.io/badge/%F0%9F%A9%BA_tested_with-DispatchDoctor.jl-blue?labelColor=white)](https://github.com/MilesCranmer/DispatchDoctor.jl)

GraphCombinations.jl generates non-isomorphic multigraph topologies for a prescribed set of vertex degrees, with Feynman-diagram generation as the primary use case.

A vertex specification `n` uses `n[k]` for the number of degree-`k` vertices. Degree-1 vertices are fixed external vertices; internal vertices are quotient-labeled under degree-preserving relabelings. Parallel edges and self-loops/tadpoles are supported.

```julia
using GraphCombinations

graphs = allgraphs([2, 0, 0, 2])
```

`allgraphs` returns `(edges, S)` pairs, where `edges` is a canonical `Vector{Pair{Int,Int}}` representation and `S::BigInt` is the exact symmetry denominator of the topology.

The production generator enumerates degree-constrained multigraphs directly instead of first constructing all Wick pairings. It uses a hybrid exact reduction strategy: low-redundancy inputs canonicalize completed graphs directly, while larger internal relabeling sectors quotient isomorphic partial states at completed multiplicity-row boundaries. Public representatives, result ordering, and symmetry denominators remain deterministic and exact. A brute-force Wick implementation is retained internally as a small-system correctness oracle.

## Explicit degree-sequence problems

`DegreeSequenceProblem` is the lower-level scalar interface when the vertices already exist explicitly rather than being specified through a degree histogram. It also permits fixed distinguished vertices of arbitrary degree.

```julia
problem = DegreeSequenceProblem([1, 1, 4, 4]; num_fixed=2)
graphs = generate_multigraphs(problem)
```

Here `degrees[v]` is the prescribed degree of vertex `v`, and the first `num_fixed` vertices retain their labels under canonicalization. The remaining vertices are quotient-labeled. `generate_multigraphs` returns the same canonical graph representation and exact `BigInt` symmetry denominators as `allgraphs`.

## Weighted colored-port generation

For downstream diagram engines that need directed, typed half-edge matching rather than scalar degree sequences, `ColoredPortProblem` provides an exact weighted colored-port generator.

```julia
problem = ColoredPortProblem(
    fill(1, 3),
    ones(Int, 3, 1),
    ones(Int, 3, 1),
    trues(1, 1),
)

completions = generate_weighted(problem)
```

Rows of the source/target count matrices are vertices and columns are opaque port colors. The admissibility relation may be either a port-color compatibility matrix or a full pair-local relation depending on both endpoint vertices and colors. Exact matching multiplicities are accumulated as `BigInt`, while fixed external vertices and admissibility-preserving relabelings are respected during partial-state quotienting.

`generate_weighted_with_stats` additionally reports traversal statistics. Consumer-defined pruning policies may reject only states whose invalidity is invariant under canonical relabeling and monotone under extension.

Signed or graded consumers can extend `initial_port_weight` and `transport_port_weight` for their own concrete transport type. The transport receives a deterministic `PortRelabeling` before orbit-equivalent contributions are accumulated; GraphCombinations remains agnostic about the physical or algebraic meaning of any resulting sign.

The package is heavily inspired by [this Mathematica StackExchange post](https://mathematica.stackexchange.com/questions/170268/how-to-generate-all-feynman-diagrams-with-mathematica) by AccidentalFourierTransform. A Mathematica notebook based on that approach is available in the [examples folder](https://github.com/oameye/GraphCombinations.jl/tree/main/examples).
