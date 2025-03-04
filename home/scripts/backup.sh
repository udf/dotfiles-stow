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

if [ "$1" = 'mount' ]; then
  echo 'Not syncing because mount was passed'
  exit
fi

BACKUP_DATASET=booty/misc/backups/root
echo 'Syncing root...'
rsync -vaAXHx --delete --info=progress2 \
  --exclude=/.beeshome \
  --exclude=/dev \
  --exclude=/proc \
  --exclude=/sys \
  --exclude=/tmp \
  --exclude=/run \
  --exclude=/lost+found \
  --exclude=/nix/store \
  --exclude=/home/sam/.config/syncthing \
  --exclude=/home/sam/.cache \
  --exclude=/home/sam/.local/share/Steam/steamapps/common \
  --exclude=/home/sam/.local/share/nicotine \
  --exclude=/home/sam/Downloads/phanes_ext \
  --exclude=/home/sam/Downloads/durga_qbit \
  --exclude=/home/sam/Downloads/qbit \
  --exclude=/home/sam/Downloads/claire \
  --exclude=/var/lib/libvirt/images \
  --exclude=/var/lib/docker \
  / "/$BACKUP_DATASET/"
echo 'Syncing boot...'
rsync -vaAXHx --delete --info=progress2 /boot/ "/$BACKUP_DATASET/boot/"
echo 'Snapshotting root backup...'
zfs snapshot "$BACKUP_DATASET@$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
echo 'Deleting old snapshots...'
zfs list -t snapshot -o name -S creation $BACKUP_DATASET | grep -v '@syncoid' | tail -n +5 | xargs -rn 1 sudo zfs destroy -vr
zfs list -t snapshot $BACKUP_DATASET

echo 'Syncing backups dataset...'
syncoid --recursive --sendoptions=w booty/misc/backups backup/backups

echo 'Syncing enc dataset...'
syncoid --recursive --sendoptions=w booty/enc backup/enc

echo 'Syncing cached dataset...'
syncoid --recursive --sendoptions=w booty/cached backup/cached

echo 'Syncing music dataset...'
systemctl --user -M sam@ start music_tasks.service
syncoid --recursive --sendoptions=w booty/music backup/music

if [[ "$WAS_IMPORTED" == 1 ]]; then
  echo 'Exporting pool...'
  zpool export backup
else
  echo 'Not exporting pool because we did not import it.'
fi
