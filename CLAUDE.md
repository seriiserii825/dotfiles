# dotfiles

Личные конфиги, симлинкаются вручную из `~/dotfiles/.config/<app>` в `~/.config/<app>` (см. существующие симлинки как образец — не GNU stow, просто `ln -s`).

`packages/pacman.txt` — пакеты из официальных репозиториев, `packages/eiwi.txt` — пакеты из AUR (ставятся через `yay`).

## Задачи для Claude Code на новой машине

Когда открываешь этот репозиторий Claude Code'ом на новой (например, домашней) машине — вот пункты, которые можно/нужно накатить. Не делай их молча все подряд — сверься с пользователем, что из этого актуально для этой машины (например, i3 vs другой WM, есть ли уже Chrome и т.п.).

### chrome-open-dialog-with-yazi

Полное описание проблемы и решения: `~/Documents/Knowledge-base_/Arch/chrome-open-dialog-with-yazi.md` (это на исходной машине; если её нет тут — она не синхронизируется через dotfiles, содержимое ниже самодостаточно).

Проблема: GTK Save-диалог Chrome не реагирует на Enter после ввода имени файла. Решение — заменить его на `xdg-desktop-portal` + `yazi` через `xdg-desktop-portal-termfilechooser`.

Шаги установки на новой машине:

1. Убедиться, что `yazi` установлен (`packages/pacman.txt`), и `i3` — WM (для правила `for_window` ниже; если WM другой, шаг с i3 адаптировать/пропустить).

2. Поставить AUR-пакет:
   ```
   yay -S xdg-desktop-portal-termfilechooser
   ```
   (уже добавлен в `packages/eiwi.txt` — можно сверить, что установлен, через `pacman -Qi xdg-desktop-portal-termfilechooser`).

3. Конфиги уже лежат в этом репо (симлинкать, если симлинков ещё нет):
   ```
   ln -s ~/dotfiles/.config/xdg-desktop-portal-termfilechooser ~/.config/xdg-desktop-portal-termfilechooser
   ln -s ~/dotfiles/.config/xdg-desktop-portal ~/.config/xdg-desktop-portal
   ```
   Файлы: `.config/xdg-desktop-portal-termfilechooser/config` (там `TERMCMD=alacritty -T termfilechooser -e` — если на новой машине терминал не alacritty, поправить), `.config/xdg-desktop-portal/portals.conf`.

4. i3-конфиг (`.config/i3/workspaces`) уже содержит правило:
   ```
   for_window [title="termfilechooser"] floating enable, resize set 900 700, move position center, focus
   ```
   и `.config/i3/keyboard` уже содержит биндинг Chrome с переменной окружения:
   ```
   bindsym $mod+g exec env GTK_USE_PORTAL=1 google-chrome-stable
   ```
   Если Chrome запускается иначе на новой машине (другой биндинг/автостарт) — добавить `GTK_USE_PORTAL=1` туда же.

5. Перезапустить сервисы и reload i3:
   ```
   systemctl --user restart xdg-desktop-portal.service xdg-desktop-portal-termfilechooser.service
   i3-msg reload
   ```

6. **Важно:** если Chrome уже был запущен на этой машине до пункта 4 — он не подхватит `GTK_USE_PORTAL=1` (single-instance процесс). Нужно полностью закрыть Chrome (`pgrep -al chrome` должен быть пуст) и открыть заново через биндинг.

7. Проверить: Ctrl+S в Chrome на любой странице — должно открыться floating-окно alacritty с yazi по центру экрана, а не нативный GTK-диалог.

Диагностика при проблемах:
```
journalctl --user -u xdg-desktop-portal.service -u xdg-desktop-portal-termfilechooser.service --since "5 minutes ago" --no-pager
busctl --user call org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.FileChooser OpenFile "ssa{sv}" "" "Test" 0
```
Частые грабли: осиротевший вручную запущенный `xdg-desktop-portal-termfilechooser` держит имя на D-Bus (`failed to acquire service name: File exists`) — проверить `ps aux | grep termfilechooser`, убить лишнее, перезапустить сервис.

Как пользоваться (после установки): при сохранении файла yazi открывает директорию с файлом-плейсхолдером (предложенное Chrome имя). Подтверждение сохранения — действие `open` на этом файле (у пользователя в `.config/yazi/keymap.toml` забинжено на `o`, не на `Enter` — в главном режиме менеджера `<Enter>` не забинден вообще). `q` — отмена.
