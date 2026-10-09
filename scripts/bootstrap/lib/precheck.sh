#!/usr/bin/env bash

set -euo pipefail

bootstrap_check_network() {
  if ! command -v curl >/dev/null 2>&1; then
    bootstrap_warn "curl not found; network precheck skipped"
    return 0
  fi

  if ! curl -fsSI --max-time 5 https://github.com >/dev/null 2>&1; then
    bootstrap_warn "Cannot reach github.com. Install steps may fail until network is available."
  fi
}

bootstrap_run_precheck() {
  bootstrap_log "Running pre-checks"

  if [[ "$(uname -s)" != "Darwin" ]]; then
    bootstrap_die "This install supports macOS only."
  fi

  if [[ ! -r "$BOOTSTRAP_REPO_ROOT/cli/all.zsh" ]]; then
    bootstrap_die "Cannot find cli/all.zsh under repo root: $BOOTSTRAP_REPO_ROOT"
  fi

  if [[ ! -r "$BOOTSTRAP_REPO_ROOT/dev/hindsight.zsh" ]]; then
    bootstrap_die "Cannot find dev/hindsight.zsh under repo root: $BOOTSTRAP_REPO_ROOT"
  fi

  if ! xcode-select -p >/dev/null 2>&1; then
    bootstrap_warn "Xcode Command Line Tools are not installed. Run: xcode-select --install"
  fi

  bootstrap_check_network

  if bootstrap_find_brew_bin >/dev/null 2>&1; then
    bootstrap_log "Homebrew detected"
  else
    bootstrap_warn "Homebrew is not installed yet; the Shell stop installs it."
  fi
}
