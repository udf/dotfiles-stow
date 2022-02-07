#!/usr/bin/env python
from mpd import MPDClient
from _mpd import client

cur = client.currentsong()
client.sticker_set('song', cur['file'], 'rating', 10)