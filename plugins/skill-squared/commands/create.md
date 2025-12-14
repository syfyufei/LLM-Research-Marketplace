---
description: Create a brand new Claude Code skill repository with templates, metadata, and executable install script.
---

## Goal
Use `/skill-squared:create` to scaffold a complete skill project from scratch.

## Workflow
1. Gather required inputs:
   - `skill_name` (kebab-case)
   - `skill_description`
   - `author_name`
   - `author_email`
   - `github_user`
   - Optional `target_dir` (defaults to current)
   - Optional `version` (default `0.1.0`)
2. Validate:
   - Name matches `^[a-z0-9]+(-[a-z0-9]+)*$`
   - Email contains `@`
   - Target directory is writable and destination folder does not already exist (prompt for overwrite only if user insists).
3. Create directory skeleton inside `$TARGET/$skill_name`:
   ```
   .claude-plugin/
   .claude/commands/
   skills/
   handlers/
   templates/skill/
   templates/command/
   config/
   docs/
   ```
4. Render templates from `templates/skill/*.template` (inside this marketplace) using env substitution:
   ```bash
   export SKILL_NAME=...
   export SKILL_DESCRIPTION=...
   export AUTHOR_NAME=...
   export AUTHOR_EMAIL=...
   export GITHUB_USER=...
   export VERSION=...
   export CREATED_DATE=$(date +%Y-%m-%d)
   envsubst < templates/skill/plugin.json.template > "$SKILL_PATH/.claude-plugin/plugin.json"
   # repeat for marketplace.json, skill.md, README.md, install.sh, CLAUDE.md
   ```
5. Copy `.gitignore` and `LICENSE` contents (use MIT license text with current year + author).
6. Make install script executable: `chmod +x "$SKILL_PATH/install.sh"`.
7. Output summary table:
   - Root path
   - Directories created
   - Files rendered
   - Reminder to run `./install.sh` from inside the new skill.

## Error Handling
- If directory exists, stop unless the user explicitly confirms `force`.
- Missing templates → point to `templates/skill/` and suggest running `/skill-squared:sync` to refresh.
- Template render failure → include variable name causing the issue and reference docs/skill-squared.md for valid placeholders.
