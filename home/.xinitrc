#!/bin/zsh

xrdb ~/.Xresources

if [ "$(hostname)" = "arch-vm" ]; then
    export ON_CAMPUS=0
    getent hosts wethinkcode.co.za 
    case "$?" in
        "0")
            xrandr --newmode "3840x2160_60.00" 712.34 3840 4152 4576 5312 2160 2161 2164 2235 -HSync +Vsync
            xrandr --addmode VGA-1 3840x2160_60.00
            xrandr --output VGA-1 --mode 3840x2160_60.00
            ;;
        "2")
            xrandr --output VGA-1 --mode 1920x1080
            export ON_CAMPUS=1
            ;;
    esac
fi

exec i3
