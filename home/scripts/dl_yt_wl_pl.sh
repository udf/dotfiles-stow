#!/usr/bin/env bash
set -e
cd ~/Downloads/ananke/yt
new_wl="$(~/.local/bin/yt-dlp --cookies-from-browser firefox --flat-playlist --print id 'https://www.youtube.com/playlist?list=WL')"
if [ "$(<wl.txt md5sum)" = "$(echo -n "$new_wl" | md5sum)" ]; then
  echo "no new video IDs"
  exit
fi
echo -n "$new_wl" > wl.txt
echo grabbed $(wc -l < wl.txt) video IDs