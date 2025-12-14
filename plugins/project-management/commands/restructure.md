---
description: Restructure an existing project into the standard directory/file blueprint with backups.
---

## Goal
Upgrade an existing project to the canonical layout while preserving data by creating a timestamped backup and normalizing directories.

## Preparation
1. Gather `root` (project path), `backup` (default true), `remove_nonstandard` (default true), and `force` flags.
2. Verify the directory exists via `ls "$root"`; abort with actionable error if missing.
3. Load required directories/files from `config/marketplace-config.json -> project-management.standard_structure`.

## Execution
1. **Backup (if enabled)**
   ```bash
   if [ "$backup" = "true" ]; then
     ts=$(date +%Y%m%d_%H%M%S)
     backup_dir="$(dirname "$root")/$(basename "$root")_backup_$ts"
     cp -R "$root" "$backup_dir"
   fi
   ```
   Report backup path.
2. **Create missing directories**
   Loop through required list and run `mkdir -p "$root/$dir"` while tracking which ones were added.
3. **Suggest file moves**
   - Scan top-level items (excluding `.git`, `.claude*`).
   - For loose `.py`/`.ipynb`, suggest moving into `codes/`.
   - For figures (`*.png`, `*.svg`, `*.pdf`), suggest `paper/figures/`.
   Confirm before moving unless `force=true`.
4. **Remove non-standard directories** when permitted:
   ```bash
   if [ "$remove_nonstandard" = "true" ]; then
     # list directories not in required set + allowed hidden ones
   fi
   ```
   Always log deletions; skip if uncertain.
5. **Refresh templates**
   Re-render README, `.gitignore`, `project.yml`, `.project-config.json` using `update_existing=true` semantics (overwrite while keeping backups). Mention fields updated (e.g., restructure date).
6. **Report**
   Summarize backup, created dirs, removed dirs, files moved, and manual follow-ups.

## Error Handling
- If copy fails due to permissions, warn and confirm whether to continue without backup.
- If user declines destructive step, skip and note outstanding work.
- Keep backups until user deletes them.

## Example Reply
```
Restructured ~/projects/ablation-study
- Backup: ~/projects/ablation-study_backup_20250214_103255
- Created dirs: paper/manuscripts, pre/poster
- Moved scripts -> codes/, PNGs -> paper/figures/
- Removed non-standard dir: old-notes/
Templates refreshed with restructure date 2025-02-14.
Next: run /project-management:validate to confirm compliance.
```
