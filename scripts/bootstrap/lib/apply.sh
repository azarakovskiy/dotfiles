#!/usr/bin/env bash

set -euo pipefail

bootstrap_install_homebrew_if_needed() {
  local brew_bin

  if brew_bin="$(bootstrap_find_brew_bin)"; then
    bootstrap_log "Homebrew already installed at $brew_bin"
    return 0
  fi

  bootstrap_log "Installing Homebrew"
  if (( BOOTSTRAP_DRY_RUN )); then
    printf '[dry-run] /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"\n'
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

bootstrap_configure_shellenv() {
  local brew_bin shellenv_line zprofile

  brew_bin="$(bootstrap_resolve_brew_bin)"
  zprofile="$HOME/.zprofile"
  printf -v shellenv_line 'eval "$(%s shellenv)"' "$brew_bin"

  bootstrap_append_line_once "$shellenv_line" "$zprofile"

  if (( BOOTSTRAP_DRY_RUN )); then
    printf '[dry-run] eval shellenv from %s\n' "$brew_bin"
    return 0
  fi

  eval "$("$brew_bin" shellenv)"
}

bootstrap_install_brew_bundle() {
  local brew_bin

  if [[ ! -f "$BOOTSTRAP_REPO_ROOT/Brewfile" ]]; then
    bootstrap_die "Brewfile not found at $BOOTSTRAP_REPO_ROOT/Brewfile"
  fi

  brew_bin="$(bootstrap_resolve_brew_bin)"
  bootstrap_log "Installing packages from Brewfile"
  bootstrap_run_cmd "$brew_bin" bundle --file "$BOOTSTRAP_REPO_ROOT/Brewfile"
}

bootstrap_configure_zsh_source() {
  local zshrc source_line

  zshrc="$HOME/.zshrc"
  printf -v source_line 'source "%s/all.zsh"' "$BOOTSTRAP_REPO_ROOT"

  bootstrap_append_line_once "$source_line" "$zshrc"
}

bootstrap_configure_hammerspoon_link() {
  local source_path target_path

  source_path="$BOOTSTRAP_REPO_ROOT/hammerspoon"
  target_path="$HOME/.hammerspoon"

  if [[ ! -d "$source_path" ]]; then
    bootstrap_warn "hammerspoon directory not found at $source_path"
    return 0
  fi

  if [[ -L "$target_path" ]]; then
    if [[ "$(readlink "$target_path")" == "$source_path" ]]; then
      bootstrap_log "Hammerspoon symlink already configured"
      return 0
    fi

    bootstrap_warn "$target_path points elsewhere. Skipping overwrite."
    return 0
  fi

  if [[ -e "$target_path" ]]; then
    bootstrap_warn "$target_path exists and is not a symlink. Skipping overwrite."
    return 0
  fi

  bootstrap_run_cmd ln -s "$source_path" "$target_path"
}

bootstrap_run_apply() {
  bootstrap_log "Applying bootstrap"

  bootstrap_install_homebrew_if_needed
  bootstrap_configure_shellenv
  bootstrap_install_brew_bundle
  bootstrap_configure_zsh_source
  bootstrap_configure_hammerspoon_link

  bootstrap_log "Git name, email, and commit signing are manual: ./scripts/gpg-signing.sh"
}
