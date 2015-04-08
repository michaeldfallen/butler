dot="$(cd "$(dirname "$0")"; pwd)"

source "$dot/helpers.sh"
source "$dot/../butler-base.sh"

test_example() {
  cd_to_tmp
  touch foo
  assertEquals "1" "1"
  rm_tmp
}

source "$dot/../shunit/shunit2"
