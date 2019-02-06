#!/bin/bash
while :
do
    acpi -b | sed -E "s/.+ (.+) remaining/\1/"
    sleep 10
done
