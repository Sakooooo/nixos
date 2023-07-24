#!/bin/sh

sleep 1 && killall trayer
trayer \
  --edge bottom \
  --align right \
  --SetDockType true \
  --SetPartialStrut true \
  --height 30 \
  --transparent true \
  --alpha 0 \
  --tint #000000 \
  --widthtype request
