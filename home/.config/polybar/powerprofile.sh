#!/bin/bash
toggle() {
  if [ "$(powerprofilesctl get)" = "performance" ]; then
    powerprofilesctl set power-saver
  else
    powerprofilesctl set performance
  fi
  print
}

print() {
  profile="$(powerprofilesctl get)"
  profile="${profile/performance/$URAMP_0 󰑮}"
  profile="${profile/power-saver/$URAMP_3 󰒲}"
  echo "%{+u}$profile "
}

trap "toggle" USR1

while true; do
  print
  sleep 5 &
  wait
done