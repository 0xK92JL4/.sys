#!/bin/bash

offset="-1 hours"

xsetroot -name "$(date -d "$offset" +"%H:%M")"

seconds_until_next_minute=$((60 - $(date +%S)))
sleep $seconds_until_next_minute

while true; do
    xsetroot -name "$(date -d "$offset" +"%H:%M")"
    sleep 60
done
