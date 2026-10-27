# How it works

This document explains what `/new-project` does at each step, why it is built this way, and what you can expect to see.

## Core idea

A coding agent is only as good as the plan it receives. Most failed agent projects start from a vague idea plus an eager model: the agent fills the gaps with guesses, and the guesses harden into code. This workflow inserts a structured conversation before any code exists. The agent reads your raw material, asks the questions that matter, records the answers, and only then writes the documentation and a step-by-step plan.

Three principles run through everything:

1. **You decide, the agent recommends.** Every question carries a recommended option with its reason, but the choice is yours.
2. **Nothing is guessed silently.** What is not in your sources or your answers is asked, or recorded as an explicit *assumption*.
3. **Everything is auditable.** Originals are preserved, decisions are logged with their status, and the plan traces back to documented decisions.

## The three pieces

| Piece | Where | Role |
| :--- | :--- | :--- |
| Workflow | `.agents/workflows/new-project.md` (or the Claude Code skill) | The procedure: stages, conduct rules, question rules. Kept compact. |
| Templates | `.agents/templates/*.md` | Detail the workflow points to: round format, state file, intake mechanics, docs layout, plan layout, repository files, question bank. |
| Wrapper (Claude Code, "both" variant) | `.claude/commands/new-project.md` | Seven lines telling Claude Code to follow the workflow file. |

## Stage by stage

### 1 · Intake and understanding

Mechanics are in `intake.md`. In order:

1. **Resolve the project.** If you pointed at `<X>/docs/00-intake`, the project is `<X>` and its folder name is the project name. Otherwise the agent asks for a name and location.
2. **Inventory** every file (recursively, excluding `original/` and `formalized/`). Readable types (Markdown, text, CSV, JSON, PDF, images, and Office files when tools allow) are processed. Audio, video, archives and unreadable files are listed as **unprocessed** and the agent asks you for a transcript or summary. Nothing is skipped silently.
3. **Sensitive content check.** API keys, passwords, financial or third-party personal data are flagged and left out of the formalized copy (`[redacted: ...]`).
4. **Move** each file into `docs/00-intake/original/`, untouched. The previous path is logged in the index so the move can be reversed.
5. **Formalize, losslessly.** One Markdown copy per readable source in `formalized/`. Allowed: clearer structure, typo fixes, `[unclear: ...]` marks. Not allowed: interpretation, summarizing away detail, filling gaps, translating. Every file carries a small header with its source and date.
6. **Index.** `formalized/index.md` lists sources with 2-line factual summaries, topics, unprocessed files, sensitive-data flags, conflicts between documents and open questions.
7. **Understanding summary.** From the index, the agent says what it understood, who is involved, what is clear, missing or contradictory, and which assumptions it is making, then asks you to confirm or correct. It proposes no solutions yet.

### 2 · Purpose and success

Why the project exists and how you will know it worked: the real problem, for whom, what happens if nothing is done, success measures, motivation. With very raw material this stage often takes several rounds; the workflow tells the agent not to rush it.

### 3 · Scope and limits

What is in, out and constrained: must-haves, nice-to-haves and explicit non-goals; time, budget, people, skills; legal or privacy constraints; external dependencies. The agent helps you cut, for example by asking what you would drop first with half the time.

### 4 · Phases and goals

The work is split into phases, each with an objective, an observable deliverable, an acceptance criterion ("done when..."), a duration estimate and what is postponed. You also choose where to place checkpoints to decide whether to continue.

### 5 · Approach and tools

For software projects the agent analyzes layer by layer (interface, logic, data, AI or integrations, deployment, testing), presenting 2-4 viable alternatives per real fork with pros, cons, cost and learning curve, and a recommendation that weighs your experience and constraints. It prefers mature, well-documented technology that coding agents handle well. For other domains it does the same with methods, tools and providers. Weighty decisions (hard to reverse, costly, legal) are always put to you explicitly.

### 6 · Human / agent split

