#!/bin/sh

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT*/capacity)"
  get_status="$(cat /sys/class/power_supply/BAT*/status)"
  case "$get_status" in
  Charging) printf "^c$blue^ 󰂄 $get_capacity" ;;
  Discharging) printf "^c$white^ ^b$blue 󰁹 $get_capacity"
  esac
}

while true; do
  sleep 1 && xsetroot -name "$(battery)"
done
