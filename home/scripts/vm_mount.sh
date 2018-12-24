#!/usr/bin/bash
# This script mounts my vm's disk image with vdfuse, the crypt partition with cryptsetup, and finally the actual partition.

set -e

# access path so autofs mounts the drive
file "/vm/drive/btw i use arch/btw i use arch.vdi" 

# check if we can write to the drive
sudo touch /vm/drive/test
sudo rm /vm/drive/test

# mount vdi image
echo "Mounting image..."
sudo vdfuse -f "/vm/drive/btw i use arch/btw i use arch.vdi" /vm/img

# map encrypted partition to decrypt it
echo "Mapping luks partition..."
sudo cryptsetup open --type luks /vm/img/Partition2 cryptvm

# mount root partition
echo "Mounting root..."
sudo mount /dev/mapper/cryptvm /vm/root

# mount boot partition
echo "Mounting boot..."
sudo mount /vm/img/Partition1 /vm/root/boot
