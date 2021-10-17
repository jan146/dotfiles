# Generate global color scheme
wal -i ~/Pictures/wallpapers/"$2" --backend $1

# IntelliJ
# /bin/bash ~/.config/JetBrains/"IdeaIC2020.3"/intellijPywal/intellijPywalGen.sh ~/.config/JetBrains/"IdeaIC2020.3"

# Konsole (requires restart)
# ln ~/.cache/wal/colors-konsole.colorscheme ~/.local/share/konsole
# /usr/bin/python $HOME/jan/services/konsoleTransparency.py

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

# Spotify
spicetify update

if [ $(playerctl -p spotify status) != "No players found" ]; then
    echo "Spotify is running"
    spicetify watch -l &
else
    echo "Spotify is not running"
fi

# Restart polybar
$HOME/.config/polybar/launch.sh

