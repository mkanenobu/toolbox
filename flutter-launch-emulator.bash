#!/usr/bin/env bash

set -Ceu

IFS=$'\n'
available_emulator_ids=""

counter=-1
available_emulators_count=0
for line in $(flutter emulators); do
  counter=$((counter + 1))
  if [ "$counter" -eq 0 ]; then
    available_emulators_count="$(echo "$line" | cut -d' ' -f 1)"
    continue
  fi
  emulator_id="$(echo "$line" | cut -d' ' -f 1)"
  available_emulator_ids="${available_emulator_ids}${emulator_id}"
  if [ "$counter" == "${available_emulators_count}" ]; then
    break
  fi
done

if [ -z "${available_emulator_ids}" ]; then
  echo "Available emulator not found"
  exit 1
fi

selected_emulator_id="$(echo $"${available_emulator_ids}" | fzf)"
if [ -z "${selected_emulator_id}" ]; then
  exit 2
fi
flutter emulators --launch "${selected_emulator_id}"
