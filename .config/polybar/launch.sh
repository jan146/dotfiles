#!/bin/bash

# Terminate already running bar instances
kill -9 $(pidof polybar) > /dev/null 2>&1

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar
do
    echo "Waiting for all polybar istances to stop"
    sleep 1
	kill -9 $(pidof polybar) > /dev/null 2>&1
done
echo "All polybar instances stopped"

# Launch Polybar, using default config location ~/.config/polybar/config
# polybar example -l trace > ~/.config/polybar/log 2>&1 &
polybar example > ~/.config/polybar/log 2>&1 &

echo "Polybar launched..."
