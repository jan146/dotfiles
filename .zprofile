#!/bin/sh

export ZPROFILE=1
DEVICE_ID_NVIDIA="01:00.0"
DEVICE_ID_INTEL="00:02.0"

if lspci -k -s "$DEVICE_ID_NVIDIA" | grep "in use" | grep -Eq 'nvidia|nouveau'
then
	# Nvidia or nouveau driver is in use
	if [ "$XDG_SESSION_TYPE" = "wayland" ]
	then
		export MOZ_ENABLE_WAYLAND=1
		export LIBVA_DRIVER_NAME=nouveau
		export VDPAU_DRIVER=nouveau
		export QT_QPA_PLATFORM=wayland
		export XDG_CURRENT_DESKTOP=sway
	elif [ "$XDG_SESSION_TYPE" = "x11" ]
	then
		export LIBVA_DRIVER_NAME=vdpau
		export VDPAU_DRIVER=nvidia
		export MOZ_X11_EGL=1
	fi
elif lspci -k -s "$DEVICE_ID_INTEL" | grep "in use" | grep -Eq 'i915'
then
	# Intel driver is in use -> assume Xorg
	export LIBVA_DRIVER_NAME=i965
	#export LIBVA_DRIVER_NAME=iHD
	export VDPAU_DRIVER=va_gl
	export MOZ_X11_EGL=1
else
	export ZPROFILE=0	# Something went wrong (other/no graphics driver?)
fi


