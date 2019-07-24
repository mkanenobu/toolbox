#!/bin/bash
### Switch compiler for each file type

# WIP

set -Ceu

VERSION="0.1.0"

usage_text="USAGE: c [COMPILER_OPTIONS] [SOURCE_FILE]"

if [ "$#" -eq 0 ]; then
  echo "${usage_text}"
  exit 1
fi

if [[ $1 =~ (-|--)(h|help) ]]; then
  echo "${usage_text}"
  exit 0
elif [[ $1 =~ (-|--)(v|version) ]]; then
  echo "Version: ${VERSION}"
  exit 0
fi

source_file="${!#}"
options="${@:1:$#-1}"
file_extension="$(echo "${source_file}" | sed 's/^.*\.\([^\.]*\)$/\1/')"
filename_without_extension="${source_file%.*}"
compiler=""
compile_argument=""
compiler_not_found="false"

if [ ! -e "${source_file}" ]; then
  echo "Source file is not found" 1>&2
  echo "${usage_text}"
  exit 1
fi

sbcl_compiler(){
  echo '(compile-file (nth 1 sb-ext:*posix-argv*))' | sbcl "${source_file}" && \
    chmod +x "$(echo "${source_file}" | sed -e "s/\.\(lisp\|cl\)/\.fasl/")"
}

# Haskell (exists stask?)
[ "$(type stack)" ] && compile_argument="ghc --"; haskell_compiler="stack" \
  || [ "$(type ghc)" ] && haskell_compiler="ghc" \
  || compiler_not_found="true"

# remove when compile finished
middle_file_extensions=""

case "${file_extension}" in
  "c"   ) compiler="$( \
             [ "$(type clang)" ] && "clang" \
          || [ "$(type gcc)" ] && "gcc" \
          || "cc")"
    options="${options} -o ${filename_without_extension}" ;;
  "cpp" ) compiler="$( \
             [ "$(type clang++)" ] && "clang++" \
          || [ "$(type g++)" ] && "g++" \
          || "c++")"
    options="${options} -o ${filename_without_extension}" ;;
  "d"   ) compiler="$( \
             [ "$(type dmd)" ] && "dmd" \
          || [ "$(type gdc)" ] && "gdc" \
          || [ "$(type ldc)" ] && "ldc" \
          || compiler_not_found="true")";;
  "go"  ) compiler="go"; compile_argument="build" ;;
  "rs"  ) compiler="rustc" ;;
  "hs"  ) compiler="${haskell_compiler}" \
    middle_file_extensions="hi";;
  "ml"  ) compiler="ob" ;;
    # options="${options} -o ${filename_without_extension}" ;;
    # middle_file_extensions="cmi cmx" ;;
  "nim" ) compiler="nim"; compile_argument="c" ;;
  "pas" ) compiler="fpc" \
    middle_file_extensions="o" ;;
  "kt"  ) compiler="kotlinc" ;;
  "zig" ) compiler="zig"; compile_argument="build-exe"  ;;
  "scm" ) compiler="csc" ;;
  "rkt" ) compiler="raco"; compile_argument="exe" ;;
  "ts"  ) compiler="tsc" ;;
  "cl" | "lisp" ) compiler="sbcl_compiler" ;;
  * ) echo "Filetype is not supported" 1>&2; exit 2 ;;
esac

if [ "${compiler_not_found}" == "true" ]; then
  echo "Compiler (${compiler}) is not found"
  exit 3
fi

if [ -n "${compiler}" ]; then
  exec_command="${compiler} ${compile_argument} ${options} ${source_file}"
  eval "${exec_command}"
fi

if [ -e "${filename_without_extension}.o" ]; then
  rm "${filename_without_extension}.o"
fi

for extension in ${middle_file_extensions}; do
  if [ -e "${filename_without_extension}.${extension}" ]; then
    rm "${filename_without_extension}.${extension}"
  fi
done

