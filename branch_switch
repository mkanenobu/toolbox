#!/usr/bin/env bash

dest_branch="$(git branch -a | fzf)"
dest_branch="${dest_branch//\ /}"

if [[ "${dest_branch}" =~ \* ]]; then
  echo "Already in the branch"
fi

echo "Checkout to ${dest_branch}"

if [[ "${dest_branch}" =~ remotes ]]; then
  git checkout -b "${dest_branch//remotes\/origin\//}" "${dest_branch//remotes\//}"
elif [[ "${dest_branch}" =~ \* ]]; then
  echo "Already in the branch"
else
  git checkout "${dest_branch}"
fi
