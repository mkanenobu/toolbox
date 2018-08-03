#!/bin/bash
### 日報用
### for Cygwin

dayOfWeek="$(date -d '1 days' +%u)"
if [ "$dayOfWeek" -eq 6 ]; then
    tomorrow="$(date -d '3 days' +%-m/%-d)"
else
    tomorrow="$(date -d '1 days' +%-m/%-d)"
fi

echo ■${tomorrow}作業予定 >/dev/clipboard
