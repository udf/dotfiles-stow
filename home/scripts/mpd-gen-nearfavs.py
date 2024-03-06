#!/usr/bin/env python
import sys
from pathlib import Path
from _mpd import client

to_file_set = lambda l: {t['file'] for t in l}

rated = to_file_set(client.sticker_find('song', 'albums', 'rating', '>', 0))
all_tracks = to_file_set(client.find("(base 'albums')"))
unrated = all_tracks - rated

print(f'{len(all_tracks)} tracks, {len(rated)} rated, {len(unrated)} unrated')

def gen_near_playlist(name, src_set):
  dirs_with_liked = {str(Path(p).parent) for p in src_set}
  print(f'{name}: found {len(dirs_with_liked)} dirs')
  near_favs = {p for p in unrated if str(Path(p).parent) in dirs_with_liked}

  print(f'{name}: {len(near_favs)} unrated files in dirs')
  with open(f'/booty/media/music/playlists/{name}.m3u', 'w') as f:
    f.write('\n'.join(sorted(near_favs)))


favourites = to_file_set(client.sticker_find('song', 'albums', 'rating', '=', 8))
loved = to_file_set(client.sticker_find('song', 'albums', 'rating', '=', 10))
fav_dupes = to_file_set(client.sticker_find('song', 'albums', 'rating', '=', 4))
print(f'{len(favourites)} likes, {len(loved)} loved, {len(fav_dupes)} duplicate likes')

all_liked = favourites | loved | fav_dupes
print(f'{len(favourites)} all likes')
gen_near_playlist('_near_favs', all_liked)
gen_near_playlist('_near_loved', loved)
