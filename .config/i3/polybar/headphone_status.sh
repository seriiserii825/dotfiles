#!/bin/bash

# Get default sink
sink=$(pactl get-default-sink)

# Extract block for the default sink
sink_info=$(pactl list sinks | awk -v s="$sink" '
  $0 ~ "Sink #" { in_block = 0 }
  $0 ~ "Name: "s { in_block = 1 }
  in_block { print }
')

# Extract active port and its description
active_port=$(echo "$sink_info" | awk '/Active Port:/ { print $3 }')
port_description=$(echo "$sink_info" | awk -v p="$active_port" '
  $1 == "Port:" && $2 == p { $1=$2=""; print substr($0,3) }
')

# Output icon and description (or fallback)
if [[ "$active_port" == *"headphone"* ]]; then
    echo " ${port_description:-Headphones}"
else
    echo " ${port_description:-Speakers}"
fi
