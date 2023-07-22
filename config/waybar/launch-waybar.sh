#!/bin/sh

CONFIG_FILES="/home/sako/.config/waybar"

trap "killall waybar" EXIT

while true; do
    waybar &
    inotifywait -e create,modify $CONFIG_FILES
    killall waybar
done
