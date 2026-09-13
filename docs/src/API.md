```@meta
CollapsedDocStrings = true
```

# API

```@contents
Pages = ["API.md"]
Depth = 2:3
```

```@docs
GraphCombinations
```

## Scalar graph generation

```@docs
allgraphs
DegreeSequenceProblem
TypedMultigraphProblem
generate_multigraphs
vertex_degrees
vertex_colors
edge_admissibility
fixed_vertex_count
build_graph
combinatoric_factor
total_degree
canonical_form
```

## Weighted colored-port generation

### Types

```@docs
ColoredPortEdge
ColoredPortProblem
ColoredPortState
PortRelabeling
WeightedPortCompletion
PortGenerationStats
AcceptAllPortPolicy
MultiplicityPortTransport
```

### Generation and state inspection

```@docs
generate_weighted
generate_weighted_with_stats
generation_statistics
canonical_relabeling
relabel_port_state
port_edges
source_port_counts
target_port_counts
```

### Custom weight transport

```@docs
initial_port_weight
transport_port_weight
```

## Private

### Types

```@docs
GraphCombinations.MultigraphWrap
```

### Functions

```@docs
GraphCombinations.sort_graph_edges
```
