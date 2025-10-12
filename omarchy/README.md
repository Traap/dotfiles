## Omarchy Customizing

DO NOT USE THESE SCRIPTS WITHOUT READING THEM FIRST.

YOU HAVE BEEN WARNED!

Traap

## An attempt at humor:

Good news Omarchy, DHH, and Traap are all opinionated: Everyone wins.  We are all
narcissist if we 100% agree with everyone on everything 100% of the time; at
that point I'm just talking to myself, which I do all the time anyway -- and yes
I answer myself too.

It's my computer so my opinion wins.  If I break a beautiful setup done by the
amazing Omarchy team, well that's my problem and mine fix.

## On a serious note:
I have been using a tiling window managers (BSPWM, and Hyprland), terminals
(alacritty, ghostty, kitty, and MS Terminal), shells (bash and Git Bash), and
TMUX for several years.

I have studied keyboard layout differences, window movement, and key presses
to maximize my personal productivity.  Each time I uncover an award movement, I
make a note, study the problem, and implement a solution.

I can seamlessly float between BSPWM, Hyprland, Vim, Neovim on Arch Linux,
Ubuntu, WSL2 running Arch Linux, WSL2 running Ubuntu, and Git Bash and remain
productive.  Linux based solutions are always nearly flawless; Windoz does take
mangling to accomplish setup tasks that a painless on Linux.

## The solution
Omarchy is built upon the greatest Linux distribution ever: Arch Linux.  I used
Omarchy defaults, studied the bash scripts (they are amazing by the way), and
did minor tweaking to improve my workflows.  After installing Omarchy on three
different laptops and convincing myself that I could create a seamless workflow
for all systems that I use daily, I add my Omarchy customizations.

## The journey begins with .bashrc and .inputrc
Effortlessly combine both bash environments.

```bash
# All the default Omarchy aliases and functions
source ~/.local/share/omarchy/default/bash/rc

# Traap's customization.
source ~/git/dotfiles/bash/bashrc

# Don't mess with my .inputrc
bind -f ~/.inputrc
```

I document everything I care about. I have been bashing since 2014.  Almost 13
years of muscle and visual memory is not easily undone.  Here is my fully
document .inputrc
```bash
# ============================================================================
# ~/.inputrc — Merged Configuration
#
# Purpose:
#   Start from documented GNU Readline defaults, apply useful Omarchy settings,
#   then override with personal preferences. This ensures a predictable, stable
#   shell experience across systems.
#
# Compatibility:
#   - GNU Readline 8.x, Bash 5.x
#   - Linux and macOS
#
# To apply changes immediately:
#   bind -f ~/.inputrc
# ============================================================================

# ============================================================================
# Character Encoding & Meta Keys
# ============================================================================

# Enable Meta (Alt) key support.
set meta-flag on

# Allow entering 8-bit characters.
set input-meta on

# Display 8-bit characters as-is instead of escaping them.
set output-meta on

# Prevent Meta characters from being converted to ESC sequences.
set convert-meta off

# ============================================================================
# Editing Mode
# ============================================================================

# Disable terminal bell entirely (default: audible)
set bell-style none

# Use Vi editing mode instead of default Emacs.
set editing-mode vi
set keymap vi

# ============================================================================
# Completion Behavior (Defaults → Personal)
# ============================================================================

# Case-insensitive completion
set completion-ignore-case on

# Show all completions on first Tab if ambiguous
set show-all-if-ambiguous on

# Show completions even if line hasn't been modified
set show-all-if-unmodified on

# Display first N common characters in completion lists
set completion-prefix-display-length 0

# Automatically append '/' when completing symlinks to directories
set mark-symlinked-directories on

# Do not match hidden files unless input begins with '.'
set match-hidden-files off

# Show all results at once (disable paging)
set page-completions off

# Ask before showing more than N (200) completions
set completion-query-items 200

# Show file type indicators (like `ls -F`)
set visible-stats on

# Skip already-completed text when completing (Bash 4+)
set skip-completed-text on

# Enable colored completion listings (Bash 4+)
set colored-stats on

# ============================================================================
# Key Bindings (Restore to Personal Defaults)
# ============================================================================

# Up arrow: navigate to previous command in history
"\e[A": previous-history

# Down arrow: navigate to next command in history
"\e[B": next-history

# Right arrow: move forward one character
"\e[C": forward-char

# Left arrow: move backward one character
"\e[D": backward-char

# Remove stray alternative escape sequences
"\eOA": ""
"\eOB": ""

# Remove legacy +/- bindings for history navigation
"+": ""
"-": ""

# ============================================================================
# End of ~/.inputrc
#
# This configuration merges:
#   - GNU Readline defaults (for predictability)
#   - Omarchy enhancements (for usability)
#   - Personal preferences (for control)
#
# Reload with: bind -f ~/.inputrc
# ============================================================================
```
## The Migration
Omarchy uses a familiar migration strategy that Ruby On Rails does.  No
surprise: DHH invented both.  There are two driving files: config and migration.

I use config to set flags.  These flags define what I want installed.  I have
several computer to manage.  Each computer has its own sshkey.  Some computers
do not need LaTeX, etc.

```bash
bashrcFlag=false
gitBashPromptFlag=false
hyprlandFlag=false
luarocksPackages=false
mirrorFlag=false
nodeJsFlag=false
openSSLFlag=true
orphanedFlag=true
pacmanPackagesFlag=false
pipPackagesFlag=false
seamlessLoginFlag=false
sshHostKeyFlag=false
starshipFlag=false
symlinksFlag=false
texPackagesFlag=false
tmuxPluginsFlag=false
waybarFlag=false
yayPackagesFlag=false


```bash
#!/usr/bin/env bash
set -euo pipefail

# Run premigration setup first.
source ./functions
source ./config
echo "=== Migration started ==="

# Run migrations
for script in [0-9][0-9]-*; do
  echo "$script is running."
  source "./$script"
  echo "$script has completed."
  echo
done

# Done
echo "=== Tha-Tha-Tha That's all, folks! ==="
echo "=== Porky Pig, Looney Toons and Merrie Melodies, 1937 ==="
```
