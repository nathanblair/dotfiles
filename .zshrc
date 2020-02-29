source ~/.aliases
source ~/.tokens
if [[ ! -d ~/.zgen ]]; then
  git clone https://github.com/tarjoilija/zgen ~/.zgen
fi

source ~/.zgen/zgen.zsh

if ! zgen saved; then
    zgen load zsh-users/zsh-history-substring-search
    zgen load zsh-users/zsh-autosuggestions
    zgen load zdharma/fast-syntax-highlighting
    zgen load denysdovhan/spaceship-prompt spaceship
    zgen save
fi

# Prompt configuration
SPACESHIP_CHAR_SYMBOL_ROOT=#\ 
SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true
SPACESHIP_PROMPT_PREFIXES_SHOW=true
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_USER_SHOW=needed
SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_12H=true
SPACESHIP_TIME_SUFFIX=
SPACESHIP_EXIT_CODE_SHOW=true
SPACESHIP_PROMPT_ORDER=(
    user
    host
    dir
    char
)
SPACESHIP_RPROMPT_ORDER=(
    git
    exec_time
    exit_code
    node
    dotnet
    jobs
    time
    #line_sep
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
    SPACESHIP_GIT_SYMBOL=√
    SPACESHIP_GIT_BRANCH_PREFIX=√\ 
fi

export EDITOR=$(which nvim)
export VISUAL=$(which nvim)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export QT_QPA_PLATFORM=wayland
export CLUTTER_BACKEND=wayland
export XDG_SESSION_TYPE=wayland
#export GDK_BACKEND=wayland

export MOZ_ENABLE_WAYLAND=1
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export CC=clang
export CXX=clang++

if test -z "${XDG_RUNTIME_DIR}"; then
  export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
  if ! test -d "${XDG_RUNTIME_DIR}"; then
    mkdir "${XDG_RUNTIME_DIR}" >> /dev/null
    chmod 0700 "${XDG_RUNTIME_DIR}"
  fi
fi

export PATH=/usr/local/bin:$PATH
