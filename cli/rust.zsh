# shellcheck shell=zsh

# Keg-only Homebrew rustup and Cargo. The stable toolchain is not a Brewfile entry.

__devtools_rustup_bin=""
for __devtools_prefix in /opt/homebrew /usr/local; do
  if [[ -x "$__devtools_prefix/opt/rustup/bin/rustup" ]]; then
    __devtools_rustup_bin="$__devtools_prefix/opt/rustup/bin"
    break
  fi
done

if [[ -z "$__devtools_rustup_bin" ]]; then
  echo "[devtools][warn] Homebrew rustup not found under /opt/homebrew or /usr/local" >&2
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
