function clean() {
  printf "\[\e[0m\]"
}

function last_command_status() {
  if [ $1 -ne 0 ]; then printf "\[\e[31m\]($1)"; fi
}

function show_git_info() {
  git_toplevel="$(dirname $(git rev-parse --show-toplevel))"
  git_relative_path="${PWD##$git_toplevel/}"

  printf "${git_relative_path//$USER/\~}"

  git_porcelain="$(git status --porcelain --branch --ahead-behind)"

  printf " \[\e[96m\]${1} "
  printf "\[\e[92m\]$(printf "${git_porcelain}" | grep -c '^A')|"
  printf "\[\e[92m\]$(printf "${git_porcelain}" | grep -c '^R')|"
  printf "\[\e[92m\]$(printf "${git_porcelain}" | grep -c '^M')|"
  printf "\[\e[31m\]$(printf "${git_porcelain}" | grep -c '^D')|"
  printf "\[\e[97m\]$(printf "${git_porcelain}" | grep -c '^ M')|"
  printf "\[\e[94m\]$(printf "${git_porcelain}" | grep -c '^??')|"
  printf "\[\e[31m\]$(printf "${git_porcelain}" | grep -c '^ D')"

  ahead=$(printf "${git_porcelain}" | awk '/ahead/ {print substr($4,1,length($4)-1)}')
  behind=$(printf "${git_porcelain}" | awk '/behind/ {print substr($4,1,length($4)-1)}')

  if [ "${ahead}" ] || [ "${behind}" ]; then
    printf " "
    if [ "${ahead}" ] && [ "${ahead}" -gt 0 ]; then
      printf "\[\e[95m\]${ahead}↑"
    fi
    if [ "${behind}" ] && [ "${behind}" -gt 0 ]; then
      printf "\[\e[95m\]${behind}↓"
    fi
  fi
}

function current_dir_info() {
  printf '\[\e[34m\]'
  b=$(git branch --show-current 2>/dev/null || printf "")
  if [ "${b}" = "" ]; then printf "\w"; else show_git_info "${b}"; fi
}

function prompt_char() {
  if [ $(id -u) -eq 0 ]; then printf "#"; else printf ">"; fi
}

function my_prompt() {
  last_exit_code=$?
  clean
  last_command_status $last_exit_code
  clean
  printf " "
  current_dir_info
  clean
  printf " "
  prompt_char
  clean
  printf " "
}

export PS1='$(my_prompt)'
