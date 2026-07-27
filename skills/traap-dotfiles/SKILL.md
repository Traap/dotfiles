---
name: traap-dotfiles
description: Maintain, explain, troubleshoot, and safely modernize Traap's
  personalized development environment. Use for Bash, Neovim and lazy.nvim,
  VSCode Neovim in Visual Studio Code Insiders, tmux, Ghostty, Windows Terminal,
  WSL Arch Linux, terminal compatibility, navigation, clipboard integration,
  dotfile linking, or related bootstrap changes across Traap's ~/git layout.
---

# Traap Dotfiles

Maintain Traap's cross-platform terminal and editor environment while preserving
its narrative style and repository boundaries.

## Start every task

1. Read [repositories.md](references/repositories.md).
2. Identify every repository and runtime environment affected by the request.
3. Read repository-local guidance and inspect current files before editing.
4. Check Git status in each affected repository.
5. Preserve unrelated and pre-existing changes.
6. Read [style.md](references/style.md) before changing configuration.
7. Read [validation.md](references/validation.md) before planning validation.

Treat the checked-in source as authoritative. Inspect active symlinks only to
diagnose deployment or runtime discrepancies.

## Work by component

### Bash

Place aliases, completions, environment variables, exports, functions, paths,
program initialization, and prompt logic in the existing dedicated `bash/my_*`
files. Prefer portable behavior across Arch Linux, WSL Arch, Git Bash, and
Ubuntu. Use Bash-specific features when they materially improve the result.

Quote expansions safely. Avoid unnecessary subprocesses. Guard optional
commands and platform-specific behavior with capability checks. Keep
interactive-only logic out of noninteractive startup paths where practical.

### Neovim

Treat `~/git/nvim.traap` as the only source of truth for Traap's Neovim
configuration. Support terminal Neovim and its use as the backend for VSCode
Neovim by Alexey Svetliakov in Visual Studio Code Insiders.

Before changing plugin specifications, read
`lua/traap/plugins/init.lua` and follow its narrative. Prefer lazy loading.
Distinguish LazyVim-provided plugins from Traap's custom plugins because that
choice changes event patterns. Preserve operating-system and runtime-environment
detection. Disable or replace plugins that conflict with VS Code.

### tmux and terminals

Treat `~/git/tmux` as the tmux source of truth. Preserve compatibility across
Ghostty on Linux and Windows Terminal hosting WSL Arch as primary targets.
Treat Git Bash, PowerShell, Ubuntu, SSH, and other terminals as secondary
compatibility targets.

Preserve seamless Neovim/tmux navigation so `Ctrl-H`, `Ctrl-J`, `Ctrl-K`, and
`Ctrl-L` work across editor and pane boundaries. Prefer one clipboard model for
tmux, Neovim, Linux, WSL, Windows Terminal, and SSH. Use OSC 52 or forwarding
when available and provide a graceful fallback when unavailable.

### Code Insiders and Windows Terminal

Keep portable Code Insiders settings and VSCode Neovim keybindings separate
from private or employer-specific settings. Never place SQL connections,
internal hostnames, private identifiers, or credentials in general dotfiles.

Treat manual JSON copies under `~/git/wiki/json` as legacy inputs, not future
sources of truth. Propose moving portable Code settings and keybindings under
`~/git/dotfiles/vscode`, and Windows Terminal settings under
`~/git/dotfiles/windows-terminal`. Do not perform that migration without
approval.

### Bootstrap

Use `~/bootstrap/Omarchy` for machine provisioning, installation, and linking.
Inspect and update it when an approved configuration change requires deployment
changes. Do not duplicate its responsibility inside this skill.

## Handle modernization

Apply ordinary, explicitly requested changes directly. Before applying a
structural migration or broad modernization, present:

1. The problem and expected benefit.
2. The proposed target directory tree.
3. Files to move, split, generate, or retire.
4. Required bootstrap, link, or platform changes.
5. Compatibility and privacy impact.
6. Validation steps.
7. A rollback approach.

Wait for approval before implementing the modernization.

## Protect sensitive material

Treat `~/git/ssh` as sensitive and off-limits by default. Never read, display,
copy, or modify private keys unless the user explicitly requests a narrowly
scoped SSH task. Avoid exposing secrets or work-specific data found elsewhere.

## Finish changes

Run relevant static checks and safe smoke tests. Review the final diff and
report remaining risks or untested environments. Never commit or push unless
explicitly requested.

Propose a plain imperative Git commit message. Limit the subject to 72
characters, insert a blank line, and wrap body lines at 80 characters. Do not
use component prefixes.
