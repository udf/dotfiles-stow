#!/usr/bin/env python3
import os
from pathlib import Path
import json
import hashlib


def walk_files(path):
  for root, dirs, files in os.walk(path):
    for file in files:
      yield os.path.join(root, file)


def partial_hash(fp):
  h = hashlib.sha512()
  with open(fp, 'rb') as f:
    h.update(f.read(1024 * 64))
  return h.hexdigest()


def delete_empty_dirs(path):
  if not os.path.isdir(path):
    return
  for dir in os.listdir(path):
    delete_empty_dirs(os.path.join(path, dir))
  if not os.listdir(path):
    print('Removing', path)
    os.rmdir(path)


def link_watching(src_dir, dst_dir):
  src_dir = Path(src_dir)
  dst_dir = Path(dst_dir)

  linked = {}
  with open(dst_dir / 'linked.json') as f:
    linked = json.load(f)

  path_to_hash = {p: h for h, p in linked.items()}

  # remove broken links and their hashes (so if files have been moved they will be linked again)
  for link_path in walk_files(dst_dir):
    if not os.path.islink(link_path):
      continue
    old_path = os.readlink(link_path)
    if os.path.exists(old_path):
      continue
    if old_path not in path_to_hash:
      print(f'warning: can\'t find hash for broken link "{link_path}" -> "{old_path}"')
      continue
    print(f'deleting "{link_path}"')
    os.unlink(link_path)
    hash = path_to_hash[old_path]
    print(link_path, path_to_hash[old_path])
    del linked[hash]

  delete_empty_dirs(dst_dir)

  for src_path in walk_files(src_dir):
    dst_path = dst_dir / Path(src_path).relative_to(src_dir)
    if dst_path.exists():
      continue
    hash = partial_hash(src_path)
    if hash in linked:
      continue
    dst_path.parent.mkdir(parents=True, exist_ok=True)
    print(src_path)
    try:
      os.symlink(src_path, dst_path)
    except FileExistsError:
      pass
    linked[hash] = src_path

  with open(dst_dir / 'linked.json', 'w') as f:
    json.dump(linked, f)

for p in ['anime', 'movies', 'series']:
  link_watching(f'/booty/media/{p}', f'/booty/media/watching/{p}')