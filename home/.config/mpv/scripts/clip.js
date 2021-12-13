var clip_start = null;
var clip_dir = '.';

function dump() {
  var out = [];
  for (var i = 0; i < arguments.length; i++) {
    out.push(
      typeof arguments[i] === 'string'
        ? arguments[i]
        : JSON.stringify(arguments[i])
    );
  }
  print(out.join(' '));
}

function read_options() {
  var opts = {
    'directory': '.'
  };
  mp.options.read_options(opts);
  clip_dir = mp.command_native(['expand-path', opts.directory]);
  dump('Directory set to', clip_dir);
}

function ffmpeg_filter_escape(str) {
  // https://xkcd.com/1638/
  // https://www.youtube.com/watch?v=NNn1L3gKZMc
  return str.replace(/([\\'=:])/g, '\\$1').replace(/([\\'\[\],;])/g, '\\$1')
}

function on_clip() {
  if (clip_start == null) {
    clip_start = mp.get_property_native('time-pos').toFixed(3);
    mp.osd_message('Clip start: ' + clip_start);
    return;
  }
  var clip_end = mp.get_property_native('time-pos').toFixed(3);
  mp.osd_message('Clip: ' + clip_start + ' - ' + clip_end);

  var path = mp.get_property_native('path');
  var cmd = [
    'run', 'ffmpeg', '-hide_banner', '-y',
    '-ss', clip_start, '-to', clip_end, '-copyts',
    '-i', path, '-sn'
  ];
  var outname = mp.get_property_native('filename/no-ext');
  outname += '_' + clip_start + '-' + clip_end;

  var vid_track = mp.get_property_native('current-tracks/video');
  var aud_track = mp.get_property_native('current-tracks/audio');
  var sub_track = mp.get_property_native('current-tracks/sub');

  if (!!vid_track) {
    outname += '.mp4';
  } else if (!!aud_track) {
    outname += '.ogg';
  }

  if (vid_track) {
    cmd = cmd.concat(['-map', '0:v:' + (vid_track.id - 1)]);
    cmd = cmd.concat(['-pix_fmt', 'yuv420p']);
    cmd = cmd.concat(['-crf', '24']);
  }

  if (aud_track) {
    cmd = cmd.concat(['-map', '0:a:' + (aud_track.id - 1)]);
    if (!vid_track) {
      cmd = cmd.concat(['-f', 'opus', '-b:a', '128k', '-vbr', 'on']);
    }
  }

  if (sub_track && vid_track) {
    cmd.push('-vf');
    cmd.push('subtitles=f=' + ffmpeg_filter_escape(path) + ':si=' + (sub_track.id - 1));
  }

  cmd = cmd.concat(['-ss', clip_start, '-to', clip_end]);
  var outpath = clip_dir + '/' + outname;
  cmd.push(outpath);

  dump('Running', cmd);
  mp.osd_message('Clipping: ' + outpath);
  mp.command_native(cmd);

  clip_start = null;
}

function cancel_clip() {
  if (clip_start != null) {
    mp.osd_message('Clip cancelled');
  }
  clip_start = null;
}

read_options();
mp.add_key_binding('ctrl+x', 'start-clip', on_clip);
mp.add_key_binding('ctrl+X', 'cancel-clip', cancel_clip);