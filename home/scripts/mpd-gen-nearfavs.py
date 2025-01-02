#!/usr/bin/env python
import sys
from pathlib import Path
from _mpd import client

to_file_set = lambda l: {t['file'] for t in l}

rated = to_file_set(client.sticker_find('song', 'albums', 'rating', '>', 0))
all_tracks = to_file_set(client.find("(base 'albums')"))
unrated = all_tracks - rated

print(f'{len(all_tracks)} tracks, {len(rated)} rated, {len(unrated)} unrated')

favourites = to_file_set(client.sticker_find('song', 'albums', 'rating', '=', 8))
loved = to_file_set(client.sticker_find('song', 'albums', 'rating', '=', 10))
fav_dupes = to_file_set(client.sticker_find('song', 'albums', 'rating', '=', 4))
print(f'{len(favourites)} likes, {len(loved)} loved, {len(fav_dupes)} duplicate likes')

all_liked = favourites | loved | fav_dupes
not_disliked = favourites | loved | unrated
print(f'{len(all_liked)} total likes, {len(not_disliked)} not disliked (likes + unrated)')

def gen_near_playlists(name, src_set):
  dirs_with_liked = {str(Path(p).parent) for p in src_set}
  print(f'{name}: found {len(dirs_with_liked)} dirs')

  tracks = {p for p in unrated if str(Path(p).parent) in dirs_with_liked}
  print(f'{name}: {len(tracks)} unrated files in dirs')
  with open(f'/booty/music/music/playlists/{name}.m3u', 'w') as f:
    f.write('\n'.join(sorted(tracks)))

  dirs_with_unrated = {str(Path(p).parent) for p in tracks}
  tracks = {p for p in not_disliked if str(Path(p).parent) in dirs_with_unrated}
  print(f'{name}_all: {len(tracks)} not disliked files in dirs')
  with open(f'/booty/music/music/playlists/{name}_all.m3u', 'w') as f:
    f.write('\n'.join(sorted(tracks)))


gen_near_playlists('_near_favs', all_liked)
gen_near_playlists('_near_loved', loved)
