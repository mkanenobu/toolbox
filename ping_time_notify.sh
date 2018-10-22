#!/bin/sh

threshold="300"
if [ "$#" -ge 1 ]; then
  threshold="${1}"
fi

URL="www.google.com"
while : ;do
    ping_time="$(\ping ${URL} -i 1 -c 1 | grep 64 | rev | cut -d '=' -f 1 | rev | sed -e "s/ ms//g")"
    if [ "$?" -ne 0 ]; then
        notify-send "ping timeout"
    elif [ "$(echo "${ping_time} > ${threshold}" | bc)" -eq 1 ]; then
        notify-send "ping time is ${ping_time} ms!"
    fi
    echo "$ping_time"
    sleep 1
done
