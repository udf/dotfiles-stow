#!/bin/zsh

xrandr --auto

xset -b
xset s off 
xset -dpms

export TERMINAL="urxvt"
export PATH="$HOME/scripts:$PATH"
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_STYLE_OVERRIDE=qt5ct-style
export GDK_SCALE=1

# gnome keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

xrdb ~/.Xresources
$HOME/scripts/gen_config.sh

numlockx on

case "$(hostname)" in
"karen-chan")
    numlockx off
    ;;
"arch-vm")
    xrandr --newmode "1080p" 157.87  1912 2024 2232 2552  996 997 1000 1031  -HSync +Vsync
    xrandr --addmode VGA-1 1080p
    xrandr --addmode Virtual-1 1080p

    # let other scripts check if we're at home
    DESKTOP_KEY="AAAAC3NzaC1lZDI1NTE5AAAAIF0496p9x/zRn/f2ePFOV5H7xjlBltqQmVsZ6kgbM6pc" 
    ssh-keyscan -t ed25519 192.168.2.2 | grep $DESKTOP_KEY && export VM_IS_HOME=1
    ;;
"archbb")
    xset +dpms
    xset s on
    export DOTNET_ROOT=/opt/dotnet
    export MSBuildSDKsPath=$DOTNET_ROOT/sdk/$(${DOTNET_ROOT}/dotnet --version)/Sdks
    export PATH=${PATH}:${DOTNET_ROOT}
    export PATH="${HOME}/.npm-packages/bin:${PATH}"
    nm-applet &
    xss-lock --transfer-sleep-lock -- transfer-sleep-lock.sh &
    ;;
esac

xbanish &
dunst &
i3
