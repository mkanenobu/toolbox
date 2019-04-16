#!/usr/bin/env bash

generate_file=$(basename "$(pwd)" | sed -e "s/\$/.m3u/g")

if [ -e "${generate_file}" ]; then
  exit 1
fi

if [ ! -d "../$(basename "$(pwd)")" ]; then
  exit 2
fi

echo '#EXTM3U' >> "$generate_file"
playlist="$(find . -type f | sort -h | grep -E "*.(wav|mp3|flac|ogg)")"
echo "${playlist}" >> "$generate_file"
