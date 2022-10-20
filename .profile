# vim:ft=sh

. "${HOME}/.env" || true
. "${HOME}/.aliases" || true
. "${HOME}/.tokens" || true

printf "\e]0;${HOSTNAME}\a"
if [ "$(env | grep WSL)" ]; then
  printf "\e]0;${HOSTNAME} [WSL]\a"
fi

. "${HOME}/.zfuncs/prompt/prompt.sh"

if test -z "${XDG_RUNTIME_DIR}"; then
    export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
    if ! test -d "${XDG_RUNTIME_DIR}"; then
        mkdir "${XDG_RUNTIME_DIR}" >> /dev/null
        chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
fi
