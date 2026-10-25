export PATH="$HOME/.local/bin:$PATH"
source ~/dotfiles/zsh_modules/zsh_colors
source ~/dotfiles/zsh_modules/zsh_bash_scripts
source ~/dotfiles/zsh_modules/zsh_nvm
source ~/dotfiles/zsh_modules/zsh_default_editor
source ~/dotfiles/zsh_modules/zsh_yazi
source ~/dotfiles/zsh_modules/zsh_zoxide
source ~/dotfiles/zsh_modules/zsh_go
source ~/dotfiles/zsh_modules/zsh_xclip
source ~/dotfiles/zsh_modules/zsh_fzf
source ~/dotfiles/zsh_modules/zsh_ffmpeg
source ~/dotfiles/zsh_modules/zsh_mount
source ~/dotfiles/zsh_modules/zsh_mogrify
source ~/dotfiles/zsh_modules/zsh_dc_docker
source ~/dotfiles/zsh_modules/zsh_oh_my_zsh
source ~/dotfiles/zsh_modules/zsh_atuin
source ~/dotfiles/zsh_modules/zsh_aliases
source ~/dotfiles/zsh_modules/zsh_git
source ~/dotfiles/zsh_modules/zsh_find
source ~/dotfiles/zsh_modules/zsh_zellij

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# go: добавляем $GOPATH/bin в PATH только если его там ещё нет
if command -v go >/dev/null 2>&1; then
  _gobin="$(go env GOPATH)/bin"
  [[ ":$PATH:" != *":$_gobin:"* ]] && export PATH="$_gobin:$PATH"
  unset _gobin
fi

# global-aliases
source ~/Documents/global-aliases/zsh_golang
source ~/Documents/global-aliases/zsh_lf
source ~/Documents/global-aliases/zsh_local_cli
source ~/Documents/global-aliases/zsh_node
source ~/Documents/global-aliases/zsh_parser
source ~/Documents/global-aliases/zsh_python
source ~/Documents/global-aliases/zsh_wp
