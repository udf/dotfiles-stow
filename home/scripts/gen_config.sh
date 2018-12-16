#!/bin/bash

set -e

echo "Generating i3 config..."
cd ~/dotfiles/home/.config/i3
cat "config_main" "config_$(hostname)" > config
