#!/usr/bin/env python
import sys
from pathlib import Path
from _mpd import client

to_file_set = lambda l: {t['file'] for t in l}

favourites = to_file_set(client.sticker_find('song', 'albums', 'rating', '>', 8))
fav_dupes = to_file_set(client.sticker_find('song', 'albums', 'rating', '>', 4))
liked = favourites | fav_dupes
rated = to_file_set(client.sticker_find('song', 'albums', 'rating', '>', 0))
all_tracks = to_file_set(client.find("(base 'albums')"))
unrated = all_tracks - rated

print(f'{len(all_tracks)} tracks, {len(rated)} rated, {len(unrated)} unrated, {len(liked)} liked')

dirs_with_liked = {str(Path(p).parent) for p in liked}
print(f'{len(dirs_with_liked)} dirs containing likes')
near_favs = {p for p in unrated if str(Path(p).parent) in dirs_with_liked}

print(f'{len(near_favs)} unrated files in dirs containing likes')
with open('/booty/media/music/playlists/_near_favs.m3u', 'w') as f:
  f.write('\n'.join(sorted(near_favs)))