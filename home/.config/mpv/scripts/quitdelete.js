var opts = {
  'enabled': ''
};

var files = {};


function dump(v) {
  print(JSON.stringify(v));
}

function quit_delete() {
  var file_list = Object.keys(files).filter(function (k) { return files[k]; });

  print('Deleting ' + file_list.length + ' file(s)!')
  var sub_list = [];
  var total_length = 0;
  file_list.forEach(function (file) {
    print(file);
    sub_list.push(file);
    if (sub_list.length >= 16) {
      mp.utils.subprocess_detached({
        args: ['send2trash'].concat(sub_list)
      });
      sub_list = [];
    }
  });
  if (sub_list.length > 0) {
    mp.utils.subprocess_detached({
      args: ['send2trash'].concat(sub_list)
    });
  }
}

function file_loaded() {
  var k = mp.get_property_native('path');
  if (!files.hasOwnProperty(k)) {
    mp.osd_message('Marked for delete');
    files[k] = true;
  }
}

function toggle_mark() {
  var k = mp.get_property_native('path')
  files[k] = !files[k];
  if (files[k]) {
    mp.osd_message('Marked for delete');
  } else {
    mp.osd_message('Unmarked for delete');
  }
}

mp.options.read_options(opts);
if (opts.enabled !== '') {
  print('WARNING: delete on quit is active!');
  mp.register_event('shutdown', quit_delete);
  mp.register_event('file-loaded', file_loaded);
}

mp.add_key_binding('ctrl+z', 'toggle-mark', toggle_mark);
