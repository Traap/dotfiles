#!/usr/bin/env sh
killall -q dunst
dunst -c $HOME/.config/dunst/dunstrc --startup_notification &
