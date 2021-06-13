#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while [ $(pgrep -u $UID -x polybar) ]
do
    echo "Waiting for all polybar istances to stop"
    sleep 1
done
echo "All polybar instances stopped"

# Launch Polybar, using default config location ~/.config/polybar/config
polybar example -l trace &> ~/.config/polybar/log &
# polybar example &> ~/.config/polybar/log &
# polybar example &

echo "Polybar launched..."
