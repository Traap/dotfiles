#!/usr/bin/env sh

# More info : https://github.com/jaagr/polybar/wiki

killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

       bar=mainbar-bspwm
connected=$(xrandr --query | grep " connected" | cut -d" " -f1)
  desktop=$(echo $DESKTOP_SESSION)
      ini=~/.config/polybar/config.ini

for m in $connected; do
  MONITOR=$m polybar --reload $bar -c $ini  &
done
