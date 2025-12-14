---
description: Generate a comprehensive status report for a research project, combining structure stats, validation score, and Git telemetry.
---

## Goal
Produce `/project-management:status` output so the user can see readiness at a glance.

## Preparation
1. Ask for `root` path (default current).
2. Determine whether to include Git data (`include_git`, default true) and per-directory file stats (`include_file_stats`, default true).

## Execution
1. Confirm project exists. Collect `project_name=$(basename "$root")` and `last_modified` via `stat -f "%Sm"`.
2. Traverse directory tree (skip hidden) using `find` or `python - <<'PY' ...` to compute:
   - Total directory count
   - Total file count
   - Total size in MB (rounded to 0.1)
   - Optional breakdown: for each top-level directory, record file count + size.
3. Invoke `/project-management:validate` internally (or re-run the validation logic inline) to reuse compliance score and key issues.
4. If `.git` exists and `include_git=true`, gather:
   ```bash
   commits=$(git -C "$root" rev-list --count HEAD 2>/dev/null || echo 0)
   branches=$(git -C "$root" branch --list | wc -l | tr -d ' ')
   last_commit=$(git -C "$root" log -1 --format=%ci 2>/dev/null || echo "n/a")
   ```
   Handle detached HEAD gracefully.
5. Render a human-readable report:
   - Header: project name, path, last modified
   - Structure stats table
   - Compliance score with emoji indicator (>=90 ✅, 75-89 👍, 60-74 ⚠️, <60 ❌)
   - File breakdown (only if requested)
   - Git stats or warning if repo missing
   - Recommendations (e.g., “Score < 70 → run /project-management:restructure”)

## Error Handling
- Missing directory → respond with actionable message.
- `git` not installed or repo missing → show “Git data unavailable”.
- Traversal permission issues → skip and mention path.

## Example Reply
```
Status: /Users/adrian/projects/ablation-study (updated 2025-02-18 09:42)
Structure: 23 dirs, 178 files, 412.5 MB, compliance score 88/100 (👍)
Breakdown:
- data/: 94 files, 320.4 MB
- codes/: 28 files, 12.6 MB
Git: 42 commits across 3 branches, last commit 2025-02-17 22:10 UTC
Insights:
- Missing directory pre/poster. Create before conference prep.
- Consider validating again after migrating notebooks under codes/.
```
