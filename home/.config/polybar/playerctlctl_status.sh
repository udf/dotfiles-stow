#!/bin/sh
cd ~/.config/polybar/playerctlctl
python -m bar_status "$@" 2>/dev/null
