#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
# polybar-msg cmd quit
# Otherwise you can use the nuclear option:
killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
# polybar example 2>&1 | tee -a /tmp/polybar1.log & disown
# polybar bar2 2>&1 | tee -a /tmp/polybar2.log & disown



if type "xrandr"; then
  for m in $(polybar --list-monitors | cut -d":" -f1); do
    echo "MONITOR: $m"
      MONITOR=$m polybar --reload example &
  done
else
  polybar --reload example &
fi
# polybar --reload example &
echo "Bars launched..."

