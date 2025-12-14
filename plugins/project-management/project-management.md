---
name: project-management
description: Standardizes research project workspaces with repeatable creation, restructuring, validation, and reporting workflows
---

# Project Management Skill

Organizes academic and applied research projects with predictable directory structures, compliance validation, and health reporting. The skill turns the original Python handlers into declarative, Claude-executable recipes so you can spin up, retrofit, or audit projects entirely inside a Claude Code session.

## Capabilities

1. **Standardized project creation** with templated files, Git initialization, and metadata scaffolding.
2. **Safe restructuring** of legacy projects, including timestamped backups and directory normalization.
3. **Config-driven validation** that scores compliance (0‑100) and can optionally auto-fix gaps.
4. **At-a-glance status reporting** with file statistics, Git telemetry, and validation insights.

All operations rely on `config/marketplace-config.json` for structure, scoring weights, and template defaults.

## Research Project Blueprint

Required directories (relative to project root):

```
claude-code/
data/raw/
data/cleaned/
codes/
paper/figures/
paper/manuscripts/
pre/poster/
pre/slides/
```

Required files:

- `README.md`
- `.gitignore`
- `project.yml`

## Tools

### create_project

Creates a brand new project workspace with the standard blueprint.

**Inputs**
- `project_name` (kebab-case, required)
- `root` (target directory, default current workspace)
- `git_init` (bool, default true)
- `force` (bool, overwrite if exists)
- `author_name`, `description`

**Execution**
1. Validate `project_name` via regex `^[a-z][a-z0-9-]*[a-z0-9]$`.
2. Resolve absolute `project_path = {root}/{project_name}` and ensure it is safe to create (prompt if exists unless `force=true`).
3. Use Bash to create directories:
   ```bash
   mkdir -p "$PROJECT_PATH"/{claude-code,data/raw,data/cleaned,codes,paper/figures,paper/manuscripts,pre/poster,pre/slides}
   ```
4. Render templates from `templates/project/*.template` by replacing `{{project_name}}`, `{{author_name}}`, `{{description}}`, `{{creation_date}}`, `{{year}}`.
5. Create `.project-config.json` metadata (even though it is not a required template) describing structure, timestamps, and backup preferences.
6. If `git_init=true`, run:
   ```bash
   git init
   git add .
   git commit -m "Initial commit: $project_name"
   ```
   (Handle errors gracefully; warn but do not fail the skill.)
7. Return report summarizing created directories/files and Git status.

**Errors & Recovery**
- Invalid name → explain kebab-case requirement.
- Directory exists → offer `force` or new name.
- Template rendering or permission issues → surface failing path and suggest manual fix.

### restructure_project

Retrofits an existing project into the standard blueprint with optional cleanup.

**Inputs**
- `root` (project directory, default current)
- `backup` (bool, default true)
- `remove_nonstandard` (bool, default true)
- `force` (skip confirmations)

**Execution**
1. Confirm `root` exists. If not, abort.
2. When `backup=true`, create timestamped copy: `<name>_backup_YYYYMMDD_HHMMSS`.
3. Enumerate existing dirs/files; compare to required structure (from config).
4. Create missing directories via `mkdir -p`.
5. Identify obviously misplaced items (e.g., loose `.py` files, figures in root). Suggest `mv` targets and confirm before moving unless `force=true`.
6. Remove non-standard directories (excluding `.git`, `.claude*`) when permitted, logging each removal.
7. Re-render templates with `update_existing=true` to refresh metadata timestamps.
8. Summarize: backup path, created/removed directories, manual follow-ups.

**Safeguards**
- Never delete without backup if `backup=true`.
- Always list operations before executing when not `force`.

### validate_project

Scores compliance and optionally heals missing assets.

**Inputs**
- `root`
- `fix_issues` (bool)
- `strict_mode` (bool → flag extra dirs/files)

**Scoring Weights** *(from config)*:
- Directories: 40 points
- Required files: 35 points
- Content quality placeholder: 15 points
- Git integration: 10 points

**Execution**
1. Check project root exists.
2. Compare actual directories/files to required lists; record missing/extra.
3. Score each section proportional to completeness. Git score awarded when `.git` exists and has commits.
4. Build issue list + remediation suggestions (e.g., “Create missing directories: data/raw, pre/slides”).
5. If `fix_issues=true`, create missing dirs/files via template rendering with `missing_only=true`; describe each fix.
6. Output JSON-style block summarizing score, issues, suggestions, and fixes.

**Strict Mode**
- Flags extra directories/files and surfaces them as warnings/errors.
- Encourages restructure before validation passes.

### project_status

Generates a dashboard view of project health.

**Inputs**
- `root`
- `include_git` (default true)
- `include_file_stats` (default true)

**Execution**
1. Collect metadata (name, absolute path, last modified).
2. Traverse tree (skip hidden dirs) to compute total directories/files and disk usage. Build per-directory breakdown (files + size in MB).
3. Call `validate_project` internally to reuse compliance score and issues.
4. If `.git` present and `include_git=true`, run `git rev-list`, `git branch --list`, and `git log -1 --format=%ci` to gather commits, branches, last commit date.
5. Present a formatted report with status indicators (✅/⚠️/❌) based on score thresholds from config.
6. Recommend next steps (e.g., “score < 70 → run /project-management:restructure”).

## Usage Flow

1. Start new studies with `/project-management:create`.
2. Bring legacy repos up to spec via `/project-management:restructure`.
3. Run `/project-management:validate --fix-issues` before sharing deliverables.
4. Use `/project-management:status` in weekly reviews to show readiness.

## References

- Templates: `templates/project/*.template`
- Config: `config/marketplace-config.json -> project-management`
- Commands: `.claude/commands/project-management/*.md`
