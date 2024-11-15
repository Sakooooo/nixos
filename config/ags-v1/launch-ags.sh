#!/bin/sh

CONFIG_FILES="/home/sako/.config/ags"

trap "killall ags" EXIT

while true; do
    ags &
    export APP_PID=$!
    inotifywait -e create,modify $CONFIG_FILES
    kill $APP_PID
done
