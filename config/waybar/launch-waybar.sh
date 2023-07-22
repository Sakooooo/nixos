#!/bin/sh

CONFIG_FILES="/home/sako/.config/waybar/config /home/sako/.config/waybar/style.css"

trap "killall waybar" EXIT

while true; do
    waybar &
    inotifywait -e create,modify $CONFIG_FILES
    killall waybar
done
