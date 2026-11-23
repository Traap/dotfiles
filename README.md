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
- Unlimited, appended command history (`HISTSIZE=-1`).
- Automatic directory changes and spelling correction.
- Dotfile globbing and multiline history preservation.
- SSH agent keys and Neovim application aliases when available.

A non-interactive login shell, such as `ssh host command`, loads the
environment, functions, exports, aliases, and `PATH`, then returns.
Completions, fzf, mise, Starship, and `sshkeys` run only in an
interactive shell. `history -a` records each interactive command after
Starship installs its prompt hook.

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

`vpnConnect` uses `snx-rs` to authenticate through DUO Mobile and establish the
VPN tunnel.  A DUO approval does not always mean the tunnel is ready: the VPN
gateway can return `is_authenticated=true` without the SSL `active_key` that
`snx-rs` needs to build the tunnel.  In that case `snx-rs` exits with an error
even though authentication succeeded.  `vpnConnect` automatically retries this
failure up to three total attempts by default.  It invokes `adConnect` only
after `snx-rs` reports `Tunnel connected` and an AD DNS server answers through
the tunnel.  Set `SNX_MAX_ATTEMPTS` or `SNX_RETRY_DELAY` to adjust the retry
behavior.  Set `SNX_PROBE=false` to skip the DNS proof.

`vpnConnect` writes `no-keepalive=true` into its runtime config.  This gateway
forwards tunnel traffic and does not answer IPSec keepalives on UDP port
18234.  With those probes left on, `snx-rs` exits about 20 seconds after
`Tunnel connected` with `Error: Keepalive failed`.  Set `SNX_NO_KEEPALIVE=false`
to send them again.

If an established tunnel still exits, `vpnConnect` starts a new tunnel.  The
wait doubles from `SNX_RECONNECT_DELAY` up to `SNX_RECONNECT_MAX_DELAY`.
Set `SNX_RECONNECT=false` to keep the old exit-on-disconnect behavior.  Ctrl-C
still closes the tunnel.  The VPN password is stored in a mode 600 runtime
config for the life of `vpnConnect` and is not passed on the `snx-rs` command
line.

Keepalives are off, so `snx-rs` cannot see a tunnel that sends packets and
receives none.  `vpnConnect` probes the AD DNS servers while the tunnel is up.
Two missed replies close that tunnel, clear its IPSec state, and reconnect.
A reboot is not required.  `klist` can still show a ticket from the last good
tunnel; `kinit` now stops waiting after `AD_CONNECT_KINIT_TIMEOUT` seconds
instead of hanging on the silent DNS path.

`vpnFlush` clears a stuck session so a new `vpnConnect` can start.  It stops
`vpnConnect` and `snx-rs`, wipes the runtime config and log, deletes
`snx-xfrm`, and flushes the IPSec state and keepalive routes `snx-rs` adds.
It also lazy-unmounts CIFS shares under `/mnt`, clears a systemd start-limit
on those automounts, and starts the automounts again.  The `vpn` tmux session
is left running.  `vpnFlush --dry-run` prints the actions without changing
the system.  `vpnFlush --kernel` clears only tunnel state.  `vpnFlush --mounts`
repairs latched automounts without stopping a working tunnel.

Kerberos CIFS entries under `/mnt` can be accessed before the first ticket is
available.  `vpnFlush` installs the mount-unit retry policy when it is
missing.  Install it by hand with:

```bash
sudo install -D -m 644 \
  systemd/system/mnt-.mount.d/kerberos-retry.conf \
  /etc/systemd/system/mnt-.mount.d/kerberos-retry.conf
sudo systemctl daemon-reload
```

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
bash -n bash/bin/vpnConnect bash/bin/vpnFlush
generate-session-bindings --check
git diff --check
```

After a Windows or WSL reboot, open WSL normally.  Bash and session bindings
should be immediately usable while the systemd user timer handles AD reconnect
work in the background.
