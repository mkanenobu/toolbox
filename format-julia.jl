#!/usr/bin/env -S julia --startup-file=no -O1

using JuliaFormatter

target = "."

@debug ARGS
if length(ARGS) > 0
  target = ARGS[1]
end

exit(format_file(target, verbose=true) ? 0 : 1)
