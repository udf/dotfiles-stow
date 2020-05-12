#!/bin/bash
# usage: screenshot [-s] [-o filename] [-e /path/to/image_editor]
set -e

editor=""
filename="/tmp/screenshot.png"
slop=slop
[ -e ~/.config/slop/guides.frag ] && slop="slop -r guides"
while getopts ":o:e:s" flags; do
  case $flags in
    s) sel=$($slop -f "-g %g") ;;
    o) filename=${OPTARG} ;;
	e) editor=${OPTARG} ;;
  esac
done

maim -u $sel $filename
[[ -n $editor ]] && $editor "$filename"
xclip -se c -t image/png "$filename"
