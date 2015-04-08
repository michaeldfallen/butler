dot="$(cd "$(dirname "$0")"; pwd)"

source "$dot/helpers.sh"
source "$dot/../butler-base.sh"

test_no_butlerfile() {
  cd_to_tmp
  output="$(butler)"
  assertEquals "error: No butlerfile found." "$output"
  rm_tmp
}

test_should_list_commands_if_none_given() {
  expected="$(usage)
commands:
  run: foo"

  cd_to_tmp
  echo "run: foo" > butlerfile
  output="$(butler)"
  assertEquals "$expected" "$output"
  rm_tmp
}

test_should_list_no_commands_for_empty_butlerfile() {
  expected="$(usage)
commands:"
  cd_to_tmp
  touch butlerfile
  output="$(butler)"
  assertEquals "$expected" "$output"
  rm_tmp
}

source "$dot/../shunit/shunit2"
