dot="$(cd "$(dirname "$0")"; pwd)"

source "$dot/helpers.sh"

test_works_for_symlinks() {
  expected="error: No butlerfile found."

  cd_to_tmp
  ln -s "$dot/../butler" "butler"
  output="$(./butler)"

  assertEquals "$expected" "$output"
  rm_tmp
}

source "$dot/../shunit/shunit2"
