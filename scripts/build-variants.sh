#!/usr/bin/env bash
# Regenerates antigravity/ and claude-code/ from both/ (the source of truth).
# Edit files under both/ (workflow and templates in both/.agents/, wrapper in
# both/.claude/commands/), then run:  bash scripts/build-variants.sh
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src="$root/both"
wf="$src/.agents/workflows/new-project.md"

[ -f "$wf" ] || { echo "source workflow not found: $wf" >&2; exit 1; }

rm -rf "$root/antigravity" "$root/claude-code"

# Antigravity only: .agents/
mkdir -p "$root/antigravity"
cp -r "$src/.agents" "$root/antigravity/"

# Claude Code only: self-contained skill in .claude/skills/new-project/
skill="$root/claude-code/.claude/skills/new-project"
mkdir -p "$skill"
cp -r "$src/.agents/templates" "$skill/templates"

desc="$(grep -m1 '^description:' "$wf" | sed 's/^description:[[:space:]]*//' | tr -d '\r')"
[ -n "$desc" ] || { echo "description not found in workflow frontmatter" >&2; exit 1; }
grep -q '^## Input' "$wf" || { echo '"## Input" section not found in workflow' >&2; exit 1; }

input_line='The input for this run (intake folder or file, and optional flags): $ARGUMENTS'
{
  printf -- '---\nname: new-project\ndescription: %s\nargument-hint: @projects/<name>/docs/00-intake [quick]\ndisable-model-invocation: true\n---\n' "$desc"
  tr -d '\r' < "$wf" \
    | awk '/^---$/ && c<2 {c++; next} c>=2' \
    | sed 's#\.agents/templates/#.claude/skills/new-project/templates/#g' \
    | awk -v l="$input_line" '{print} /^## Input$/ {print ""; print l}'
} > "$skill/SKILL.md"

echo "Rebuilt: antigravity/ and claude-code/ (from both/)"
