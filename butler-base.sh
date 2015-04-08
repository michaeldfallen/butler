#! /usr/bin/env sh
#
# Butler-base
#
# The API for Butler.
# Let the Butler do it.

usage() {
  echo "usage:"
  echo "  butler [COMMAND]        # Run a command defined in your butlerfile"
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
  fi
  exit 0
}
