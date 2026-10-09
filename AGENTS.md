# AGENTS.md

## Invariants

- `install.sh` and `scripts/**/*.sh` are bash. `cli/*.zsh` and `dev/*.zsh` are zsh.
- `install.sh` is the install command. It appends the Homebrew `shellenv` line to `~/.zprofile` once, appends `source "<repo>/cli/all.zsh"` and `source "<repo>/dev/hindsight.zsh"` to `~/.zshrc` once, creates the Hammerspoon, Ghostty, and Herdr symlinks only when those paths are missing, and writes `~/.config/devtools/hindsight-openai` once when that file is missing. The Hindsight secret reference stays in that local file.
- Symlink sources are `config/hammerspoon`, `config/ghostty/config.ghostty`, and `config/herdr/config.toml`.
- Git name, email, and signing keys live in the global Git config and `~/.gnupg`, written by `scripts/gpg-signing.sh`. `git/.gitconfig` stays an unapplied template.
- The `chpwd` hook sources `$PWD/.zsh_config` once per directory. Sourcing stops there.

## Docs

When install or shell-sourcing behavior changes, update `README.md` in the same change.

## Checks

Syntax-check the shell files you change:

```sh
zsh -n cli/*.zsh dev/*.zsh
bash -n install.sh scripts/bootstrap/lib/*.sh scripts/gpg-signing.sh
bash install.sh --check
```
