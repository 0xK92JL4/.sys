#!/bin/bash

updates=$(checkupdates 2>/dev/null | wc -l)

if [ -z "$updates" ]; then
    echo "?"
else
    echo "$updates"
fi
