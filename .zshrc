source ~/.aliases
if [[ ! -d ~/.zgen ]]; then
  git clone https://github.com/tarjoilija/zgen ~/.zgen
fi

source ~/.zgen/zgen.zsh

if ! zgen saved; then
    zgen load mafredri/zsh-async
    zgen load DFurnes/purer
    zgen load zsh-users/zsh-history-substring-search
    zgen load zsh-users/zsh-autosuggestions
    zgen load nathanblair/fast-syntax-highlighting
    zgen save
fi

# Prompt configuration
#SPACESHIP_CHAR_SYMBOL_ROOT=#
#SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true
#SPACESHIP_PROMPT_PREFIXES_SHOW=true
#SPACESHIP_PROMPT_ADD_NEWLINE=false
#SPACESHIP_PROMPT_SEPARATE_LINE=false
#SPACESHIP_USER_SHOW=always
#SPACESHIP_HOST_SHOW=always
#SPACESHIP_TIME_SHOW=true
#SPACESHIP_TIME_12H=true
#SPACESHIP_EXIT_CODE_SHOW=true
#SPACESHIP_PROMPT_ORDER=(
    #user
    #dir
    #host
    #char
#)
#SPACESHIP_RPROMPT_ORDER=(
	#git
	#exec_time
	#exit_code
	#node
	#dotnet
	#jobs
	#time
	#line_sep
#)

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
		[[ $1 = 'beam' ]]; then
		echo -ne '\e[5 q'
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
#else
    #SPACESHIP_CHAR_SYMBOL=\>
    #SPACESHIP_CHAR_SUFFIX=\ 
    #SPACESHIP_GIT_SYMBOL=√
    #SPACESHIP_GIT_BRANCH_PREFIX=√\ 
fi

export EDITOR=vim
export VISUAL=vim
export CC=$(which clang)
export CXX=$(which clang++)
export LC_ALL=en_US.UTF-8


export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
