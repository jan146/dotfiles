# Generate global color scheme
if [ -n "$2" ]
then
	wal -n -i "$2" --backend "$1"
else
	wal -n -i ~/Pictures/wallpapers4k/ --backend "$1"
fi

# Set wallpaper manually
WALLPAPER_DIR="$HOME/.cache/wal/wallpapers"
OUTPUT_WIDTH=3640
OUTPUT_HEIGHT=1920
LEFT_MONITOR="2560x1440+0+195"
LEFT_MONITOR_ID="DP-2"
RIGHT_MONITOR="1080x1920+2560+0"
RIGHT_MONITOR_ID="DP-3"
if [ "$XDG_SESSION_TYPE" = "wayland" ]
then
	# wayland
	
	# echo "Setting wallpaper in wayland not supported" 1>&2
	# copy background to ~/.cache/wal/wallpapers/input.ext
	BG="$(cat "$HOME/.cache/wal/wal")"
	EXT="${BG##*.}"
	cp "$BG" "${WALLPAPER_DIR}/input.${EXT}"

	# force shrink input image to display size without
	convert -resize "${OUTPUT_WIDTH}x${OUTPUT_HEIGHT}!" "${WALLPAPER_DIR}/input.${EXT}" "${WALLPAPER_DIR}/resized.${EXT}"

	# crop left side
	convert -crop "$LEFT_MONITOR" "${WALLPAPER_DIR}/resized.${EXT}" "${WALLPAPER_DIR}/left"
	# convert -crop "$LEFT_MONITOR" "${WALLPAPER_DIR}/resized.${EXT}" "${WALLPAPER_DIR}/left.${EXT}"

	# crop right side
	convert -crop "$RIGHT_MONITOR" "${WALLPAPER_DIR}/resized.${EXT}" "${WALLPAPER_DIR}/right"
	# convert -crop "$RIGHT_MONITOR" "${WALLPAPER_DIR}/resized.${EXT}" "${WALLPAPER_DIR}/right.${EXT}"
	
	# use swaymsg to set bg for both monitors
	swaymsg output "$LEFT_MONITOR_ID" bg "${WALLPAPER_DIR}/left" fill "#000000"
	# swaymsg output "$LEFT_MONITOR_ID" bg "${WALLPAPER_DIR}/left.${EXT}" fill "#000000"
	swaymsg output "$RIGHT_MONITOR_ID" bg "${WALLPAPER_DIR}/right" fill "#000000"
	# swaymsg output "$RIGHT_MONITOR_ID" bg "${WALLPAPER_DIR}/right.${EXT}" fill "#000000"
	
	# wait for swaymsg to finish before deleting files
	# sleep 1

	# clean up created files (but they are needed on sway's restart)
	# rm "${WALLPAPER_DIR}/input.${EXT}"
	# rm "${WALLPAPER_DIR}/resized.${EXT}"
	# rm "${WALLPAPER_DIR}/left.${EXT}"
	# rm "${WALLPAPER_DIR}/right.${EXT}"

elif [ "$XDG_SESSION_TYPE" = "x11" ]
then
	# xorg - feh
	feh --bg-scale --no-xinerama "$(cat "${HOME}/.cache/wal/wal")"
else
	echo "Can't determine session type" 1>&2
fi


# IntelliJ
# /bin/bash ~/.config/JetBrains/"IdeaIC2020.3"/intellijPywal/intellijPywalGen.sh ~/.config/JetBrains/"IdeaIC2020.3"

# Konsole (requires restart)
# KONSOLE_DIR="$HOME/.local/share/konsole"
# ln ~/.cache/wal/colors-konsole.colorscheme "$KONSOLE_DIR"
# sed 's/Opacity=.*/Opacity=0.7/g' "$KONSOLE_DIR/colors-konsole.colorscheme" > "$KONSOLE_DIR/colors-konsole-with-opacity.colorscheme"

# Discord
# wal-discord -b $1; beautifuldiscord --css $HOME/.cache/wal-discord/style.css
wal-discord -b $1

# Firefox
pywalfox update

# Steam
# wal_steam -w

# Razer peripherals
# razer-cli -a

# General (all) peripherals
xrdb -query | grep "*color1:" | sed 's/.*#//g' | xargs openrgb -c 

# Dunst
cp ~/.cache/wal/dunstrc ~/.config/dunst/dunstrc
killall dunst

# Zathura
~/jan/services/wal-zathura.sh > ~/.config/zathura/zathurarc

# Spotify
# spicetify update

if pidof spotify > /dev/null
then
    echo "Spotify is running"
    spicetify watch -s &
else
    echo "Spotify is not running"
fi

if [ "$XDG_SESSION_TYPE" = "wayland" ]
then
	# wayland -> restart waybar
	$HOME/.config/waybar/launch.sh
elif [ "$XDG_SESSION_TYPE" = "x11" ]
then
	# xorg -> restart polybar
	$HOME/.config/polybar/launch.sh
else
	echo "Can't determine session type" 1>&2
fi

