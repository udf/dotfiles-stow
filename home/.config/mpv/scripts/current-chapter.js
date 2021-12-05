function chapter_change(_, meta) {
  if (!meta) return;
  var title = meta.TITLE || meta.title;
  if (!title) return;
  print(title)
}

mp.observe_property('chapter-metadata', 'native', chapter_change);