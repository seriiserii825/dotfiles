#!/bin/bash
# Polybar mail widget backed by mailnag (D-Bus).
#   - mailnag works, no unread mail  -> prints nothing (module hidden)
#   - mailnag works, N unread        -> " N" on dark red
#   - mailnag not running            -> "mailnag off" on bright red (left click starts it)
#
#   mail-count.sh          # print widget text
#   mail-count.sh check    # ask mailnag to check mail now
#   mail-count.sh click    # start mailnag if it is down, otherwise focus/open aerc

SERVICE=(mailnag.MailnagService /mailnag/MailnagService mailnag.MailnagService)

mailnag_running() { pgrep -x mailnag >/dev/null; }

case "${1:-}" in
  check)
    busctl --user call "${SERVICE[@]}" CheckForMails >/dev/null 2>&1
    exit 0
    ;;
  click)
    if busctl --user call "${SERVICE[@]}" GetMailCount >/dev/null 2>&1; then
      if pgrep -x aerc >/dev/null; then
        i3-msg -q '[title="^aerc$"] focus'
      else
        i3-msg -q 'exec --no-startup-id alacritty -T aerc -e aerc'
      fi
    else
      pkill -x mailnag
      i3-msg -q 'exec --no-startup-id mailnag'
    fi
    exit 0
    ;;
esac

if out=$(busctl --user call "${SERVICE[@]}" GetMailCount 2>/dev/null); then
  count=$(awk '{print $2}' <<<"$out")
  if [ -n "$count" ] && [ "$count" -gt 0 ]; then
    printf '%%{B#A54242}%%{F#fff}%%{u#FC1D1D}%%{+u}   %s  %%{-u}%%{F-}%%{B-}\n' "$count"
  else
    echo ""
  fi
elif mailnag_running; then
  # Process exists but D-Bus service not registered yet (e.g. just starting) — don't flash red.
  echo ""
else
  printf '%%{B#FC1D1D}%%{F#fff}%%{u#FFFFFF}%%{+u}   mailnag off — click to start  %%{-u}%%{F-}%%{B-}\n'
fi
