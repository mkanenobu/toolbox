#!/usr/bin/env bash

target="${1}"

if [ -z "${target}" ]; then
  echo "Specify compress target"
  exit 1
fi

tar cvjf "${target}.tar.bz2" "${target}"
