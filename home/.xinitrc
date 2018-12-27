#!/bin/zsh

xset -b
xset s off 
xset -dpms

xrdb ~/.Xresources
$HOME/scripts/gen_config.sh

case "$(hostname)" in
"karen-chan")
    ;;
"arch-vm")
    # add resolution that might be used in scripts/vm_res_fix.sh
    xrandr --newmode "desktophost" 157.87  1912 2024 2232 2552  996 997 1000 1031  -HSync +Vsync
    xrandr --addmode VGA-1 desktophost
esac

numlockx &
dunst &
i3
