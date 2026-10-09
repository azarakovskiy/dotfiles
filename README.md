# Development Tools

macOS install wizard and Zsh config. Apple Silicon first. Both Homebrew prefixes are supported: `/opt/homebrew` and `/usr/local`.

## Install

`install.sh` is the install command.

```sh
./install.sh
```

It surveys the machine in one report. Missing rows start selected. Matching installs, outdated packages, and differing configs start unselected, and the report shows the difference. Toggle a row by number, or a stop with `s1` through `s6`. Enter starts the walk.

Each selected stop explains the change, then asks you to continue, skip, redo, or abort.

1. Preflight. Checks macOS and the network. When Xcode Command Line Tools are missing, you install them and the stop waits.
2. Shell. Installs Homebrew when it is missing, appends the `shellenv` line to `~/.zprofile` once, and appends source lines for `cli/all.zsh` and `dev/hindsight.zsh` to `~/.zshrc` once. The next shell sets mouse scaling to 9 and font smoothing to 0.
3. Packages. One row per `Brewfile` line. The Node row is nvm plus Node 24. The Rust row is rustup plus the stable toolchain. Docker Desktop is one of these rows. `antidote`, `nvm`, and `rustup` can be turned off. A selected outdated row is upgraded. Redo upgrades every selected row.
4. Symlinks. Ghostty, Hammerspoon, and Herdr. A symlink is created only when the path is missing. A path that is not this repo's symlink stays unless you choose replace. Hammerspoon keeps `blueutil` selected.
5. Hindsight. Writes `~/.config/devtools/hindsight-openai` once. The choices are a 1Password reference, the `OPENAI_API_KEY` already in the environment, or skip.
6. Commit signing. Runs `scripts/gpg-signing.sh`. That stop keeps `gnupg` and `pinentry-mac` selected.

You act for Command Line Tools, the Hindsight key choice, and `scripts/gpg-signing.sh`. The wizard runs the other install commands after you continue.

## Repo

- `install.sh` — install wizard
- `Brewfile` — Homebrew formulae and casks
- `zsh_plugins.txt` — Antidote plugin list
- `cli/` — terminal enrichment
- `dev/hindsight.zsh` — `hindsight-up`
- `dev/docker-compose.yaml` — Hindsight. `hindsight-up` starts it
- `config/ghostty/config.ghostty` — symlinked to `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`
- `config/hammerspoon/` — symlinked to `~/.hammerspoon`
- `config/herdr/config.toml` — symlinked to `~/.config/herdr/config.toml`
- `git/.gitconfig` — identity template with `???` placeholders; the install does not apply it
- `git/.gitignore` — excludes template, including `.zsh_config`
- `scripts/gpg-signing.sh` — Git name, email, and commit signing
- `scripts/bootstrap/lib/` — install actions the wizard calls

`git` and `zsh` stay the copies that come with macOS.

## Git commit signing

The install does not set your Git name, email, or signing key until you continue the Commit signing stop. `git/.gitconfig` stays a template. Real values stay in your global Git config and in `~/.gnupg`.

`gnupg` and `pinentry-mac` are Brewfile rows. New shells export `GPG_TTY` from `cli/gpg.zsh`.

You can run the signing script on its own:

```sh
./scripts/gpg-signing.sh
```

The script follows [GitHub's GPG signing steps](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key). It writes your global Git config and `~/.gnupg`. It does not write your name, email, or key into this repo.

## Shell

`~/.zshrc` sources `cli/all.zsh` and `dev/hindsight.zsh`.

`cli/all.zsh` sources:

- `cli/cli.zsh` — Option-arrow jumps by alphanumeric word, `chrome_no_cors`, and a `$PWD/.zsh_config` hook
- `cli/docker.zsh` — `dockstop`
- `cli/gpg.zsh` — `GPG_TTY` for commit signing
- `cli/macos.zsh` — mouse scaling and font smoothing, rewritten when the values differ
- `cli/nvm.zsh` — nvm and Node 24. Uses the Homebrew formula, or `~/.nvm/nvm.sh` when Homebrew nvm is absent.
- `cli/rust.zsh` — rustup, Cargo, and the stable toolchain. Uses the Homebrew formula, or `~/.cargo/bin/rustup` when Homebrew rustup is absent.
- `cli/antidote.zsh` — Antidote, loaded from `zsh_plugins.txt`

`dev/hindsight.zsh` defines `hindsight-up`.

Homebrew installs the `nvm` and `rustup` formulae. The Packages stop also installs Node 24 and the stable Rust toolchain when those rows are selected. The shell modules install them again when they are still absent.

Docker Desktop's Kubernetes client is `kubectl.docker`. `kubectl` is the Homebrew formula.

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

## Hindsight

`dev/docker-compose.yaml` starts Hindsight. Compose passes `OPENAI_API_KEY` through as `HINDSIGHT_API_LLM_API_KEY`. `hindsight-up` needs Docker Desktop, which is installed from its Packages row.

`hindsight-up` reads `~/.config/devtools/hindsight-openai` when you run it. The install writes that file once. The choices are a 1Password secret reference (`op read` at command time), the `OPENAI_API_KEY` already in your environment, or skip. The reference stays in that file. Delete the file and run `./install.sh` again to change the choice. A 1Password reference needs the 1Password CLI with app integration turned on.

## Contributor note

`AGENTS.md` is the working agreement for changes in this repo.
