# Development Tools

macOS bootstrap and Zsh config for a new machine. Apple Silicon first. Both Homebrew prefixes are supported: `/opt/homebrew` and `/usr/local`.

## Repo root

- `Brewfile` — Homebrew formulae and casks
- `bootstrap.sh` — setup runner
- `all.zsh` — shell entry point
- `zsh_plugins.txt` — Antidote plugin list
- `cli/` — shell helpers
- `git/.gitconfig` — identity template with `???` placeholders; bootstrap does not apply it
- `git/.gitignore` — excludes template, including `.zsh_config`
- `hammerspoon/` — config symlinked to `~/.hammerspoon`
- `ghostty/config.ghostty` — Ghostty config, symlinked to `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`
- `herdr/config.toml` — Herdr config, symlinked to `~/.config/herdr/config.toml`

## Quick start

1. Clone this repo to a stable path (example: `~/.dotfiles`).
2. Preview:

```sh
cd ~/.dotfiles
./bootstrap.sh --dry-run
```

3. Install and verify:

```sh
./bootstrap.sh
```

4. Open a new shell.

## Bootstrap

Default is apply, then verify.

- `./bootstrap.sh` — install and verify
- `./bootstrap.sh --dry-run` — print planned commands
- `./bootstrap.sh --precheck-only` — macOS check, Command Line Tools warning, network
- `./bootstrap.sh --verify-only` — verification only

Apply does this:

- Installs Homebrew when it is missing
- Runs `brew bundle` on `Brewfile`
- Appends `brew shellenv` to `~/.zprofile` once
- Appends `source "<repo>/all.zsh"` to `~/.zshrc` once
- Symlinks Hammerspoon, Ghostty, and Herdr config paths to this repo, and leaves an existing real file or directory in place
- Prints a reminder to run `./scripts/gpg-signing.sh` for Git name, email, and commit signing

Precheck requires macOS. When Xcode Command Line Tools are missing it prints `xcode-select --install` and does not install them.

`git` and `zsh` stay the copies that come with macOS.

Homebrew installs the `nvm` and `rustup` formulae. Node 24 and the stable Rust toolchain are installed by the shell modules below.

Docker Desktop's Kubernetes client is `kubectl.docker`. `kubectl` is the Homebrew formula.

## Git commit signing

Bootstrap does not set your Git name, email, or signing key. `git/.gitconfig` stays a template. Real values stay in your global Git config and in `~/.gnupg`.

The Brewfile installs `gnupg` and `pinentry-mac`. New shells export `GPG_TTY` from `cli/gpg.zsh`.

After bootstrap, run:

```sh
./scripts/gpg-signing.sh
```

The script follows [GitHub's GPG signing steps](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key). It writes your global Git config and `~/.gnupg`. It does not write your name, email, or key into this repo.

## Shell

`all.zsh` sources `cli/all.zsh`:

- `cli/cli.zsh` — Option-arrow jumps by alphanumeric word, `chrome_no_cors`, and a `$PWD/.zsh_config` hook
- `cli/docker.zsh` — `dockstop`
- `cli/gpg.zsh` — `GPG_TTY` for commit signing
- `cli/macos.zsh` — mouse scaling and font smoothing, rewritten when the values differ
- `cli/nvm.zsh` — nvm and Node 24. Uses the Homebrew formula, or `~/.nvm/nvm.sh` when Homebrew nvm is absent.
- `cli/rust.zsh` — rustup, Cargo, and the stable toolchain. Uses the Homebrew formula, or `~/.cargo/bin/rustup` when Homebrew rustup is absent.
- `cli/antidote.zsh` — Antidote, loaded from `zsh_plugins.txt`

## Plugins

Edit `zsh_plugins.txt`. Put one plugin on each line. Save the file, then open a new shell. Antidote clones a new plugin at that start. The shell runs `compinit` before the list so Oh My Zsh plugins can register completions.

```
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting
```

Put `zsh-users/zsh-syntax-highlighting` on the last line.

Run `antidote update` to update cloned plugins. Run `antidote install owner/repo` to append one plugin and clone it.

An Oh My Zsh plugin uses this form:

```
ohmyzsh/ohmyzsh path:plugins/git
```

## Hammerspoon

Caffeine on `ctrl-alt-shift-c`, ShiftIt with its default binds, and a Bluetooth toggle that turns the radio off on sleep and on at wake. `blueutil` is taken from `/opt/homebrew` or `/usr/local`, whichever is present. Vendored spoons: Caffeine, ShiftIt, SpoonInstall.

## Layout

- `scripts/bootstrap/lib/` — `common`, `precheck`, `apply`, `verify`

## Contributor note

`AGENTS.md` is the working agreement for changes in this repo.
