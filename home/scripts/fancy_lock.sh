#!/bin/bash

shotgun - | convert - -blur 10 -paint 3 ~/scripts/lock_icon.png -gravity center -composite /tmp/lock.png
i3lock -e -f -i /tmp/lock.png "$@"
