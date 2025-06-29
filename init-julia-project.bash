#!/usr/bin/env bash

set -Ceu

if [ -z "$1" ]; then
  echo "Error: Specify project name" >&2
  exit 1
fi
module_name="${1}"

julia --eval "using Pkg; Pkg.generate(\"${module_name}\")"

cat > "${module_name}/Makefile" <<EOF
module_name := ${module_name}

.DEFAULT_GOAL := all

.PHONY: all setup run fmt

all: setup build

setup:
	julia --project=. pkg.jl

run:
	@julia --project=. --eval "using \$(module_name); \$(module_name).main()"

fmt:
	@julia --project=. --eval 'using JuliaFormatter; JuliaFormatter.format(".", verbose=true)'

EOF

cat > "${module_name}/.editorconfig" <<EOF
root = true

[*]
end_of_line = lf
insert_final_newline = true

[*.zig]
indent_style = space
indent_size = 2

EOF

cat > "${module_name}/pkg.jl" <<EOF
using Pkg

Pkg.activate(@__DIR__)

pkgs = [
]

for pkg in pkgs
  Pkg.add(pkg)
end

Pkg.instantiate()

EOF

cat > "${module_name}/src/${module_name}.jl" <<EOF
module ${module_name}

main() = begin
  println("Hello World!")
end

end # module ${module_name}

EOF
