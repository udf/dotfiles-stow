#!/usr/bin/env bash

#
# Original author: Rokas Kupstys <rokups@zoho.com>
# Heavily modified by: Danny Lin <danny@kdrag0n.dev>
#
# This hook uses systemd's AllowedCPUs property to dynamically isolate and
# unisolate CPUs using cgroup v2. While it's not as effective as full
# kernel-level scheduler and timekeeping isolation, it still does wonders for
# VM latency as compared to not isolating CPUs at all. Note that vCPU thread
# affinity is a must for this to work properly.
#
# Original source: https://rokups.github.io/#!pages/gaming-vm-performance.md
#
# Target file locations:
#   - $SYSCONFDIR/hooks/qemu.d/vm_name/prepare/begin/cset.sh
#   - $SYSCONFDIR/hooks/qemu.d/vm_name/release/end/cset.sh
# $SYSCONFDIR is usually /etc/libvirt.
#

TOTAL_CORES='0-23'
TOTAL_CORES_MASK="$(printf '%x' "$((2#111111111111111111111111))")"
HOST_CORES='0-11'
HOST_CORES_MASK="$(printf '%x' "$((2#111111111111000000000000))")"
VIRT_CORES='12-23'

VM_NAME="$1"
VM_ACTION="$2/$3"

function shield_vm() {
    sync
    echo 3 > /proc/sys/vm/drop_caches
    echo 1 > /proc/sys/vm/compact_memory

    systemctl set-property --runtime -- user.slice AllowedCPUs=$HOST_CORES
    systemctl set-property --runtime -- system.slice AllowedCPUs=$HOST_CORES
    systemctl set-property --runtime -- init.scope AllowedCPUs=$HOST_CORES

    sysctl vm.stat_interval=30
    sysctl kernel.watchdog=0
}

function unshield_vm() {
    systemctl set-property --runtime -- user.slice AllowedCPUs=$TOTAL_CORES
    systemctl set-property --runtime -- system.slice AllowedCPUs=$TOTAL_CORES
    systemctl set-property --runtime -- init.scope AllowedCPUs=$TOTAL_CORES

    sysctl vm.stat_interval=1
    sysctl kernel.watchdog=1
}

# For convenient manual invocation
if [[ "$VM_NAME" == "shield" ]]; then
    shield_vm
    exit
elif [[ "$VM_NAME" == "unshield" ]]; then
    unshield_vm
    exit
fi

if [[ "$VM_ACTION" == "prepare/begin" ]]; then
    echo "libvirt-qemu cset: Reserving CPUs $VIRT_CORES for VM $VM_NAME" > /dev/kmsg 2>&1
    shield_vm > /dev/kmsg 2>&1

    # the kernel's dirty page writeback mechanism uses kthread workers. They introduce
    # massive arbitrary latencies when doing disk writes on the host and aren't
    # migrated by cset. Restrict the workqueue to use only cpu 0.
    echo $HOST_CORES_MASK > /sys/bus/workqueue/devices/writeback/cpumask
    echo 0 > /sys/bus/workqueue/devices/writeback/numa

    echo "libvirt-qemu cset: Successfully reserved CPUs $VIRT_CORES" > /dev/kmsg 2>&1
elif [[ "$VM_ACTION" == "release/end" ]]; then
    echo "libvirt-qemu cset: Releasing CPUs $VIRT_CORES from VM $VM_NAME" > /dev/kmsg 2>&1
    unshield_vm > /dev/kmsg 2>&1

    # Revert changes made to the writeback workqueue
    echo $TOTAL_CORES_MASK > /sys/bus/workqueue/devices/writeback/cpumask
    echo 1 > /sys/bus/workqueue/devices/writeback/numa

    echo "libvirt-qemu cset: Successfully released CPUs $VIRT_CORES" > /dev/kmsg 2>&1
fi
