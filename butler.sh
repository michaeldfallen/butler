#! /usr/bin/env sh
#
# Butler
#
# A task runner to simplify development
# Let the Butler do it.

dot="$(cd "$(dirname "$0")"; pwd)"

source "$dot/butler-base.sh"

butler "$@"
