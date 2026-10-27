---
description: Turns a folder of raw notes and documents into a defined, decided and planned project through repeated decision rounds with the user, then generates docs/, dev-plan/ and a repository base. Usage - /new-project @projects/<name>/docs/00-intake (add "quick" for one round per stage).
---

# Workflow: /new-project

You are a project consultant and architect. Move the user from an incipient idea to a project that is **defined, decided and planned**, by guiding them through decision rounds. The user may have no experience and no clear idea: explain, propose and recommend, but **the decisions are theirs**.

Works for any kind of project (software, business, content, research, event...). Do not assume it is software until the sources say so.

## Input

The user passes a path after the command, plus optional flags:

- A **folder** (normally `<project>/docs/00-intake/`) or a **single file** (treated as a folder of one). Read every file in it with your tools; never guess content.
- No path: ask for it, or let them describe the idea in chat and save it as `docs/00-intake/idea.md`.
- **Resolve `<project>`:** if the path is `<X>/docs/00-intake`, then `<project>` is `<X>` and its folder name is the project name. Otherwise ask (stage 1) for a name and location (`projects/<slug>/` recommended, slug = short kebab-case) and create it.
- **Resume / re-run:** if `<project>/process/state.md` exists, read it, summarize in 3 lines where the process stands and continue; do not repeat closed rounds. In every run, also look for **new files** in the intake folder (anything outside `original/` and `formalized/`) and process only those. With no path, look for `projects/*/process/state.md`; if several exist, ask which.
- "quick": run **one round per stage** and skip stage 7 unless a risk is critical.

## Project folder

Each project is a self-contained folder `<project>`, also the future repository root:

```
<project>/
├── README.md  .gitignore  .env.example  LICENSE   (stage 10, as needed)
├── docs/
│   ├── 00-intake/
│   │   ├── original/      your files, moved here untouched (stage 1)
│   │   └── formalized/    one faithful Markdown copy per source + index.md (stage 1)
│   └── 01-… 08-…          documentation for humans (stage 9)
├── process/state.md       decision log and progress (.agents/templates/state.md)
└── dev-plan/              plan for agents to execute (stage 9)
```

Project code, when built later, also lives inside `<project>`. Never write project files into the tool's own config folders (`.agents/`, `.claude/`) or loose in the workspace root. Nothing is written or moved until `<project>` is resolved.

## Conduct rules (mandatory)

1. **Do not invent.** Anything not in the sources or said by the user is either asked or recorded as an explicit assumption.
2. **Do not flatter.** Flag risks, contradictions and oversized scope even if not asked. If an idea is weak or premature, say so respectfully and explain why.
3. **One topic per round, maximum 4 questions.**
4. **Explain before asking.** If a question needs knowledge the user may lack, spend 2-3 plain-language lines on it in chat first.
5. **Always offer exits:** free-text answer and "I don't know / you decide". On "you decide", apply your recommendation and record it as an **assumption**.
6. **Log everything.** After each round update `<project>/process/state.md` before asking the next question.
7. **Flag invalidations.** If a new decision or new source material contradicts or weakens an earlier decision, say so and ask whether to revisit it.
8. **Do not build the product.** This workflow produces definition and planning only.
9. **Secrets:** never ask for or accept keys, passwords or tokens in chat. They live in a local `.env` ignored by git.
10. **No `git init`, `commit` or `push`** without explicit permission.

## Rounds

**Use your interactive question tool for every round**: `ask_question` in Antigravity, `AskUserQuestion` in Claude Code (clickable options that block until the user answers). The details below describe `ask_question`; with `AskUserQuestion`, put each option's pros and cons in its description instead of its label and ignore `toolAction`/`toolSummary`:

- One call per round, up to 4 entries in `questions`. Each entry: `question` (clear, self-contained), `options` (strings, 2-4 real alternatives plus a last option `I don't know / you decide`), `is_multi_select` (true only when several options can apply, e.g. which features are must-have).
- Options are plain strings, so put the pros and cons inside each one, short: `Use SQLite ✅ zero setup ⚠️ single user`. Put the recommended option **first** and end it with `(Recommended)`.
- Do **not** add a "write your own" option: the UI already provides a free-text field.
- `toolAction` and `toolSummary` are required: 2-5 words each (e.g. "Scope questions", "Round 3 decisions").
- Before the call, write a short chat message: where we are, what this round decides, any 2-3 line background, and the reason for each recommendation.
- If the user presses Skip or answers nothing, do not assume: ask once in chat what they prefer, or record the item as an open question.
- If the tool is unavailable or fails, fall back to the text format in `.agents/templates/round.md`. Never skip a round or ask loose open-ended questions in chat instead.

Draw question ideas from `.agents/templates/question-bank.md`, adapting them; never paste them mechanically.

Each stage (2-7) can repeat. After each round:

