#!/bin/sh

CONFIG_FILES="/home/sako/.config/waybar"

trap "killall waybar" EXIT

while true; do
    waybar &
    export APP_PID=$!
    inotifywait -e create,modify $CONFIG_FILES
    kill $APP_PID
done
