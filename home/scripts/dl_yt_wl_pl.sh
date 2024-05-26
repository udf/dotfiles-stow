#!/usr/bin/env bash
set -e
cd ~/Downloads/durga_qbit/yt
rm -f wl.tmp
~/.local/bin/yt-dlp --cookies-from-browser firefox --flat-playlist --print-to-file id wl.tmp 'https://www.youtube.com/playlist?list=WL'
mv wl.tmp wl.txt
echo grabbed $(wc -l < wl.txt) video IDs