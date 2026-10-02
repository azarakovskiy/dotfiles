# shellcheck shell=zsh

# Homebrew nvm and Node 24. Node itself is not a Brewfile entry.

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

if [[ ! -d "$NVM_DIR" ]]; then
  mkdir -p "$NVM_DIR"
fi

__devtools_nvm_sh=""
for __devtools_prefix in /opt/homebrew /usr/local; do
  if [[ -s "$__devtools_prefix/opt/nvm/nvm.sh" ]]; then
    __devtools_nvm_sh="$__devtools_prefix/opt/nvm/nvm.sh"
    break
  fi
done

if [[ -z "$__devtools_nvm_sh" ]]; then
  echo "[devtools][warn] Homebrew nvm not found under /opt/homebrew or /usr/local" >&2
else
  # shellcheck disable=SC1090
  source "$__devtools_nvm_sh"

  if ! nvm ls 24 >/dev/null 2>&1; then
    echo "[devtools] Installing Node 24"
    if nvm install 24; then
      nvm alias default 24
    else
      echo "[devtools][warn] Node 24 install failed" >&2
    fi
  fi
fi

unset __devtools_nvm_sh __devtools_prefix
