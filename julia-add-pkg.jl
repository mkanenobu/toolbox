#!/bin/bash
#=
exec julia --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
=#
import Pkg

args = ARGS

if length(args) < 1
    println(stdout, "Specify pkg name.")
    exit(1)
end

Pkg.add(args[1])
