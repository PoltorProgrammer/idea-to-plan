# Template: `<project>/process/state.md`

Working file the agent creates inside the project folder (default `projects/<slug>/process/state.md`) and updates after every round. It lets the process pause and resume without losing decisions. Use this structure:

````markdown
# Process state: <project name>

- **Project folder:** <path, e.g. projects/book-tracker/>
- **Intake:** <intake folder path> (<n> files formalized, <m> unprocessed; see formalized/index.md)
- **Created:** <date>  ·  **Last updated:** <date>
- **Current stage:** <1-11 and name>
- **Rounds done:** <n>
- **Mode:** full | quick

## Living summary (max 10 lines)
<The idea as currently understood. Rewritten, not appended.>

## Decisions
| ID | Topic | Decision | Status | Round | Why |
|----|-------|----------|--------|-------|-----|
| D-001 | <e.g. scope> | <chosen> | decided / assumption / deferred / discarded | 3 | <brief reason> |

Status: **decided** (user chose it), **assumption** (agent applied it after "you decide"; needs validation), **deferred** (to be decided later), **discarded** (considered and rejected; keep the reason).

## Open questions
- [ ] <unresolved question> (stage X)

## Assumptions to validate
- A-001: <assumption>: <how it would be validated>

## Risks
| ID | Risk | Likelihood | Impact | Mitigation |
|----|------|------------|--------|------------|

## Stage progress
- [ ] 1 Reading and understanding (name and location confirmed)
- [ ] 2 Purpose and success
- [ ] 3 Scope and limits
- [ ] 4 Phases and goals
- [ ] 5 Approach and tools
- [ ] 6 Human / agent split
- [ ] 7 Risks and assumptions
- [ ] 8 Closing gate (approved: yes/no)
- [ ] 9 Docs and plan generated
- [ ] 10 Repository prepared
- [ ] 11 Wrap-up delivered

## Round log
- **Round 1 (stage 1):** <what was asked, what was answered, 1-2 lines>
````

## Usage rules

- Update **after every round**, before the next question.
- Never contains secrets, keys or sensitive personal data.
- When generating `docs/08-decisions.md` (stage 9), the decision log comes from here.
