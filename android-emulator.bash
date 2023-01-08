#!/usr/bin/env bash

available_avds="$(emulator -list-avds)"

target_avd="$(echo "${available_avds}" | fzf)"

if [ -n "${target_avd}" ]; then
  emulator -avd "${target_avd}" -dns-server 8.8.8.8
fi
