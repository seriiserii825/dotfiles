---
name: go-install
description: Use at the end of any task that changed Go code (.go files, go.mod/go.sum) in a Go CLI project of the user (a module with `package main` in the root, e.g. ~/Documents/go/go-scripts) — after vet/tests pass, runs `go install .` from the module root so the installed binary in $GOBIN/~/go/bin picks up the change.
---

# go-install

Пользователь запускает свои Go-утилиты (например, `go-scripts`) как установленный
бинарник из `~/go/bin`, а не через `go run`. Поэтому любое изменение кода, не
сопровождённое `go install .`, на деле не видно — бинарник остаётся старым.

## Когда

В конце задачи, в которой менялись `.go`-файлы, `go.mod` или `go.sum` в модуле,
где в корне есть `package main` (проверить: `go list -f '{{.Name}}' .` выдаёт `main`).
Не нужно для библиотек без `main` в корне (например, `go-libs`).

## Шаги

1. Из корня модуля (где `go.mod`):
   ```
   go vet ./... && go test ./...
   ```
   Если что-то падает — **не** устанавливать, сначала починить или сообщить
   пользователю с выводом ошибки.
2. Если всё зелёное:
   ```
   go install .
   ```
3. В итоговом ответе одной строкой сказать, что бинарник переустановлен
   (или почему нет).

Git-команды не запускать — пользователь коммитит сам.
