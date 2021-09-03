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

function last_command_status() { echo -n "%(?..%{%F{red}%}(%?%))" }

function current_dir_info() { echo -n '%{%B%F{blue}%}%~' }

function prompt_char() { echo -n "%(!.#.>)" }

function show_git_info() {
  local b=$(git branch --show-current 2>/dev/null || printf "")
  if [ "${b}" = "" ]; then
    echo -n " "
  else
    echo -n " %{%F{cyan}%}${b}%{%f%}%{%K{black}%} "
    echo -n "%{%F{green}%}$(git status --porcelain 2>/dev/null| grep -c "^M")"
    echo -n "%{%F{white}%}$(git status --porcelain 2>/dev/null| grep -c "^ M")"
    echo -n "%{%F{blue}%}$(git status --porcelain 2>/dev/null| grep -c "^??")"
    echo -n " "
  fi
}

function my_prompt() {
  echo -n "%{%b%k%f%}"
  last_command_status
  echo -n "%{%b%k%f%}"
  echo -n " "
  current_dir_info
  echo -n "%{%b%k%f%}"
  show_git_info
  echo -n "%{%b%k%f%}"
  prompt_char
  echo -n "%{%b%k%f%}"
  echo -n " "
}

setopt promptsubst

PROMPT='$(my_prompt)'
