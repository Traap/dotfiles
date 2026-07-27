# Validation

Select checks proportional to the change. Run safe static checks and smoke tests
when the required tools are available. Report skipped checks and why.

## General checks

1. Inspect repository-local test commands and documentation.
2. Validate only affected components unless integration risk requires more.
3. Use isolated or temporary runtime state for smoke tests.
4. Review the diff for secrets, private data, and narrative-style damage.
5. Check line lengths for files governed by the 80-character style rule.
6. Confirm unrelated worktree changes remain untouched.

## Bash

- Run `bash -n` on changed Bash scripts.
- Run ShellCheck when available and applicable.
- Exercise platform-detection branches without destructive side effects.
- Distinguish interactive and noninteractive startup behavior.

## Neovim

- Use the repository's existing test and formatting commands first.
- Run a headless startup check with isolated state where practical.
- Check terminal Neovim and VSCode Neovim conditionals separately.
- Confirm lazy-loading triggers match the plugin narrative.
- Compare startup or lazy-loading behavior when plugin loading changes.

## tmux

- Parse the configuration with a temporary isolated tmux server.
- Do not attach to or disturb the user's live tmux server.
- Verify terminal feature declarations against primary environments.
- Test navigator bindings across tmux and Neovim boundaries.
- Test clipboard copy and paste with available Linux, WSL, and OSC 52 paths.

## JSON and applications

- Parse strict JSON with an appropriate JSON parser.
- Use a JSONC-aware validator for Code files containing comments.
- Check Windows Terminal settings against its current schema when practical.
- Check Code Insiders settings and keybindings for duplicate or conflicting
  keys, especially VSCode Neovim navigation.

## Bootstrap

- Use the bootstrap repository's documented validation.
- Verify links resolve to the intended source-of-truth files.
- Avoid replacing an active configuration until its target exists and passes
  validation.
- Include a rollback path for migrations and linking changes.
