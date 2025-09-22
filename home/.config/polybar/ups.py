#!/usr/bin/env python3
import time
import re
import subprocess


class UnderlineColours:
  Green = '%{u#92bd68}'
  Red = '%{u#cc6666}'
  Yellow = '%{u#f0de74}'
  White = '%{u#faffff}'


def get_input_status(props):
  icon = {
    'OL': UnderlineColours.Green + '󰚥',
    'OB': UnderlineColours.Red + '󰚦',
    'OL BOOST': UnderlineColours.Yellow + '󰚥↑',
    'OL TRIM': UnderlineColours.Yellow + '󰚥↓',
    'OL BYPASS': UnderlineColours.Yellow + '󰚥'
  }.get(props.get('ups.status', None), '')
  voltage = round(float(props.get('input.voltage'))) - 4
  return f"{icon} {voltage}V {props.get('output.frequency')}Hz"


def get_battery_status(props):
  return f"{UnderlineColours.White}󰁹 {props.get('battery.voltage')}V"


def get_load_status(props):
  load_perc = int(props.get('ups.load'))
  return f"{UnderlineColours.White} {load_perc:>2}% / {load_perc * 18} W"


def get_status():
  try:
    output = subprocess.check_output(['upsc', 'mecer-vesta-3k@192.168.0.3'])
  except:
    return '';
  props = {}
  for line in output.splitlines():
    m = re.match(r'^(.+?): (.+)$', line.decode('ascii'))
    if not m:
      continue
    props[m.group(1)] = m.group(2)

  return ' '.join(
    f'%{{+u}}{module(props)}%{{-u}}'
    for module in
    (get_input_status, get_battery_status, get_load_status)
  )


prev_output = ''
while 1:
  output = get_status()
  if output != prev_output:
    print(output, flush=True)
    prev_output = output
  time.sleep(2)
