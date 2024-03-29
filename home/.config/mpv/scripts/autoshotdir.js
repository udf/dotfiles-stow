// automatically sets the screenshot directory
// screenshot-directory + path to file (excluding any configured base directory)
// for example:
// screenshot-directory=~/screenshots
// autoshotdir-base-dirs=/media/anime (list of colon separated regex patterns)
// screenshots of "/media/anime/Some Show/*.mkv" would be placed in "~/screenshots/Some Show"

var screenshot_dir = mp.get_property_native('screenshot-directory');
var base_dirs = [];

function dump(v) {
  print(JSON.stringify(v));
}

function read_options() {
  var opts = {
    'base-dirs': ''
  };
  mp.options.read_options(opts);
  opts['base-dirs'].split(':').forEach(function (dir) {
    if (dir === '') {
      return;
    }
    base_dirs.push(new RegExp('^' + dir));
  });
}

function normalise_path(path) {
  var subpaths = path.split('/');
  // remove . and multiple slashes
  subpaths = subpaths.filter(function (s) {
    return !(s == '.' || s == '');
  });

  // resolve ..
  var newpath = [];
  subpaths.forEach(function(s) {
    if (s == '..') {
      newpath.pop();
      return;
    }
    newpath.push(s);
  });

  var final = newpath.join('/');
  if (final.length == 0) {
    return '/';
  }
  if (path[0] == '/') {
    return '/' + final;
  }
  return final;
}

function set_shot_dir() {
  var filepath = mp.get_property_native('path');
  // TODO: convert windows path to unix
  var is_url = filepath.indexOf('://') !== -1;
  var is_absolute = filepath[0] == '/';

  // Convert relative directories to absolute
  if (!is_absolute && !is_url) {
    var working_dir = mp.get_property_native('working-directory');
    filepath = mp.utils.join_path(working_dir, filepath);
  }

  // Strip protocol and decode urls
  if (is_url) {
    filepath = decodeURI(filepath).replace(/^\w+:\/\//, '');
  }

  // Strip file name
  filepath = mp.utils.split_path(filepath)[0]

  // normalise path, and add trailing slash
  filepath = normalise_path(filepath) + '/';

  // Try to strip base dir, stopping after first replace succeeds
  for (var i = 0; i < base_dirs.length; i++) {
    var replaced = false;
    filepath = filepath.replace(base_dirs[i], function () {
      replaced = true;
      return '';
    });
    if (replaced) break;
  }

  // Use first directory if we removed some of the path, otherwise use last directory
  filepath = filepath.replace(replaced ? /(.)\/.*$/ : /^.*\/(.)/, '$1');

  // TODO: configurable domain aliases
  if (is_url && filepath.indexOf('youtu') === 0) {
    filepath = 'youtube';
  }

  // If no directory, use filename
  if (filepath === '') {
    filepath = mp.get_property_native('filename/no-ext');
  }

  var new_dir = screenshot_dir + '/' + filepath;
  print('Setting dir to "' + new_dir + '"');
  mp.set_property('screenshot-directory', new_dir);
}

read_options();
mp.register_event('file-loaded', set_shot_dir);
