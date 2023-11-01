# vim:ft=sh

. "${HOME}/.env" || true
. "${HOME}/.aliases" || true

if [ "$(env | grep WSL)" ]; then
  printf "\e]0;${HOST} [WSL]\a"
fi

. "${HOME}/.prompt.zsh"

KEYTIMEOUT=5

WORDCHARS=''

FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"

# Enable zsh fpath completions
autoload -Uz compinit && compinit -i
autoload -Uz bashcompinit && bashcompinit

zstyle ':completion:*' menu select
zstyle ':completion:*' file-list all
zstyle ':completion:*' group-name ''

complete -o nospace -C $(which terraform) terraform

. $(brew --prefix)/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
. $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTOSUGGEST_STRATEGY=(completion history)
ZSH_AUTOSUGGEST_USE_ASYNC=1

bindkey "^?" backward-delete-char
bindkey "^H" backward-delete-char
bindkey "^w" backward-delete-word
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search
bindkey "^F" forward-word
bindkey '^[[Z' reverse-menu-complete
