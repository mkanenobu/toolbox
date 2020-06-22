import os

let args = commandLineParams()

if args.len == 0:
  quit 1

let file = args[0]

if not existsFile(file) and not existsDir(file):
  quit 2

echo absolutePath(file)