#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
SOURCE_DIR="$DOTFILES_DIR/apps/claude"

mkdir -p "$CLAUDE_DIR"

link() {
  local src="$SOURCE_DIR/$1"
  local dst="$CLAUDE_DIR/$1"

  if [ -L "$dst" ]; then
    echo "already linked: $dst"
    return
  fi

  if [ -e "$dst" ]; then
    rm -rf "$dst"
  fi

  ln -s "$src" "$dst"
  echo "linked: $dst -> $src"
}

link commands
link settings.json
