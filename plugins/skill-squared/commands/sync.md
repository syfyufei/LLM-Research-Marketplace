---
description: Synchronize a standalone skill repository into the marketplace with optional dry-run and backups.
---

## Goal
Use `/skill-squared:sync` to copy the skill markdown + command files from a source repo into this marketplace safely.

## Inputs
- `source_dir` (standalone skill root)
- `target_dir` (usually this marketplace root)
- `skill_name` (auto-detect from plugin.json if omitted)
- `dry_run` (bool, default false)
- `backup` (bool, default true)

## Procedure
1. Validate both directories exist and contain the expected `.claude-plugin/plugin.json` files.
2. Determine `skill_name`:
   - If provided, trust it.
   - Else parse `.claude-plugin/plugin.json` for `"name"`.
3. Load sync config from `config/marketplace-config.json -> skill-squared.sync.files_to_sync` (defaults: `skills/{skill_name}.md` + `.claude/commands/`).
4. Build file list; show preview to the user and confirm unless `dry_run=false` with explicit approval.
5. For each file:
   - Ensure target subdirectory exists (e.g., `.claude/commands/skill-squared/` inside the marketplace).
   - If backup enabled and target file already exists, copy it to `<file>.backup.<timestamp>.md`.
   - Copy file when not `dry_run`; otherwise, log `[DRY RUN]` entry.
6. After copying, verify file sizes match (`stat -f "%z"`) and display summary counts: copied, skipped, backups.
7. Recommend running `/skill-squared:validate` on the marketplace copy to confirm success.

## Error Handling
- Missing source/target path → fail fast and show `ls` command to help locate.
- Dry-run flagged issues (e.g., missing commands dir) should block execution until resolved.
- If timestamp indicates target newer than source, warn and request confirmation before overwriting.
