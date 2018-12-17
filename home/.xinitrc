#!/bin/zsh

xset -b
xset s off 
xset -dpms

DESKTOP_KEY="AAAAC3NzaC1lZDI1NTE5AAAAIF0496p9x/zRn/f2ePFOV5H7xjlBltqQmVsZ6kgbM6pc" 
ssh-keyscan -t ed25519 10.0.2.2 | grep $DESKTOP_KEY && export VM_IS_HOME=1

xrdb ~/.Xresources
$HOME/scripts/gen_config.sh

case "$(hostname)" in
"karen-chan")
    ;;
"arch-vm")
    xrandr --newmode "desktophost" 155.02  1888 2008 2208 2528  987 988 991 1022  -HSync +Vsync
    xrandr --addmode VGA-1 desktophost
    if [[ -v VM_IS_HOME ]]; then
        xrandr --output VGA-1 --mode desktophost
    else
        xrandr --output VGA-1 --mode 1920x1080
    fi
    ;;
esac

numlockx &
dunst &
i3
