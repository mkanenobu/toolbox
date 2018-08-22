#!/bin/bash
### Switch compiler for each file type

source_file="$1"
file_extension="$(echo "$source_file" | sed 's/^.*\.\([^\.]*\)$/\1/')"
options="${@:2}"

case "$file_extension" in
  "nim" ) nim c "$1";;
  "pas" ) fpc "$1";;
  "cl" | "lisp" ) lc "$1";;
  * ) echo "File is not supported";;
esac
