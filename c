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

sbcl_compiler() {
  echo '(compile-file (nth 1 sb-ext:*posix-argv*))' | sbcl "${source_file}" && \
    chmod +x "$(echo "${source_file}" | sed -e "s/\.\(lisp\|cl\)/\.fasl/")"
}

exists_compiler() {
  suggested_compilers="$*"
  for compiler in ${suggested_compilers}; do
    type "${compiler}" 1>/dev/null 2>/dev/null
    exists=$?
    if [ "${exists}" -eq 0 ]; then
      echo -n "${compiler}"
      break
    fi
  done
}

# remove when compile finished
middle_file_extensions=""

case "${file_extension}" in
  "c"   )
    compiler="$(exists_compiler "clang gcc cc")"
    options="${options} -o ${filename_without_extension}"
    ;;
  "cpp" )
    compiler="$(exists_compiler "clang++ g++ c++")"
    options="${options} -o ${filename_without_extension}"
    ;;
  "d"   )
    compiler="$(exists_compiler "dmd gdc ldc")"
    ;;
  "go"  )
    compiler="go"
    compile_argument="build"
    ;;
  "rs"  )
    compiler="rustc"
    ;;
  "hs"  )
    # exists stask?
    [ "$(type stack 1>/dev/null 2>/dev/null)" ] && compile_argument="ghc"; haskell_compiler="stack" \
    || [ "$(type ghc 1>/dev/null 2>/dev/null)" ] && haskell_compiler="ghc"

    if [ -n "${options}" ]; then
      # give options to ghc (not to stack)
      compile_argument="${compile_argument} -- "
    fi
    compiler="${haskell_compiler}"
    middle_file_extensions="hi"
    ;;
  "ml"  )
    compiler="ob_bash"
    # options="${options} -o ${filename_without_extension}"
    # middle_file_extensions="cmi cmx"
    ;;
  "nim" )
    compiler="nim"
    compile_argument="c"
    ;;
  "pas" )
    compiler="fpc"
    middle_file_extensions="o"
    ;;
  "kt"  )
    compiler="kotlinc"
    ;;
  "scm" )
    compiler="csc"
    ;;
  "rkt" )
    compiler="raco"
    compile_argument="exe"
    ;;
  "ts"  )
    compiler="tsc"
    ;;
  "cl" | "lisp" )
    compiler="sbcl_compiler"
    ;;
  * ) echo "Filetype is not supported" 1>&2; exit 2 ;;
esac

if [ -n "${compiler}" ]; then
  exec_command="${compiler} ${compile_argument} ${options} ${source_file}"
  echo "${exec_command}"
  eval "${exec_command}"
else
  echo "Compiler not found"
  exit 3
fi

if [ -e "${filename_without_extension}.o" ]; then
  rm "${filename_without_extension}.o"
fi

for extension in ${middle_file_extensions}; do
  if [ -e "${filename_without_extension}.${extension}" ]; then
    rm "${filename_without_extension}.${extension}"
  fi
done

