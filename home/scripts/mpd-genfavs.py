#!/usr/bin/env python
from mpd import CommandError
from _mpd import client
client.timeout = 10

PLAYLIST_NAME = 'all_favs'

try:
  client.rm(PLAYLIST_NAME)
except CommandError:
  pass

for track in client.sticker_find('song', '', 'rating', '=', 10):
  client.playlistadd(PLAYLIST_NAME, track['file'])

client.searchaddpl(PLAYLIST_NAME, "(file contains 'favourites/')",)
