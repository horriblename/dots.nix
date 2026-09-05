#!/bin/sh

mpv_playing=false

playerctl --all-players metadata \
    --format '{{status}} {{playerName}}' \
    --follow |
while IFS= read -r line
do
    case "$line" in
        "Playing mpv")
            mpv_playing=true
            ;;
        "Paused mpv"|"Stopped mpv")
            mpv_playing=false
            ;;
        "Playing "*)
            if [ "$mpv_playing" = true ]; then
                playerctl --player=mpv pause
                mpv_playing=false
            fi
            ;;
    esac
done