The agent takes everything it can resolve with its own tools. You handle only what genuinely needs a human: identity, credentials, 2FA, payments, business decisions, tests with real people or devices, legal validation. Review frequency and "never without permission" actions (delete, publish, spend, send) are agreed here.

### 7 · Risks and assumptions

A pre-mortem ("it is six months later and the project failed: why?") produces the 5-8 likeliest risks with mitigations, plus the assumptions still to validate.

### 8 · Closing gate

The agent presents a decision summary and a readiness checklist (clear purpose, trimmed scope, phases with acceptance criteria, weighty decisions made by you, no contradictions, few open assumptions). It recommends another round if something is missing but respects your choice. **Nothing is generated without your explicit approval.**

### 9 · Generate documentation and plan

Two separate folders:

- **`docs/`** for humans: vision and goals, scope, requirements (with IDs and acceptance criteria), phases and timeline, approach and tools, human/agent split, risks and assumptions, decision log.
- **`dev-plan/`** for agents: `README.md` (global rules, fixed decisions, phase map, start prompt), `PROGRESS.md` (checklist) and one file per phase. Each phase file has objective, prerequisites, numbered agent steps with verification, a handoff message, a human part (only if needed), acceptance criteria and a **continuation prompt** the human pastes to start the next phase.

A coherence check follows: every requirement appears in some phase and no phase contradicts a logged decision.

### 10 · Prepare the repository

`README.md`, a `.gitignore` fitted to the chosen approach (always excluding `.env` and secrets), `.env.example` if credentials exist, and a license after asking you. Git commands are offered but never run unless you ask.

### 11 · Wrap-up

A short report: the project tree, key decisions, open assumptions and risks, and the exact prompt to start phase 0.

## The question rounds

- One topic per round, at most 4 questions.
- Each question has 2-4 real alternatives plus "I don't know / you decide". The recommended option comes first. A free-text answer is always possible.
- If you choose "you decide", the agent applies its recommendation and records it as an **assumption**, not as your decision.
- If you skip a question, the agent does not assume: it asks once more or logs an open question.
- After each round the agent restates what it understood, updates `process/state.md`, and offers: go deeper, next stage, or go back. Say "freeze" at any time to jump to the closing gate.
- If a new decision or new source contradicts an earlier one, the agent says so and asks whether to revisit it.

Delivery uses Antigravity's `ask_question` or Claude Code's `AskUserQuestion` (clickable options that block until you answer). If neither is available, a plain-text format with letter codes (`1B, 2 my own: ..., 3 you decide`) is used.

## The state file

`process/state.md` is the memory of the process: project folder, intake summary, a living summary, a decision table (ID, topic, decision, status, round, reason), open questions, assumptions to validate, risks, per-stage progress and a round log. Decision status is one of **decided** (you chose it), **assumption** (the agent applied it), **deferred** or **discarded**. It lets you stop and resume any day by running the command again.

## Design rationale

- **Why a folder instead of one file?** Real starting material is scattered. A folder lets you dump everything without preparing it first, and the folder name gives the project its name.
- **Why move originals?** The drop zone stays clean and the originals live in one known place. The path log makes the move reversible.
- **Why lossless formalizing?** If the agent interprets while cleaning, invented details get frozen into a document that looks authoritative. Interpretation belongs in the summary you can correct.
- **Why an index?** With many documents, the agent cannot hold everything in context. The index lets later stages read a compact map first and open files only for detail.
- **Why a thin workflow plus templates?** Some tools cap the size of workflow files. Detail lives in templates referenced from the workflow.
- **Why are there three variants?** Antigravity reads `.agents/`, Claude Code reads `.claude/`. No shared folder is read by both, so `both/` carries one real copy and a seven-line pointer.

## Limitations

- It has been verified manually, not with automated tests. Model behavior varies, so rounds may occasionally need a nudge.
- Quality depends on the model. Very small or fast models may ignore the question-count limit or skip the approval gate; use a stronger model if that happens.
- Binary and audio sources cannot be read; you must provide transcripts.
- Antigravity's customization details are not uniformly documented across versions (folder name, file size limit). The README lists what to check.
