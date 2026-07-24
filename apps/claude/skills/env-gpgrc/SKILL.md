---
name: env-gpgrc
description: Use whenever a .env file is created, found, or edited in any git repo that uses the .gpgrc/gpg workflow (bash-git/encrypt.sh, bash-scripts/gpg.sh) — registers the .env in that repo's .gpgrc so it gets auto encrypted/decrypted, creating .gpgrc if it doesn't exist yet.
---

# env-gpgrc

Во всех репозиториях пользователя секреты хранятся через единый конвеншен:
`.gpgrc` в корне репо со списком файлов вида `<path>.gpg` — их шифрует/расшифровывает
`bash-git/encrypt.sh` (вызывается из `git-push.sh`/`git-pull.sh`/`git-clone.sh`) и
вручную `bash-scripts/gpg.sh --env --encrypt|--decrypt`. Каждый `.env` должен быть
зарегистрирован в `.gpgrc`, иначе он никогда не попадёт в зашифрованном виде в git.

## Когда применять

Как только в репозитории появляется (создаётся вручную, генерируется скриптом,
копируется) файл `.env` (в корне или во вложенной папке) — сразу же:

1. Найти корень репозитория (`git rev-parse --show-toplevel`).
2. Проверить `.gpgrc` в этом корне.
3. Добавить туда путь к `.env` относительно корня репо, с суффиксом `.gpg`.

## Формат строки в .gpgrc

Путь — относительно корня репозитория, без ведущего `./`, с `.gpg` в конце:

- `.env` в корне репо → строка `.env.gpg`
- `.env` в подпапке, например `apps/api/.env` → строка `apps/api/.env.gpg`

## Алгоритм

```bash
REPO_ROOT="$(git rev-parse --show-toplevel)"
ENV_REL="$(realpath --relative-to="$REPO_ROOT" "$ENV_FILE")"   # напр. .env или apps/api/.env
GPGRC="$REPO_ROOT/.gpgrc"
ENTRY="${ENV_REL}.gpg"

# создать .gpgrc, если его нет
[ -f "$GPGRC" ] || touch "$GPGRC"

# добавить запись, только если её там ещё нет
grep -qxF "$ENTRY" "$GPGRC" || echo "$ENTRY" >> "$GPGRC"
```

Ключевые правила:

1. **Не дублировать строки** — проверять `grep -qxF` перед добавлением
   (`.gpgrc` читается построчно в `encrypt.sh`/`decrypt.sh`, дубли просто
   зря пересчитают/перезапишут один и тот же файл).
2. **Не шифровать сам файл** — эта задача только регистрирует `.env` в
   `.gpgrc`. Реальное шифрование (`gpg.sh --env --encrypt` или `gpg -e -r
   $USER .env`) пользователь делает сам, если явно не попросил иначе.
3. **`.env` уже должен быть в `.gitignore`** репозитория — если его там нет,
   добавить (иначе plaintext секретов попадёт в git при обычном `git add .`).
4. **Не трогать существующие строки** `.gpgrc` — только дописывать
   недостающую, никогда не переписывать файл целиком.
5. Если в репозитории несколько `.env`-подобных файлов (`.env`,
   `.env.local`, `.env.production` и т.п.) — регистрировать именно тот,
   который реально был создан/изменён, не пытаться угадать остальные.
