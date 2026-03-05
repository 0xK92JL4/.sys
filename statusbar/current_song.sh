#!/bin/bash

if cmus-remote -Q >/dev/null 2>&1; then
    artist=$(cmus-remote -Q | grep '^tag artist ' | sed 's/tag artist //')
    title=$(cmus-remote -Q | grep '^tag title ' | sed 's/tag title //')

    if [ -n "$artist" ] && [ -n "$title" ]; then
        echo "🎵 $artist - $title |"
    elif [ -n "$title" ]; then
        echo "🎵 $title |"
    else
        echo ""
    fi
else
    echo ""
fi
