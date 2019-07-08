#!/bin/sh

gip="$(curl --silent 'https://api.ipify.org')"
echo "$gip"
