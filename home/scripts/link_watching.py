#!/usr/bin/env python3
import os
from pathlib import Path
import json
import hashlib


CACHE_FILE = Path('~/.cache/py_partial_hash.json').expanduser()
partial_hash_cache = {}
try:
  with open(CACHE_FILE) as f:
    partial_hash_cache = json.load(f)
except FileNotFoundError:
  pass


def walk_files(path):
  for root, dirs, files in os.walk(path):
    root = Path(root)
    for file in files:
      yield root / file


def partial_hash_from_file(fp):
  h = hashlib.sha512()
  with open(fp, 'rb') as f:
    h.update(f.read(1024 * 64))
  return h.hexdigest()


def partial_hash(fp):
  path = str(fp)
  stat = fp.stat()
  cached = partial_hash_cache.get(path, None)
  if cached and cached['size'] == stat.st_size and cached['mtime'] == stat.st_mtime:
    return cached['hash']
  cached = {
    'size': stat.st_size,
    'mtime': stat.st_mtime,
    'hash': partial_hash_from_file(fp)
  }
  partial_hash_cache[path] = cached
  return cached['hash']



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
      print(f'warning: can\'t find hash for dead link "{link_path}" -> "{old_path}", please remove it manually')
      continue
    hash = path_to_hash[old_path]
    print(f'removing dead link "{link_path}" (had hash {path_to_hash[old_path]})')
    os.unlink(link_path)
    del linked[hash]

  delete_empty_dirs(dst_dir)

  for src_path in walk_files(src_dir):
    dst_path = dst_dir / src_path.relative_to(src_dir)
    hash = partial_hash(src_path)
    if hash in linked:
      continue
    dst_path.parent.mkdir(parents=True, exist_ok=True)
    if not dst_path.exists():
      print('making link to', src_path)
      os.symlink(src_path, dst_path)
    linked[hash] = str(src_path)

  with open(dst_dir / 'linked.json', 'w') as f:
    json.dump(linked, f)

for p in ['anime', 'movies', 'series']:
  link_watching(f'/booty/media/{p}', f'/booty/media/watching/{p}')


with open(CACHE_FILE, 'w') as f:
  json.dump(partial_hash_cache, f)