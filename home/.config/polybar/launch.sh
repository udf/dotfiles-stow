#!/bin/bash
# Basic script to kill all old bars and launch new.

# Terminate already running bad instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Dumb hack to fix polybar not running when there's no monitor
# (happens on hyper-v with xrdp)
while :; do
    polybar "$(hostname)"
    sleep 3
done
