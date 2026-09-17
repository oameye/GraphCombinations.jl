# Release notes

## v0.5.0

GraphCombinations v0.5.0 extends the exact directed-canonicalization backend with capacity-sized reusable input storage and two exact individualization/refinement search optimizations. The release is additive and was driven by production integration in KeldyshContraction.jl.

### Reusable capacity API

The directed hot path now supports one reusable allocation sized for the largest graph in a workload:

- `DirectedGCGraphBuffer(capacity)` owns mutable directed-multiplicity input scratch;
- `load_directed_graph!` reloads `Pair` or `(source, target)` edge vectors at any active size up to capacity;
- `DirectedCanonicalizationWorkspace(capacity)` and `DirectedCanonicalizationBuffer(capacity)` accept active graphs smaller than their allocation capacity;
- `canonicalize_directed!` consumes the mutable input buffer directly, so downstream packages no longer need to mutate `DirectedGCGraph` internals or maintain per-size workspace caches.

The immutable `DirectedGCGraph` remains the hashable/value representation. The mutable buffer is explicitly scratch storage for repeated hot-path use.

### Exact directed search improvements

The production individualization/refinement search now chooses the smallest non-singleton refined color cell, with deterministic ties from canonical color order. This reduces unnecessary branching without changing canonical semantics.

The search also quotients branches related by a proven exact twin transposition automorphism. Two vertices are treated as twins only when exchanging them preserves the complete directed multiplicity graph and they lie in the same current target cell. One representative branch is visited for each exact twin class, while checked branch multiplicity is propagated to leaves so the exact color-preserving automorphism order is unchanged.

A dedicated regression verifies that four same-color edgeless twins collapse to one visited leaf while retaining automorphism order `4! = 24`. Canonical graph comparison and relabeling-witness semantics remain unchanged.

### Certification

The reusable-workspace suite is now wired directly into normal package tests. Allocation assertions are additionally exercised in an explicit Julia 1.13 no-coverage lane because coverage instrumentation itself allocates on newer Julia versions.

The release candidate is green on Julia LTS, 1.12, and 1.13, including static analysis, exact workspace/reference agreement, changing active graph sizes, automorphism-order certification, zero-allocation warmed input/canonicalization paths, formatting, and spell checking.

### Downstream acceptance

KeldyshContraction.jl retains Nauty as an independent oracle and switches only its dummy-loop momentum canonicalization candidate. On the exact final v0.5.0 candidate, the downstream acceptance fixture measured:

- two-loop full quotient: 248.52 μs with GC versus 838.46 μs with Nauty (`0.296x`), with memory ratio `0.687x`;
- two-loop warmed canonical-transform sweep: `0.204x` Nauty;
- four-loop full quotient: 884.25 μs with GC versus 1847.18 μs with Nauty (`0.479x`), with memory ratio `0.634x`;
- four-loop warmed canonical-transform sweep: 609.9 μs with GC versus 1498.08 μs with Nauty (`0.407x`).

The exact downstream GC/Nauty semantic oracle passes `4 / 4`. The migration remains selective: physical one-shot propagator canonicalization and historical topology-numbering compatibility stay on Nauty.

### Compatibility

v0.5.0 is an additive minor release. Existing users should not need code changes. Consumers requiring the reusable capacity-sized directed input API should depend on `GraphCombinations = "0.5"`.

## v0.4.0

GraphCombinations v0.4.0 adds exact colored directed multigraph canonical labeling with a reusable allocation-free production workspace. The API is additive; existing scalar and weighted colored-port interfaces are unchanged.

### Directed canonicalization API

The release adds:

- `DirectedGCGraph` for exact directed multigraphs with loops and repeated-edge multiplicity;
- `canonicalize_directed` for allocating exact canonicalization;
- `DirectedCanonicalizationWorkspace` and `DirectedCanonicalizationBuffer` together with `canonicalize_directed!` for repeated warmed canonicalization;
- `canonical_graph` and `canonical_automorphism_order` for the canonical image and exact color-preserving automorphism order;
- `canonical_rank` and `original_vertex` for both directions of the canonical relabeling witness.

