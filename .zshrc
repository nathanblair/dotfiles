# vim:ft=sh

. "${HOME}/.prompt.zsh" 2>/dev/null || true
. ~/.env || true
. ~/.aliases || true
. ~/.tokens || true

if [ ! -d ~/.zgen ]; then
    git clone https://github.com/tarjoilija/zgen ~/.zgen
fi

. ~/.zgen/zgen.zsh

if ! zgen saved; then
    zgen load zsh-users/zsh-history-substring-search
    zgen load zsh-users/zsh-autosuggestions
    zgen load zdharma/fast-syntax-highlighting
    zgen save
fi

ZSH_AUTOSUGGEST_USE_ASYNC=true

WORDCHARS=''
zstyle ':completion:*' menu yes select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zmodload zsh/complist
setopt MENU_COMPLETE

KEYTIMEOUT=5

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
autoload -U compinit
compinit -i

if [ -n "$DISPLAY" ]; then
    # Use beam shape cursor for each new prompt.
    preexec() {
        echo -ne '\e[5 q'
    }
fi

complete -o nospace -C $(which terraform) terraform

