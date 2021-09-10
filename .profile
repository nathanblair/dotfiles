. "${HOME}/.env" || true
. "${HOME}/.aliases" || true
. "${HOME}/.tokens" || true

printf "\e]0;$HOSTNAME\a"
if [ "$(env | grep WSL)" ]; then
  printf "\e]0;${HOSTNAME} [WSL]\a"
fi

if [ ! -f "${HOME}/.zfuncs/fsh/fast-syntax-highlighting.plugin.zsh" ] ||
   [ ! -f "${HOME}/.zfuncs/zsh-autosuggestions/zsh-autosuggestions.zsh" ] ||
   [ ! -f "${HOME}/.zfuncs/prompt/prompt.sh" ]; then
  git submodule update --init --recursive --depth 1
fi

. "${HOME}/.zfuncs/prompt/prompt.sh"

