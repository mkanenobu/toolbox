#!/usr/bin/env bash

set -Ceu

git fetch --prune 2>&1 >/dev/null
target_branches="$(git branch --remotes | awk '{print $1}' | egrep --invert-match --file /dev/fd/0 <(git branch -vv | grep origin | grep --invert-match '*') | awk '{print $1}')"

if [ -z "${target_branches}" ]; then
  echo "No branches to delete."
  exit 0
fi

echo "target branches:"
echo "${target_branches}"

read -p "Delete branches? (y/N): " yn
case "$yn" in
  [yY]*) ;;
  *) exit 0;;
esac

echo ${target_branches} | xargs git branch --delete --force

