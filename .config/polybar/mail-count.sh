#!/bin/bash
# Unread mail count from mailnag (D-Bus). Prints nothing if mailnag is not running or count is 0,
# so the polybar module hides itself.
#   mail-count.sh          # print count
#   mail-count.sh check    # ask mailnag to check mail now

SERVICE=(mailnag.MailnagService /mailnag/MailnagService mailnag.MailnagService)

if [ "${1:-}" = "check" ]; then
  busctl --user call "${SERVICE[@]}" CheckForMails >/dev/null 2>&1
  exit 0
fi

count=$(busctl --user call "${SERVICE[@]}" GetMailCount 2>/dev/null | awk '{print $2}')
[ -n "$count" ] && [ "$count" -gt 0 ] && printf ' %s\n' "$count" || echo ""
