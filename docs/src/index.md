# GraphCombinations.jl

[![docs](https://img.shields.io/badge/docs-online-blue.svg)](https://oameye.github.io/GraphCombinations.jl/)
[![codecov](https://codecov.io/gh/oameye/GraphCombinations.jl/branch/main/graph/badge.svg)](https://app.codecov.io/gh/oameye/GraphCombinations.jl)
[![Benchmarks](https://github.com/oameye/GraphCombinations.jl/actions/workflows/Benchmarks.yaml/badge.svg?branch=main)](https://oameye.github.io/GraphCombinations.jl/benchmarks/)

[![Code Style: Blue](https://img.shields.io/badge/blue%20style%20-%20blue-4495d1.svg)](https://github.com/JuliaDiff/BlueStyle)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![jet](https://img.shields.io/badge/%F0%9F%9B%A9%EF%B8%8F_tested_with-JET.jl-233f9a)](https://github.com/aviatesk/JET.jl)
[![DispatchDoctor](https://img.shields.io/badge/%F0%9F%A9%BA_tested_with-DispatchDoctor.jl-blue?labelColor=white)](https://github.com/MilesCranmer/DispatchDoctor.jl)

GraphCombinations.jl generates non-isomorphic multigraph topologies for a prescribed set of vertex degrees, with Feynman-diagram generation as the primary use case.

A vertex specification `n` uses `n[k]` for the number of degree-`k` vertices. Degree-1 vertices are fixed external vertices; internal vertices are quotient-labeled under degree-preserving relabelings. Parallel edges and self-loops/tadpoles are supported.

```julia
using GraphCombinations

graphs = allgraphs([2, 0, 0, 2])
```

`allgraphs` returns `(edges, S)` pairs, where `edges` is a canonical `Vector{Pair{Int,Int}}` representation and `S::BigInt` is the exact symmetry denominator of the topology.

The production generator enumerates degree-constrained multigraphs directly instead of first constructing all Wick pairings. It uses a hybrid exact reduction strategy: low-redundancy inputs canonicalize completed graphs directly, while larger internal relabeling sectors quotient isomorphic partial states at completed multiplicity-row boundaries. Public representatives, result ordering, and symmetry denominators remain deterministic and exact. A brute-force Wick implementation is retained internally as a small-system correctness oracle.

The package is heavily inspired by [this Mathematica StackExchange post](https://mathematica.stackexchange.com/questions/170268/how-to-generate-all-feynman-diagrams-with-mathematica) by AccidentalFourierTransform. A Mathematica notebook based on that approach is available in the [examples folder](https://github.com/oameye/GraphCombinations.jl/tree/main/examples).
