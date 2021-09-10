# vim:ft=sh

. "${HOME}/.env" || true
. "${HOME}/.aliases" || true
. "${HOME}/.tokens" || true

printf "\e]0;$HOST\a"
if [ "$(env | grep WSL)" ]; then
  printf "\e]0;${HOST} [WSL]\a"
fi

if [ ! -f "${HOME}/.zfuncs/fsh/fast-syntax-highlighting.plugin.zsh" ] ||
   [ ! -f "${HOME}/.zfuncs/zsh-autosuggestions/zsh-autosuggestions.zsh" ] ||
   [ ! -f "${HOME}/.zfuncs/prompt/prompt.zsh" ]; then
  git submodule update --init --recursive --depth 1
fi

. "${HOME}/.zfuncs/prompt/prompt.zsh"
. "${HOME}/.zfuncs/fsh/fast-syntax-highlighting.plugin.zsh"
. "${HOME}/.zfuncs/zsh-autosuggestions/zsh-autosuggestions.zsh"

ZSH_AUTOSUGGEST_USE_ASYNC=true

KEYTIMEOUT=5

WORDCHARS=''
zstyle ':completion:*' menu yes select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zmodload zsh/complist
setopt MENU_COMPLETE

bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey "^?" backward-delete-char
bindkey "^H" backward-delete-char
bindkey "^w" backward-delete-word
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search
bindkey "^F" forward-word

# Enable bash completions
autoload -U +X bashcompinit && bashcompinit
# Enable zsh fpath completions
autoload -U compinit && compinit -i

complete -o nospace -C $(which terraform) terraform

