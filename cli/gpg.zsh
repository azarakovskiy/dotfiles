# shellcheck shell=zsh

# Pinentry needs the terminal that started this shell.
# https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key
if [[ -t 1 ]]; then
  __devtools_gpg_tty="$(tty 2>/dev/null || true)"
  if [[ -n "$__devtools_gpg_tty" ]]; then
    export GPG_TTY="$__devtools_gpg_tty"
  fi
  unset __devtools_gpg_tty
fi
