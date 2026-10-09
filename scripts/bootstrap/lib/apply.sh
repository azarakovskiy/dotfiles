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

bootstrap_configure_zsh_source() {
  local zshrc source_line

  zshrc="$HOME/.zshrc"
  printf -v source_line 'source "%s/cli/all.zsh"' "$BOOTSTRAP_REPO_ROOT"
  bootstrap_append_line_once "$source_line" "$zshrc"
  printf -v source_line 'source "%s/dev/hindsight.zsh"' "$BOOTSTRAP_REPO_ROOT"
  bootstrap_append_line_once "$source_line" "$zshrc"
}

bootstrap_link_when_missing() {
  local source_path="$1"
  local target_path="$2"
  local label="$3"

  if [[ ! -e "$source_path" ]]; then
    bootstrap_warn "$label not found at $source_path"
    return 0
  fi

  if [[ -L "$target_path" ]]; then
    if [[ "$(readlink "$target_path")" == "$source_path" ]]; then
      bootstrap_log "$label symlink already configured"
      return 0
    fi

    bootstrap_warn "$target_path points elsewhere. Skipping overwrite."
    return 0
  fi

  if [[ -e "$target_path" ]]; then
    bootstrap_warn "$target_path exists and is not a symlink. Skipping overwrite."
    return 0
  fi

  bootstrap_run_cmd mkdir -p "$(dirname "$target_path")"
  bootstrap_run_cmd ln -s "$source_path" "$target_path"
}

bootstrap_hindsight_config_path() {
  printf '%s/devtools/hindsight-openai\n' "${XDG_CONFIG_HOME:-$HOME/.config}"
}

bootstrap_write_hindsight_resolver() {
  local value="$1"
  local config dir

  config="$(bootstrap_hindsight_config_path)"
  dir="$(dirname "$config")"
  mkdir -p "$dir"
  printf '%s\n' "$value" > "$config"
  chmod 600 "$config"
  bootstrap_log "Wrote Hindsight key resolver to $config"
}

bootstrap_configure_hindsight() {
  local config choice ref

  config="$(bootstrap_hindsight_config_path)"

  if [[ -f "$config" ]]; then
    bootstrap_log "Hindsight key resolver already set at $config"
    return 0
  fi

  if (( BOOTSTRAP_DRY_RUN )); then
    printf '[dry-run] ask how to resolve OPENAI_API_KEY for hindsight-up and write %s\n' "$config"
    return 0
  fi

  if [[ ! -t 0 ]]; then
    bootstrap_warn "No terminal. Skipping Hindsight key resolver. Re-run ./install.sh to set it."
    return 0
  fi

  printf '%s\n' \
    "How should hindsight-up resolve OPENAI_API_KEY?" \
    "  1) 1Password secret reference (op read, when you run hindsight-up)" \
    "  2) OPENAI_API_KEY already in the environment" \
    "  3) Skip"
  printf 'Choice [1/2/3]: '
  read -r choice || true

  case "$choice" in
    1)
      printf '1Password secret reference (op://...): '
      read -r ref || true
      ref="${ref#"${ref%%[![:space:]]*}"}"
      ref="${ref%"${ref##*[![:space:]]}"}"
      if [[ "$ref" != op://* ]]; then
        bootstrap_warn "Expected an op:// reference. Hindsight key resolver was not written."
        return 0
      fi
      bootstrap_write_hindsight_resolver "$ref"
      ;;
    2)
      bootstrap_write_hindsight_resolver "env"
      ;;
    3 | "")
      bootstrap_write_hindsight_resolver "skip"
      ;;
    *)
      bootstrap_warn "Unknown choice. Hindsight key resolver was not written."
      ;;
  esac
}
