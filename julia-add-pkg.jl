#!/usr/bin/env -S julia --project
using Pkg

args = ARGS

if length(args) < 1
    println(stdout, "Specify pkg name.")
    exit(1)
end

Pkg.add(args[1])