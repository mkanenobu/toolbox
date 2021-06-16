#!/bin/sh
set -Ceu

gh pr checkout "${1}"
webstorm .
