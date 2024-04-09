#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Documents/$(hostname)-lock"
PICOM=0

while read line 
do
  if [[ $line =~ "Session.Lock" ]]; then
    WALLPAPER="$(find "$WALLPAPER_DIR" -type f | shuf -n 1)"
    echo "Changing lockscreen to $WALLPAPER"
    cp "$WALLPAPER" /usr/share/backgrounds/lockscreen.png
    if pkill picom; then
      PICOM=1
    fi
  fi
  if [[ $line =~ "Session.Unlock" ]]; then
    if [ -n "$PICOM" ]; then
      picom &!
    fi
  fi
done < <(gdbus monitor --system --dest org.freedesktop.login1)