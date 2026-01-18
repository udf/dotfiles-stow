#!/usr/bin/env bash

[ -z "$1" ] && echo "mising cookies filename" && exit 1
ssh sam@phanes 'nc -UN /var/run/yt-wl/yt-store-cookies.socket' < "$1"