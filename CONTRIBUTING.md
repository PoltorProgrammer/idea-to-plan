# Contributing

Thanks for helping improve `idea-to-plan`. The repository is small: Markdown files and one build script.

## Layout

```
both/            source of truth (.agents/ workflow + templates, .claude/commands/ wrapper)
antigravity/     generated from both/
claude-code/     generated from both/
examples/        sample intake material for manual testing
docs/            explanation of how the workflow works
scripts/         build-variants.sh
```

## Changing the workflow

1. Edit files under `both/` only: the workflow in `both/.agents/workflows/new-project.md`, templates in `both/.agents/templates/`, the Claude Code wrapper in `both/.claude/commands/new-project.md`.
2. Regenerate the other variants (Git Bash or any POSIX shell):
   ```bash
   bash scripts/build-variants.sh
   ```
3. Commit the source and the generated folders together. Do not edit `antigravity/` or `claude-code/` by hand; the next build overwrites them.

## Keep the workflow compact

Some Antigravity customization files are reported to have a cap of about 12,000 characters, and the workflow is already around 11.1 KB (check with `wc -c both/.agents/workflows/new-project.md`). Put new detail in a template and reference it from the workflow instead of growing the workflow.

## Testing a change

There are no automated tests; the workflow is instructions for a model, so test it by running it:

1. Copy a variant into a scratch project (see the README's "Try it").
2. Run `/new-project` against `examples/book-tracker-intake` and check that the agent: respects the 4-question limit, offers clickable options with a recommendation, logs decisions in `process/state.md`, and does not generate documents before the closing gate.
3. Try a stronger and a weaker model if you can; instruction-following differs.

## Style

- Instructions are imperative and specific. Prefer a rule with a reason over a vague exhortation.
- Keep the workflow tool-agnostic where possible; tool-specific details (question tool names, folder names) belong in the places already marked for them.
- Plain Markdown, no dependencies.
