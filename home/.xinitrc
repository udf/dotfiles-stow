#!/bin/zsh

xset -b
xset s off 
numlockx &

xrdb ~/.Xresources

$HOME/scripts/gen_config.sh

case "$(hostname)" in
"karen-chan")
    ;;
"arch-vm")
    xrandr --output VGA-1 --mode 1920x1080
    ;;
esac

dunst &
i3
