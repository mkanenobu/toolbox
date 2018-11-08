#!/bin/bash

git-auto-fetch() {
  current_root="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [ -z "${current_root}" ]; then
    return
  fi

  current_time="$(date +%s)"
  interval="600" # seconds

  hists_file="${HOME}/.cache/.git-auto-fetch"
  tmp_file="${HOME}/.cache/.git-auto-fetch-tmp"

  if [ -f "${hists_file}" ]; then
    saved="$(rg -N "${current_root}" "${hists_file}")"
    if [ -z "${saved}" ]; then
      echo "Git fetching in background"
      (git fetch >/dev/null &)
      cat "${hists_file}" >| "${tmp_file}"
      echo "${current_time},${current_root}" >> "${tmp_file}"
    else
      saved_time="$(echo "${saved}" | cut -d"," -f 1)"
      if [ "$((current_time - saved_time))" -gt "${interval}" ]; then
        echo "Git fetching in background"
        (git fetch >/dev/null &)
        cat "${hists_file}" >| "${tmp_file}"
        echo "${current_time},${current_root}" >> "${tmp_file}"
      fi
    fi
  fi

  if [ -f "${tmp_file}" ]; then
    cat "${tmp_file}" >| "${hists_file}"
    rm "${tmp_file}"
  fi
}
