#!/bin/bash
set -e

if [[ $EUID -ne 0 ]]; then
   echo 'This script must be run as root'
   exit 1
fi

if zfs list backup; then
   echo 'Pool already imported, continuing...'
else
   echo 'Pool not found, trying to import'
   zpool import backup
   WAS_IMPORTED=1
fi

if mountpoint /backup/root; then
   echo 'Dataset mounted, continuing...'
else
   echo 'Loading key and mounting dataset...'
   zfs load-key backup/root
   zfs mount backup/root
fi

zfs list backup/root

if [ "$1" = 'mount' ]; then
    echo 'Not syncing because mount was passed'
    exit
fi

echo 'Syncing root...'
rsync -aAXHxx --delete --info=progress2 --exclude={/dev,/proc,/sys,/tmp,/run,/lost+found,/nix/store,/home/sam/Downloads,/home/sam/.cache} / /backup/root/
echo 'Syncing boot...'
rsync -aAXHxx --delete --info=progress2 /boot/ /backup/root/boot/

echo 'Snapshotting...'
zfs snapshot "backup/root@$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
zfs list -t snapshot backup/root

if [[ "$WAS_IMPORTED" == 1 ]]; then
   echo 'Exporting pool...'
   zpool export backup
else
   echo 'Not exporting pool because we did not import it.'
fi
