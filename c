#!/bin/bash
### Switch compiler for each file type

set -Ceu

if [ "$#" -eq 0 ]; then
  echo "usage: c {OPTIONS} [SOURCE_FILE]"
  exit 1
fi

source_file="${!#}"
options="${@:1:$#-1}"
file_extension="$(echo "${source_file}" | sed 's/^.*\.\([^\.]*\)$/\1/')"
compiler=""

if [ ! -e "${source_file}" ]; then
  echo "File is not found"
  echo "usage: c [OPTIONS] [SOURCE_FILE]"
  exit 1
fi

if [ "$(uname)" == "Darwin" ]; then
  c_compiler="clang"
  cpp_compiler="clang++"
else
  c_compiler="gcc"
  cpp_compiler="g++"
fi

scheme_compiler="csc"
sbcl_compiler(){
  echo '(compile-file (nth 1 sb-ext:*posix-argv*))' | sbcl "${source_file}" && \
    chmod +x "$(echo "${source_file}" | sed -e "s/\.\(lisp\|cl\)/\.fasl/")"
}

# user_setting="${XDG_CONFIG_HOME}/compile/user_setting"
# if [ -e "${user_setting}" ]; then
#   source "${user_setting}"
# fi

# User setting
c_compiler="clang"
cpp_compiler="clang++"


case "${file_extension}" in
  "c"   ) compiler="$c_compiler" ;;
  "cpp" ) compiler="$cpp_compiler" ;;
  "go"  ) compiler="go build" ;;
  "rs"  ) compiler="rustc" ;;
  "hs"  ) compiler="ghc" ;;
  "ml"  ) compiler="ocamlopt" ;;
  "nim" ) compiler="nim c" ;;
  "pas" ) compiler="fpc" ;;
  "ros" ) compiler="ros build" ;;
  "scm" ) compiler="$scheme_compiler" ;;
  "rkt" ) compiler="raco exe" ;;
  "ts"  ) compiler="tsc" ;;
  "cl" | "lisp" ) compiler="sbcl_compiler" ;;
  * ) echo "File is not supported"; exit 1 ;;
esac

if [ -n "${compiler}" ]; then
  eval "${compiler} ${options} ${source_file}"
fi
