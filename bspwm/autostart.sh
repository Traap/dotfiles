#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

# bspwm specificc
$HOME/.config/polybar/launch.sh &
picom --config $HOME/.config/bspwm/picom.conf &
run /usr/lib/xfce4/notifyd/xfce4-notifyd &
run conky -c $HOME/.config/bspwm/system-overview &

# Common to my window managers.
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
run dex $HOME/.config/autostart/arcolinux-welcome-app.desktop
run blueberry-tray &
run nm-applet &
run pamac-tray &
run volumeicon &
run xfce4-power-manager &

# Turn off numlock, swap Cap Lock and Escape keys, and left-handed mouse.
run numlockx off &
run setxkbmap -option caps:swapescape &
xmodmap -e "pointer = 3 2 1 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 4 5"

# Simple wallpape.
feh --bg-scale --slideshow-delay 900 ~/.config/wallpaper/. &

# Keybindings.
run sxhkd -c ~/.config/bspwm/sxhkd/sxhkdrc &
