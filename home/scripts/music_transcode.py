#!/usr/bin/env python3
# heavily based

import os
import shutil
import subprocess
from collections import defaultdict
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

music_path = Path('/booty/media/music')
playlist_dir = music_path / 'playlists'
out_path = Path('/booty/media/music_trans')


def transcode(infile):
    outfile = infile.with_suffix('.opus')
    outfile: Path = out_path / outfile.relative_to(music_path)
    if outfile.is_file() and outfile.stat().st_mtime > infile.stat().st_mtime:
        return outfile
    print('Transcoding', infile)
    outfile.parent.mkdir(parents=True, exist_ok=True)

    outtmp = outfile.with_suffix('.tmp')
    encode_cmd = [
        'opusenc',
        *'--bitrate 256'.split(),
        '--vbr',
        infile,
        outtmp,
    ]

    subprocess.run(
        encode_cmd,
        stderr=subprocess.DEVNULL,
        stdin=subprocess.DEVNULL,
        check=True
    )

    subprocess.run(
        ['r128gain', outtmp],
        stderr=subprocess.DEVNULL,
        stdin=subprocess.DEVNULL,
        check=True
    )

    os.rename(outtmp, outfile)

    return outfile


def copy_file(infile, old_root=music_path):
    outfile = out_path / infile.relative_to(old_root)
    if outfile.is_file() and outfile.stat().st_mtime > infile.stat().st_mtime:
        return outfile
    print('Copying', infile)
    os.makedirs(outfile.parent, exist_ok=True)
    shutil.copy(infile, outfile)
    return outfile


def delete_empty_dirs(path):
    if path.name in {'.stfolder'}:
        return
    if not os.path.isdir(path):
        return
    for dir in os.listdir(path):
        delete_empty_dirs(path / dir)
    if not os.listdir(path):
        print('Removing', path)
        os.rmdir(path)


def walk_files(path):
    for root, dirs, files in os.walk(path):
        root = Path(root)
        for file in files:
            yield root / file


def process_file(f: Path):
    if f.suffix.lower() in ('.flac', '.wav', '.aiff'):
        return f, transcode(f)
    return f, copy_file(f)


def main():
    os.nice(16)

    # load playlists
    playlists = defaultdict(list)
    for playlist in walk_files(playlist_dir):
        if playlist.name.startswith('_'):
            continue
        with open(playlist) as pl:
            for f in pl:
                f = f.strip('\n')
                if (music_path / f).exists():
                    playlists[playlist.name].append(f)
    files = {music_path / f for fs in playlists.values() for f in fs}

    # copy art from all parent directories
    directories = set()
    for f in files:
        directories.add(f.parent)
    for d in directories:
        for f in d.iterdir():
            if f.stem.lower() in {'cover', 'albumart', 'folder'}:
                files.add(f)

    # Process files
    file_map = {}
    expected_files = set()
    with ThreadPoolExecutor(max_workers=32) as pool:
        for infile, outfile in pool.map(process_file, files):
            infile = infile.relative_to(music_path)
            outfile = outfile.relative_to(out_path)
            if infile != outfile:
                file_map[str(infile)] = str(outfile)
            expected_files.add(outfile)

    expected_files.add(Path('.nomedia'))
    # Delete files that we don't expect to exist in output dir
    for f in walk_files(out_path):
        if f.relative_to(out_path) not in expected_files:
            print('Deleting', f)
            os.remove(f)

    # write playlists
    for name, files in playlists.items():
        print('Generating', name)
        with open(out_path / name, 'w') as f:
            f.write('\n'.join(str(file_map.get(f, f)) for f in files))

    # Remove empty directories in the output dir
    delete_empty_dirs(out_path)


if __name__ == '__main__':
    main()
