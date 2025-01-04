#!/usr/bin/env bash

cookies="$(python ~/proj/p/nix_hanzo/phanes/scripts/yt-cookies-dump.py)"
ssh yt-wl-dl@phanes 'nc -UN /var/run/yt-store-cookies.socket' <<< "$cookies"