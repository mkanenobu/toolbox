#!/usr/bin/env bash

if [ -z $TMUX ]; then
  echo '\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]$ '
else
  RETURN_CODE='\[$(
  if [ $? -eq 0 ]; then
    echo -en \e[m\]
  else
    echo -en \e[31m\]
  fi
  echo -en $\e[m\]
  )'
  PS1='\e[01;32m\][\D{%F %T}]\e[00m\]:\e[01;34m\]\W'
  echo "${PS1}${RETURN_CODE} "
fi

