#!/bin/sh

blue=#0000ff

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT1/capacity)"
  get_status="$(cat /sys/class/power_supply/BAT1/status)"
  case "$get_status" in
  Charging) printf "󰂄 $get_capacity" ;;
  Discharging) printf "󰁹 $get_capacity" ;;
  esac
}

audio() {
  get_vol=$(pamixer --get-volume-human)
  if [ $get_vol = 'muted' ]; then
    printf "󰕾 Muted"
  else
    printf "󰕾 $get_vol"
  fi
}

while true; do
  xsetroot -name " $(audio) $(battery) "
  sleep 1
done
