#!/bin/zsh

xset -b
xset s off 
numlockx &

xrdb ~/.Xresources

case "$(hostname)" in
"karen-chan")
    POST_CMD='compton &; pulseffects &'
    ;;
"arch-vm")
    xrandr --output VGA-1 --mode 1920x1080
    ;;
esac

dunst &
i3 &
eval $POST_CMD
wait
