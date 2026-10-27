# Template: `docs/` folder

Documentation **for humans** (the user, collaborators, newcomers). Generated in stage 9 from `process/state.md` and the rounds. Lives in `<project>/docs/`. It describes what is wanted and why; the executable how goes in `dev-plan/`.

## Files to generate

```
docs/
├── README.md                    index and reading guide
├── 00-intake/                   already exists from stage 1 (original/ + formalized/); do not modify, only link to it
├── 01-vision-and-goals.md
├── 02-scope.md
├── 03-requirements.md
├── 04-phases-and-timeline.md
├── 05-approach-and-tools.md
├── 06-human-agent-split.md
├── 07-risks-and-assumptions.md
└── 08-decisions.md
```

For very small projects, merge files instead of creating near-empty documents. For domains without "requirements" in the technical sense, rename (e.g. "deliverables").

## Content of each file

**README.md**: project name, 3-line summary, status and date, index with relative links.

**01-vision-and-goals.md**: problem, for whom, value proposition (1-2 paragraphs), motivation, measurable success criteria, specific goals (3-5).

**02-scope.md**: in scope; out of scope (non-goals with reasons); constraints (time, money, people, legal); external dependencies.

**03-requirements.md**: numbered list with ID (`R-001`...), description, priority (must / should / later), phase it enters, acceptance criterion. Include relevant non-functional requirements (performance, privacy, accessibility, cost).

**04-phases-and-timeline.md**: per phase: objective, observable deliverable, acceptance criterion, duration estimate, requirement IDs covered, review point. Summary table with dates or relative weeks. What is postponed.

**05-approach-and-tools.md**: choice per layer or area, discarded alternatives and why, estimated cost. High-level diagram (ASCII or Mermaid) if it helps.

**06-human-agent-split.md**: table "agent does" / "human does" per phase, with the reason for each human task (2FA, payment, physical test, business decision). Agreed review frequency and actions the agent never takes without permission.

**07-risks-and-assumptions.md**: risk table (likelihood, impact, mitigation) and assumptions with how to validate each.

**08-decisions.md**: decision log (ID, topic, decision, alternatives considered, reason, date, status: decided/assumption/deferred/discarded). Comes from the state file.

## Quality criteria

- Clear language; define jargon.
- Every requirement is verifiable.
- No claim without backing in the notes or a logged decision; assumptions are labeled.
- Relative links between documents.
- No secrets or sensitive data.
