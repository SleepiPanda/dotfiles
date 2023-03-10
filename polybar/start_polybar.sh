#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

screens=$(xrandr --listactivemonitors | grep -v "Monitors" | cut -d" " -f6)

if [[ $(xrandr --listactivemonitors | grep -v "Monitors" | cut -d" " -f4 | cut -d"+" -f2- | uniq | wc -l) == 1 ]]; then
  MONITOR=$(polybar --list-monitors | cut -d":" -f1) TRAY_POS=right polybar i3main_bar &
else
  primary=$(xrandr --query | grep primary | cut -d" " -f1)

  for m in $screens; do
    if [[ $primary == $m ]]; then
        echo MONITOR=$m TRAY_POS=right polybar i3main_bar
	MONITOR=$m TRAY_POS=right polybar i3main_bar &
    else
	echo MONITOR=$m TRAY_POS=none polybar i3side_bar
        MONITOR=$m TRAY_POS=none polybar i3side_bar &
    fi
  done
fi