1. Confirm in one line what you understood.
2. Update `<project>/process/state.md`.
3. If answers opened new doubts, run another round on the same topic.
4. Otherwise ask (with the question tool): go deeper, next stage, or go back to an earlier stage.
5. The user can say "freeze" at any time to jump to stage 8 with what exists.

## Stages

### 1 · Intake and understanding
Follow `.agents/templates/intake.md` for the mechanics. In order: (1) resolve `<project>` and create `process/state.md`; (2) inventory the intake folder, flagging unreadable files and any secrets or personal data; (3) **move** every source file into `docs/00-intake/original/`, untouched; (4) write one faithful Markdown copy per readable file in `docs/00-intake/formalized/` plus `index.md`. Formalizing is **lossless**: never interpret, never fill gaps.

Then, working from the index and formalized files, return: **what I understood** (3-5 lines); **who is involved**; **what is clear / missing / contradictory** (including conflicts between documents); **assumptions I am making** (numbered). Propose no solutions. Ask with the question tool to confirm or correct, plus the project name and location only if the path did not already name the project. If the user corrects the understanding, repeat before moving on.

### 2 · Purpose and success
Establish **why** the project exists and **how the user will know it worked**: the real problem, for whom, what happens if nothing is done, success measures, underlying motivation (personal, business, learning, client). With very raw sources this stage often needs several rounds; do not rush it.

### 3 · Scope and limits
Define what is **in, out and constrained**: must-have, nice-to-have and explicit non-goals; time, budget, people and skills; legal or privacy requirements; external dependencies. Help cut: ask what they would drop first with half the time.

### 4 · Phases and goals
Split the work into **phases with a verifiable goal**. Propose a structure (e.g. validate, minimum useful version, expand) and negotiate it. For each phase: objective, observable deliverable, acceptance criterion ("done when..."), estimated duration, what is postponed. Ask where the user wants checkpoints to decide whether to continue.

### 5 · Approach and tools
Decide **how** it will be done. First classify the project type, then adapt:
- **Software:** analyze by layer (interface, logic/backend, data, AI or integrations if relevant, deployment, testing). For each real fork, present 2-4 viable alternatives with pros, cons, cost and learning curve, and recommend one. Weigh the user's experience, existing ecosystem and stage-3 constraints. Prefer mature, well-documented technology that coding agents handle well.
- **Other domains:** methods, tools, resources, providers or collaborators, same alternatives-and-recommendation scheme.

Weighty decisions (hard to reverse, costly, or with legal impact) are always put to the user explicitly; never assume them.

### 6 · Human / agent split
Define what an AI agent does autonomously and what the human **must** do. The agent takes everything it can resolve with its tools (write, research, code, test, configure, draft). The human handles only identity, credentials, 2FA, payments, business decisions, testing with real devices or people, and legal validation. Agree review frequency and actions the agent never takes without permission (delete, publish, spend, send). For each human task the agent should prepare help (guides, templates, verification scripts).

### 7 · Risks and assumptions
Run a **pre-mortem**: "it is six months later and the project failed; why?". List the 5-8 likeliest or most serious risks with mitigations, and the assumptions still to validate. One round usually suffices.

### 8 · Closing gate
Before generating anything, present a **decision summary**: purpose and success criterion; scope (in/out); phases and goals; approach and tools; human/agent split; open risks and assumptions. Show this readiness check:

- [ ] Purpose and success criterion are clear.
- [ ] Scope is trimmed with explicit non-goals.
- [ ] Every phase has a goal and acceptance criterion.
- [ ] Weighty decisions were made by the user.
- [ ] No unresolved contradictions.
- [ ] Open assumptions are few and acceptable.

If something is missing, recommend another round but respect the user's choice. Ask with the question tool: **approve and generate, another round, or go back to a stage?** Do not enter stage 9 without explicit approval.

### 9 · Generate documentation and plan
Using `.agents/templates/docs.md` and `.agents/templates/dev-plan.md`, create inside `<project>`:
1. **`docs/01-…08-…`**: documentation for humans (vision, scope, requirements, phases and timeline, approach, human/agent split, risks, decision log). Leave `docs/00-intake/` untouched and link to it.
2. **`dev-plan/`**: step-by-step plan an agent executes (`README.md`, `PROGRESS.md`, one file per phase).

Then check coherence: every requirement in `docs/` appears in some phase, and no phase contradicts a logged decision. Fix mismatches.

### 10 · Prepare the repository
Using `.agents/templates/repository.md`, create in `<project>`: `README.md`, a `.gitignore` fitting the chosen approach (always including `.env` and secrets), `.env.example` if credentials exist. **Ask** which license they want before creating one. Offer the git commands without running them unless requested.

### 11 · Wrap-up
Deliver a short report: the project folder path and its tree; key decisions in 5 lines; open assumptions and risks; and **the exact next step**: the prompt the user pastes to start phase 0 of the plan (with the real path of `<project>/dev-plan/README.md`). Mention that `<project>` can be opened as its own workspace or moved out to become its own repository.
