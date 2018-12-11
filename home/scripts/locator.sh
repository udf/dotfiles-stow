#!/bin/bash
# Note: I don't use pulseeffects in my vm anymore, this script is only here in case i want to
# run something when im on campus
set -e

function notify {
    notify-send -a "Locator" "$1"
}

outside=0
[ "$(getent hosts wethinkcode.co.za | cut -d' ' -f1)" == "174.129.25.170" ] && outside=1

# make sure pulseeffects is already running
pgrep -x "pulseeffects"

if [ $outside == 1 ]; then
    pulseeffects -l off || true
    notify "Pulse effects off"
else
    pulseeffects -l shitcandy || true
    notify "Pulse effects eq loaded"
fi
