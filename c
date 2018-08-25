#!/bin/bash
### Switch compiler for each file type

if [ -z "$#" ]; then
  echo "usage: c [OPTIONS] [SOURCE_FILE]"
  exit 1
fi

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

sbcl_compile(){
  echo '(compile-file (nth 1 sb-ext:*posix-argv*))' | sbcl "${1}" && \
    chmod +x "$(echo "${1}" | sed -e "s/\.\(lisp\|cl\)/\.fasl/")"
}


case "${file_extension}" in
  "c"   ) compiler="${c_compiler}" ;;
  "cpp" ) compiler="${cpp_compiler}" ;;
  "go"  ) compiler="go build" ;;
  "rs"  ) compiler="rustc" ;;
  "hs"  ) compiler="ghc" ;;
  "ml"  ) compiler="ocamlopt" ;;
  "nim" ) compiler="nim c" ;;
  "pas" ) compiler="fpc" ;;
  "cl" | "lisp" ) compiler="sbcl_compile" ;;
  * ) echo "File is not supported"; exit 1 ;;
esac

if [ -n "${compiler}" ]; then
  eval "${compiler} ${options} ${source_file}"
fi
