CI = get(ENV, "CI", nothing) == "true" || get(ENV, "GITHUB_TOKEN", nothing) !== nothing

using GraphCombinations
using Documenter

include("pages.jl")

# The README.md file is used index (home) page of the documentation.
if CI
    include("make_md_examples.jl")
    cp(
        normpath(@__FILE__, "../../README.md"),
        normpath(@__FILE__, "../src/index.md");
        force=true,
    )
else
    nothing
end
# ^ when using LiveServer, this will generate a loop

makedocs(;
    sitename="GraphCombinations.jl",
    authors="Orjan Ameye",
    modules=GraphCombinations,
    format=Documenter.HTML(; canonical="https://oameye.github.io/GraphCombinations.jl"),
    pages=pages,
    clean=true,
    linkcheck=true,
    warnonly=[:missing_docs, :linkcheck],
    draft=false,#,(!CI),
    doctest=false,  # We test it in the CI, no need to run it here
    checkdocs=:exports,
)

if CI
    deploydocs(;
        repo="github.com/oameye/GraphCombinations.jl",
        devbranch="main",
        target="build",
        branch="gh-pages",
        push_preview=true,
    )
end
