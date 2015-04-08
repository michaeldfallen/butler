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
