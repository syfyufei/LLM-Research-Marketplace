---
description: Create a standardized research project workspace with templates, Git init, and metadata.
---

## Goal
Guide the user through `/project-management:create` to spin up a new project directory following the standard blueprint.

## Preparation
1. Collect parameters (ask concise follow-up questions if missing):
   - `project_name` (kebab-case, required)
   - `root` directory (default current workspace)
   - `git_init` (y/n, default yes)
   - `author_name` (default from config)
   - `description`
   - `force` overwrite flag if directory already exists
2. Validate project name against regex `^[a-z][a-z0-9-]*[a-z0-9]$`. Reject uppercase, underscores, or trailing hyphens.
3. Determine `PROJECT_PATH="$ROOT/$project_name"` and confirm with the user before creating anything when `force` not provided.

## Execution Steps
1. **Create directories**
   ```bash
   PROJECT_PATH="<abs path>"
   mkdir -p "$PROJECT_PATH"/{claude-code,data/raw,data/cleaned,codes,paper/figures,paper/manuscripts,pre/poster,pre/slides}
   ```
   Mention any pre-existing directories that were reused.
2. **Render templates** using values:
   - `creation_date=$(date +%Y-%m-%d)`
   - `year=$(date +%Y)`
   Copy from `templates/project/*.template`:
   ```bash
   env PROJECT_NAME="..." AUTHOR_NAME="..." DESCRIPTION="..." CREATION_DATE="$creation_date" YEAR="$year" \
     envsubst < templates/project/README.md.template > "$PROJECT_PATH/README.md"
   ```
   Repeat for `.gitignore` and `project.yml`. Also write `.project-config.json` matching the template in `skills/project-management.md`.
3. **Git initialization**
   ```bash
   if [ "$git_init" = "true" ]; then
     (cd "$PROJECT_PATH" && git init && git add . && git commit -m "Initial commit: $project_name")
   fi
   ```
   If Git commands fail, capture stderr and report as warning, not fatal.
4. **Summary**
   Respond with:
   - Absolute project path
   - Directories created
   - Files generated
   - Git initialization status
   - Suggested next steps (e.g., “open README.md and update problem statement”)

## Error Handling
- Directory already exists → offer `force` or alternative name.
- Missing template or permission issue → stop and show exact path plus remediation idea.
- Invalid project name → repeat regex hint.

## Example Reply
```
Created /Users/adrian/research/causal-impact
- Directories: claude-code, data/raw, data/cleaned, ...
- Files: README.md, .gitignore, project.yml, .project-config.json
Git repo initialized with initial commit.
Next: document hypotheses inside README.md and add datasets under data/raw/.
```
