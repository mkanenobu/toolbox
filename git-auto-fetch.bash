#!/bin/bash
git-auto-fetch() {
  hists_file="${HOME}/.cache/.git-auto-fetch"
  tmp_file="${HOME}/.cache/.git-auto-fetch-tmp"

  if [ ! "$(git root 2>/dev/null)" ]; then
    return
  fi

  current_time="$(date +%s)"
  current_root="$(git root)"
  interval="600" # second
  exists_flg=0
  fetch_flg=0

  if [ -f "${hists_file}" ]; then
    cat "${hists_file}" >| "${tmp_file}"
    while read -r line; do
      saved_time="$(echo "${line}" | cut -d"," -f 1)"
      saved_root="$(echo "${line}" | cut -d"," -f 2)"
      if [ "${saved_root}" = "${current_root}" ]; then
        exists_flg=1
        if [ "$((current_time - saved_time))" -gt "${interval}" ]; then
          fetch_flg=1
        fi
      fi
    done < "${hists_file}"
  fi

  if [ "${exists_flg}" -eq 0 ]; then
    echo "${current_time},${current_root}" >>"${tmp_file}"
  fi

  if [ "$fetch_flg" -eq 1 ]; then
    (git fetch >/dev/null &)
    echo "${current_time},${current_root}" >>"${tmp_file}"
  fi

  if [ -s "${tmp_file}" ]; then
    cat "${tmp_file}" >| "${hists_file}"
    rm "${tmp_file}"
  fi

  exists_flg=0
  fetch_flg=0
}
