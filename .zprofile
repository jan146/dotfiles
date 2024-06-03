#!/bin/sh

LOG_FILE="$HOME/.xorg.log"

run_x() {
	
	if [ -z "$DISPLAY" ] && [ $(id -u) -ge 1000 ]
	then
		exec startx -- -keeptty > "$LOG_FILE" 2>&1
	fi

}

main() {
	
    if ! [ -f "$LOG_FILE" ]; then
        run_x
    else
        LAST_STARTX="$(stat -c "%Y" $LOG_FILE)"
        UPTIME_SECONDS="$(cat /proc/uptime | sed 's/[ .].*//g')"
        CURRENT_TIME="$(date +%s)"
        LAST_BOOT="$(( CURRENT_TIME - UPTIME_SECONDS ))"

        # Run X only if there hasn't been an X session since last boot
        if [ $LAST_STARTX -lt $LAST_BOOT ]; then
        	run_x
        else
            echo "X has alread ran since last boot -> skip running X again"
        fi
    fi
	
}

main

