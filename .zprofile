#!/bin/sh

export ZPROFILE=1
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
else
	export ZPROFILE=0	# Something went wrong
fi

