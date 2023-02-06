#!/bin/bash

# Terminate already running bar instances
# kill -9 $(pidof waybar) > /dev/null 2>&1
killall waybar
killall playerctl-scroller

# Wait until the processes have been shut down
while pgrep -u $UID -x waybar
do
    echo "Waiting for all waybar istances to stop"
    sleep 1
	# kill -9 $(pidof waybar) > /dev/null 2>&1
	killall waybar
done
echo "All waybar instances stopped"

# Launch waybar, using default config location ~/.config/waybar/config
export XDG_CURRENT_DESKTOP=Unity
waybar > ~/.config/waybar/log 2>&1 &

echo "waybar launched..."

