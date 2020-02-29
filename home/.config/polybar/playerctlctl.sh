#!/bin/sh
cd ~/.config/polybar/playerctlctl
python -m playerctlctl "$@" 2>/dev/null
