#!/bin/bash

# check if have file .nvmrc
if [ -f .nvmrc ]; then
  if [ -n "$MSYSTEM" ] && [ "$MSYSTEM" = "MINGW64" ]; then
    local node_version="$(nvm version)"
    local nvmrc_version=$(cat .nvmrc)

    echo "node version: $node_version"
    echo "nvmrc version: $nvmrc_version"

    if [ "$nvmrc_version" != "$node_version" ]; then
      echo "Choose node version: $nvmrc_version"
      exit 1
    fi
  else
    autoload -U add-zsh-hook
    load-nvmrc() {
      local node_version="$(nvm version)"
      local nvmrc_path="$(nvm_find_nvmrc)"

      if [ -n "$nvmrc_path" ]; then
        local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

        if [ "$nvmrc_node_version" = "N/A" ]; then
          nvm install
        elif [ "$nvmrc_node_version" != "$node_version" ]; then
          nvm use
        fi
      elif [ "$node_version" != "$(nvm version default)" ]; then
        echo "Reverting to nvm default version"
        nvm use default
      fi
    }
    add-zsh-hook chpwd load-nvmrc
    load-nvmrc
  fi
elif [ -f package.json ]; then
  echo "No .nvmrc file found"
fi
