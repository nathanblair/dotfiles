source ~/.aliases
# Check if zplug is installed
if [[ ! -d ~/.zgen ]]; then
  git clone https://github.com/tarjoilija/zgen ~/.zgen
fi

source ~/.zgen/zgen.zsh

if ! zgen saved; then
	zgen load zsh-users/zsh-history-substring-search
	zgen load zsh-users/zsh-autosuggestions
	zgen load nathanblair/fast-syntax-highlighting
	zgen load denysdovhan/spaceship-prompt spaceship

	zgen save
fi
#
# Plugin configuration
SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_12H=true
SPACESHIP_EXIT_CODE_SHOW=true

ZSH_AUTOSUGGEST_USE_ASYNC=true

zstyle ':completion:*' menu yes select
zmodload zsh/complist
setopt MENU_COMPLETE
bindkey -M menuselect '^[[Z' reverse-menu-complete
#
