# Template: intake (stage 1 mechanics)

How to turn the user's raw files into a clean, auditable base. Applies to the intake folder `<project>/docs/00-intake/` and to every re-run when new files appear.

## Folder layout

```
docs/00-intake/
├── (new files dropped here, waiting to be processed)
├── original/      source files moved here untouched
└── formalized/    one faithful Markdown copy per readable source + index.md
```

## 1. Inventory

List every file in the intake folder, recursively, **excluding** `original/` and `formalized/`. For each: relative path, type, size. Decide per type:

| Type | Handling |
| :--- | :--- |
| `.md`, `.txt`, `.csv`, `.json` | Read directly. |
| `.pdf`, images (screenshots, photos, diagrams) | Read with your tools; transcribe text and describe diagrams factually. |
| `.docx`, `.xlsx`, `.pptx`, `.html` | Convert or read if your tools allow it. |
| Audio, video, archives, binaries, anything unreadable | **Unprocessed.** Do not guess content. List it and ask the user for a transcript or summary. |
| Very large files | Process in parts; state in the formalized copy which parts were covered. |

Never silently skip a file: everything ends up either formalized or listed as unprocessed.

## 2. Sensitive content check

If a source contains API keys, passwords, tokens, financial data or personal data about third parties, **flag it** in the index and in chat, and leave the sensitive values out of the formalized copy (write `[redacted: api key]`). Suggest the user keep `original/` out of version control (see `repository.md`).

## 3. Move to `original/`

**Always move** each source file into `docs/00-intake/original/`, preserving its relative subfolders (even when it came from outside the project). Rules:

- Never edit an original, never rename it, except to resolve a name collision by adding `-2`, `-3`.
- Record the file's **previous path** in the index so the move can be reversed.
- Unprocessed files are moved too.

## 4. Formalize (lossless)

Write `formalized/<same-name>.md` (kebab-case, `.md`) for each readable source. Goal: the same content, cleaner and navigable. **Only** these changes are allowed:

- Add a clear structure: headings, lists, tables where the source implies them.
- Fix transcription noise, typos and broken line wraps.
- Mark ambiguity inline: `[unclear: ...]` or `[illegible]`.

Never allowed: interpreting, summarizing away detail, filling gaps, adding conclusions, translating, reordering ideas in a way that changes meaning. Keep every distinct idea, number, name, date and quote. Keep the original language.

Each formalized file starts with:

```markdown
---
source: original/<relative-path>
processed: <date>
type: <note | transcript | spec | email | slide | other>
---
```

## 5. Index

Create or update `formalized/index.md`:

```markdown
# Intake index

## Sources
| Source | Formalized | Type | Previous path | Summary (2 lines, factual) | Topics |
|--------|------------|------|---------------|----------------------------|--------|

## Unprocessed files
- <file>: <why> → <what is needed from the user>

## Flags
- <file>: <sensitive content found, what was redacted>

## Cross-document conflicts
- <file A> says X; <file B> says Y.

## Open questions
- [ ] <question the sources leave unanswered>

## Processing log
- <date>: <files processed>
```

Later stages read the index first and open individual files only when they need detail. Conflicts and open questions feed the stage 1 summary and `process/state.md`.

## 6. Re-runs

When the command runs again and the intake folder contains new files, process **only those**, append them to the index, and tell the user what changed. If new material contradicts earlier decisions, flag it (conduct rule 7). If the user asks to reprocess a specific original, regenerate its formalized copy from `original/`.

## Quality criteria

- Every source file is accounted for (formalized or unprocessed).
- Originals are byte-for-byte what the user provided.
- Nothing in `formalized/` is interpretation or invention.
- The index lets a newcomer understand the material without opening every file.
