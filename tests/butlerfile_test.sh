dot="$(cd "$(dirname "$0")"; pwd)"

source "$dot/helpers.sh"
source "$dot/../butler-base.sh"

test_no_butlerfile() {
  cd_to_tmp
  output="$(butler_exec)"
  assertEquals "error: No butlerfile found." "$output"
  rm_tmp
}

test_should_list_commands_if_none_given() {
  expected="\
$(usage)
commands:
  run: foo"

  cd_to_tmp
  echo "run: foo" > butlerfile
  output="$(butler_exec)"
  assertEquals "$expected" "$output"
  rm_tmp
}

test_should_list_no_commands_for_empty_butlerfile() {
  expected="\
$(usage)
commands:"
  cd_to_tmp
  touch butlerfile
  output="$(butler_exec)"
  assertEquals "$expected" "$output"
  rm_tmp
}

test_runs_command_from_butlerfile() {
  expected="\
Executing foo: echo \"Hello, world!\"
Hello, world!"

  commands="\
foo: echo \"Hello, world!\""

  cd_to_tmp
  echo "$commands" > butlerfile

  output="$(butler_exec foo)"

  assertEquals "$expected" "$output"
  rm_tmp
}

test_messages_if_command_not_found_in_butlerfile() {
  expected="error: foo doesn't exist in your butlerfile"

  cd_to_tmp
  echo "bar: echo \"Hello, world!\"" > butlerfile

  output="$(butler_exec foo)"

  assertEquals "$expected" "$output"
  rm_tmp
}

test_reports_multiple_instance_of_command() {
  expected="error: found 3 commands named foo, please fix your butlerfile"
  commands="\
foo: echo \"Hello, 1!\"
foo: echo \"Hello, 2!\"
foo: echo \"Hello, 3!\""

  cd_to_tmp
  echo "$commands" > butlerfile

  output="$(butler_exec foo)"

  assertEquals "$expected" "$output"

  rm_tmp
}

test_only_execute_the_correct_command() {
  expectedFoo="\
Executing foo: echo \"Hello, Foo!\"
Hello, Foo!"
  expectedBar="\
Executing bar: echo \"Hello, Bar!\"
Hello, Bar!"
  commands="\
foo: echo \"Hello, Foo!\"
bar: echo \"Hello, Bar!\""

  cd_to_tmp
  echo "$commands" > butlerfile

  output="$(butler_exec foo)"
  assertEquals "$expectedFoo" "$output"

  output="$(butler_exec bar)"
  assertEquals "$expectedBar" "$output"

  rm_tmp
}

test_passes_args_to_command() {
  expectedBar="\
Executing bar: echo \"Hello, \$1 \$2!\"
Hello,"
  expectedBaz="\
Executing baz: echo \"Hello, \$@!\"
Hello,"
  expectedFoo="\
Executing foo: echo \"Hello, \$1!\"
Hello,"
  commands="\
foo: echo \"Hello, \$1!\"
baz: echo \"Hello, \$@!\"
bar: echo \"Hello, \$1 \$2!\""

  cd_to_tmp
  echo "$commands" > butlerfile

  output="$(butler_exec foo "World")"
  assertEquals "$expectedFoo World!" "$output"
  output="$(butler_exec foo "Butler")"
  assertEquals "$expectedFoo Butler!" "$output"
  output="$(butler_exec foo "Michael" "Allen")"
  assertEquals "$expectedFoo Michael!" "$output"
  output="$(butler_exec bar "Michael" "Allen")"
  assertEquals "$expectedBar Michael Allen!" "$output"
  output="$(butler_exec baz "Michael" "Allen")"
  assertEquals "$expectedBaz Michael Allen!" "$output"

  rm_tmp
}

source "$dot/../shunit/shunit2"
