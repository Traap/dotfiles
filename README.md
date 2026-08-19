# dotfiles

Personal configuration for Bash and the applications used across Arch Linux,
WSL Arch, Git Bash, Ubuntu, and macOS.

The repository is the source of truth.  `bash/bin/symlinks` links supported
configuration into `$HOME` and `~/.config`.

## Bash environment

`~/.bashrc` links to `bash/bashrc`.  It establishes guarded sourcing and then
loads `bash/bashrc_personal`.  A file guard prevents the same configuration
module from running more than once in a shell.

The personal configuration enables:

- Vi command-line editing.
- Unlimited, appended command history.
- Automatic directory changes and spelling correction.
- Dotfile globbing and multiline history preservation.
- SSH agent keys and Neovim application aliases when available.

The `bash/my_*` modules load in this order:

1. `my_environment` defines directory and service settings.
2. `my_functions` provides reusable shell and path helpers.
3. `my_exports` selects platform-aware applications and environment values.
4. `my_aliases` defines commands, Vi mode, tmux behavior, and session keys.
5. `my_paths` assembles Linux, WSL, language, and user executable paths.
6. `my_completions` loads available platform and application completions.
7. `my_programs` initializes optional tools such as fzf, NVM, uv, mise, and
   Starship.

Optional programs are guarded so a missing tool does not prevent Bash startup.
Platform checks keep Linux, WSL, Git Bash, Ubuntu, and macOS behavior separate.

## Readline

`bash/inputrc` is linked to `~/.inputrc`.  It enables Vi editing, Meta key
support, colored completion, case-insensitive matching, and personal cursor and
history bindings.

Run this after changing the file:

```bash
bind -f ~/.inputrc
```

## Session bindings

`sb/sessions.tsv` is the source of truth for shared session bindings.
`bash/bin/generate-session-bindings` generates Bash, tmux, and Hyprland
configuration from that table.

On WSL, lowercase Alt bindings create or switch tmux sessions.  Uppercase Alt
bindings terminate them.  For example:

- `Alt-W` creates or switches to `Work`.
- `Alt-N` creates or switches to `Neovim`.
- `Alt-Shift-W` terminates `Work`.
- `Alt-Shift-N` terminates `Neovim`.

tmux owns these keys while Neovim is running inside tmux, so Neovim does not
need duplicate mappings.

Validate generated files with:

```bash
generate-session-bindings --check
```

## Active Directory reconnect

`adConnect` does not run from `.bashrc`.  Running it synchronously during shell
startup can consume commands sent to new tmux panes and delay Bash, tmux, and
Neovim.

Instead, `ad-connect.timer` schedules the `ad-connect.service` systemd user
unit.  The one-shot service:

- Starts independently of interactive shell initialization.
- Checks whether the AD network is reachable.
- Detects Windows, WSL, and Linux reboots.
- Uses `~/.config/krb5/user.keytab` without reading terminal input.
- Refreshes Kerberos credentials when reconnect state requires it.
- Refreshes every eight hours by default, before a typical ten-hour ticket
  expires.
- Uses noninteractive sudo for DNS and SSSD maintenance.
- Records successful reconnect state and avoids repeated work.

The timer runs shortly after boot and retries periodically.  `vpnConnect`
continues to invoke `adConnect` with VPN-specific DNS behavior.

The keytab is a local credential and must never be committed.  Provision or
replace it interactively with:

```bash
createUserKeytab
```

Recreate the keytab after changing the AD password.

Inspect the service with:

```bash
systemctl --user status ad-connect.timer --no-pager
systemctl --user status ad-connect.service --no-pager
journalctl --user -u ad-connect.service -b --no-pager
klist
```

Force an interactive recovery with:

```bash
adConnect -f
```

## Installation

Create the configured links with:

```bash
bash/bin/symlinks --create
```

The script installs the systemd user units and enables
`ad-connect.timer`.  Reload systemd after changing a unit:

```bash
systemctl --user daemon-reload
systemctl --user restart ad-connect.timer
```

## Validation

Useful checks after Bash changes:

```bash
bash -n bash/bashrc bash/bashrc_personal bash/my_*
bash -n bash/bin/adConnect bash/bin/adConnectService
bash -n bash/bin/createUserKeytab
generate-session-bindings --check
git diff --check
```

After a Windows or WSL reboot, open WSL normally.  Bash and session bindings
should be immediately usable while the systemd user timer handles AD reconnect
work in the background.
