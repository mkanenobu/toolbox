#!/bin/bash
### Switch compiler for each file type

source_file="${!#}"
options="${@:1:$#-1}"
file_extension="$(echo "${source_file}" | sed 's/^.*\.\([^\.]*\)$/\1/')"

if [ "$(uname)" == "Darwin" ]; then
  c_compiler="clang"
  cpp_compiler="clang++"
elif [ "$(uname)" == "Linux" ]; then
  c_compiler="gcc"
  cpp_compiler="g++"
fi

compiler=""

case "${file_extension}" in
  "c"   ) compiler="${c_compiler}" ;;
  "cpp" ) compiler="${cpp_compiler}" ;;
  "go"  ) compiler="go tool compile" ;;
  "rs"  ) compiler="rustc" ;;
  "nim" ) compiler="nim c" ;;
  "pas" ) compiler="fpc" ;;
  "cl" | "lisp" ) compiler="lc" ;;
  * ) echo "File is not supported";;
esac

if [ -n "${compiler}" ]; then
  eval "${compiler} ${options} ${source_file}"
fi
