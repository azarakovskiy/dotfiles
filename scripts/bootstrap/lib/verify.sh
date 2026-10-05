#!/usr/bin/env bash

set -euo pipefail

bootstrap_verify_line_present() {
  local line="$1"
  local file="$2"

  if [[ -f "$file" ]] && grep -Fqx "$line" "$file"; then
    printf 'PASS  %s contains expected line\n' "$file"
  else
    printf 'WARN  %s missing expected line: %s\n' "$file" "$line"
  fi
}

bootstrap_verify_command() {
  local command_name="$1"

  if command -v "$command_name" >/dev/null 2>&1; then
    printf 'PASS  command available: %s (%s)\n' "$command_name" "$(command -v "$command_name")"
  else
    printf 'WARN  command missing: %s\n' "$command_name"
  fi
}

bootstrap_verify_script() {
  local label="$1"
  local relative_path="$2"
  local prefix

  for prefix in /opt/homebrew /usr/local; do
    if [[ -s "$prefix/$relative_path" ]]; then
      printf 'PASS  %s script found at %s/%s\n' "$label" "$prefix" "$relative_path"
      return 0
    fi
  done

  printf 'WARN  %s script missing\n' "$label"
}

bootstrap_verify_formula() {
  local formula="$1"

  # Formula name and command differ for these. nvm and antidote are scripts, not binaries.
  case "$formula" in
    awscli) bootstrap_verify_command aws ;;
    gnupg) bootstrap_verify_command gpg ;;
    nvm) bootstrap_verify_script nvm opt/nvm/nvm.sh ;;
    antidote) bootstrap_verify_script antidote opt/antidote/share/antidote/antidote.zsh ;;
    *) bootstrap_verify_command "$formula" ;;
  esac
}

bootstrap_verify_cask() {
  local brew_bin="$1"
  local cask="$2"

  if [[ -z "$brew_bin" ]]; then
    printf 'WARN  cask missing: %s\n' "$cask"
    return 0
  fi

  if "$brew_bin" list --cask "$cask" >/dev/null 2>&1; then
    printf 'PASS  cask installed: %s\n' "$cask"
  else
    printf 'WARN  cask missing: %s\n' "$cask"
  fi
}

bootstrap_verify_brewfile() {
  local brew_bin="$1"
  local line name

  if [[ ! -f "$BOOTSTRAP_REPO_ROOT/Brewfile" ]]; then
    printf 'WARN  Brewfile missing at %s/Brewfile\n' "$BOOTSTRAP_REPO_ROOT"
    return 0
  fi

  while IFS= read -r line || [[ -n "${line:-}" ]]; do
    case "$line" in
      'brew "'*'"'*)
        name="${line#brew \"}"
        name="${name%%\"*}"
        bootstrap_verify_formula "$name"
        ;;
      'cask "'*'"'*)
        name="${line#cask \"}"
        name="${name%%\"*}"
        bootstrap_verify_cask "$brew_bin" "$name"
        ;;
    esac
  done < "$BOOTSTRAP_REPO_ROOT/Brewfile"
}

bootstrap_run_verify() {
  local brew_bin source_line

  bootstrap_log "Running verification"
  brew_bin="$(bootstrap_find_brew_bin || true)"

  if [[ -n "$brew_bin" ]]; then
    printf 'PASS  Homebrew found at %s\n' "$brew_bin"
  else
    printf 'WARN  Homebrew not found\n'
  fi

  printf -v source_line 'source "%s/all.zsh"' "$BOOTSTRAP_REPO_ROOT"
  bootstrap_verify_line_present "$source_line" "$HOME/.zshrc"

  # git and zsh come from macOS. They are not Brewfile entries.
  bootstrap_verify_command git
  bootstrap_verify_command zsh
  bootstrap_verify_brewfile "$brew_bin"
}
