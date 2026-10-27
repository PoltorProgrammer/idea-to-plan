# idea-to-plan

**An agent workflow that turns a folder of raw notes into a decided, phased project plan, through interactive decision rounds.**

Works with [Antigravity](https://antigravity.google/product/antigravity-ide) and [Claude Code](https://claude.com/claude-code). Plain Markdown, no dependencies, any kind of project.

> **Status:** tested manually in Antigravity and Claude Code. There are no automated tests, since the workflow is instructions for a model. Feedback welcome.

## The problem

You have an idea and a pile of loose material: messy notes, transcripts, screenshots, PDFs. You want a coding agent to help build it, but handing it that pile gets you a confident first guess, not a plan. The goals are fuzzy, the limits are unstated, and nobody has weighed the tech options.

## What this does

You drop your files in a folder and run one command. The agent:

1. **Reads and preserves everything.** Your files are archived untouched, and faithful Markdown copies plus an index are produced.
2. **Interviews you in rounds.** It asks 2-4 questions at a time with clickable options, each with pros, cons and a recommendation. You can always write your own answer or say "you decide".
3. **Repeats rounds until you are satisfied.** Purpose, scope, phases, tech and tools, human/agent split, risks. Go deeper, move on or go back, as often as you want.
4. **Asks for approval,** then generates two folders: **`docs/`** for humans (vision, scope, requirements, timeline, decisions) and **`dev-plan/`** for coding agents (step-by-step phases with verification and continuation prompts).
5. **Prepares the repository:** README, `.gitignore`, `.env.example`, license, and `AGENTS.md` / `CLAUDE.md` so any future agent session starts with the project's context.
6. **Verifies it is done and hands off:** a final checklist, then the exact prompt to start phase 00.

You make every decision. The agent explains, recommends and pushes back when it sees a problem; it does not flatter.

## Quick start

**1. Install.** Copy the *contents* of one folder into the root of your project (hidden folders included):

| Folder | Use it if you run | Adds to your project |
| :--- | :--- | :--- |
| [`antigravity/`](antigravity/) | Antigravity | `.agents/` (workflow + templates) |
| [`claude-code/`](claude-code/) | Claude Code | `.claude/skills/new-project/` (one self-contained skill) |
| [`both/`](both/) | Both | `.agents/` + a thin pointer in `.claude/commands/` |

```bash
cp -r idea-to-plan/both/. path/to/my-project/
```

**2. Put your raw material in a folder:** any mix of notes, transcripts, PDFs, images; messy is fine. The folder can have **any name**. A good place is `projects/<name>/docs/<any-name>/`, for example `projects/<name>/docs/starting-notes/`.

**3. Run it** in the agent chat, mentioning that folder:

```
/new-project @projects/<name>/docs/starting-notes
```

If the folder sits in `<project>/docs/`, the project is `<project>`. If it is anywhere else, the agent asks for a project name and location and moves the folder there. Add `quick` for one round per stage. If the command does not appear, start a new Claude Code session, or check the folder name in Antigravity (see [Compatibility](#compatibility)).

## What you get

```
projects/<name>/
├── README.md  .gitignore  .env.example  LICENSE
├── AGENTS.md  CLAUDE.md      context for any future agent session
├── docs/
│   ├── starting-notes/       the folder you pointed at (any name)
│   │   ├── original/         your files, moved here untouched
│   │   └── formalized/       one faithful Markdown copy per file + index.md
│   └── 01-… 08-…             vision, scope, requirements, phases, approach,
│                             human/agent split, risks, decision log
├── process/state.md          every decision, assumption and open question
└── dev-plan/                 README, PROGRESS checklist, one file per phase
```

The project folder is self-contained: open it as its own workspace or move it out to become its own repository.

## How a session goes

```
 Your raw notes and documents, in any folder
      │   /new-project @path/to/that-folder
      ▼
 1 Intake and understanding ──► files archived, faithful copies + index,
                                 you confirm it understood you
 2 Purpose and success      ┐
 3 Scope and limits         │  decision rounds with clickable options,
 4 Phases and goals         │  repeat as many times as you want
 5 Approach and tools       │
 6 Human / agent split      │
 7 Risks and assumptions    ┘
      ▼
 8 Closing gate ──► decision summary; nothing is generated without your approval
      ▼
 9 Generates docs/ and dev-plan/
10 Prepares the repository (README, .gitignore, AGENTS.md, ...)
11 Definition-of-done check + handoff: the exact prompt to start phase 0
```

## Where it ends

The workflow ends at a verified handoff: the project is documented, planned in phases and has a repository base. It then stops. **It never runs the plan or writes product code.** Execution starts with phase 00, ideally in a new chat with the project folder as the workspace, using the prompt it gives you.

- A **definition-of-done checklist** is run at the end: intake complete, decisions logged, docs and plan complete, every must-have requirement covered by a phase, prompts chained correctly, no secrets or placeholders.
- The state file is marked **"Planning complete"**.
- Running `/new-project` again on a finished project does not redo anything: it offers to revise (new files or a reopened stage) or to repeat the handoff.
- If a requirement changes during execution, the plan's rules say to update `docs/` and the decision log first, then the plan.

## Key features

- **Lossless intake.** Originals are moved, never edited. Formalized copies only fix structure and typos, and mark ambiguity as `[unclear: ...]`. Nothing is interpreted or invented at this step.
- **An index, not a pile.** `index.md` summarizes every source, flags conflicts between documents, lists open questions and unreadable files (audio, etc.), and warns about secrets or personal data.
- **Re-runnable.** Add documents later and run again: only new files are processed, and anything that contradicts earlier decisions is flagged.
- **Pause and resume.** Progress lives in `process/state.md`, separating your decisions from the agent's assumptions.
- **Honest advisor.** Recommendations are tied to your situation. The agent is instructed to flag risks, contradictions and oversized scope.
- **Agent-ready plans.** Each phase file has verifiable steps, a human handoff, and the exact continuation prompt for the next phase.
- **Minimal human work.** The agent takes everything it can do alone; you only handle credentials, payments, 2FA, real-world tests and business decisions.
- **Secrets never go in chat.** They live in a local `.env` ignored by git.

## Compatibility

| Tool | How it runs | Notes |
| :--- | :--- | :--- |
| Antigravity | Workflow in `.agents/workflows/` | Google's codelab uses `.agents/` (plural); some guides say `.agent/`. Create a test workflow from the UI (`...` → Customizations → Workflows → `+Workspace`) to see which your version uses. If it is `.agent/`, rename the folder and the `.agents/templates/` paths inside the workflow. |
| Claude Code | Skill in `.claude/skills/` (or command in `.claude/commands/`) | Runs only when you type `/new-project` (`disable-model-invocation`). |

Questions use `ask_question` in Antigravity and `AskUserQuestion` in Claude Code, with a plain-text fallback when neither is available. Output quality depends on the model: very small, fast models follow long instructions less reliably.

## Try it

[`examples/book-tracker-intake/`](examples/book-tracker-intake/) holds two messy sample documents that partly contradict each other, which exercises conflict detection. The workflow moves the files it processes, so copy the example into a scratch project first:

```bash
mkdir -p my-test/projects/book-tracker/docs
cp -r idea-to-plan/both/. my-test/
cp -r idea-to-plan/examples/book-tracker-intake my-test/projects/book-tracker/docs/starting-notes
```

Open `my-test/` in your agent and run `/new-project @projects/book-tracker/docs/starting-notes`.

## Learn more

- [How it works](docs/how-it-works.md): each stage in detail, the question rounds, intake, the generated plan and the design rationale.
- [Contributing](CONTRIBUTING.md): repository layout and how to modify the workflow.

## License

[MIT](LICENSE)
