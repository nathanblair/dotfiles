# vim:ft=sh

. ~/.env 2>/dev/null || true
. ~/.aliases 2>/dev/null || true
. ~/.tokens 2>/dev/null || true

if [[ ! -d ~/.zgen ]]; then
    git clone https://github.com/tarjoilija/zgen ~/.zgen
fi

. ~/.zgen/zgen.zsh

if ! zgen saved; then
    zgen load zsh-users/zsh-history-substring-search
    zgen load zsh-users/zsh-autosuggestions
    zgen load zdharma/fast-syntax-highlighting
    zgen load denysdovhan/spaceship-prompt spaceship
    zgen save
fi

# Prompt configuration
SPACESHIP_CHAR_SYMBOL_ROOT=#\ 
SPACESHIP_CHAR_PREFIX=\ 
#SPACESHIP_GIT_SYMBOL=
#SPACESHIP_GIT_BRANCH_PREFIX=
SPACESHIP_DIR_PREFIX=
SPACESHIP_DIR_SUFFIX=
SPACESHIP_GIT_PREFIX=\(
SPACESHIP_GIT_SUFFIX=\)
SPACESHIP_GIT_STATUS_PREFIX=
SPACESHIP_GIT_STATUS_SUFFIX=
SPACESHIP_GIT_BRANCH_PREFIX=
SPACESHIP_GIT_BRANCH_SUFFIX=
SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=false
SPACESHIP_PROMPT_PREFIXES_SHOW=true
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_USER_SHOW=needed
SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_12H=true
SPACESHIP_TIME_SUFFIX=\ 
SPACESHIP_EXIT_CODE_SHOW=true
SPACESHIP_EXEC_TIME_PREFIX=\ 
SPACESHIP_EXEC_TIME_SUFFIX=
SPACESHIP_EXIT_CODE_PREFIX=\ 
SPACESHIP_EXIT_CODE_SUFFIX=
SPACESHIP_DOCKER_SYMBOL=🐳
SPACESHIP_DOCKER_PREFIX=
SPACESHIP_DOCKER_SUFFIX=
SPACESHIP_PROMPT_ORDER=(
    jobs
    time
    user
    host
    dir
    git
    #hg
    char
)
SPACESHIP_RPROMPT_ORDER=(
    rust
    node
    ruby
    dotnet
    docker
    kubectl
    exit_code
    exec_time
)

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

# Change cursor shape for different vi modes.
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] ||
        [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] ||
        [[ ${KEYMAP} == viins ]] ||
        [[ ${KEYMAP} = '' ]] ||
        [[ $1 = 'beam' ]]; then echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select

# Enable bash completions
autoload -U +X bashcompinit && bashcompinit
# Enable zsh fpath completions
autoload -U compinit
compinit -i

if [[ -n "$DISPLAY" ]]; then
    # Use beam shape cursor on startup.
    echo -ne '\e[5 q'
    # Use beam shape cursor for each new prompt.
    preexec() {
        echo -ne '\e[5 q'
    }
else
    SPACESHIP_CHAR_SYMBOL=\>
    SPACESHIP_CHAR_SUFFIX=\ 
fi

complete -o nospace -C $(which terraform) terraform

