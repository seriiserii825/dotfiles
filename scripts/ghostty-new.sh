#!/usr/bin/env zsh

# Get PID of the active window
pid=$(xdotool getactivewindow getwindowpid 2>/dev/null)

# Get current working directory of the process
cwd=$(readlink "/proc/$pid/cwd" 2>/dev/null)

# Fallback to $HOME if anything goes wrong
if [[ -z "$cwd" || ! -d "$cwd" ]]; then
    cwd="$HOME"
fi

# Launch Ghostty in that directory
ghostty --working-directory="$cwd" &
