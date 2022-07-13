#!/bin/sh
xrandr \
  --output HDMI-0   --mode 2560x1440 --pos    0x0 --rotate normal \
  --output DP-2     --mode 2560x1440 --pos 2560x0 --rotate normal \
  --output DP-0     --mode 2560x1440 --pos 5120x0 --rotate normal \
  --output DP-1     --off  \
  --output DP-1-1   --off  \
  --output DP-3     --off  \
  --output DVI-D-0  --off  \
  --output HDMI-1   --off  \
  --output HDMI-1-1 --off  \
  --output HDMI-1-2 --off  \
  --output HDMI-1-3 --off
