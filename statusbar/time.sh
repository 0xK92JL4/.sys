#!/usr/bin/env bash

export TZ=Europe/Paris

url=https://www.google.com
cache=${XDG_RUNTIME_DIR:-/tmp}/time_offset
sync_interval=300
retry_interval=30

offset=0 last_ok=0 last_try=0
[[ -r $cache ]] && read -r offset last_ok last_try < "$cache"

if (( EPOCHSECONDS - last_ok >= sync_interval &&
      EPOCHSECONDS - last_try >= retry_interval )); then
    before=$EPOCHSECONDS
    last_try=$before
    hdr=$(curl -fsSI --connect-timeout 2 --max-time 3 "$url" 2>/dev/null |
          tr -d '\r' | sed -n 's/^date: //Ip')
    if [[ $hdr ]] && server=$(date -d "$hdr" +%s 2>/dev/null); then
        offset=$(( server - (before + EPOCHSECONDS) / 2 ))
        last_ok=$EPOCHSECONDS
    fi
    echo "$offset $last_ok $last_try" > "$cache"
fi

if (( last_ok )); then
    printf '🕒 %(%H:%M)T\n' $(( EPOCHSECONDS + offset ))
else
    echo '🕒 XX:XX'
fi

#time_server="https://timeapi.io/api/Time/current/zone?timeZone=Europe/Paris"
#
#get_server_time() {
#    response=$(curl -s --max-time 2 "$time_server")
#    if [ -n "$response" ]; then
#        hour=$(echo "$response" | grep -oP '"hour":\K\d+')
#        minute=$(echo "$response" | grep -oP '"minute":\K\d+')
#        second=$(echo "$response" | grep -oP '"seconds":\K\d+')
#        if [ -n "$hour" ] && [ -n "$minute" ] && [ -n "$second" ]; then
#            printf "%02d:%02d\n" "$hour" "$minute"
#            return 0
#        fi
#    fi
#    return 1
#}
#
#if server_time=$(get_server_time); then
#    echo "🕒 $server_time"
#else
#    echo "🕒 XX:XX"
#fi

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
