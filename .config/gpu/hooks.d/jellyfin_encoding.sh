#!/bin/sh

ENCODING_XML="/var/lib/jellyfin/config/config/encoding.xml"

# check if argument was passed
test "$#" -ne 1 && echo "${0}: invalid number of arguments" && exit 1

case "$1" in
    "nvidia")
        HWACCEL="nvenc" ;;
    "nouveau")
        HWACCEL="vaapi" ;;
    "i915")
        HWACCEL="vaapi" ;;
    *)
        ;;
esac

sed "s/<HardwareAccelerationType>.*<\/HardwareAccelerationType>/<HardwareAccelerationType>${HWACCEL}<\/HardwareAccelerationType>/" -i "$ENCODING_XML"
