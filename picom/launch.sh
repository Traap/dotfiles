#!/usr/bin/env sh
killall -q picom
picom --config $HOME/.config/picom/picom.conf &
