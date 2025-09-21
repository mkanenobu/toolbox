#!/usr/bin/env bash

# Usage: ./giffy.sh input.mov

set -Ceu

if [ $# -lt 1 ]; then
  echo "Usage: $0 input.mov"
  exit 1
fi

input="$1"
output="${input%.*}.gif"

max_colors=128
fps=10

ffmpeg -y -i "$input" -filter_complex \
    "fps=${fps},scale=iw/2:-1:flags=lanczos,split [a][b];
     [a]palettegen=stats_mode=single:max_colors=${max_colors}[p];
     [b][p]paletteuse=dither=sierra2_4a" \
    "$output"

