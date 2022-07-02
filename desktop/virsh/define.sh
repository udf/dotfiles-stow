#!/bin/bash
virsh --connect qemu:///system define win10-2.xml
virsh --connect qemu:///system define endeavour.xml