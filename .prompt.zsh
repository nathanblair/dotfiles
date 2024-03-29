function preexec() {
  timer=${timer:-$SECONDS}
}

function precmd() {
  if [ $timer ]; then
    time_info=$((SECONDS - timer))
    if [ ${time_info} -gt 0 ]; then
      time_info="%F{cyan}${time_info}s"
    else
      time_info=""
    fi
  fi

  if [ "$TERM_PROGRAM" = WarpTerminal ]; then
    RPROMPT="${time_info}%{%{$reset_color%}%}"
  else
    echo -n "${time_info}%{%{$reset_color%}%}"
  fi
  unset timer
  unset time_info
}

function clean() {
  echo -n "%{%b%k%f%}"
}

function last_command_status() { echo -n "%(?..%{%F{red}%}(%?%))" }

function host_info() {
  if [ -n "${SSH_CONNECTION}" ]; then
    echo -n "%{%F{magenta}%}[%{%b%k%f%}%m%{%F{magenta}%}]"
  fi
}

function show_git_info() {
  local git_toplevel="$(dirname $(git rev-parse --show-toplevel))"
  local git_relative_path="${PWD##$git_toplevel/}"

  echo -n "${git_relative_path/#$USER/~}"

  local git_porcelain="$(git status --porcelain --branch --ahead-behind 2>/dev/null)"
  local git_stash_count="$(git stash list | grep "" -c)"

  echo -n " %{%F{cyan}%}${1} "
  echo -n "%{%F{green}%}$(printf "${git_porcelain}" | grep -c '^A')• "
  echo -n "%{%F{green}%}$(printf "${git_porcelain}" | grep -c '^R')+ "
  echo -n "%{%F{green}%}$(printf "${git_porcelain}" | grep -c '^M')~ "
  echo -n "%{%F{red}%}$(printf "${git_porcelain}" | grep -c '^D')- "
  echo -n "%{%F{white}%}$(printf "${git_porcelain}" | grep -c '^.M')• "
  echo -n "%{%F{blue}%}$(printf "${git_porcelain}" | grep -c '^??')- "
  echo -n "%{%F{red}%}$(printf "${git_porcelain}" | grep -c '^.D')?"

  local ahead=$(echo -n "${git_porcelain}" | awk '/ahead/ {print substr($4,1,length($4)-1)}')
  local behind=$(echo -n "${git_porcelain}" | awk '/behind/ {print substr($4,1,length($4)-1)}')

  if [ "${ahead}" ] || [ "${behind}" ]; then
    echo -n " "
    if [ "${ahead}" -gt 0 ]; then
      echo -n "%{%F{blue}%}${ahead}↑"
    fi
    if [ "${behind}" -gt 0 ]; then
      echo -n "%{%F{blue}%}${behind}↓"
    fi
  fi

  if [ "${git_stash_count}" -gt 0 ]; then
    echo -n " %{%F{blue}%}${git_stash_count}✗"
  fi
}

function current_dir_info() {
  echo -n '%{%B%F{blue}%}'
  local b=$(git branch --show-current 2>/dev/null || printf "")
  if [ "${b}" = "" ]; then echo -n '%~'; else show_git_info "${b}"; fi
}

function prompt_char() { echo -n "%(!.#.>)" }

function my_prompt() {
  clean
  last_command_status
  clean
  host_info
  clean
  echo -n " "
  current_dir_info
  clean
  echo -n " "
  prompt_char
  clean
  echo -n " "
}

setopt promptsubst

PROMPT='$(my_prompt)'
# PROMPT2=' > '
