#!/bin/sh

run_x() {
	
	if [ -z "$DISPLAY" ] && [ $(id -u) -ge 1000 ] && [ "$XDG_VTNR" -eq 1 ]
	then
		exec startx -- -keeptty > $HOME/.xorg.log 2>&1
	fi

}

env_video() {

	ENV_VIDEO=0
	
	if [ "$XDG_SESSION_TYPE" = "wayland" ]
	then
	
		# Assume nvidia (nouveau) driver
		export MOZ_ENABLE_WAYLAND=1
		export QT_QPA_PLATFORM=wayland
		export XDG_CURRENT_DESKTOP=sway
		LIBVA_DRIVER_NAME=nouveau
		VDPAU_DRIVER=nouveau
	
	elif [ "$XDG_SESSION_TYPE" = "x11" ]
	then
	
		XORG_LOG="$HOME/.local/share/xorg/Xorg.${DISPLAY:1}.log"
		#XORG_LOG="/var/log/Xorg.${DISPLAY:1}.log"
		#XORG_LOG="/var/log/Xorg.0.log"
		export MOZ_X11_EGL=1
		export NVD_BACKEND=direct
	
		# Check which driver Xorg is using (nvidia or intel)
		if grep LoadModule "$XORG_LOG" | grep -q nouveau
		then
			MONITOR=DP-2
			LIBVA_DRIVER_NAME=nouveau
			VDPAU_DRIVER=nouveau
		elif grep LoadModule "$XORG_LOG" | grep -q nvidia
		then
			MONITOR=DP-2
			# LIBVA_DRIVER_NAME=vdpau
			LIBVA_DRIVER_NAME=nvidia
			VDPAU_DRIVER=nvidia
		elif grep LoadModule "$XORG_LOG" | grep -q intel
		then
			MONITOR=HDMI2
			LIBVA_DRIVER_NAME=i965
			# LIBVA_DRIVER_NAME=iHD
			VDPAU_DRIVER=va_gl
		else
			ENV_VIDEO=2	# Failed to find Xorg log
		fi
		export MONITOR
	
	else
		ENV_VIDEO=1	# Something went wrong (other/no graphics driver?)
	fi
	
	export LIBVA_DRIVER_NAME
	export VDPAU_DRIVER
	export ENV_VIDEO

}

main() {
	
	env_video
	run_x
	
}

main

