#!/usr/bin/env bash


while true
do
  chrome-cli reload
  echo "Reload $(date "+%Y-%m-%dT%H:%M:%S%z")"
  sleep 5
done

