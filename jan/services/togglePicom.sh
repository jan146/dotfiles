if pgrep -u $USER picom >/dev/null 2>&1; then
    exec killall picom
else
    exec picom -b
fi

