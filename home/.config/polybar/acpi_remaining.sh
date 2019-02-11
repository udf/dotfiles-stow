#!/bin/bash
while :
do
    acpi -b | sed -E "
        s/.+ (.+) remaining/%{u#ffda00}\1/;
        s/.+ (.+) until charged/%{u#00ff00}\1/
        s/.+ Full.+//
        s/.+charging at zero rate.+//
        s/.+Unknown.+//
    "
    sleep 3
done
