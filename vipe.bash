#!/usr/bin/env bash
set -e

TOVIMTMP=~/.cache/.tovim_tmp_`date +%Y-%m-%d_%H-%M-%S.txt`
trap 'rm $TOVIMTMP' ERR

cat > "${TOVIMTMP}"
vim "${TOVIMTMP}" < /dev/tty > /dev/tty
cat "${TOVIMTMP}"
rm "${TOVIMTMP}"
