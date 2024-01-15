#!/usr/bin/env bash

target_branches="$(git fetch -p ; git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}')"

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

echo ${target_branches} | xargs git branch -D

