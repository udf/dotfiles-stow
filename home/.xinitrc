#!/bin/zsh

xrandr --auto

xset -b
xset s off 
xset -dpms

export TERMINAL="termite"
export PIPEWIRE_LATENCY=256/48000
export PATH="$HOME/scripts:$PATH"
export QT_QPA_PLATFORMTHEME="qt5ct"
export GDK_SCALE=1
export MOZ_USE_XINPUT2=1
export GTK_THEME=Arc-Dark

dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# gnome keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

xrdb ~/.Xresources
$HOME/scripts/gen_config.sh

numlockx on

case "$(hostname)" in
"karen-chan")
    numlockx off
    nm-applet &
    xrandr --output DisplayPort-1 --mode 2560x1440 -r 144 --pos 0x538 --rotate normal --output HDMI-A-0 --primary --mode 3840x2160 --pos 2560x0 --rotate normal
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
i3 2>&1 > /tmp/i3.log
