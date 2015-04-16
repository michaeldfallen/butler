dot="$(cd "$(dirname "$0")"; pwd)"

source "$dot/helpers.sh"
source "$dot/../butler-base.sh"

test_no_hash_file_yes() {
  cd_to_tmp

  export DOT_BUTLER="./.butler_test"
  echo "foo: echo \"foo\"" >> butlerfile

  expected="\
First time executing foo: echo \"foo\"
Execute foo? (y)es, (n)o, just this (o)nce"

  command_execution="Executing foo: echo \"foo\"
foo"

  output="$(butler_exec "foo" <<< "y")"
  assertEquals "$expected
$command_execution" "$output"

  output="$(butler_exec "foo")"
  assertEquals "$command_execution" "$output"

  rm_tmp
}

test_no_hash_file_no() {
  cd_to_tmp

  export DOT_BUTLER="./.butler_test"
  echo "foo: echo \"foo\"" >> butlerfile

  expected="\
First time executing foo: echo \"foo\"
Execute foo? (y)es, (n)o, just this (o)nce"

  command_execution="Executing foo: echo \"foo\"
foo"

  output="$(butler_exec "foo" <<< "n")"
  assertEquals "$expected" "$output"

  output="$(butler_exec "foo" <<< "n")"
  assertEquals "$expected" "$output"

  rm_tmp
}

test_no_hash_file_once() {
  cd_to_tmp

  export DOT_BUTLER="./.butler_test"
  echo "foo: echo \"foo\"" >> butlerfile

  expected="\
First time executing foo: echo \"foo\"
Execute foo? (y)es, (n)o, just this (o)nce"

  command_execution="Executing foo: echo \"foo\"
foo"

  output="$(butler_exec "foo" <<< "o")"
  assertEquals "$expected
$command_execution" "$output"

  output="$(butler_exec "foo" <<< "o")"
  assertEquals "$expected
$command_execution" "$output"

  rm_tmp
}

test_with_hash_file() {
  cd_to_tmp

  prep_command "foo: echo \"foo\""

  expected="\
Executing foo: echo \"foo\"
foo"

  output="$(butler_exec "foo")"
  assertEquals "$expected" "$output"

  rm_tmp
}

source "$dot/../shunit/shunit2"
