#!/bin/bash
while :
do
    acpi -b | sed -E "
        s/.+ (.+) remaining/%{u#ffda00}\1/;
        s/.+ (.+) until charged/%{u#00ff00}\1/
    "
    sleep 3
done
