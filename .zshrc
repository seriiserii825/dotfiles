eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/base.yml)"

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

plugins=(copybuffer dirhistory)
source $ZSH/oh-my-zsh.sh
export PATH;


# change node vesion when run yarn or bun
source ~/Documents/bash/bash-scripts/n.sh
# docker
source ~/dotfiles/scripts/docker.sh

export NVM_DIR="/home/serii/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# autocomplete for zsh shell with tab
autoload -U compinit; compinit
zstyle ':completion:*' menu select

export VISUAL=nvim
export EDITOR="$VISUAL"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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



### Added by Zinit's installer
# if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
#     print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
#     command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
#     command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
#         print -P "%F{33} %F{34}Installation successful.%f%b" || \
#         print -P "%F{160} The clone has failed.%f%b"
# fi
#
# source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
# autoload -Uz _zinit
# (( ${+_comps} )) && _comps[zinit]=_zinit
#
# # Load a few important annexes, without Turbo
# # (this is currently required for annexes)
# zinit light-mode for \
#     zdharma-continuum/zinit-annex-as-monitor \
#     zdharma-continuum/zinit-annex-bin-gem-node \
#     zdharma-continuum/zinit-annex-patch-dl \
#     zdharma-continuum/zinit-annex-rust
#
# zinit light zsh-users/zsh-syntax-highlighting
# zinit light zsh-users/zsh-completions
# zinit light zsh-users/zsh-autosuggestions
# zinit light Aloxaf/fzf-tab
# zinit light zdharma-continuum/fast-syntax-highlighting
#
# # zinit snippet https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/sudo/sudo.plugin.zsh
#
# ### End of Zinit's installer chunk
#
# # zsh basic commands
#
# setopt autocd # cd without typing cd
# setopt correct # correct command if you type wrong
# setopt notify # notify when command finished
# setopt hist_ignore_all_dups # don't save duplicate commands in history
# setopt hist_find_no_dups # don't show duplicate commands in history when searching
# setopt hist_verify # verify command before executing
#
#
