export PATH=~/Documents/bash-apps:$PATH
export PATH=~/Documents/bash/bash-scripts:$PATH
export PATH=~/Documents/bash/bash-git:$PATH
export PATH=~/Documents/bash-private/dist:$PATH
export PATH=~/Documents/bash/bash-wp:$PATH
export PATH=~/Documents/bash-arch:$PATH
export PATH=~/Documents/bash:$PATH
export ZSH="/home/serii/.oh-my-zsh"
ZSH_THEME="bira"
source $ZSH/oh-my-zsh.sh

plugins=(copybuffer dirhistory)



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

# zinit light zsh-users/zsh-syntax-highlighting
# zinit light zsh-users/zsh-completions
# zinit light zsh-users/zsh-autosuggestions
# zinit light Aloxaf/fzf-tab
# zinit light zdharma-continuum/fast-syntax-highlighting
#
# # zinit snippet https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/sudo/sudo.plugin.zsh

# if find files that not exist, then don't show error
setopt NULL_GLOB
# in terminal use vi mode, ctrl+[
set -o vi

