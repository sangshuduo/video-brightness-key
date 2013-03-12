#!/bin/bash

# this directory is a symlink on my machine:
KEYS_DIR=/sys/class/backlight/acpi_video0

test -d $KEYS_DIR || exit 0

MIN=0
MAX=$(cat $KEYS_DIR/max_brightness)
VAL=$(cat $KEYS_DIR/brightness)

if [ "$1" = down ]; then
	VAL=$((VAL-1))
else
	VAL=$((VAL+1))
fi

if [ "$VAL" -lt $MIN ]; then
	VAL=$MIN
elif [ "$VAL" -gt $MAX ]; then
	VAL=$MAX
fi

PERCENT=$(($VAL*100/15))

echo "$PERCENT"

echo $VAL > $KEYS_DIR/brightness

for user in $(users)
do
	su $user -l -c "DISPLAY=:0.0 notify-send 'Brightness' -i notification-display-brightness-high -h int:value:$PERCENT -h  string:x-canonical-private-synchronous:brightness"
done

