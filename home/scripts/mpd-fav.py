#!/usr/bin/env python
from mpd import MPDClient
from _mpd import client

cur = client.currentsong()
stickers = client.sticker_list('song', cur['file'])
rating = int(stickers.get('rating', 0))
client.sticker_set('song', cur['file'], 'rating', 10 if rating >= 8 else 8)