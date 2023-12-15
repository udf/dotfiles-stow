#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Documents/$(hostname)-lock"

while read line 
do
  if [[ $line =~ "Session.Lock" ]]; then
    WALLPAPER="$(find "$WALLPAPER_DIR" -type f | shuf -n 1)"
    echo "Changing lockscreen to $WALLPAPER"
    cp "$WALLPAPER" /usr/share/backgrounds/lockscreen.png
  fi
done < <(gdbus monitor --system --dest org.freedesktop.login1)