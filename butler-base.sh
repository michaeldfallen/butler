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
  local command="$1";shift;
  local args=$@
  bash -c "$command" -- $args
}

init_butlerfile() {
  echo "Creating an example butlerfile with one command: hello"
  echo "Try executing:"
  echo "> butler hello"
  echo "hello: echo \"Hello, World!\"" >> butlerfile
}

run_command() {
  local targetname="$1"; shift;
  local args=$@
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
    echo "Executing $targetname: $foundcommand"
    execute "$foundcommand" $args
  fi
}

butler_exec() {
  local command="$1"; shift;
  local butlerfile='butlerfile'
  if [[ "$command" == "--init" ]]; then
    if [[ -f $butlerfile ]]; then
      error "butlerfile already exists"
      list_commands $butlerfile
      exit 1
    else
      init_butlerfile
      exit 0
    fi
  fi

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
    run_command "$command" $@
    exit 0
  fi
  exit 1
}
