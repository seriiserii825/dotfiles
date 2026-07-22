#!/bin/sh

devices=$(lsblk -Jplno NAME,TYPE,RM,SIZE,MOUNTPOINT,VENDOR,TRAN,PKNAME)
# echo "$devices"
# A partition counts as "pluggable" if its own transport, or its parent
# disk's transport, is usb. Many USB-SATA enclosures don't set RM=1,
# so RM alone is not reliable here.
usb_part_filter='(.blockdevices | map(select(.type=="disk")) | INDEX(.name)) as $disks | .blockdevices[] | select(.type == "part") | . + {ptran: ($disks[.pkname].tran // .tran)} | select(.ptran == "usb")'
case "$1" in
  --mount)
    for mount in $(echo "$devices" | jq -r "$usb_part_filter"' | select(.mountpoint == null) | .name'); do
      udisksctl mount --no-user-interaction -b "$mount"

      mountpoint=$(udisksctl mount --no-user-interaction -b $mount)
      mountpoint=$(echo $mountpoint | cut -d " " -f 4- | tr -d ".")
      terminal -e "bash -lc 'filemanager $mountpoint'" &
    done
    ;;
  --unmount)
    for unmount in $(echo "$devices" | jq -r "$usb_part_filter"' | select(.mountpoint != null) | .name'); do
      udisksctl unmount --no-user-interaction -b "$unmount"
      udisksctl power-off --no-user-interaction -b "$unmount"
    done
    ;;
  *)
    counter=0
    for mounted in $(echo "$devices" | jq -r "$usb_part_filter"' | select(.mountpoint != null) | .mountpoint'); do
      device_size=$(echo "$devices" | jq -r '.blockdevices[] | select(.mountpoint == "'"$mounted"'") | .size')
      device_name=$(echo "$devices" | jq -r '.blockdevices[] | select(.mountpoint == "'"$mounted"'") | .name')
      used_pct=$(df -P "$mounted" | tail -n1 | awk '{print $5}' | tr -d '%')
      free_pct=$((100 - used_pct))
      if [ $counter -eq 0 ]; then
        space=""
      else
        space="   "
      fi
      counter=$((counter + 1))

      output="${space}${device_name##*/} ${device_size} (${free_pct}% free)"
      echo "$output" | tr '\n' ' '
    done
    if [ $counter == 0 ]; then
      echo "No USB"
    fi
    ;;
esac
