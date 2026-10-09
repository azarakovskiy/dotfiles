# AGENTS.md

## Invariants

- `bootstrap.sh` and `scripts/**/*.sh` are bash. `all.zsh`, `cli/*.zsh`, and `dev/*.zsh` are zsh.
- Bootstrap stays idempotent: append the Homebrew `shellenv` line and the `all.zsh` source line once, create the Hammerspoon, Ghostty, and Herdr symlinks only when those paths are missing, and write `~/.config/devtools/hindsight-openai` once when that file is missing. The Hindsight secret reference stays in that local file.
- Git name, email, and signing keys live in the global Git config and `~/.gnupg`, written by `scripts/gpg-signing.sh`. `git/.gitconfig` stays an unapplied template.
- The `chpwd` hook sources `$PWD/.zsh_config` once per directory. Sourcing stops there.

## Docs

When install, bootstrap, or shell-sourcing behavior changes, update `README.md` in the same change.

## Checks

Syntax-check the shell files you change:

```sh
zsh -n all.zsh cli/*.zsh dev/*.zsh
bash -n bootstrap.sh scripts/bootstrap/lib/*.sh scripts/gpg-signing.sh
```
