#pyscripts Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# if find files that not exist, then don't show error
setopt NULL_GLOB
# in terminal use vi mode, ctrl+[
set -o vi

# theme for bat cli tool
export BAT_THEME="OneHalfDark"

export PATH=~/Documents/bash-apps:$PATH
export PATH=~/Documents/bash/bash-scripts:$PATH
export PATH=~/Documents/bash/bash-git:$PATH
export PATH=~/Documents/bash-private/dist:$PATH
export PATH=~/Documents/bash/bash-wp:$PATH
export PATH=~/Documents/bash-arch:$PATH
export PATH=~/Documents/bash:$PATH
export ZSH="/home/serii/.oh-my-zsh"
export PATH;

# change node vesion when run yarn or bun
source ~/Documents/bash/bash-scripts/n.sh
# docker
source ~/dotfiles/scripts/docker.sh

plugins=(z npm zsh-autosuggestions zsh-syntax-highlighting you-should-use copybuffer sudo colored-man-pages vi-mode extract)

set ZSH_HIGHLIGHT_MAXLENGTH=100
ZSH_THEME="powerlevel10k/powerlevel10k"

source $ZSH/oh-my-zsh.sh

export NVM_DIR="/home/serii/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# zsh-z
# autocomplete for zsh shell with tab
autoload -U compinit; compinit
zstyle ':completion:*' menu select

export VISUAL=nvim
export EDITOR="$VISUAL"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

#ZSH_AUTOSUGGEST_ACCEPT_WIDGETS[$ZSH_AUTOSUGGEST_ACCEPT_WIDGETS[(i)forward-char]]=()
bindkey '^J' autosuggest-execute
# bindkey '^P' autosuggest-accept

# atuin - history management
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# yazi - file manager
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# zoxide - smart cd
eval "$(zoxide init zsh)"

source ~/dotfiles/zsh_modules/zsh_colors
source ~/dotfiles/zsh_modules/zsh_aliases
source ~/dotfiles/zsh_modules/zsh_python
source ~/dotfiles/zsh_modules/zsh_node
source ~/dotfiles/zsh_modules/zsh_go
source ~/dotfiles/zsh_modules/zsh_xclip
source ~/dotfiles/zsh_modules/zsh_fzf
source ~/dotfiles/zsh_modules/zsh_ffmpeg
source ~/dotfiles/zsh_modules/zsh_mount
source ~/dotfiles/zsh_modules/zsh_mogrify
source ~/dotfiles/zsh_modules/zsh_dc_docker


