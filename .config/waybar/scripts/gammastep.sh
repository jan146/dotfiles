#!/bin/sh

INCREMENT="100"
DEFAULT_TEMP="3000"
TEMPERATURE_FILE="$HOME/.config/waybar/temperature"

getTemp() {

	# Set default temperature if none exists yet
	if ! [ -f "$TEMPERATURE_FILE" ]
	then
		echo "$DEFAULT_TEMP" | tee "$TEMPERATURE_FILE" 
	fi

	TEMPERATURE=$(tail -n 1 $TEMPERATURE_FILE)

}

setTemp() {

	echo "$1" | tee "$TEMPERATURE_FILE"

}

update() {

	killall gammastep
	gammastep -O "$TEMPERATURE" &

}

main() {
	
	getTemp
	case "$1" in
		"inc")
			NEWTEMP=$(( $TEMPERATURE + $INCREMENT ))
			setTemp "$NEWTEMP"
			getTemp
			update "$TEMPERATURE"
			;;
		"dec")
			NEWTEMP=$(( $TEMPERATURE - $INCREMENT ))
			setTemp "$NEWTEMP"
			getTemp
			update "$TEMPERATURE"
			;;
		"get")
			echo "$TEMPERATURE"
			;;
		"toggle")
			if pgrep -u $UID -x "gammastep"
			then
				killall gammastep
			else
				gammastep -O "$TEMPERATURE" &
			fi
			;;
	esac
	return 0

}

main "$*"
exit 0

