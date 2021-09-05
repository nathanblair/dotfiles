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

  RPROMPT="${time_info}%{%{$reset_color%}%}"
  unset timer
  unset time_info
}

function clean() {
  echo -n "%{%b%k%f%}"
}

function last_command_status() { echo -n "%(?..%{%F{red}%}(%?%))" }

function show_git_info() {
  local git_toplevel="$(dirname $(git rev-parse --show-toplevel))"
  local git_relative_path="${PWD##$git_toplevel/}"

  echo -n "${git_relative_path/#$USER/~}"

  echo -n " %{%F{cyan}%}${1}%{%K{black}%} "
  echo -n "%{%F{green}%}$(git status --porcelain 2>/dev/null | grep -c '^A')"
  echo -n "%{%F{green}%}$(git status --porcelain 2>/dev/null | grep -c '^M')"
  echo -n "%{%F{red}%}$(git status --porcelain 2>/dev/null | grep -c '^D')"
  echo -n "%{%F{white}%}$(git status --porcelain 2>/dev/null | grep -c '^ M')"
  echo -n "%{%F{blue}%}$(git status --porcelain 2>/dev/null | grep -c '^??')"
  echo -n "%{%F{red}%}$(git status --porcelain 2>/dev/null | grep -c '^ D')"

  local ahead_behind=$(git status --porcelain --branch --ahead-behind)
  local ahead=$(echo -n "${ahead_behind}" | awk '/ahead/ {print substr($4,1,length($4)-1)}')
  local behind=$(echo -n "${ahead_behind}" | awk '/behind/ {print substr($4,1,length($4)-1)}')

  if [ "${ahead}" -gt 0 ] || [ "${behind}" -gt 0 ]; then
    echo -n " "
    if [ "${ahead}" -gt 0 ]; then
      echo -n "%{%F{blue}%}${ahead}↑"
    fi
    if [ "${behind}" -gt 0 ]; then
      echo -n "%{%F{blue}%}${behind}↓"
    fi
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
