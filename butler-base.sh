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
  local foundcommand=""
  local foundnum=0

  while read line || [[ -n "$line" ]]; do
    local name="${line%%:*}"
    local command="${line#*:[[:space:]]}"
    if [ "$name" == "$targetname" ]; then
      foundcommand="$command"
      let foundnum+=1
    fi
  done < "$butlerfile"

  if [[ -z "$foundcommand" ]]; then
    error "$targetname doesn't exist in your butlerfile"
    exit 1
  elif [[ "$foundnum" -ne "1" ]]; then
    error "found $foundnum commands named $targetname, please fix your butlerfile"
    exit 1
  else
    echo "Executing $targetname: $command"
    execute "$command"
  fi
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
