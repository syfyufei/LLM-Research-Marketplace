#!/bin/bash

set -euo pipefail

VERSION="2.1.0" # Updated version for new structure
REPO_ROOT=$(cd "$(dirname "$0")" && pwd)
TARGET_DIR=${TARGET:-}
MARKETPLACE_NAME="LLM-Research-Marketplace"
SKILL_NAMES=("research-memory" "project-management" "skill-squared")

copy_dir_contents() {
  local src="$1"
  local dest="$2"
  mkdir -p "$dest"
  if [ -d "$src" ]; then
    cp -R "$src/." "$dest/"
  fi
}

# Simplified manual installation for the new structure
if [ -n "$TARGET_DIR" ]; then
  echo "Installing $MARKETPLACE_NAME v$VERSION into $TARGET_DIR"
  
  # Copy the marketplace definition and the plugins themselves
  copy_dir_contents "$REPO_ROOT/.claude-plugin" "$TARGET_DIR/.claude-plugin"
  copy_dir_contents "$REPO_ROOT/plugins" "$TARGET_DIR/plugins"

  # Copy shared resources
  copy_dir_contents "$REPO_ROOT/templates" "$TARGET_DIR/templates"
  copy_dir_contents "$REPO_ROOT/config" "$TARGET_DIR/config"
  copy_dir_contents "$REPO_ROOT/docs" "$TARGET_DIR/docs"

  echo "✓ Deployed marketplace files."
  echo "Next: Manually add '$TARGET_DIR' to your Claude marketplaces."
  exit 0
fi

# Standard installation using claude CLI
if ! command -v claude >/dev/null 2>&1; then
  echo "Error: claude CLI not found in PATH. Install Claude Code CLI or set TARGET to deploy manually." >&2
  exit 1
fi

echo "Adding LLM Research Marketplace v$VERSION from local checkout..."
claude plugin marketplace add "$REPO_ROOT"

cat <<MSG

✓ Added $MARKETPLACE_NAME to your Claude marketplaces.

You can now install the available skills. For example:

  /plugin install research-memory@$MARKETPLACE_NAME
  /plugin install project-management@$MARKETPLACE_NAME
  /plugin install skill-squared@$MARKETPLACE_NAME

Verify available plugins with:
  /plugin marketplace search $MARKETPLACE_NAME

MSG
