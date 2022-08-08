#!/bin/sh
run() { if ! pgrep -f "$1"; then "$@"& fi }

# Simple wallpaper.
run feh --bg-scale $HOME/.config/wallpaper/.

# Swap keys and left handed mouse.
run setxkbmap -option caps:swapescape
run xmodmap -e "pointer = 3 2 1 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 4 5"

# Desktops
if [[ $HOSTNAME =~ "Monk" ]]; then
  xrandr --output HDMI-0 --mode 2560x1440 --pos    0x0 --rotate normal \
         --output DP-0   --mode 2560x1440 --pos 2560x0 --rotate normal \
         --output DP-2   --mode 2560x1440 --pos 5120x0 --rotate normal
  bspc monitor HDMI-0 -d 1 2 3 4
  bspc monitor DP-0   -d 5 6 7
  bspc monitor DP-2   -d 8 9 10
else
  bspc monitor -d 1 2 3 4 5 6 7 8 9 10
fi

# Extra programs to launch.
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
run conky -c $HOME/.config/bspwm/system-overview
dex $HOME/.config/autostart/arcolinux-welcome-app.desktop
run blueberry-tray
run nm-apple
run pamac-tray
run xfce4-power-manager
