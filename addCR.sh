#!/bin/sh
cat "$1" | sed -e "s/$/\r/g"
