_butler_complete() {
  local word words completions
  read -cA words
  word="${words[2]}"
  if [ "${#words[@]}" -eq 2 ]; then
    completions="$(butler --cmplt "${word}")"
  fi
  reply=( "${(ps:\n:)completions}" )
}

compctl -K _butler_complete butler
