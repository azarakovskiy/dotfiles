# shellcheck shell=zsh

__devtools_root="${funcsourcetrace[1]%/*}"
if [[ -r "$__devtools_root/cli/all.zsh" ]]; then
  source "$__devtools_root/cli/all.zsh"
else
  echo "[devtools][warn] Missing file: $__devtools_root/cli/all.zsh" >&2
fi
if [[ -r "$__devtools_root/dev/hindsight.zsh" ]]; then
  source "$__devtools_root/dev/hindsight.zsh"
else
  echo "[devtools][warn] Missing file: $__devtools_root/dev/hindsight.zsh" >&2
fi
unset __devtools_root
