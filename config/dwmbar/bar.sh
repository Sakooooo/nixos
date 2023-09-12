#!/bin/sh

blue=#0000ff

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT1/capacity)"
  printf "$get_capacity"
}

audio() {
  get_vol=$(pamixer --get-volume-human)
  if [ $get_vol = 'muted' ]; then
    printf "^b$blue^ 󰕾 Muted"
  else
    printf "^b$blue^ 󰕾 $get_vol"
  fi
}

while true; do
  xsetroot -name "$(battery) $(audio)"
  sleep 1
done
