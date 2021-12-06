var speed_min = 2;
var speed_max = 6;
var target_wps = 35;
var enabled = false;

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

function change_wps(amount) {
  target_wps = clamp(target_wps + amount, 1, 100);
  mp.osd_message('wps: ' + target_wps);
}

function toggle_enable() {
  enabled = !enabled;
  if (!enabled) {
    if (text_check_timeout) {
      clearTimeout(text_check_timeout);
      text_check_timeout = null;
    }
    mp.remove_key_binding('autospeed-wps-down');
    mp.remove_key_binding('autospeed-wps-up');
    mp.set_property('speed', 1);
    mp.osd_message('autospeed off');
    return;
  }
  mp.set_property('speed', speed_min);
  mp.add_key_binding('[', 'autospeed-wps-down', function () { change_wps(-1); });
  mp.add_key_binding(']', 'autospeed-wps-up', function () { change_wps(1); })
  mp.osd_message('autospeed on');
}

function adjust_speed(sub_text) {
  var words = (sub_text || '').split(/[\s-]+/);
  var num_words = words.length;

  var target_speed = target_wps / (num_words || 1);
  target_speed = clamp(target_speed, speed_min, speed_max);
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
