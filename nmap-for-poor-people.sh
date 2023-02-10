#!/usr/bin/env bash

echo_success() {
  echo -e "✅ \e[32m${*}\e[0m"
}

echo_error() {
  echo -e "🔴 \e[31m${*}\e[0m"
}

HOST="$1"
shift
PORTS=("$@")

if [[ -z "$HOST" ]] || [[ -z "${PORTS[*]}" ]]
then
  echo "Usage: HOST PORT [PORT...]" >&2
  exit 2
fi

for PORT in "${PORTS[@]}"
do
  MESSAGE="${HOST}:${PORT}"
  if echo > "/dev/tcp/${HOST}/${PORT}" 2> /dev/null
  then
    echo_success "$MESSAGE open"
  else
    echo_error "$MESSAGE CLOSED"
  fi
done
