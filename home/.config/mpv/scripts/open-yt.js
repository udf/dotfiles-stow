function open_yt_in_browser() {
  var filepath = mp.get_property_native('path');
  var videoId = filepath.match(/-([\dA-Za-z_-]{11})\..+$/);
  if (!videoId) {
    mp.osd_message('No videoId found');
    return;
  }
  mp.command_native(['run', 'xdg-open', 'https://youtu.be/' + videoId[1]])
}

mp.add_key_binding('c', 'open-yt-in-browser', open_yt_in_browser);