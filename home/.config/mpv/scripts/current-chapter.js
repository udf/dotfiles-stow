function chapter_change(_, meta) {
  if (meta) {
    var title = meta.TITLE || meta.title;
    print(title)
  }
}

mp.observe_property('chapter-metadata', 'native', chapter_change);