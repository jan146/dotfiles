#!/bin/sh

getDefaultSink() {
    defaultSink=$(pactl info | awk -F : '/Default Sink:/{print $2}')
    description=$(pactl list sinks | sed -n "/${defaultSink}/,/Description/s/^\s*Description: \(.*\)/\1/p")
    echo "${description}"
}

getDefaultSource() {
    defaultSource=$(pactl info | awk -F : '/Default Source:/{print $2}')
    description=$(pactl list sources | sed -n "/${defaultSource}/,/Description/s/^\s*Description: \(.*\)/\1/p")
    echo "${description}"
}

getIcon() {
	case ${SINK} in
		"Built-in Audio Analog Stereo")
			echo "󰋋"
			;;
		"GP104 High Definition Audio Controller Digital Stereo (HDMI)")
			echo "󰍹"
			;;
		*)
			echo "󰝚"
			;;
	esac
}

getVolume() {

	if [ $(pamixer --get-mute) = "true" ]
	then
		echo "0%"
	else
		echo $(pamixer --get-volume-human)
	fi

}

VOLUME=$(getVolume)
SINK=$(getDefaultSink)
SOURCE=$(getDefaultSource)
ICON=$(getIcon)

case $1 in
    "--up")
        pamixer --allow-boost --increase 2
        ;;
    "--down")
        pamixer --decrease 2
        ;;
    "--mute")
        pamixer --toggle-mute
        ;;
    *)
        echo "${VOLUME} ${ICON}"
esac
