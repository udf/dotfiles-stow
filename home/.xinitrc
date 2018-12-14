#!/bin/zsh

xset -b

xrdb ~/.Xresources

case "$(hostname)" in
"karen-chan")
    # everything is ok in proprietary-land
    ;;
"arch-vm")
    xrandr --output VGA-1 --mode 1920x1080
    ;;
esac

dunst &
i3 &
wait
