#!/bin/sh

# Utility for branch swither

if [ "$1" = "show" ]; then
  :
fi

git fetch || exit 1
target_branch="$(git branch -a | peco)"
if [ "$(echo "$target_branch" | cut -d '/' -f 1)" = "  remotes" ]; then
  git checkout -t "$(echo "$target_branch" | sed -e "s/\ \ remotes\///")"
else
  git checkout "$(echo "$target_branch" | sed -e "s/\ \ //")"
fi
