# shellcheck shell=zsh

# nvm and Node 24. Node itself is not a Brewfile entry.
# Prefer the Homebrew formula. Use an existing ~/.nvm install when that formula is absent.

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

if [[ -z "$__devtools_nvm_sh" && -s "$NVM_DIR/nvm.sh" ]]; then
  __devtools_nvm_sh="$NVM_DIR/nvm.sh"
fi

if [[ -z "$__devtools_nvm_sh" ]]; then
  echo "[devtools][warn] nvm not found under Homebrew or $NVM_DIR" >&2
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
