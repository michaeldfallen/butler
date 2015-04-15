if [[ "$OSTYPE" == *darwin* ]]; then
  READLINK_CMD='greadlink'
else
  READLINK_CMD='readlink'
fi

dot="$(cd "$(dirname "$([ -L "$0" ] && $READLINK_CMD -f "$0" || echo "$0")")"; pwd)"

if [[ -n "$ZSH_VERSION" ]]; then
  source "$dot/complete.zsh"
elif [[ -n "$BASH_VERSION" ]]; then
  source "$dot/complete.bash"
fi