Vertex colors are opaque labels. Canonical vertex numbers are combinatorial coordinates rather than consumer semantics; downstream packages must transport their own meaning through the returned witness.

### Exactness and production architecture

The production kernel uses deterministic exact individualization/refinement with flat reusable workspace storage and direct canonical-image comparison. It supports direction, self-loops, repeated directed edges, fixed vertices through unique colors, repeated color cells, and disconnected graphs.

The optimized workspace implementation is checked exhaustively against the independent allocating/reference canonicalizer over all 512 simple directed graphs on three vertices and multiple color partitions, including exact witness and automorphism-order agreement. Public hot entry points remain inferred and covered by the package DispatchDoctor/JET gates.

### Performance and downstream acceptance

Prepared workspaces permit zero warmed heap allocations on the certified production path. Permanent benchmark coverage includes tiny colored graphs, directed and bidirectional cycles, almost-discrete colorings, fixed vertices, loops and multiplicity, disconnected graphs, subdivision-style graphs, repeated-color cells, high-symmetry graphs, and scaling series.

The first external acceptance corpus is KeldyshContraction.jl. On its certified loop-canonicalization workloads, the final v0.4.0 candidate measured approximately 16.65 μs versus 275.89 μs for Nauty at two loops, and 93.9 μs versus 523.9 μs at four loops, with the GC workspace at zero warmed allocations. The same downstream gate verifies all 384 signed four-loop coordinate spellings and representative bosonic and fermionic collision semantics.

The migration decision is intentionally selective: workloads that do not meet the strict parity-or-better performance rule remain on their existing backend.

### Compatibility

v0.4.0 is an additive minor release. Existing users should not need code changes. Consumers requiring the new directed canonicalization workspace should depend on `GraphCombinations = "0.4"`.

## v0.3.0

GraphCombinations v0.3.0 adds the production weighted colored-port backend and freezes a public downstream integration boundary for diagram engines that require directed, typed half-edge matching. The existing scalar `allgraphs` API and its exact graph semantics are unchanged.

### Weighted colored-port API

The release adds the following public building blocks:

- `ColoredPortProblem` for concrete directed colored-port matching problems;
- `generate_weighted` and `generate_weighted_with_stats` for exact canonical weighted completions;
- `PortGenerationStats` and `generation_statistics` for traversal diagnostics;
- `ColoredPortState` plus state accessors for consumer policies;
- deterministic `PortRelabeling` witnesses together with `canonical_relabeling` and `relabel_port_state`;
- `AcceptAllPortPolicy` and a concrete policy interface for generic monotone pruning;
- `MultiplicityPortTransport`, `initial_port_weight`, and `transport_port_weight` as the weight-transport extension point for signed or graded consumers.

The API is additive. No v0.2 scalar public interface is removed or reinterpreted.

### Exact search architecture

Weighted generation uses residual source/target port counts to remove ordering redundancy of indistinguishable port occurrences. When the pair-local admissibility relation has a nontrivial admissibility-preserving vertex automorphism group, partial states are additionally quotiented under that group. Fixed external vertices remain fixed, and exact labelled multiplicities are accumulated as `BigInt`.

A consumer pruning policy may reject a child before canonicalization only when rejection is invariant under the same admissibility-preserving relabelings and monotone under extension. The default `AcceptAllPortPolicy` selects the ordinary unpruned traversal exactly.

### Relabeling and signed consumers

`PortRelabeling` is a domain-neutral witness from a raw state to its canonical representative. Custom weight transport runs after canonicalization but before orbit-equivalent contributions are accumulated. This allows a downstream package to transform its own signed or graded representation and permits exact cancellation of contributions without moving sign semantics into GraphCombinations itself.

GraphCombinations does not define fermionic, Wick, Keldysh, causal, or other domain-specific rules. Those remain the responsibility of consuming packages.

### Validation and performance evidence

The weighted backend is tested against fully labelled brute-force matching oracles on small problems, including repeated ports, fixed external vertices, asymmetric pair-local admissibility, exact continuation-state merging, relabeling witnesses, pruning identity, and exact multiplicity conservation.

