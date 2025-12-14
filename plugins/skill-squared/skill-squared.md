---
name: skill-squared
description: Meta-skill for creating, extending, syncing, and validating Claude Code skills using declarative tool workflows
---

# Skill-Squared

Skill-Squared turns the standalone Python automation for managing Claude Code skills into markdown instructions that Claude can execute directly using Read/Write/Edit/Bash. Use it whenever you need to bootstrap a new skill, add slash commands, synchronize into a marketplace, or audit compliance.

## Capabilities

1. **Create** end-to-end skill repositories with templated marketplace files and boilerplate documentation.
2. **Command**: append new slash commands with consistent frontmatter and plugin registration.
3. **Sync** skill artifacts from standalone repos into this marketplace with optional dry-run + backups.
4. **Validate** skill structure/content for readiness before publishing.

## Tool Reference

### create_skill

**Purpose**: Generate a new Claude Code skill scaffold.

**Inputs**
- `skill_name` (kebab-case), `skill_description`
- `author_name`, `author_email`, `github_user`
- `target_dir` (default current)
- `version` (default 0.1.0)

**Steps**
1. Validate inputs (non-empty, kebab-case, email contains `@`).
2. Create `$TARGET/$skill_name` and nested directories:
   ```
   .claude-plugin/
   .claude/commands/
   skills/
   handlers/
   templates/{skill,command}/
   config/
   docs/
   ```
3. Render templates from `templates/skill/*.template` using context variables above plus derived values:
   - `display_name` → title case (e.g., `data-orbit` → `Data Orbit`)
   - `repository_url` → `https://github.com/{github_user}/{skill_name}`
   - `created_date` → `$(date +%Y-%m-%d)`
4. Files to render:
   - `.claude-plugin/plugin.json` & `marketplace.json`
   - `skills/{skill_name}.md`
   - `README.md`
   - `.claude/CLAUDE.md`
   - `install.sh`
5. Create `.gitignore` inline (use template from source repo) and MIT `LICENSE` with current year.
6. `chmod +x install.sh`.
7. Print table of created files + follow-up instructions (“run ./install.sh inside Claude to load the skill”).

### add_command

**Purpose**: Add new slash command to an existing skill repo.

**Inputs**
- `skill_dir`
- `command_name` (kebab-case), `command_description`
- Optional `command_instructions`

**Steps**
1. Validate `skill_dir` exists and contains `.claude-plugin/plugin.json`.
2. Ensure `.claude/commands/` exists, creating if necessary.
3. Confirm the command does not already exist.
4. Generate `.claude/commands/{command_name}.md` from `templates/skill/command.md.template`, injecting:
   - YAML frontmatter `description`
   - Command title derived from command name
   - Body instructions (defaults to “Use the skill to handle …” if not provided)
5. Update `.claude-plugin/plugin.json` by appending `./.claude/commands/{command_name}.md` to the `commands` array (create array if missing). Preserve JSON formatting.
6. Respond with new command path and remind the user to reinstall.

### sync_skill

**Purpose**: Mirror skill files from a standalone repo into the marketplace.

**Inputs**
- `source_dir`, `target_dir`
- `skill_name` (auto-detect from plugin.json when omitted)
- `dry_run` (default false), `backup` (default true)

**Steps**
1. Validate directories exist and contain the expected files.
2. Load sync config from `config/marketplace-config.json -> skill-squared.sync.files_to_sync`.
3. Build file list (skill definition plus `.claude/commands/` folder).
4. For each target file:
   - If backup enabled and file exists, copy to `${file}.backup.<timestamp>.md`.
   - Copy (or simulate copy when `dry_run=true`) from source to target.
5. Produce summary showing copies, skips, and backup locations.
6. Warn if target file is newer (compare timestamps) and request confirmation before overwriting unless forced.

### validate_skill

**Purpose**: Check that a skill repository satisfies publishing requirements.

**Inputs**
- `skill_dir`
- Optional `skill_name`
- `strict` flag (optional) for additional linting

**Checks**
1. Required files exist (`.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `skills/{skill}.md`, `README.md`, `LICENSE`, `install.sh`).
2. JSON files parse correctly.
3. Skill + command files contain YAML frontmatter with `name`/`description`.
4. `install.sh` is executable.
5. Provide summary lists (`errors`, `warnings`, `info`) plus actionable remediation steps.

**Output**
- `valid` boolean
- Detailed arrays of findings
- Next-step recommendations (e.g., “Missing .claude/commands directory, run /skill-squared:command to add one”)

## Usage Tips

- Use `/skill-squared:create` when starting a new public skill before syncing into this marketplace.
- After editing handlers locally, run `/skill-squared:validate` to ensure metadata stays compliant.
- `/skill-squared:sync` supports `dry_run` so you can preview copies before touching marketplace files.
- Keep template files up to date; both create and add_command rely on them for consistent scaffolding.
