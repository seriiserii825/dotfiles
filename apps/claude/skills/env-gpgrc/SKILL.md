---
name: env-gpgrc
description: Use whenever a secret/credentials file (.env, .env.local, or a *-env.sh style credentials file with API keys/passwords/tokens) is created, found, or edited in any git repo that uses the .gpgrc/gpg workflow (bash-git/encrypt.sh, bash-scripts/gpg.sh) — registers it in that repo's .gpgrc (with .gpg suffix) and its plaintext path in .gitignore, creating .gpgrc if it doesn't exist yet.
---

# env-gpgrc

Во всех репозиториях пользователя секреты хранятся через единый конвеншен:
`.gpgrc` в корне репо со списком файлов вида `<path>.gpg` — их шифрует/расшифровывает
`bash-git/encrypt.sh` (вызывается из `git-push.sh`/`git-pull.sh`/`git-clone.sh`) и
вручную `bash-scripts/gpg.sh --env --encrypt|--decrypt`. Это касается не только
`.env`, но и любого другого secret-файла с кредами (например,
`bash-scripts/export-xml-env.sh`, `bash-scripts/set-smtp-to-wp-config-env.sh`) —
каждый такой файл должен быть зарегистрирован в `.gpgrc` **и** в `.gitignore`,
иначе он либо никогда не попадёт в git в зашифрованном виде, либо (хуже) утечёт
в git как plaintext.

## Механизм

`bash-git/encrypt.sh` (`encryptFiles`/`decryptFiles`) построчно читает
`.gpgrc`. Каждая строка — путь к `.gpg`-файлу от корня репозитория; функция
отрезает суффикс `.gpg`, чтобы получить путь к расшифрованному файлу:

```bash
filename=$(echo "$line" | sed 's/\.gpg$//')
```

## Когда применять

Как только в репозитории появляется (создаётся вручную, генерируется скриптом,
копируется) файл с секретами — `.env`, `.env.local`, `.env.production`, или
кастомный вида `<script-name>-env.sh` — сразу же зарегистрировать его в двух
местах:

1. **`.gpgrc`** — путь к файлу от корня репо, с суффиксом `.gpg`.
2. **`.gitignore`** — тот же путь, без `.gpg` (plaintext-версия не должна
   попадать в git).

## Формат строки

Путь — относительно корня репозитория, без ведущего `./`:

- `.env` в корне репо → `.gpgrc`: `.env.gpg`, `.gitignore`: `.env`
- `.env` в подпапке, например `apps/api/.env` → `.gpgrc`: `apps/api/.env.gpg`,
  `.gitignore`: `apps/api/.env`
- кастомный credentials-файл, например `bash-scripts/set-smtp-to-wp-config-env.sh`
  → `.gpgrc`: `bash-scripts/set-smtp-to-wp-config-env.sh.gpg`, `.gitignore`:
  `bash-scripts/set-smtp-to-wp-config-env.sh`

## Алгоритм

```bash
REPO_ROOT="$(git rev-parse --show-toplevel)"
REL="$(realpath --relative-to="$REPO_ROOT" "$SECRET_FILE")"   # напр. .env или bash-scripts/foo-env.sh
GPGRC="$REPO_ROOT/.gpgrc"
GITIGNORE="$REPO_ROOT/.gitignore"
ENTRY="${REL}.gpg"

# создать .gpgrc, если его нет
[ -f "$GPGRC" ] || touch "$GPGRC"

# добавить запись в .gpgrc, только если её там ещё нет
grep -qxF "$ENTRY" "$GPGRC" || echo "$ENTRY" >> "$GPGRC"

# зарегистрировать plaintext-путь в .gitignore, только если его там ещё нет
grep -qxF "$REL" "$GITIGNORE" 2>/dev/null || echo "$REL" >> "$GITIGNORE"
```

## Сам секретный файл (для кастомных `*-env.sh`, не для `.env`)

- Только plaintext-значения, без исполняемых прав (`644`, не `755`) — файл
  предназначен для `source`, не для запуска напрямую.
- Комментарий-заголовок вида:
  ```bash
  # <Назначение>. Encrypted at rest (see .gpgrc) — never commit unencrypted.
  ```
- Скрипт, который его использует, должен явно проверять существование файла
  перед `source` и подсказывать, что расшифровать нужно вручную:
  ```bash
  if [ ! -f "$SECRET_FILE" ]; then
    echo "Missing ${SECRET_FILE}. Decrypt <name>.gpg first (see .gpgrc)."
    exit 1
  fi
  source "$SECRET_FILE"
  ```

Ключевые правила:

1. **Не дублировать строки** — проверять `grep -qxF` перед добавлением и в
   `.gpgrc`, и в `.gitignore` (дубли просто зря пересчитают/перезапишут один
   и тот же файл).
2. **Не шифровать сам файл** — эта задача только регистрирует secret-файл в
   `.gpgrc`/`.gitignore`. Реальное шифрование (`gpg.sh --env --encrypt` или
   `gpg -e -r $USER <file>`) пользователь делает сам, если явно не попросил
   иначе.
3. **Не трогать существующие строки** `.gpgrc`/`.gitignore` — только
   дописывать недостающее, никогда не переписывать файл целиком.
4. Если в репозитории несколько secret-файлов (`.env`, `.env.local`,
   несколько `*-env.sh`) — регистрировать именно тот, который реально был
   создан/изменён, не пытаться угадать остальные.
