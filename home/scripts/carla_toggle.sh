#!/bin/bash

NUM_PLUGINS=3
TARGET=${1-0}

for ((i=0;i<NUM_PLUGINS;i++)); do
  oscsend osc.tcp://localhost:22752 /Carla/$i/set_volume f $(($i == $TARGET))
done
