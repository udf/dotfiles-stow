#!/bin/bash
# Basic script to kill all old bars and launch new.

# Generate ramp variables
ramp=('#66cc66' '#83cc66' '#a0cc66' '#bdcc66' '#ccbd66' '#cca066' '#cc8366' '#cc6666')

for i in ${!ramp[@]}; do
  export RAMP_$i="${ramp[$i]}"
  export URAMP_$i="%{u${ramp[$i]}}"
  export FRAMP_$i="%{F${ramp[$i]}}"
done

# Terminate already running bad instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Dumb hack to fix polybar not running when there's no monitor
# (happens on hyper-v with xrdp)
while :; do
    polybar "$(hostname)"
    [[ $? != 1 ]] && break
    sleep 3
done
