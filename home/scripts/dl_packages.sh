#!/bin/bash
LIST_PACKAGES='pacman -Qq | grep -vx "$(pacman -Qqm)"'
PACKAGE_LIST=~/packs.txt

if [[ -v VM_IS_HOME ]]; then
    eval "$LIST_PACKAGES" > $PACKAGE_LIST
    ssh sam@192.168.2.4 "$LIST_PACKAGES" >> $PACKAGE_LIST
    ssh sam@192.168.2.2 "$LIST_PACKAGES" >> $PACKAGE_LIST
    sort $PACKAGE_LIST | uniq > /tmp/packs.txt
    mv /tmp/packs.txt $PACKAGE_LIST
    echo "collected $(wc -l < $PACKAGE_LIST) package names"
else
    yay -Syw $(cat $PACKAGE_LIST)
fi
