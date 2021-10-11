function chapter_change(_, meta) {
  if (meta && !!meta.TITLE) {
    print(meta.TITLE)
  }
}

mp.observe_property('chapter-metadata', 'native', chapter_change);