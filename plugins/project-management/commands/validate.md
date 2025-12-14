---
description: Validate a project directory, compute compliance score, and optionally auto-fix issues.
---

## Goal
Run `/project-management:validate` to ensure a project matches the standard blueprint and produce a scored report.

## Preparation
1. Ask for `root` path (default current).
2. Determine whether to `fix_issues` (y/n) and if `strict_mode` should flag extra directories/files.
3. Load scoring weights from `config/marketplace-config.json -> project-management.validation.scoring_weights`.

## Execution Steps
1. **Directory/File Scan**
   ```bash
   root="<abs path>"
   required_dirs=(claude-code data/raw data/cleaned codes paper/figures paper/manuscripts pre/poster pre/slides)
   required_files=(README.md .gitignore project.yml)
   ```
   - Capture missing and extra items (ignore `.git`, `.claude`, `.claude-plugin`, `__pycache__`).
2. **Score Calculation**
   - `dir_score = (required_dirs - missing_dirs)/required_dirs * 40`
   - `file_score = (required_files - missing_files)/required_files * 35`
   - `content_score = 15` if key files exist and non-empty else 0.
   - `git_score = 10` when `.git` exists and has commits (`git rev-list --count HEAD > 0`).
   - Total score = round sum to int.
3. **Issue List**
   - Missing directories/files.
   - Strict mode: list extras.
   - Empty or tiny files (<10 bytes) flagged for rewrite.
4. **Auto-Fix (optional)**
   When `fix_issues=true`, create missing directories and render templates with `missing_only=true` so existing files remain untouched. Document each fix.
5. **Report**
   Respond with:
   - Score out of 100 + qualitative tier (>=90 excellent, >=75 good, >=60 fair, else poor).
   - Table/bullets of missing vs. extra.
   - Fixes applied or pending.
   - Recommendations (e.g., “Initialize Git before sharing”).

## Error Handling
- Root missing → abort with helpful tip.
- If Git commands fail, treat as warning and continue scoring without Git points.
- When template rendering fails, include failing file path and leave instructions for manual creation.

## Example Reply
```
/Users/adrian/projects/causal-impact scored 82/100 (good)
Missing: pre/poster, README.md
Extras (strict): old-data/
Fixes: created pre/poster, generated README.md from template.
Recommendation: move raw datasets under data/raw and remove old-data after backup.
```
