---
description: Add a new slash command to an existing skill and update plugin metadata.
---

## Goal
Execute `/skill-squared:command` so the user gains a new `.claude/commands/<name>.md` in their skill repo and the plugin manifest references it.

## Steps
1. Collect:
   - `skill_dir` (absolute path to skill root)
   - `command_name` (kebab-case)
   - `command_description`
   - Optional `command_instructions`
2. Validate:
   - `skill_dir` contains `.claude-plugin/plugin.json`
   - Command name not already present in `.claude/commands/`
   - Plugin JSON is valid.
3. Ensure `.claude/commands/` folder exists: `mkdir -p "$skill_dir/.claude/commands"`.
4. Render command file using `templates/skill/command.md.template`. Variables:
   - `command_name`
   - `command_title` (title case)
   - `command_description`
   - `command_instructions` (fallback to default sentence when empty)
5. Append command path to plugin manifest:
   ```bash
   jq '.commands += ["./.claude/commands/'"$command_name"'.md"]' \
     "$skill_dir/.claude-plugin/plugin.json" > /tmp/plugin.json && \
   mv /tmp/plugin.json "$skill_dir/.claude-plugin/plugin.json"
   ```
   If the `commands` array is missing, initialize it.
6. Respond with success message including the relative command path and reminder to reinstall the skill.

## Error Handling
- Directory missing → explain expected structure.
- Invalid command name → show kebab-case example.
- JSON update failure → keep created command file but warn user to manually register it.
