# Configuration style

Preserve Traap's narrative configuration style.

## Narrative blocks

- Retain explanatory comments and intentional ordering.
- Use the file's native comment syntax.
- Preserve section folds such as `# {{{ Section name`.
- Include each section's closing separator made from hyphens.
- Keep all lines, block markers, and separators within 80 characters.
- Follow the exact local pattern already present in the file.

Do not remove narrative comments merely because the configuration works without
them. Add concise rationale when a platform workaround or non-obvious choice
would otherwise be rediscovered later.

## Formatting

Use a formatter only when it preserves:

- Narrative ordering.
- Section blocks and closing separators.
- Explanatory comments.
- Intentional alignment.

Prefer a targeted manual edit when automatic formatting would reorder or erase
the narrative.

## Change discipline

- Preserve existing conventions unless the requested change requires more.
- Make the smallest coherent change.
- Propose modernization rather than silently restructuring files.
- Preserve unrelated and pre-existing worktree changes.
- Avoid generated churn and unrelated cleanup.

## Commit message proposal

- Use a plain imperative subject.
- Do not use a component prefix.
- Limit the subject to 72 characters.
- Insert one blank line after the subject.
- Wrap body lines at 80 characters.
- Explain motivation and important compatibility effects in the body.
