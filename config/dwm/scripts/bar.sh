#!/bin/sh

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.dwmscripts/themes/sako.sh

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$black^ ^b$red^ CPU"
  printf "^c$white^ ^b$grey^ $cpu_val"
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT1/capacity)"
  get_status="$(cat /sys/class/power_supply/BAT1/status)"
  case "$get_status" in
  Charging) printf "^c$blue^ 󰂄 $get_capacity" ;;
  Discharging) if (( $get_capacity <= 20)); then
                  printf "^c$lightred^ 󰂃 $get_capacity"
              else
                  printf "^c$blue^ 󰁹 $get_capacity"
              fi ;;
  esac
  #printf "^c$blue^   $get_capacity"
}

audio() {
  get_vol=$(pamixer --get-volume)
  get_mute=$(pamixer --get-mute)
  if [ get_mute = 'true' ]; then
    printf "^c$blue^ 󰝟^"
  else
    printf "^c$blue^ 󰕾 $get_vol"
  fi
}

brightness() {
  printf "^c$red^   "
  printf "^c$red^%.0f\n" $(cat /sys/class/backlight/*/brightness)
}

mem() {
  printf "^c$blue^^b$black^  "
  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨  ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭  ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$darkblue^ 󱑆 "
	printf "^c$black^^b$blue^ $(date '+%H:%M')  "
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] 
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$(audio) $(battery) $(brightness) $(cpu) $(mem) $(clock)"
done
