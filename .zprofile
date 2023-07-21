#!/bin/sh

export ZPROFILE=1

if [ "$XDG_SESSION_TYPE" = "wayland" ]
then
	# Assume nvidia (nouveau) driver
	export MOZ_ENABLE_WAYLAND=1
	export LIBVA_DRIVER_NAME=nouveau
	export VDPAU_DRIVER=nouveau
	export QT_QPA_PLATFORM=wayland
	export XDG_CURRENT_DESKTOP=sway
elif [ "$XDG_SESSION_TYPE" = "x11" ]
then
	# Check which driver Xorg is using (nvidia or intel)
	export MOZ_X11_EGL=1
	if grep LoadModule "/var/log/Xorg.0.log" | grep -q nvidia
	then
		export MONITOR=DP-2
		export LIBVA_DRIVER_NAME=vdpau
		export VDPAU_DRIVER=nvidia
	elif grep LoadModule "/var/log/Xorg.0.log" | grep -q intel
	then
		export MONITOR=HDMI2
		export LIBVA_DRIVER_NAME=i965
		#export LIBVA_DRIVER_NAME=iHD
		export VDPAU_DRIVER=va_gl
	fi
else
	export ZPROFILE=0	# Something went wrong (other/no graphics driver?)
fi

