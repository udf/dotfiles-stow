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
    'OL': UnderlineColours.Green + 'ﮣ',
    'OB': UnderlineColours.Red + 'ﮤ',
    'OL BOOST': UnderlineColours.Yellow + 'ﮣ↑'
  }.get(props.get('ups.status', None), '')
  voltage = round(float(props.get('input.voltage'))) - 4
  return f"{icon} {voltage}V {props.get('input.frequency')}Hz"


def get_battery_status(props):
  return f"{UnderlineColours.White} {props.get('battery.voltage')}V"


def get_load_status(props):
  return f"{UnderlineColours.White} {props.get('ups.load'):>2}%"


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
