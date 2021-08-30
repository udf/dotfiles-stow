var len_hist_count = 6;
var len_target = 0.55;
var speed_max = 6;
var enabled = false;

var sub_len_hist = [];

function dump() {
  var out = [];
  for (var i = 0; i < arguments.length; i++) {
    out.push(JSON.stringify(arguments[i]))
  }
  print(out.join(' '));
}

function clamp(v, min, max) {
  return Math.max(Math.min(v, max), min);
}

function toggle_enable() {
  enabled = !enabled;
  mp.osd_message('autospeed ' + (enabled ? 'on' : 'off'));
  mp.set_property('speed', enabled ? 2 : 1);
}

function sub_start_change(_, sub_start) {
  if (!enabled) {
    return;
  }

  var sub_end = mp.get_property_native('sub-end');
  var speed = mp.get_property_native('speed');

  if (sub_start === undefined || sub_end === undefined) {
    mp.set_property('speed', speed + 0.2);
    return;
  }
  var sub_len = sub_end - sub_start;
  sub_len_hist.push(sub_len);

  if (sub_len_hist.length > len_hist_count) {
    sub_len_hist.shift();
  }
  var sub_len_avg = 0;
  for (var i = 0; i < sub_len_hist.length; i++) {
    sub_len_avg += sub_len_hist[i];
  }
  sub_len_avg /= sub_len_hist.length;

  var target_speed = clamp(sub_len_avg / len_target, 1, speed_max);
  var step = clamp(Math.abs(target_speed - speed), 0.1, 0.3);
  sub_len_avg_cur = sub_len_avg / speed;

  if (sub_len_avg_cur > len_target) {
    speed += step;
  }
  if (sub_len_avg_cur < len_target) {
    speed -= step;
  }

  speed = clamp(speed, 1, speed_max);

  mp.set_property('speed', speed);
}

mp.observe_property('sub-start', 'number', sub_start_change);
mp.add_key_binding('ctrl+7', 'toggle-autospeed', toggle_enable)