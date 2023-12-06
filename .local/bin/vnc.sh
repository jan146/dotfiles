
if [ "$XDG_SESSION_TYPE" = "wayland" ]
then
	wayvnc --gpu --max-fps="60" --keyboard="si" --output="DP-2"
elif [ "$XDG_SESSION_TYPE" = "x11" ]
then
	sudo x11vnc -auth /run/lightdm/root/:0 -forever -loop -noxdamage -repeat -rfbauth /home/jan/.vnc/passwd -rfbport 5900 -shared -display :0 -geometry 1920x1080 -ncache_cr -clip xinerama0 
fi


