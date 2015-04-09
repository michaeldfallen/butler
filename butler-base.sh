#! /usr/bin/env sh
#
# Butler-base
#
# The API for Butler.
# Let the Butler do it.

usage() {
  echo "usage:"
  echo "  butler [COMMAND]    # Run a command defined in your butlerfile"
  echo "  butler              # List all known commands"
}

error() {
  echo "error: $@"
}

list_commands() {
  local butlerfile="$1"
  echo "commands:"
  while read line || [[ -n "$line" ]]; do
    echo "  $line"
  done < "$butlerfile"
}

execute() {
  bash -c "$1"
}

run_command() {
  local targetname="$1"
  while read line || [[ -n "$line" ]]; do
    local name="${line%%:*}"
    local command="${line#*:[[:space:]]}"
    if [[ "$name" -eq "$targetname" ]]; then
      echo "Executing $line"
      execute "$command"
    fi
  done < "$butlerfile"
}

butler() {
  local command="$@"
  local butlerfile='butlerfile'
  if [[ ! -f $butlerfile ]]; then
    error "No butlerfile found."
    exit 1
  fi

  if [[ -z "$command" ]]; then
    usage
    list_commands $butlerfile
    exit 0
  fi

  if [[ -n "$command" ]]; then
    run_command "$command"
    exit 0
  fi
  exit 1
}
