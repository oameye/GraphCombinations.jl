# # Phi-Four Theory Feynman Diagram Topologies
#
# This example demonstrates how to compute the unique, connected Feynman diagram topologies
# for a scalar phi-four theory using the `GraphCombinatorics.jl` package.
#
# In phi-four theory, the interaction vertex has degree 4. External lines correspond
# to vertices of degree 1.
#
# We will compute the topologies for the first two orders of the theory involving
# two external particles.

# ## Setup
using GraphCombinatorics, Plots, GraphRecipes

# #+ First Order Calculation (n = [2, 0, 0, 1])
# This corresponds to 2 external legs (degree 1) and 1 interaction vertex (degree 4).

n1 = [2, 0, 0, 1]
topologies_order1 = allgraphs(n1)
diagram, symmetry_factor = first(topologies_order1)

graphplot(diagram, markersize=0.05, markercolor=:black, nodeshape=:circle)

# #+ Second Order Calculation (n = [2, 0, 0, 2])
# This corresponds to 2 external legs (degree 1) and 2 interaction vertices (degree 4).
n2 = [2, 0, 0, 2]
println("Calculating topologies for n = ", n2)
topologies_order2 = allgraphs(n2)
