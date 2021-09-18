var speed_max = 6;
var target_wps = 40;
var enabled = false;

var speed_max_diff = speed_max - 1;

var text_check_timeout = null;

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

function clamp(v, min, max) {
  return Math.max(Math.min(v, max), min);
}

function toggle_enable() {
  enabled = !enabled;
  if (!enabled && text_check_timeout) {
    clearTimeout(text_check_timeout);
    text_check_timeout = null;
  }
  mp.osd_message('autospeed ' + (enabled ? 'on' : 'off'));
}

function adjust_speed(sub_text) {
  var words = (sub_text || '').split(/[\s-]+/);
  var num_words = words.length;

  var target_speed = target_wps / (num_words || 1);
  target_speed = clamp(target_speed, 1, speed_max);
  var speed = mp.get_property_native('speed');
  var step = Math.abs(target_speed - speed) * 0.5;

  new_speed = target_speed > speed ? speed + step : target_speed;

  mp.set_property('speed', new_speed);
}

function adjust_speed_timer() {
  var sub_text = mp.get_property_native('sub-text');
  adjust_speed(sub_text);
  text_check_timeout = setTimeout(adjust_speed_timer, 1000);
}

function sub_text_change(_, sub_text) {
  if (!enabled) {
    return;
  }
  if (text_check_timeout) {
    clearTimeout(text_check_timeout)
    text_check_timeout = null;
  }
  text_check_timeout = setTimeout(adjust_speed_timer, 1000);
  adjust_speed(sub_text);
}

mp.observe_property('sub-text', 'string', sub_text_change);

mp.add_key_binding('ctrl+7', 'toggle-autospeed', toggle_enable)