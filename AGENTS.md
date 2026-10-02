# AGENTS.md

## Purpose
This file is the execution contract for contributors in this repository, including both AI agents and humans.

It defines how to make safe, minimal, maintainable changes for:
- bootstrap and install flow
- Zsh modules and shell helpers
- setup documentation consistency

## Precedence
Instruction priority is:
1. System instructions
2. Developer instructions
3. User instructions
4. This `AGENTS.md`
5. Generic or personal guidance files

Repo-local rules in this file override generic AI guidance.

## Scope
This file applies to the entire repository unless a deeper `AGENTS.md` is added in a subdirectory.

If a deeper `AGENTS.md` exists later, that file refines or overrides rules only for its subtree.

## Core Rules
- Prefer KISS and YAGNI. Keep changes small, simple, and extensible.
- Prefer minimal diffs and clean, readable shell code.
- Start with non-mutating exploration first (`rg`, `ls`, `sed`, syntax checks) before editing.
- Do not run destructive commands unless explicitly requested by the user.
- Keep bootstrap logic idempotent. Avoid duplicate appends and unsafe overwrites.
- Keep machine portability in mind (`/opt/homebrew` and `/usr/local` differences).

## Bootstrap and Install Rules
- Install packages from `Brewfile`. Apply macOS mouse and font settings from `cli/macos.zsh` when the shell starts.
- Separate unattended setup from manual secret or identity steps.
- Never commit secrets, private keys, tokens, or machine-identity-sensitive data.
- Assume this repo is public-safe: only non-sensitive assets belong here.

## Shell Script Rules
- Be explicit about shell compatibility (`zsh` vs `sh`/POSIX) for every script.
- Quote variable and path expansions unless intentionally unquoted.
- Avoid shell-startup side effects where possible.
- Avoid patterns that re-source `.zshrc` repeatedly on directory change (for example in `chpwd`).

## Docs Sync Rule
Any change to install/bootstrap/sourcing behavior must update `README.md` in the same change.

## Validation Checklist
Run these checks when changing relevant files:

```sh
zsh -n all.zsh cli/*.zsh
bash -n bootstrap.sh scripts/bootstrap/lib/*.sh
```

Also smoke-check key aliases and functions after sourcing.

## PR and Change Expectations
- Include a short risk note for bootstrap or shell behavior changes.
- Include a rollback path for non-trivial setup changes.
- Call out assumptions when behavior differs between machine architectures or shell environments.

## How to Treat This File
- Treat this as the repository working agreement, not optional advice.
- Load this file first before planning or implementing changes.
- Update this file when workflow, install strategy, or safety policy changes.
- Keep it concise and enforceable; keep broad personal standards elsewhere.
- If a higher-priority instruction conflicts with this file, follow higher priority and record the exception in PR notes.
