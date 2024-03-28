#!/bin/bash

xsetroot -name "$(date +"%H:%M")"

seconds_until_next_minute=$((60 - $(date +%S)))
sleep $seconds_until_next_minute

while true; do
    xsetroot -name "$(date +"%H:%M")"
    sleep 60
done
