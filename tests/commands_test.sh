dot="$(cd "$(dirname "$0")"; pwd)"

source "$dot/helpers.sh"
source "$dot/../butler-base.sh"

test_works_for_symlinks() {
  expected="error: No butlerfile found."

  cd_to_tmp
  ln -s "$dot/../butler" "butler"
  output="$(./butler)"

  assertEquals "$expected" "$output"
  rm_tmp
}

test_record_hash() {
  cd_to_tmp

  expected="d3b07384d113edec49eaa6238ad5ff00"
  record_test_hash "foo: foo"

  assertEquals "$(can_continue "foo" "foo"; echo "$?")" "0"

  empty_dot_butler
  rm_tmp
}

source "$dot/../shunit/shunit2"
