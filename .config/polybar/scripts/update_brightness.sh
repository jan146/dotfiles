ddcutil --model "VG248" getvcp 10 2> /dev/null | grep value | sed 's/, max.*/%/g;s/.*value = *//g' > $HOME/.config/polybar/brightness
