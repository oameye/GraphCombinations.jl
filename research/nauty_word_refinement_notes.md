# #167 experiment A: word-sized refinement

This branch changes no production source.

The probe holds the #165 search tree fixed and replaces only the refinement representation for simple directed graphs with at most 64 vertices:

- outgoing/incoming adjacency rows are packed into `UInt64`;
- each current color cell is represented by one `UInt64` mask;
- directed refinement counts are computed by `count_ones(row & cell_mask)`;
- signature ordering, smallest-cell individualization, exact-twin pruning, leaf comparison, witness construction, and automorphism accumulation otherwise mirror #165.

The first acceptance gate is literal agreement with the current GC canonical graph, canonical witness, and exact automorphism order over every 3-vertex simple directed graph under three representative color partitions. Performance is reported separately for the warmed canonicalization kernel and the complete operation including packed-row loading.

This is intentionally narrower than the full nauty `refine1` design. If packed full-signature refinement is not sufficient, the next experiment is active-splitter incremental refinement while preserving the same exact ordered partition semantics.
