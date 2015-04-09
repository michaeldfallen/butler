dot="$(cd "$(dirname "$0")"; pwd)"

source "$dot/helpers.sh"
source "$dot/../butler-base.sh"

test_init_fails_when_butlerfile_exists() {
  expected="\
error: butlerfile already exists
commands:
  foo: echo \"Hello, World!\""
  commands="\
foo: echo \"Hello, World!\""

  cd_to_tmp
  echo "$commands" >> butlerfile

  output="$(butler_exec --init)"
  assertEquals "$expected" "$output"

  rm_tmp
}

test_init_function_creates_butlerfile() {
  expectedInit="\
Creating an example butlerfile with one command: hello
Try executing:
> butler hello"
  expectedHello="\
Executing hello: echo \"Hello, World!\"
Hello, World!"

  cd_to_tmp
  output="$(butler_exec --init)"
  assertEquals "$expectedInit" "$output"

  output="$(butler_exec hello)"
  assertEquals "$expectedHello" "$output"

  rm_tmp
}

source "$dot/../shunit/shunit2"
