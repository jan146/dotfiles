#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Setup environment variables for graphical session
export XDG_SESSION_TYPE="x11"
. "$HOME/.toolsrc"
env_video

# Pipewire
killall pipewire pipewire-pulse wireplumber > /dev/null 2>&1
/usr/bin/pipewire &
/usr/bin/pipewire-pulse &
# /usr/bin/pipewire-aes67 &
# /usr/bin/pipewire-avb &
/usr/bin/wireplumber &

# Dunst
/usr/bin/dunst &

# GWE
lsmod | grep -q nvidia && gwe --hide-window &

# Run DE
exec /usr/bin/i3 -V -d all > ~/.config/i3/log 2>&1

#twm &
#xclock -geometry 50x50-1+1 &
#xterm -geometry 80x50+494+51 &
#xterm -geometry 80x20+494-0 &
#exec xterm -geometry 80x66+0+0 -name login


