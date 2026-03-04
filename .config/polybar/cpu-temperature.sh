#!/bin/bash
# Auto-detect CPU temperature (works on Intel coretemp and AMD k10temp)

temp_file=""

# Try k10temp (AMD)
for f in /sys/class/hwmon/hwmon*/name; do
    name=$(cat "$f" 2>/dev/null)
    if [[ "$name" == "k10temp" ]]; then
        dir=$(dirname "$f")
        temp_file="$dir/temp1_input"
        break
    fi
done

# Try coretemp (Intel)
if [[ -z "$temp_file" ]]; then
    for f in /sys/class/hwmon/hwmon*/name; do
        name=$(cat "$f" 2>/dev/null)
        if [[ "$name" == "coretemp" ]]; then
            dir=$(dirname "$f")
            # temp1 is usually Package id 0 (total CPU temp)
            if [[ -f "$dir/temp1_input" ]]; then
                temp_file="$dir/temp1_input"
                break
            fi
        fi
    done
fi

if [[ -z "$temp_file" ]] || [[ ! -f "$temp_file" ]]; then
    echo "N/A"
    exit 0
fi

temp_raw=$(cat "$temp_file" 2>/dev/null)
temp_c=$((temp_raw / 1000))
echo "${temp_c}°C"
