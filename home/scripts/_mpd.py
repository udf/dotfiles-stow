import os
from mpd import MPDClient, CommandError

client = MPDClient()
client.connect('localhost', 6600)
if 'MPD_PASSWORD' in os.environ:
  client.password(os.environ['MPD_PASSWORD'])
