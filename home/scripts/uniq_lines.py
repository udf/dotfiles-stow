#!/usr/bin/python3
import sys
import re

seen = set()

for line in sys.stdin:
    s = line.split(None, 1)
    if len(s) != 2 or s[1] in seen:
        continue
    seen.add(s[1])
    sys.stdout.write(line)