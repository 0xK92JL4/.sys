#!/bin/bash

PID_FILE="/tmp/status_bar.pid"
echo $$ > "$PID_FILE"

update_status() {
    time_str=$($HOME/.sys/statusbar/time.sh)
    updates=$($HOME/.sys/statusbar/new_package_count.sh)
    song=$($HOME/.sys/statusbar/current_song.sh)

    xsetroot -name "$song $updates $time_str"
}

# ===== CMUS listener in background =====
(
    last_song=""
    while true; do
        song=$(cmus-remote -Q 2>/dev/null | grep "^tag title " | cut -d' ' -f3-)

        if [ "$song" != "$last_song" ]; then
            last_song="$song"
            reload_status_bar
        fi

        sleep 1
    done
) &

trap 'update_status' SIGUSR1

update_status

while true; do
    seconds_until_next_minute=$((60 - $(date +%S)))
    sleep $seconds_until_next_minute &
    wait $!
    update_status
done
