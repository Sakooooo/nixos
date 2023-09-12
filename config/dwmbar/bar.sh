#!/bin/sh

blue=#0000ff

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT1/capacity)"
  get_status="$(cat /sys/class/power_supply/BAT1/status)"
  case "$get_status" in
  Charging) printf "^c$blue^ 󰂄 $get_capacity" ;;
  Discharging) printf "^b$blue 󰁹 $get_capacity" ;;
  esac
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
  sleep 1 && xsetroot -name "$(battery)"
done
