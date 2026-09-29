#!/usr/bin/env bash
# Запускает Chrome и переносит его новое окно на воркспейс, с которого был запуск.
# Нужно, потому что Chrome при восстановлении сессии ставит _NET_WM_DESKTOP
# (запомненный рабочий стол), а i3 открывает окно именно там — часто на другом мониторе.

ws=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused) | .name')

# Ждём первое новое окно Chrome (максимум 15 секунд) и переносим его.
(
  timeout 15 i3-msg -t subscribe -m '["window"]' \
    | jq --unbuffered -r 'select(.change == "new" and .container.window_properties.class == "Google-chrome") | .container.id' \
    | head -n1 \
    | while read -r id; do
        i3-msg "[con_id=$id] move container to workspace \"$ws\", focus" >/dev/null
        i3-msg "workspace \"$ws\"" >/dev/null
      done
) &

sleep 0.2
GTK_USE_PORTAL=1 exec google-chrome-stable "$@"
