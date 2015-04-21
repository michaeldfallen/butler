#! /usr/bin/env bash
#
# Butler-base
#
# The API for Butler.
# Let the Butler do it.

if [[ "$OSTYPE" == *darwin* ]]; then
  SHA_CMD="gsha256sum"
else
  SHA_CMD="sha256sum"
fi

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

complete_command() {
  local butlerfile="$1"; shift
  local word="$@"
  while read line || [[ -n "$line" ]]; do
    local name="${line%%:*}"
    if [[ "$name" == *"$word"* ]]; then
      echo "$name"
    fi
  done < "$butlerfile"
}

hash_this() {
  echo "$@" | $SHA_CMD | sed 's/  -$//'
}

record_hash() {
  local dot_butler="${DOT_BUTLER:-$HOME/.butler}"
  if [ ! -d "$dot_butler" ]; then
    mkdir -p "$dot_butler"
  fi
  touch "$dot_butler/$@"
}

can_continue() {
  local dot_butler="${DOT_BUTLER:-$HOME/.butler}"
  local name="$1"; shift;
  local command="$1"; shift;
  local hash="$(hash_this "$name: $command")"
  if [ -f "$dot_butler/$hash" ]; then
    return 0
  else
    echo "First time executing $name: $command"
    echo "Execute $name? (y)es, (n)o, just this (o)nce"
    read execute_permission
    if [[ "$execute_permission" == "y" ]]; then
      record_hash "$hash"
      return 0
    elif [[ "$execute_permission" == "n" ]]; then
      exit 1
    elif [[ "$execute_permission" == "o" ]]; then
      return 0
    fi
    return 1
  fi
}

execute() {
  local name="$1";shift;
  local command="$1";shift;
  local args=$@
  if can_continue "$name" "$command"; then
    echo "Executing $name: $command"
    local shell=${BUTLER_SHELL:-${SHELL:-bash}}
    $shell -c "$command" -- $args
  fi
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
    execute "$targetname" "$foundcommand" $args
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

  if [[ "$command" == "--cmplt" ]]; then
    if [[ -f $butlerfile ]]; then
      complete_command $butlerfile "$@"
      exit 0
    else
      exit 1
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
