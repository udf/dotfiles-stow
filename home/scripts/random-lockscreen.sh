#!/usr/bin/env bash

randomise_lockscreen() {
  WALLPAPER="$(find "$WALLPAPER_DIR" -type f -iname '*.png' | shuf -n 1)"
  echo "Changing lockscreen to $WALLPAPER"
  cp "$WALLPAPER" /usr/share/backgrounds/lockscreen.png
}

WALLPAPER_DIR="$HOME/Documents/$(hostname)-lock"
PICOM=0
randomise_lockscreen
xset s 300
xset dpms 300 300 300

while read line 
do
  if [[ $line =~ "Session.Lock" ]]; then
    if pkill picom; then
      PICOM=1
    fi
  fi
  if [[ $line =~ "Session.Unlock" ]]; then
    if [ -n "$PICOM" ]; then
      picom &!
    fi
    xset s 300
    xset dpms 300 300 300
    randomise_lockscreen
  fi
done < <(gdbus monitor --system --dest org.freedesktop.login1)
