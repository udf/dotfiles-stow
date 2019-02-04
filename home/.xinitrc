#!/bin/zsh

xset -b
xset s off 
xset -dpms

export TERMINAL="urxvt"
export PATH="$HOME/scripts:$PATH"
export QT_QPA_PLATFORMTHEME="qt5ct"
export GDK_SCALE=1

xrdb ~/.Xresources
$HOME/scripts/gen_config.sh

case "$(hostname)" in
"karen-chan")
    ;;
"arch-vm")
    # add resolution that might be used in scripts/vm_res_fix.sh
    xrandr --newmode "desktophost" 157.87  1912 2024 2232 2552  996 997 1000 1031  -HSync +Vsync
    xrandr --addmode VGA-1 desktophost

    # let other scripts check if we're at home
    DESKTOP_KEY="AAAAC3NzaC1lZDI1NTE5AAAAIF0496p9x/zRn/f2ePFOV5H7xjlBltqQmVsZ6kgbM6pc" 
    ssh-keyscan -t ed25519 192.168.2.2 | grep $DESKTOP_KEY && export VM_IS_HOME=1
"archbb")
    export DOTNET_ROOT=/opt/dotnet
    export MSBuildSDKsPath=$DOTNET_ROOT/sdk/$(${DOTNET_ROOT}/dotnet --version)/Sdks
    export PATH=${PATH}:${DOTNET_ROOT}
esac

numlockx &
dunst &
i3
