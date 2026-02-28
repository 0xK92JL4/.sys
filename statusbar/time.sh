#!/bin/bash

time_server="https://timeapi.io/api/Time/current/zone?timeZone=Europe/Paris"

get_server_time() {
    response=$(curl -s --max-time 2 "$time_server")
    if [ -n "$response" ]; then
        hour=$(echo "$response" | grep -oP '"hour":\K\d+')
        minute=$(echo "$response" | grep -oP '"minute":\K\d+')
        second=$(echo "$response" | grep -oP '"seconds":\K\d+')
        if [ -n "$hour" ] && [ -n "$minute" ] && [ -n "$second" ]; then
            # Strip spaces
            hour=$(echo "$hour" | tr -d ' ')
            minute=$(echo "$minute" | tr -d ' ')
            second=$(echo "$second" | tr -d ' ')
            printf "%02d:%02d:%02d\n" "$hour" "$minute" "$second"
            return 0
        fi
    fi
    return 1
}

if server_time=$(get_server_time); then
    IFS=: read h m s <<< "$server_time"
    h=$(echo "$h" | tr -d ' ')
    m=$(echo "$m" | tr -d ' ')
    s=$(echo "$s" | tr -d ' ')
    current_seconds=$((h*3600 + m*60 + s))

    hh=$((current_seconds / 3600 % 24))
    mm=$((current_seconds / 60 % 60))
    xsetroot -name "$(printf "%02d:%02d" "$hh" "$mm")"
else
    xsetroot -name "CouldNotReachTimeServer"
    exit 1
fi

seconds_until_next_minute=$((60 - current_seconds % 60))
sleep $seconds_until_next_minute
current_seconds=$((current_seconds + seconds_until_next_minute))

while true; do
    hh=$((current_seconds / 3600 % 24))
    mm=$((current_seconds / 60 % 60))

    xsetroot -name "$(printf "%02d:%02d" "$hh" "$mm")"

    current_seconds=$((current_seconds + 60))
    sleep 60
done

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
