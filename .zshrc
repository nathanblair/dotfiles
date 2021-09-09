# vim:ft=sh

. "${HOME}/.prompt.zsh" || true
. ~/.env || true
. ~/.aliases || true
. ~/.tokens || true

printf "\e]0;$HOSTNAME\a"
if [ "$(env | grep WSL)" ]; then
  printf "\e]0;${HOSTNAME} [WSL]\a"
fi

ZSH_AUTOSUGGEST_USE_ASYNC=true

. ~/.zfuncs/fsh/fast-syntax-highlighting.plugin.zsh
. ~/.zfuncs/zsh-autosuggestions/zsh-autosuggestions.zsh

KEYTIMEOUT=5

#WORDCHARS=''
zstyle ':completion:*' menu yes select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zmodload zsh/complist
setopt MENU_COMPLETE

bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey "^?" backward-delete-char
bindkey "^H" backward-delete-char
bindkey "^W" backward-kill-word
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search
bindkey "^F" forward-word

# Enable bash completions
autoload -U +X bashcompinit && bashcompinit
# Enable zsh fpath completions
autoload -U compinit && compinit -i

complete -o nospace -C $(which terraform) terraform

