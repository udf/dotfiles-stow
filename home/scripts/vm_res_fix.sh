#!/bin/zsh

DESKTOP_KEY="AAAAC3NzaC1lZDI1NTE5AAAAIF0496p9x/zRn/f2ePFOV5H7xjlBltqQmVsZ6kgbM6pc" 
ssh-keyscan -t ed25519 10.0.2.2 | grep $DESKTOP_KEY && export VM_IS_HOME=1

if [[ -v VM_IS_HOME ]]; then
    xrandr --output VGA-1 --mode desktophost
else
    xrandr --output VGA-1 --mode 1920x1080
fi
