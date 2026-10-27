# Template: repository preparation

Applied in stage 10. Create files in the project folder `<project>` (its root, which is the future repository root). **Do not run `git init`, `commit` or `push` unless the user asks.**

## Files

### `README.md` (of the project)

```markdown
# <Project name>

<1-2 sentence summary: what it is and for whom.>

## Status
<Current phase and date. E.g. "Planning complete; phase 00 pending".>

## Documentation
- [Project documentation](docs/README.md)
- [Development plan for agents](dev-plan/README.md)

## Getting started
<Prerequisites, installation and run. If there is no code yet: "See dev-plan/phase-00-setup.md".>

## Configuration
Copy `.env.example` to `.env` and fill it in. **Never** commit `.env`.

## Structure
<Short tree of the main folders: docs/ (with 00-intake/), dev-plan/, process/ and, once built, the code folders.>

## License
<Chosen license or "To be defined".>
```

### `.gitignore`

Common base (always):

```gitignore
# Secrets and local config
.env
.env.*
!.env.example
*.pem
*.key
secrets/

# OS and editors
.DS_Store
Thumbs.db
.idea/
.vscode/
*.swp

# Logs and temp
*.log
tmp/
.cache/
```

Add blocks for the approach chosen in stage 5, for example:

- **Node/TypeScript:** `node_modules/`, `dist/`, `build/`, `coverage/`, `.next/`
- **Python:** `__pycache__/`, `*.pyc`, `.venv/`, `venv/`, `.pytest_cache/`, `.mypy_cache/`, `*.egg-info/`
- **Java/Kotlin:** `target/`, `build/`, `.gradle/`, `*.class`
- **Go/Rust:** `bin/`, `target/` (Rust)
- **Heavy data and models:** `data/raw/`, `*.sqlite`, `*.db` (if they should not be versioned)
- **This process's state and sources:** `process/` is useful history; version it. **Ask** whether `docs/00-intake/original/` is versioned: it holds the user's raw files and may contain personal or sensitive data (check `formalized/index.md` for flags). If in doubt, ignore it.

Do not ignore `docs/` or `dev-plan/`.

### `.env.example`

Only if the project uses credentials or sensitive configuration. One variable per line with an **empty or dummy value** and a comment saying what it is for, where to get it and whether it is required:

```dotenv
# API key for <service>. Get it at <console URL>. Required.
SERVICE_API_KEY=
```

### License

**Ask the user** (using the round format) which license they want, explaining the differences in plain language. Usual options: MIT (very permissive), Apache-2.0 (permissive with patent grant), GPL-3.0 (copyleft), or none / "all rights reserved" if private. Create `LICENSE` only after they answer.

### Optional (suggest, do not impose)

- `CONTRIBUTING.md` if there will be collaborators.
- `.editorconfig` for consistent formatting.
- Issue/PR templates if hosted on GitHub.
- An `AGENTS.md` or rules file mirroring the plan's global rules, if the user works with agents in this repo.

## Commands to offer (do not run)

```bash
git init
git add .
git commit -m "Initial project planning"
git branch -M main
git remote add origin <repository-URL>
git push -u origin main
```

Before the first commit, remind the user to run `git status` and confirm `.env` and any secret do **not** appear.
