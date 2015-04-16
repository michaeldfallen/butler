export scriptDir="$(cd "$(dirname "$0")"; pwd)"

time_now() {
  echo "$(date +%s)"
}

cd_to_tmp() {
  tmpfile="/tmp/git-prompt-tests-$(time_now)"
  mkdir -p "$tmpfile"
  cd "$tmpfile"
}

rm_tmp() {
  cd $scriptDir
  rm -rf /tmp/git-prompt-tests*
}

empty_dot_butler() {
  local dot_butler="${1:-${DOT_BUTLER:-~/.butler}}"
  rm -r "$dot_butler"
}

prep_command() {
  local command="$@"
  record_test_hash "$command"
  echo "$command" >> butlerfile
}

record_test_hash() {
  export DOT_BUTLER="./.butler_test"
  hash="$(hash_this "$@")"
  record_hash "$hash"
}
