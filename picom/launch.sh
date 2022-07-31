#!/usr/bin/env sh
killall -q picom
picom -c $HOME/.config/picom/picom.conf &
