#! /usr/bin/env sh

run_tests() {
  for t in tests/*_test.sh; do
    $t
  done
}

run_tests
