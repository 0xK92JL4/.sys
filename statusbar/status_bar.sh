#!/bin/bash

time_str=$(~/.sys/statusbar/time.sh)
updates=$(~/.sys/statusbar/new_package_count.sh)
xsetroot -name "Updates: 📥 $updates | 🕒 $time_str"

seconds_until_next_minute=$((60 - $(date +%S)))
sleep $seconds_until_next_minute

while true; do
    time_str=$(~/.sys/statusbar/time.sh)
    updates=$(~/.sys/statusbar/new_package_count.sh)
    xsetroot -name "📥 $updates | 🕒 $time_str"
    sleep 60
done
