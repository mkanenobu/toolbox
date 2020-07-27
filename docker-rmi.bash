#!/usr/bin/env bash

target="$(docker images | tail -n +2 | awk '{ print $1 ":" $2 }' | fzf)"
docker rmi "${target}"
