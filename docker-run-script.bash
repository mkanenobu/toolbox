#!/usr/bin/env bash

if [ -z "${1}" ] || [ -z "${*:2}" ]; then
  echo "script [IMAGE] ARGS"
  exit 1
fi

image="${1}"
docker run -it --rm --name running-script \
  -v "$PWD":/usr/src/app \
  -w /usr/src/app "${image}" "${@:2}"
