#!/usr/bin/env bash

## Script for spotify - waybar

player_status=$(playerctl status 2> /dev/null)

if [ "$player_status" = "Playing" ]; then
    echo -e " $(playerctl metadata artist) - $(playerctl metadata title)\nPlaying: $(playerctl metadata artist) - $(playerctl metadata title)\nplaying"
elif [ "$player_status" = "Paused" ]; then
    echo -e " $(playerctl metadata artist) - $(playerctl metadata title)\nPaused: $(playerctl metadata artist) - $(playerctl metadata title)\npaused"
else
	echo -e ""
fi
