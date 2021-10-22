#!/bin/bash

SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
NAME=Charts
URL=https://git.effectivetrade.ru/react-native-shared/${NAME}.git
BRANCH=eftr

fetch() {
  echo "[${NAME}] fetch..."
  rm -rf ${SELF_DIR}/${NAME}
  git clone ${URL} --depth  1 --branch ${BRANCH}

  echo write VERSION.hash file ...
  cd ${SELF_DIR}/${NAME} && git rev-parse HEAD >VERSION.hash && cd ${SELF_DIR}

  echo "[${NAME}] fetch done"
}

clean() {
  echo "[${NAME}] clean..."
  cd ${SELF_DIR}/${NAME}
  rm -rf ".git"
  rm -rf ".github"
  cd ${SELF_DIR}
  echo "[${NAME}] clean done"
}

echo "[${NAME}] **** 🟠️ Update ...  ****"

case "$1" in
fetch) fetch ;;
clean) clean ;;
*)
  fetch
  clean
  ;;
esac

echo "[${NAME}] **** ✅  Update done ****"
