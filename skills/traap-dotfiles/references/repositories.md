# Repository map

Use this map to locate sources of truth and understand repository boundaries.

## Active scope

- `~/git/dotfiles`
  - Source of truth for Bash and many application customizations.
  - Use `bash/` for Bash.
  - Use `ghostty/` for Ghostty.
  - Use `vscode/` as the future source for portable Code Insiders settings.
  - Store this skill at `skills/traap-dotfiles/`.
- `~/git/neovim`
  - Neovim source tree built by Traap every day.
  - Do not confuse it with the user configuration.
- `~/git/nvim.traap`
  - Source of truth for Traap's opinionated Neovim configuration.
  - Support Arch, WSL Arch, Git Bash, PowerShell, and Ubuntu.
  - Support terminal Neovim and VSCode Neovim.
- `~/git/tmux`
  - Source of truth for personalized tmux configuration.
  - Expect the active tmux directory under `~/.config` to be symlinked here.
- `~/bootstrap/Omarchy`
  - Source of truth for provisioning, installation, and symlink automation.
  - Update it when approved changes require deployment changes.

## Context-only scope

- `~/git/vim`
  - Maintained Vim configuration.
  - Know it exists, but do not modify it unless the user expands scope.
- `~/git/vim.pack`
  - Vim configuration using the built-in package manager.
  - Know it exists, but do not modify it unless the user expands scope.
- `~/git/wiki`
  - Personal notebook.
  - Inspect relevant legacy JSON when modernizing Code or Windows Terminal.
  - Do not treat copied JSON as a future source of truth.
- `~/git/youtube`
  - Published YouTube content.
  - Know it exists, but do not modify it unless the user expands scope.

## Sensitive scope

- `~/git/ssh`
  - Contains private keys and is not a repository.
  - Do not inspect or modify it by default.
  - Require an explicit, narrowly scoped SSH request.

## Legacy JSON inputs

Inspect these only when working on their modernization:

- `~/git/wiki/json/code-settings.json`
- `~/git/wiki/json/w11-wsl-code-insiders.json`
- `~/git/wiki/json/w11-wsl-code-insiders-keybindings.json`
- `~/git/wiki/json/ms-terminal-settings.json`

Separate portable configuration from private or employer-specific content.
Never migrate credentials, SQL connections, internal hosts, or private
identifiers into general dotfiles.
