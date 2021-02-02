KEYMAP=$(setxkbmap -print -verbose 10 | grep -oP '(?<=layout:     ).*')
if [[ "$KEYMAP" == "si" ]]
then
    setxkbmap us
elif [[ "$KEYMAP" == "us" ]]
then
    setxkbmap gb
elif [[ "$KEYMAP" == "gb" ]]
then
    setxkbmap si
fi
