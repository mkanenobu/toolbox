#!/bin/bash

git-auto-fetch() {
  current_root="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [ -z "${current_root}" ]; then
    return
  fi

  current_time="$(date +%s)"
  interval="3600" # seconds

  hists_file="${HOME}/.cache/.git-auto-fetch"
  tmp_file="${HOME}/.cache/.git-auto-fetch-tmp"

  if [ -f "${hists_file}" ]; then
    saved="$(grep "${current_root}"$ "${hists_file}")"
    if [ "$(grep -c "${current_root}"$ "${hists_file}")" -gt 1 ]; then
      grep -v "${current_root}"$ "${hists_file}" >| "${tmp_file}"
      echo "${current_time},${current_root}" >> "${tmp_file}"
    fi
    if [ -z "${saved}" ]; then
      echo "Git fetching in background and Added to cache file"
      (git fetch >/dev/null 2>&1 &)
      cat "${hists_file}" >| "${tmp_file}"
      echo "${current_time},${current_root}" >> "${tmp_file}"
    else
      saved_time="$(echo "${saved}" | cut -d"," -f 1)"
      if [ "${interval}" -lt "$((current_time - saved_time))" ]; then
        echo "Git fetching in background"
        (git fetch >/dev/null 2>&1 &)
        grep -v "${current_root}"$ "${hists_file}" >| "${tmp_file}"
        echo "${current_time},${current_root}" >> "${tmp_file}"
      fi
    fi
  fi

  if [ -f "${tmp_file}" ]; then
    cat "${tmp_file}" >| "${hists_file}"
    rm "${tmp_file}"
  fi
}
