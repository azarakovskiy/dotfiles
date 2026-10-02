# Development Tools

macOS bootstrap and Zsh config for a new machine. Apple Silicon first. Both Homebrew prefixes are supported: `/opt/homebrew` and `/usr/local`.

## Repo root

- `Brewfile` — Homebrew formulae and casks
- `bootstrap.sh` — setup runner
- `all.zsh` — shell entry point
- `cli/` — shell helpers
- `git/.gitconfig` — identity template with `???` placeholders; bootstrap does not apply it
- `git/.gitignore` — excludes template, including `.zsh_config`
- `hammerspoon/` — config symlinked to `~/.hammerspoon`

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
- Symlinks `~/.hammerspoon` to `hammerspoon/`, and leaves an existing real directory in place

Precheck requires macOS. When Xcode Command Line Tools are missing it prints `xcode-select --install` and does not install them.

`git` and `zsh` stay the copies that come with macOS.

Homebrew installs the `nvm` and `rustup` formulae. Node 24 and the stable Rust toolchain are installed by the shell modules below.

Docker Desktop's Kubernetes client is `kubectl.docker`. `kubectl` is the Homebrew formula.

## Shell

`all.zsh` sources `cli/all.zsh`:

- `cli/cli.zsh` — Option-arrow word movement, `chrome_no_cors`, and a `$PWD/.zsh_config` hook
- `cli/docker.zsh` — `dockstop`
- `cli/macos.zsh` — mouse scaling and font smoothing, rewritten when the values differ
- `cli/nvm.zsh` — Homebrew nvm and Node 24
- `cli/rust.zsh` — Homebrew rustup, Cargo, and the stable toolchain

## Hammerspoon

Caffeine on `ctrl-alt-shift-c`, ShiftIt with its default binds, and a Bluetooth toggle that turns the radio off on sleep and on at wake. `blueutil` is taken from `/opt/homebrew` or `/usr/local`, whichever is present. Vendored spoons: Caffeine, ShiftIt, SpoonInstall.

## Layout

- `scripts/bootstrap/lib/` — `common`, `precheck`, `apply`, `verify`

## Contributor note

`AGENTS.md` is the working agreement for changes in this repo.
