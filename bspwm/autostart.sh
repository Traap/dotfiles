#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

$HOME/.config/polybar/launch.sh &


dex $HOME/.config/autostart/arcolinux-welcome-app.desktop
xsetroot -cursor_name left_ptr &
run sxhkd -c ~/.config/bspwm/sxhkd/sxhkdrc &

run conky -c $HOME/.config/bspwm/system-overview &
run variety &
run nm-applet &
run pamac-tray &
run xfce4-power-manager &

run blueberry-tray &
picom --config $HOME/.config/bspwm/picom.conf &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &

# Turn off numlock, swap Cap Lock and Escape keys, and left-handed mouse.
run volumeicon &
run numlockx off&
run setxkbmap -option caps:swapescape&
xmodmap -e "pointer = 3 2 1 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 4 5"
