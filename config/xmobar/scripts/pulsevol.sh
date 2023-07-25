#!/bin/sh

vol=$(pamixer --get-volume)
mute=$(pamixer --get-mute)

if [ $mute = 'true' ]; then
  echo MUTED
else
  echo Vol: $vol%
fi
