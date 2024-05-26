function open_yt_in_browser(addTimestamp) {
  var filepath = mp.get_property_native('path');
  var videoId = filepath.match(/-([\dA-Za-z_-]{11})\./) || filepath.match(/ \[([\dA-Za-z_-]{11})\]\./);
  if (!videoId) {
    mp.osd_message('No videoId found');
    return;
  }
  var params = '';
  if (addTimestamp) {
    params = '?t=' + Math.floor(mp.get_property_native('time-pos'))
  }
  mp.command_native(['run', 'xdg-open', 'https://youtu.be/' + videoId[1] + params])
  mp.osd_message('Opened Youtube url in browser');
}

function open_yt_in_browser_ts() {
  open_yt_in_browser(true);
}

mp.add_key_binding('C', 'open-yt-in-browser-ts', open_yt_in_browser_ts);
mp.add_key_binding('c', 'open-yt-in-browser', open_yt_in_browser);