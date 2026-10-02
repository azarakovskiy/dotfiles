#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/scripts/bootstrap/lib"

export BOOTSTRAP_REPO_ROOT="$SCRIPT_DIR"
export BOOTSTRAP_DRY_RUN=0

RUN_APPLY=1
RUN_VERIFY=1
PRECHECK_ONLY=0

source "$LIB_DIR/common.sh"
source "$LIB_DIR/precheck.sh"
source "$LIB_DIR/apply.sh"
source "$LIB_DIR/verify.sh"

usage() {
  cat <<'HELP'
Usage: ./bootstrap.sh [options]

Options:
  --apply                       Run installation/configuration phase
  --verify                      Run verification phase
  --verify-only                 Run only verification
  --precheck-only               Run only pre-checks
  --dry-run                     Print planned commands without changing files
  -h, --help                    Show help

Default behavior: --apply --verify
HELP
}

parse_args() {
  local explicit_mode=0

  for arg in "$@"; do
    case "$arg" in
      --apply)
        if (( explicit_mode == 0 )); then
          RUN_APPLY=0
          RUN_VERIFY=0
          explicit_mode=1
        fi
        RUN_APPLY=1
        ;;
      --verify)
        if (( explicit_mode == 0 )); then
          RUN_APPLY=0
          RUN_VERIFY=0
          explicit_mode=1
        fi
        RUN_VERIFY=1
        ;;
      --verify-only)
        RUN_APPLY=0
        RUN_VERIFY=1
        explicit_mode=1
        ;;
      --precheck-only)
        RUN_APPLY=0
        RUN_VERIFY=0
        PRECHECK_ONLY=1
        explicit_mode=1
        ;;
      --dry-run)
        BOOTSTRAP_DRY_RUN=1
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        bootstrap_die "Unknown option: $arg"
        ;;
    esac
  done
}

main() {
  parse_args "$@"
  bootstrap_run_precheck

  if (( PRECHECK_ONLY )); then
    bootstrap_log "Pre-check only mode finished"
    exit 0
  fi

  if (( RUN_APPLY )); then
    bootstrap_run_apply
  fi

  if (( RUN_VERIFY )); then
    bootstrap_run_verify
  fi

  bootstrap_log "Done"
}

main "$@"
