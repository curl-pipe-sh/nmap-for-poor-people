#!/usr/bin/env bash

usage() {
  echo "Usage: $0 [--timeout TIMEOUT] HOST PORT [PORT...]"
}

echo_success() {
  echo -e "✅ \e[32m${*}\e[0m"
}

echo_error() {
  echo -e "🔴 \e[31m${*}\e[0m"
}

tcp_port_check() {
  local host="$1" port="$2" timeout="$3"
  timeout "$timeout" bash -c "echo > /dev/tcp/${host}/${port}" 2>/dev/null
}

# if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
# then
  TIMEOUT=3

  while [[ -n "$1" ]]
  do
    case "$1" in
      -h|--help|-\?|help)
        usage
        exit 0
        ;;
      -t|--timeout)
        TIMEOUT="$2"
        shift 2
        ;;
      *)
        break
        ;;
    esac
  done

  HOST="$1"
  shift
  PORTS=("$@")

  if [[ -z "$HOST" ]] || [[ -z "${PORTS[*]}" ]]
  then
    usage >&2
    exit 2
  fi

  for PORT in "${PORTS[@]}"
  do
    MESSAGE="${HOST}:${PORT}"

    if tcp_port_check "$HOST" "$PORT" "$TIMEOUT"
    then
      echo_success "$MESSAGE open"
    else
      echo_error "$MESSAGE CLOSED"
    fi
  done
# fi
