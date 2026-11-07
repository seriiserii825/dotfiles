#!/bin/sh
# Open images in nsxiv from yazi.
# One file  -> all images in its directory, starting at that file (n/p work).
# Several   -> exactly the selected files.
[ "$#" -ne 1 ] && exec nsxiv -- "$@"

dir=$(cd -- "$(dirname -- "$1")" && pwd) || exit 1
file="$dir/$(basename -- "$1")"

list=$(find "$dir" -maxdepth 1 \( -type f -o -type l \) \
	-iregex '.*\.\(jpe?g\|png\|gif\|webp\|bmp\|tiff?\|avif\|heic\|heif\|jxl\)$' | sort -f)
idx=$(printf '%s\n' "$list" | grep -nxF -- "$file" | cut -d: -f1)

if [ -z "$idx" ]; then
	exec nsxiv -- "$1"
fi
printf '%s\n' "$list" | exec nsxiv -i -n "$idx"
