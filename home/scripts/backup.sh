#!/bin/bash
set -e

if [[ $EUID -ne 0 ]]; then
  echo 'This script must be run as root'
  exit 1
fi

if [ -n "$SLEEP" ]; then
  sleep "$SLEEP"
fi

BACKUP_HOST=192.168.0.5
BACKUP_TARGET=sam@192.168.0.5
SSH_KEY=/home/sam/.ssh/id_ed25519
SYNCOID_CMD="syncoid --sshkey=$SSH_KEY --no-privilege-elevation --sendoptions=w"

if [ -z ${SKIP_ROOT_BACKUP+x} ]; then
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
    --exclude=/home/sam/.local/share/Trash \
    --exclude=/home/sam/.local/share/Steam/steamapps/common \
    --exclude=/home/sam/.local/share/nicotine \
    --exclude=/home/sam/Downloads/phanes \
    --exclude=/home/sam/Downloads/phanes_qbit \
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
  zfs list -t snapshot -o name -S creation $BACKUP_DATASET | grep -v '@syncoid' | tail -n +5 | xargs -rn 1 zfs destroy -vr
  zfs list -t snapshot $BACKUP_DATASET
fi

echo 'Syncing backups dataset...'
$SYNCOID_CMD --delete-target-snapshots --recursive booty/misc/backups "$BACKUP_TARGET:backup/backups"

echo 'Syncing enc dataset...'
$SYNCOID_CMD --recursive booty/enc "$BACKUP_TARGET:backup/enc"

echo 'Syncing music dataset...'
systemctl --user -M sam@ start music_tasks.service
$SYNCOID_CMD booty/music "$BACKUP_TARGET:backup/music"
# trigger a share rescan (via custom plugin)
ssh -i "$SSH_KEY" "nicotine@$BACKUP_HOST" 'pkill --oldest -USR1 nicotine'

if [ -n "$POWEROFF" ]; then
  poweroff
fi
