#!/bin/sh

checkService() {
	
	if ls -l /sbin/init | grep -q systemd
	then
		SERVICE_STATUS="$(systemctl status bluetooth.service | grep Active | sed 's/.*: //;s/ .*//')"
	elif ls -l /sbin/init | grep -q openrc
	then
		SERVICE_STATUS="$(rc-service bluetoothd status | grep status | sed 's/.*: //g')"
	fi

	if ! [ "$SERVICE_STATUS" = "active" ] && ! [ "$SERVICE_STATUS" = "started" ]
	then
		echo "TBT: service unavailable"
		exit 1
	fi

}

getDeviceStatus() {

	BT_MAC="00:1A:7D:DA:71:13"
	DEVICE_STATUS="$(bluetoothctl show "$BT_MAC" | grep Powered | sed 's/.*: //')"

}

toggleBluetooth() {

	if [ "$DEVICE_STATUS" = "yes" ]
	then
		bluetoothctl power off > /dev/null 2>&1
	elif [ "$DEVICE_STATUS" = "no" ]
	then
		bluetoothctl power on > /dev/null 2>&1
	else
		echo "TBT: invalid device status" 
		exit 1
	fi

}

updatePolybar() {

	if [ "$1" = "toggle" ]	# invert update due to click
	then
		ON=0
		OFF=1
	else
		ON=1
		OFF=0
	fi

	if [ "$DEVICE_STATUS" = "no" ]
	then
		polybar-msg action "#bluetooth.hook.$OFF" > /dev/null 2>&1
	elif [ "$DEVICE_STATUS" = "yes" ]
	then
		polybar-msg action "#bluetooth.hook.$ON" > /dev/null 2>&1
	else
		echo "TBT: invalid device status"
		exit 1
	fi

}

main() {

	getDeviceStatus
	if [ "$1" = "status" ]
	then
		echo "$DEVICE_STATUS"
	elif [ "$1" = "update" ]
	then
		updatePolybar "$*"
	elif [ "$1" = "toggle" ]
	then
		toggleBluetooth
		updatePolybar "$*"
	else
		echo "TBT: invalid cmd"
		exit 1
	fi

}

rfkill unblock bluetooth
checkService
main "$*"

