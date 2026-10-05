# shellcheck shell=zsh

# Homebrew antidote. The plugin list is <repo>/zsh_plugins.txt.

__devtools_antidote_cli="${funcsourcetrace[1]%/*}"
__devtools_plugins_file="${__devtools_antidote_cli:h}/zsh_plugins.txt"
__devtools_static_file="${XDG_CACHE_HOME:-$HOME/.cache}/devtools/zsh_plugins.zsh"

__devtools_antidote_sh=""
for __devtools_prefix in /opt/homebrew /usr/local; do
  if [[ -s "$__devtools_prefix/opt/antidote/share/antidote/antidote.zsh" ]]; then
    __devtools_antidote_sh="$__devtools_prefix/opt/antidote/share/antidote/antidote.zsh"
    break
  fi
done

if [[ -z "$__devtools_antidote_sh" ]]; then
  echo "[devtools][warn] Homebrew antidote not found under /opt/homebrew or /usr/local" >&2
elif [[ ! -r "$__devtools_plugins_file" ]]; then
  echo "[devtools][warn] Missing file: $__devtools_plugins_file" >&2
else
  zstyle ':antidote:bundle' file "$__devtools_plugins_file"
  zstyle ':antidote:static' file "$__devtools_static_file"
  # shellcheck disable=SC1090
  source "$__devtools_antidote_sh"
  # A comment-only list is valid. antidote bundle exits with an error on it.
  if grep -Eq '^[[:space:]]*[^#[:space:]]' "$__devtools_plugins_file"; then
    # Oh My Zsh plugins call compdef while they load.
    mkdir -p "${__devtools_static_file:h}"
    autoload -Uz compinit
    compinit -d "${__devtools_static_file:h}/zcompdump"
    if ! antidote load "$__devtools_plugins_file" "$__devtools_static_file"; then
      echo "[devtools][warn] antidote load failed for $__devtools_plugins_file" >&2
    fi
  fi
fi

unset __devtools_antidote_cli __devtools_plugins_file __devtools_static_file
unset __devtools_antidote_sh __devtools_prefix
