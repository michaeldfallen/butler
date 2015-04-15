dot="$(cd "$(dirname "$0")"; pwd)"

source "$dot/helpers.sh"
source "$dot/../butler-base.sh"

test_no_butlerfile() {
  cd_to_tmp

  output="$(butler_exec "--cmplt")"
  assertEquals "$output" ""

  rm_tmp
}

test_no_butlerfile_with_word() {
  cd_to_tmp

  output="$(butler_exec "--cmplt" "fo")"
  assertEquals "$output" ""

  rm_tmp
}

test_completes_single_option() {
  cd_to_tmp

  echo "foo: echo \"foo\"" >> butlerfile
  output="$(butler_exec "--cmplt" "fo")"
  assertEquals "$output" "foo"

  rm_tmp
}

test_completes_multiple_options() {
  cd_to_tmp

  echo "foo: echo \"foo\"" >> butlerfile
  echo "foobar: echo \"foobar\"" >> butlerfile

  output="$(butler_exec "--cmplt" "fo")"
  assertEquals "$output" "foo
foobar"
  rm_tmp
}

source "$dot/../shunit/shunit2"
