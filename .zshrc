source ~/dotfiles/zsh_modules/zsh_oh_my_zsh
source ~/dotfiles/zsh_modules/zsh_bash_scripts
source ~/dotfiles/zsh_modules/zsh_nvm
source ~/dotfiles/zsh_modules/zsh_default_editor
source ~/dotfiles/zsh_modules/zsh_atuin
source ~/dotfiles/zsh_modules/zsh_yazi
source ~/dotfiles/zsh_modules/zsh_zoxide
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

