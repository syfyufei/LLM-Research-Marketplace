---
description: Validate a skill repository for required files, JSON structure, frontmatter, and executable permissions.
---

## Goal
Run `/skill-squared:validate` on a skill directory (standalone or marketplace) to ensure it meets publishing requirements.

## Inputs
- `skill_dir`
- Optional `skill_name`
- `strict` flag (optional) for additional linting

## Steps
1. Confirm directory exists. If `skill_name` omitted, auto-detect by reading `.claude-plugin/plugin.json` or the lone file inside `skills/`.
2. Load validation config from `config/marketplace-config.json -> skill-squared.validation`.
3. **Required files**: iterate through configured patterns (expand `{skill_name}`) and ensure each exists. Record missing items as errors.
4. **JSON validation**: run `jq empty` (or `python -m json.tool`) on `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`.
5. **Frontmatter checks**:
   - Parse YAML blocks (between `---` lines) for `skills/{skill}.md`.
   - Iterate `.claude/commands/*.md`; ensure `description` present.
6. **Executable files**: verify `install.sh` has executable bit (`[ -x install.sh ]`).
7. Compile findings into categories:
   - `errors`
   - `warnings`
   - `info`
   Provide actionable suggestions for each.
8. Return pass/fail message plus summary table (e.g., “3 errors, 1 warning”). Encourage rerunning after fixes.

## Error Handling
- If YAML/frontmatter missing, highlight file and provide snippet example.
- If JSON parse fails, show `jq` stderr to guide fixes.
- When permissions insufficient, suggest `chmod +x install.sh`.
