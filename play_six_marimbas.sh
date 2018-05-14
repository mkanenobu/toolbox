#!/bin/sh
if [ "$#" -eq 0 ]; then
    while : ; do
        mpv "$HOME/Music/Reich, Steve - Sextet - Six Marimbas/06 - Reich, Steve - Six Marimbas.opus" || break
    done
elif [ "$#" -eq 1 ]; then
    while : ; do
        mpv "$1" || break
    done
fi

