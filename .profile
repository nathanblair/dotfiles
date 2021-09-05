. "${HOME}/.prompt.sh" || true
. "${HOME}/.env" || true
. "${HOME}/.aliases" || true
. "${HOME}/.tokens" || true

printf "\e]0;$HOSTNAME\a"
if [ "$(env | grep WSL)" ]; then
  printf "\e]0;${HOSTNAME} [WSL]\a"
fi
