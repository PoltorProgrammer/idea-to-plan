# Template: definition of done and handoff (stage 11)

Where the workflow ends, how to verify it is really finished, and what the user receives. Applied after stages 9 and 10.

## Where the workflow ends

**In scope:** understand the material, decide with the user, document the project, write an executable phased plan, and prepare the repository base so any agent can pick it up.

**Out of scope, never done by this workflow:** executing the plan, writing product code, installing dependencies, creating accounts, pushing to a remote. Those start with phase 0, in a separate session.

## Definition of done

Run this checklist at the end. Every item must hold. If one fails, fix it and re-check; if the fix needs a user decision, ask with the question tool.

**Intake**
- [ ] Every source file is formalized or listed as unprocessed in `<intake>/formalized/index.md`.
- [ ] Originals are in `<intake>/original/`, untouched.

**Process**
- [ ] The closing gate (stage 8) was approved by the user.
- [ ] `process/state.md` has every decision with its status, open assumptions are listed, all stages are ticked.

**`docs/`**
- [ ] All planned documents exist; requirements have IDs and acceptance criteria.
- [ ] No placeholder text (`<...>`, `TODO`, "to be defined") unless it is a logged open question.

**`dev-plan/`**
- [ ] `README.md`, `PROGRESS.md` and one file per phase exist.
- [ ] Every phase file has all mandatory sections (objective, requirements covered, prerequisites, agent part, handoff, human part if needed, acceptance criteria, continuation prompt).
- [ ] Every must-have requirement is covered by some phase.
- [ ] Phase 00 prerequisites can actually be checked by an agent.
- [ ] Continuation prompts chain correctly (phase N names phase N+1; the last one points to close-out) and every path in them exists.

**Repository base**
- [ ] `README.md`, `.gitignore`, `AGENTS.md`, `CLAUDE.md` exist; `.env.example` exists if credentials are needed.
- [ ] No secrets or personal data anywhere outside `<intake>/original/`.

Then update `process/state.md`: tick stage 11 and set **Status: Planning complete, ready for phase 00** with the date.

## Handoff report (final message)

Keep it short and concrete:

1. **Done:** the project folder path and its tree.
2. **Key decisions:** 5 lines.
3. **Still open:** assumptions and risks that remain.
4. **Not done on purpose:** no code written, nothing executed, nothing pushed.
5. **Next step:** the exact prompt to start phase 00, with the real path of `<project>/dev-plan/README.md`. Recommend starting it in a **new chat** with `<project>` opened as the workspace, so the executing agent begins with clean context and reads `AGENTS.md`.
6. **How to follow progress:** `dev-plan/PROGRESS.md`.
7. **Git:** the commands to initialize and push, offered but not run.

## After completion

If `/new-project` is run again on a project whose state is "Planning complete", do not redo the process. Offer, with the question tool:

- **Revise:** process new files in the intake folder, or reopen a specific stage, then update the affected `docs/` and `dev-plan/` files and the decision log (flag what changed).
- **Hand off again:** repeat the handoff report.

If the plan is already being executed (`PROGRESS.md` has ticked steps), warn the user before changing anything that would invalidate completed work.
