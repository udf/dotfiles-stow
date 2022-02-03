#!/usr/bin/env python
from mpd import MPDClient

with open('/tmp/test.txt', 'w') as f:
  f.write('a')

client = MPDClient()
client.timeout = 1
client.connect("localhost", 6600)

cur = client.currentsong()
client.sticker_set('song', cur['file'], 'rating', 10)