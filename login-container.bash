#!/usr/bin/env bash

containers="$(docker ps --all --format '{{.ID}}\t{{.Names}}\t{{.Status}}' | grep -v 'k8s_')"
echo "${containers}"
