# vim:ft=sh

. "${HOME}/.env" || true
. "${HOME}/.aliases" || true

if [ "$(env | grep WSL)" ]; then
  printf "\e]0;${HOST} [WSL]\a"
fi

. "${HOME}/.prompt.zsh"

KEYTIMEOUT=5

WORDCHARS=''

bindkey "^?" backward-delete-char
bindkey "^H" backward-delete-char
bindkey "^w" backward-delete-word
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search
bindkey "^F" forward-word

# Enable zsh fpath completions
# autoload -Uz compinit && rm -f ~/.zcompdump; compinit -i

# complete -o nospace -C $(which terraform) terraform
