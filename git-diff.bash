#!/usr/bin/env bash

set -Ceu

git_logs="$(git log --oneline "$@")"
target_log="$(echo "$git_logs" | fzf --preview 'echo {} | cut -d " " -f 1 | xargs git show --color=always')"
commit="$(echo "${target_log}" | cut -d " " -f 1)"

git diff "${commit}..HEAD" -- "$@"
