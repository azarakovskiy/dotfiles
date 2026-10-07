# AGENTS.md

## Invariants

- `bootstrap.sh` and `scripts/**/*.sh` are bash. `all.zsh` and `cli/*.zsh` are zsh.
- Bootstrap stays idempotent: append the Homebrew `shellenv` line and the `all.zsh` source line once, and create the Hammerspoon, Ghostty, and Herdr symlinks only when those paths are missing.
- Git name, email, and signing keys live in the global Git config and `~/.gnupg`, written by `scripts/gpg-signing.sh`. `git/.gitconfig` stays an unapplied template.
- The `chpwd` hook sources `$PWD/.zsh_config` once per directory. Sourcing stops there.

## Docs

When install, bootstrap, or shell-sourcing behavior changes, update `README.md` in the same change.

## Checks

Syntax-check the shell files you change:

```sh
zsh -n all.zsh cli/*.zsh
bash -n bootstrap.sh scripts/bootstrap/lib/*.sh scripts/gpg-signing.sh
```
