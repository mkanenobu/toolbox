#!/usr/bin/env bash

watch -n 1 -ed "multi-file-swagger index.yml -o yaml >| openapi.yml"
