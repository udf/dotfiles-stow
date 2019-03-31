#!/bin/bash
pid=$(xdotool getactivewindow getwindowpid)

# Use first child, if we have one
child=$(pgrep -P $pid | head -n 1)
[[ -n $child ]] && pid=$child

# run a terminal in the target's current directory
cd "$(readlink -en "/proc/$pid/cwd")" || exit 1
exec "$TERMINAL"
