# vim:ft=sh

. "${HOME}/.env" || true
. "${HOME}/.aliases" || true
. "${HOME}/.tokens" || true

if [ $(uname) = "Darwin" ]; then
  alias code='open -b com.microsoft.VSCode "$@"'
  alias make="gmake"
  alias ls="ls -G"
else
  alias ls="ls --color=always"
fi

printf "\e]0;${HOST}\a"
if [ "$(env | grep WSL)" ]; then
  printf "\e]0;${HOST} [WSL]\a"
fi

. "${HOME}/.zfuncs/prompt/prompt.zsh"

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
