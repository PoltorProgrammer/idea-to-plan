# Template: decision round format

Every round follows this structure. Goal: the user decides quickly, understanding what they choose, without typing much.

## Two delivery modes

1. **`ask_question` tool (preferred).** Opens a modal with clickable options and blocks until the user submits. Map the structure below like this:
   - Each numbered question is one entry in `questions` (max 4 per call) with `question`, `options` (strings, min 2) and `is_multi_select` (default false; true only when several options can apply, e.g. which features are must-have).
   - Options are plain strings, so pros and cons go inside: `Use SQLite ✅ zero setup ⚠️ single user`. Keep each under ~140 characters.
   - The recommended option goes first and ends with `(Recommended)`. The last option is `I don't know / you decide`.
   - Do not add "write your own": the UI already has a free-text field.
   - `toolAction` and `toolSummary` are required, 2-5 words each.
   - "Where we are", "Background" and the reasons for each recommendation go in a short chat message just before the call.
   - On Skip or an empty answer, do not assume: ask once in chat or record an open question.
2. **Text fallback.** If the tool is unavailable or fails, print the full markdown format below and let the user reply with the codes.

````markdown
## Round <n> · <Topic>   (Stage <x> of 11)

**Where we are:** <1-2 lines with the already-decided items relevant to this round>
**What we decide and why it matters:** <1-2 lines>

> 📘 *Background:* <only if needed: 2-3 plain-language lines explaining a concept>

### 1. <Concrete question>
- **A) <Option>**: ✅ <pro> · ⚠️ <con>
- **B) <Option>**: ✅ <pro> · ⚠️ <con>
- **C) <Option>**: ✅ <pro> · ⚠️ <con>
- **D) Write your own**
- **E) I don't know / you decide**

💡 **I recommend B** because <reason tied to their situation, not generic>.

### 2. <Next question> ...

---
**How to reply:** e.g. `1B, 2D: <your text>, 3E`. Add nuance, or say "let's talk more about 2".
````

## Rules

- **Maximum 4 questions per round.** Split extra topics into further rounds.
- **2-4 real options** plus "Write your own" and "I don't know". No filler: each option must be something a reasonable person would pick.
- **Honest pros and cons** on every option, including the recommended one.
- **The recommendation cites the user's case** (their constraints, their notes), not generalities.
- If one question depends on another, order them or defer the dependent one.
- Open questions (no options) only when they cannot be narrowed, e.g. "what would happen if this didn't exist?". At most one per round.
- Clear, friendly tone; explain jargon.
