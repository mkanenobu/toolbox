#!/bin/bash
### Switch compiler for each file type

set -Ceu

usage_text="USAGE: c [COMPILER_OPTIONS] [SOURCE_FILE]"
if [ "$#" -eq 0 ]; then
  echo "${usage_text}"
  exit 1
fi

if [[ $1 =~ (|-|--)help ]]; then
  echo "${usage_text}"
  exit 0
fi

source_file="${!#}"
options="${@:1:$#-1}"
file_extension="$(echo "${source_file}" | sed 's/^.*\.\([^\.]*\)$/\1/')"
filename_without_extension="${source_file%.*}"
# no_extension="$(echo "${source_file}" | )"
compiler=""

if [ ! -e "${source_file}" ]; then
  echo "File is not found" 1>&2
  echo "${usage_text}"
  exit 1
fi

scheme_compiler="csc"
sbcl_compiler(){
  echo '(compile-file (nth 1 sb-ext:*posix-argv*))' | sbcl "${source_file}" && \
    chmod +x "$(echo "${source_file}" | sed -e "s/\.\(lisp\|cl\)/\.fasl/")"
}
[ "$(which clang)" ] && c_compiler="clang" || c_compiler="gcc"
[ "$(which clang++)" ] && cpp_compiler="clang++" || cpp_compiler="g++"
[ "$(which stack)" ] && haskell_compiler="stack ghc -- " || haskell_compiler="ghc"

# user_setting="${XDG_CONFIG_HOME}/compile/user_setting"
# if [ -e "${user_setting}" ]; then
#   source "${user_setting}"
# fi

c_compiler="clang"
cpp_compiler="clang++"
d_compiler="gdc"
middle_file_extensions=""

case "${file_extension}" in
  "c"   ) compiler="$c_compiler" \
    options="${options} -o ${filename_without_extension}" ;;
  "cpp" ) compiler="$cpp_compiler" \
    options="${options} -o ${filename_without_extension}" ;;
  "d"   ) compiler="$d_compiler" ;;
  "go"  ) compiler="go build" ;;
  "rs"  ) compiler="rustc" ;;
  "hs"  ) compiler="${haskell_compiler}" \
    middle_file_extensions="hi";;
  "ml"  ) compiler="ob" ;;
    # options="${options} -o ${filename_without_extension}" ;;
    # middle_file_extensions="cmi cmx" ;;
  "nim" ) compiler="nim c" ;;
  "pas" ) compiler="fpc" \
    middle_file_extensions="o" ;;
    "zig" ) compiler="zig -c" ;;
  "ros" ) compiler="ros build" ;;
  "scm" ) compiler="$scheme_compiler" ;;
  "rkt" ) compiler="raco exe" ;;
  "ts"  ) compiler="tsc" ;;
  "cl" | "lisp" ) compiler="sbcl_compiler" ;;
  * ) echo "File is not supported" 1>&2; exit 2 ;;
esac

if [ -n "${compiler}" ]; then
  eval "${compiler} ${options} ${source_file}"
fi

if [ -e "${filename_without_extension}.o" ]; then
  rm "${filename_without_extension}.o"
fi

for extension in ${middle_file_extensions}; do
  if [ -e "${filename_without_extension}.${extension}" ]; then
    rm "${filename_without_extension}.${extension}"
  fi
done

