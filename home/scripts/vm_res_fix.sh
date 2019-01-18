#!/bin/zsh

if [[ -v VM_IS_HOME ]]; then
    xrandr --output VGA-1 --mode desktophost
else
    xrandr --output VGA-1 --mode 1920x1080
fi
