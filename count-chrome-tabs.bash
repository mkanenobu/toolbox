#!/usr/bin/env bash

tabs=$(chrome-cli list tabs)

echo "Number of tabs: $(echo "$tabs" | wc -l)"

