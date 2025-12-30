#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <file1> [file2 ...]" >&2
  exit 1
fi

exiftool -csv \
  -DateTimeOriginal \
  -FileSize \
  -Make \
  -Model \
  -ImageSize \
  -ISO \
  -ShutterSpeed \
  -Aperture \
  -FocalLength \
  -PictureMode \
  -AFMode \
  -LensMake \
  -LensModel \
  "$@"
