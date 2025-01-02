#!/usr/bin/env python
from collections import defaultdict
import re
from pathlib import Path
from _mpd import client

to_file_set = lambda l: {t['file'] for t in l}

ratings = {}
for track in client.sticker_find('song', 'albums', 'rating', '>', 0):
  m = re.match(r'rating=(\d+)', track['sticker'])
  if m:
    ratings[track['file']] = int(m[1])

all_rated = {t for t, rating in ratings.items() if rating != 6}
all_liked = {t for t, rating in ratings.items() if rating >= 8}
all_tracks = to_file_set(client.find("(base 'albums')"))

by_parent = defaultdict(set)
for track in all_tracks:
  by_parent[str(Path(track).parent)].add(track)

almost_complete_tracks = set()
num_almost_complete = 0
for parent, tracks in by_parent.items():
  num_tracks = len(tracks)
  if num_tracks <= 1:
    continue
  unrated = tracks - all_rated
  liked = tracks & all_liked
  if len(unrated) == 1 and len(liked) >= 1:
    num_almost_complete += 1
    almost_complete_tracks.update(tracks)

print(f'{num_almost_complete} almost complete dirs (containing {len(almost_complete_tracks)} tracks)')

with open(f'/booty/music/music/playlists/_favs_almost_complete.m3u', 'w') as f:
  f.write('\n'.join(sorted(almost_complete_tracks)))
