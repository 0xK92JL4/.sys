#!/bin/bash

time_server="https://timeapi.io/api/Time/current/zone?timeZone=Europe/Paris"

get_server_time() {
    response=$(curl -s --max-time 2 "$time_server")
    if [ -n "$response" ]; then
        hour=$(echo "$response" | grep -oP '"hour":\K\d+')
        minute=$(echo "$response" | grep -oP '"minute":\K\d+')
        second=$(echo "$response" | grep -oP '"seconds":\K\d+')
        if [ -n "$hour" ] && [ -n "$minute" ] && [ -n "$second" ]; then
            printf "%02d:%02d\n" "$hour" "$minute"
            return 0
        fi
    fi
    return 1
}

if server_time=$(get_server_time); then
    echo "🌐 $server_time"
else
    echo "🌐 XX:XX"
fi

##!/bin/bash
#
#offset="-0 hours"
#
#xsetroot -name "$(date -d "$offset" +"%H:%M")"
#
#seconds_until_next_minute=$((60 - $(date +%S)))
#sleep $seconds_until_next_minute
#
#while true; do
#    xsetroot -name "$(date -d "$offset" +"%H:%M")"
#    sleep 60
#done
