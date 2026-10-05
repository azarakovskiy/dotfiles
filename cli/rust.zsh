# shellcheck shell=zsh

# rustup and Cargo. The stable toolchain is not a Brewfile entry.
# Prefer the Homebrew formula. Use rustup in ~/.cargo/bin when that formula is absent.

__devtools_rustup_bin=""
for __devtools_prefix in /opt/homebrew /usr/local; do
  if [[ -x "$__devtools_prefix/opt/rustup/bin/rustup" ]]; then
    __devtools_rustup_bin="$__devtools_prefix/opt/rustup/bin"
    break
  fi
done

if [[ -z "$__devtools_rustup_bin" && -x "$HOME/.cargo/bin/rustup" ]]; then
  __devtools_rustup_bin="$HOME/.cargo/bin"
fi

if [[ -z "$__devtools_rustup_bin" ]]; then
  echo "[devtools][warn] rustup not found under Homebrew or $HOME/.cargo/bin" >&2
else
  typeset -U path
  path=("$__devtools_rustup_bin" "$HOME/.cargo/bin" $path)
  export PATH

  if ! rustup toolchain list 2>/dev/null | grep -q '^stable'; then
    echo "[devtools] Installing Rust stable"
    if ! rustup default stable; then
      echo "[devtools][warn] Rust stable install failed" >&2
    fi
  fi
fi

unset __devtools_rustup_bin __devtools_prefix
