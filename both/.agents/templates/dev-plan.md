# Template: `dev-plan/` folder

Plan **for a coding agent (or other agent) to execute step by step**. Generated in stage 9. It must be self-sufficient: an agent reading only this folder and `docs/` knows what to do, in what order, and how to check it did it right.

## Location and paths

The plan lives in `<project>/dev-plan/` and the project folder is the repository root. Links inside generated files are relative to their own location. Prompts the human will paste (start prompt, continuation prompts) use the **real path from the workspace root**, e.g. `projects/book-tracker/dev-plan/phase-1-core.md`. All code and assets created by the plan go inside `<project>`, never outside it.

## Structure

```
dev-plan/
├── README.md          global rules, phase map, fixed decisions, start prompt
├── PROGRESS.md        tracking checklist
├── phase-00-setup.md
├── phase-01-<name>.md
└── phase-NN-<name>.md
```

Phases come from `docs/04-phases-and-timeline.md`. Phase 0 is usually environment and tooling setup.

## Plan `README.md`

1. **How to use this folder:** the agent works one phase at a time, in order.
2. **Global rules for the agent:**
   - Read `docs/` and the current phase before acting.
   - Verify each step before the next; never advance with failing checks.
   - Update `PROGRESS.md` after each step.
   - Do not reopen fixed decisions without justification and notifying the human.
   - Never ask for or store secrets in chat; they live in a local `.env` ignored by git.
   - When in doubt, ask instead of assuming.
   - If a requirement changes, update `docs/` and `docs/08-decisions.md` first, then adjust the plan and tell the human.
   - No destructive or external actions (delete, publish, spend, send) without permission.
3. **Fixed decisions** (summary of `docs/08-decisions.md`).
4. **Phase map:** table with phase, objective, requirements covered, human action needed?
5. **Global start prompt:**
   > "Read `<project>/dev-plan/README.md` and `<project>/docs/README.md`. Then open `<project>/dev-plan/phase-00-setup.md`, check its prerequisites and execute the agent part. Update `PROGRESS.md` after each step."
   (Replace `<project>` with the real path.)

## `PROGRESS.md`

A checklist with one `[ ]` per step of each phase, grouped by phase, plus a status line ("Current phase", "Last completed step", "Blockers"). The agent ticks `[x]` only after verifying the step.

## Mandatory structure of each `phase-NN-*.md`

1. **Objective and deliverables:** what will work and be verified at the end.
2. **Requirements covered:** IDs from `docs/03-requirements.md`.
3. **Prerequisites:** checks before touching anything (files, tools, earlier phases done, credentials present).
4. **🤖 Agent part:**
   - Numbered steps (1.1, 1.2...).
   - Per step: what to do, which files to create or modify, exact commands, and **how to verify** (a checkable acceptance criterion).
   - Real code or commands in the chosen language and tools, not vague pseudocode.
   - Tests to run and expected result.
5. **🛑 Handoff to the human:** template for the agent's closing message: what was done, what was verified, what remains, whether human action is needed or it can continue.
6. **👤 Human part (only if applicable):**
   - What the human must do, with guided instructions.
   - What they must **not** do (paste secrets in chat, hand-edit code unnecessarily...).
   - How to confirm it was done right (e.g. a verification script).
7. **Phase acceptance criteria:** a list that must be fully met to close the phase.
8. **▶ Continuation prompt:** exact text the human pastes to start the next phase. It must name the phase N+1 file, order the agent to read it, check prerequisites and update `PROGRESS.md`. In the last phase, verify the success criteria from `docs/01-vision-and-goals.md` and indicate project close-out.

## Quality criteria

- Each step is small enough to verify on its own.
- Phases depend only on information in `docs/` or earlier phases.
- Every must-have requirement appears in some phase.
- Human tasks are minimal (identity, credentials, payments, physical tests, business decisions).
- Human review points exist where agreed in stage 6.
