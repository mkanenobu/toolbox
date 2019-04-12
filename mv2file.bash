#!/usr/bin/env bash
set -Ceu

if type fzf >/dev/null ; then
  dir="$(fzf)"
  if [ -n "${dir}" ]; then
    cd "$(dirname ${dir})" || :
  fi
fi
