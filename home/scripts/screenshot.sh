#!/bin/sh
# usage: screenshot [-s] [-o filename] [-e /path/to/image_editor]
set -e

editor=""
filename="/tmp/screenshot.png"
while getopts ":o:e:s" flags; do
  case $flags in
    s) sel=$(slop -f "-i %i -g %g") ;;
    o) filename=${OPTARG} ;;
	e) editor=${OPTARG} ;;
  esac
done

shotgun $sel $filename
[[ ! -z $editor ]] && $editor "$filename"
xclip -se c -t image/png "$filename"
