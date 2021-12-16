var opts = {
  'enabled': ''
};

var files = {};


function dump(v) {
  print(JSON.stringify(v));
}

function quit_delete() {
  var file_list = Object.keys(files);

  print('Deleting ' + file_list.length + ' file(s)!')
  var sub_list = [];
  var total_length = 0;
  file_list.forEach(function (file) {
    print(file);
    sub_list.push(file);
    if (sub_list.length >= 16) {
      mp.utils.subprocess_detached({
        args: ['rm'].concat(sub_list)
      });
      sub_list = [];
    }
  });
  if (sub_list.length > 0) {
    mp.utils.subprocess_detached({
      args: ['rm'].concat(sub_list)
    });
  }
}

function file_loaded() {
  files[mp.get_property_native('path')] = true;
}

mp.options.read_options(opts);
if (opts.enabled !== '') {
  print('WARNING: delete on quit is active!');
  mp.register_event('shutdown', quit_delete);
  mp.register_event('file-loaded', file_loaded);
}
