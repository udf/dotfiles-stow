#!/bin/bash

yay -Syw $(find /var/cache/pacman/pkg -name "pkgs_*.txt" -print0 | xargs -0 cat | cut -d' ' -f1 | sort | uniq)
