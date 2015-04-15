_butler_complete() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"
  if [ "${#COMP_WORDS[@]}" -eq 2 ]; then
    local completions="$(butler --cmplt "$word")"
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}

complete -F _butler_complete butler
