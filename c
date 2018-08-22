#!/bin/bash
### Switch compiler for each file type

source_file="$1"
file_extension="$(echo "$source_file" | sed 's/^.*\.\([^\.]*\)$/\1/')"

case "$file_extension" in
  "nim" ) nim c "$1";;
  "pas" ) fpc "$1";;
  "cl" | "lisp" ) sbcl_compile "$1";;
  * ) echo "Not in the list";;
esac
