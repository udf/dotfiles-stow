#!/bin/zsh

[ -f ~/.xprofile ] && . ~/.xprofile

i3 2>&1 > /tmp/i3.log