A KeldyshContraction research adapter using only the public GC boundary reproduces the existing bosonic canonical-weight oracle for `γ`, `g²`, `γ²`, mixed `gγ`, `g³`, and `g⁴`. Representative warmed matcher measurements from that integration gave about 2.89x speedup at `g³` and 7.01x at `g⁴`, with allocation reductions of about 2.19x and 5.42x respectively. These downstream measurements are validation evidence, not performance guarantees for the public API.

The public weighted path has dedicated benchmark coverage, and the release gate retains Julia LTS/current tests, documentation, formatting, spell checking, coverage, and benchmark tracking.

### Compatibility

v0.3.0 is an additive minor release. Existing users of scalar graph generation should not need code changes. Downstream consumers that require the new weighted colored-port API should depend on `GraphCombinations = "0.3"` rather than an unreleased `main` revision.

## v0.2.0

GraphCombinations v0.2.0 is a substantial rewrite of the graph-generation and canonicalization core while preserving the compact `allgraphs(n)` interface and deterministic public graph representatives.

### User-visible changes

- `allgraphs` no longer mutates its input vertex specification.
- Symmetry denominators are returned exactly as `BigInt` values instead of `Float64` values.
- `build_graph` preserves sparse vertex labels, parallel-edge multiplicities, and self-loops exactly and validates explicit vertex bounds.
- Edge representations use `Pair{Int,Int}` with canonical endpoints `a <= b`; self-loops are represented as `a => a`.
- Output topology ordering remains deterministic after canonical reduction.

The `Float64` to `BigInt` symmetry-denominator change is the main API compatibility boundary in this release. Code that explicitly requires floating-point symmetry factors should convert at the use site.

### Generation and canonicalization

Production graph generation now enumerates degree-constrained multigraphs directly through residual degrees and edge multiplicities rather than materializing every Wick pairing first. The former Wick implementation is retained internally as a small-system correctness oracle.

Generation uses a hybrid exact reduction strategy. Low-redundancy inputs use completed-graph reduction directly. Once the degree-preserving internal relabeling factor is large enough to amortize the reduction cost, production quotients isomorphic partial states at completed multiplicity-row boundaries. The state key includes fixed external labels, target degree information, and the closed/open row frontier, so only partial graphs with equivalent continuation spaces are merged.

Partition-canonical keys are internal equality keys, not a new public labeling convention. Surviving row-reduced graphs are converted to the established public canonical `GraphRep` by traversing the same exact internal-label permutation orbit and comparing mapped edge multiplicities directly. This avoids rebuilding and sorting an edge vector for every permutation while preserving byte-for-byte public representatives. Public `canonical_form` and the direct generator retain the independent in-place edge-list implementation as a reference path.

The package supports parallel edges, self-loops/tadpoles, fixed degree-1 external vertices, connected or disconnected generation, and quotienting over degree-preserving internal vertex relabelings.

### Performance

Representative certified Julia LTS benchmarks for scalar `phi^4` two-point topologies on the final v0.2.0 release candidate are approximately:

| interaction order | production `allgraphs` time |
| ---: | ---: |
| 2 | 13 us |
| 3 | 112 us |
| 4 | 1.56 ms |
| 5 | 12.85 ms |

At order 5, the row-reduced production path uses about 24.6 MB and 299k allocations. Before the generation/canonicalization optimization series, the same workload was roughly 1.67 s, 3.50 GB, and 25.6 million allocations. The direct degree-constrained generator also avoids constructing the 13,749,310,575 Wick pairings associated with this case.

The final canonical-label conversion itself is about 6.2x faster at five internal vertices than the retained in-place edge-list implementation (about 2.84 us versus 17.47 us on the release benchmark runner).

These figures are benchmark references rather than API guarantees. Exact isomorphism reduction remains combinatorial at sufficiently high order; profiling at orders 6-7 is retained as guidance for future optimization work rather than as a supported performance bound.

### Validation

The v0.2.0 implementation is covered by an independent Wick reference oracle over a systematic small-degree domain. Tests verify exact topology classes, public canonical representatives, symmetry denominators, automorphism-based identities, connected/disconnected sectors, loops, parallel edges, fixed external labels, and reconstruction of the full Wick pairing count. Julia LTS and the current Julia test lane, documentation, formatting, spell checking, and benchmark tracking form the release gate.
