#!/bin/sh

devices=$(lsblk -Jplno NAME,TYPE,RM,SIZE,MOUNTPOINT,VENDOR)
# echo "$devices"
case "$1" in
  --mount)
    for mount in $(echo "$devices" | jq -r '.blockdevices[]  | select(.type == "part") | select(.rm == "1") | select(.mountpoint == null) | .name'); do
      udisksctl mount --no-user-interaction -b "$mount"

      mountpoint=$(udisksctl mount --no-user-interaction -b $mount)
      mountpoint=$(echo $mountpoint | cut -d " " -f 4- | tr -d ".")
      terminal -e "bash -lc 'filemanager $mountpoint'" &
    done
    ;;
  --unmount)
    for unmount in $(echo "$devices" | jq -r '.blockdevices[]  | select(.type == "part") | select(.rm == "1") | select(.mountpoint != null) | .name'); do
      udisksctl unmount --no-user-interaction -b "$unmount"
      udisksctl power-off --no-user-interaction -b "$unmount"
    done
    ;;
  *)
    counter=0
    for mounted in $(echo "$devices" | jq -r '.blockdevices[] | select(.type == "part") | select(.mountpoint != null) | .mountpoint'); do
      # if mounted != / or /boot
      if [ "$mounted" != "/" ] && [ "$mounted" != "/boot" ]; then
        device_size=$(echo "$devices" | jq -r '.blockdevices[] | select(.mountpoint == "'"$mounted"'") | .size')
        device_name=$(echo "$devices" | jq -r '.blockdevices[] | select(.mountpoint == "'"$mounted"'") | .name')
        mounted=$(echo "$mounted" | tr -d "/")
        if [ $counter -eq 0 ]; then
          space=""
        else
          space="   "
        fi
        counter=$((counter + 1))

        output="$device_name $device_size"
        echo "$output" | tr '\n' ' '
      fi
    done
    if [ $counter == 0 ]; then
      echo "No USB"
    fi
    ;;
esac
