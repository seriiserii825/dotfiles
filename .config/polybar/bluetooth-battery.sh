#!/bin/bash
# Polybar: connected Bluetooth devices with battery level.
# Prints nothing when no device is connected — polybar then hides the module.

out=""
while read -r _ mac _; do
    [ -z "$mac" ] && continue
    info=$(bluetoothctl info "$mac")
    name=$(awk -F': ' '/^\s*Alias:/ {print $2; exit}' <<<"$info")
    battery=$(awk -F'[()]' '/Battery Percentage/ {print $2; exit}' <<<"$info")

    entry="$name"
    if [ -n "$battery" ]; then
        if [ "$battery" -le 20 ]; then
            entry="$entry %{F#FF6B6B}${battery}%%{F-}"
        else
            entry="$entry ${battery}%"
        fi
    fi
    out="${out:+$out, }$entry"
done < <(bluetoothctl devices Connected 2>/dev/null)

[ -n "$out" ] && echo " $out"
exit 0
