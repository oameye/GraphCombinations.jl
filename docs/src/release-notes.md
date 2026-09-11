# Release notes

## v0.2.0

GraphCombinations v0.2.0 is a substantial rewrite of the graph-generation and canonicalization core while preserving the compact `allgraphs(n)` interface and deterministic public graph representatives.

### User-visible changes

- `allgraphs` no longer mutates its input vertex specification.
- Symmetry denominators are returned exactly as `BigInt` values instead of `Float64` values.
- `build_graph` preserves sparse vertex labels, parallel-edge multiplicities, and self-loops exactly and validates explicit vertex bounds.
- Edge representations use `Pair{Int,Int}` with canonical endpoints `a <= b`; self-loops are represented as `a => a`.
- Output topology ordering remains deterministic after canonical reduction.

The `Float64` to `BigInt` symmetry-denominator change is the main API compatibility boundary in this release. Code that explicitly requires floating-point symmetry factors should convert them at the use site.

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
