# Architecture Overview

This document explains the relationship between the two repositories and how they work together following the [superpowers](https://github.com/obra/superpowers) pattern.

## Two-Repository Architecture

### 1. llm-research-marketplace (This Repository)
**Purpose**: Monorepo marketplace containing multiple LLM research skills

**Structure**:
```
llm-research-marketplace/
├── .claude-plugin/
│   ├── marketplace.json      # Defines the marketplace
│   └── plugin.json          # Defines this as a plugin
├── skills/
│   └── research-memory.md   # Skill definition (copied from research-memory repo)
├── install.sh               # Installation script
└── README.md                # Main documentation
```

**Installation**:
- Users install ALL skills together from this marketplace
- Command: `claude plugin install llm-research@LLM-Research-Marketplace`
- Best for: Users who want the complete skills collection

### 2. research-memory (Separate Repository)
**Purpose**: Standalone skill with implementation

**Structure**:
```
research-memory/
├── .claude-plugin/
│   ├── marketplace.json      # Defines its own marketplace
│   └── plugin.json          # Defines itself as a plugin
├── skills/
│   └── research-memory.md   # Skill definition (source of truth)
├── handlers.py              # Python implementation
├── config/                  # Configuration files
├── .claude/                 # Claude Code settings
├── install.sh               # Installation script
└── README.md                # Detailed documentation
```

**Installation**:
- Users can install ONLY this skill standalone
- Command: `claude plugin install research-memory@research-memory-marketplace`
- Best for: Users who only need research-memory functionality

## How They Work Together

### Skill Synchronization

The `research-memory.md` file exists in both repositories:

1. **Source of Truth**: `research-memory/skills/research-memory.md`
   - Contains the skill definition with tools and documentation
   - Maintained and updated in the research-memory repository

2. **Marketplace Copy**: `llm-research-marketplace/skills/research-memory.md`
   - Copied from the source of truth
   - Updated when syncing the marketplace
   - Allows users to install from the marketplace

### Sync Process

When updating skills in the marketplace:

```bash
# Copy updated skill from research-memory to marketplace
cp /path/to/research-memory/skills/research-memory.md \
   /path/to/llm-research-marketplace/skills/

# Commit and push marketplace
cd llm-research-marketplace
git add skills/research-memory.md
git commit -m "Update research-memory skill"
git push
```

## Installation Patterns

### Pattern 1: Marketplace Installation (Recommended for Multiple Skills)

```bash
# One-command install all skills
curl -sSL https://raw.githubusercontent.com/syfyufei/llm-research-marketplace/main/install.sh | bash
```

**Pros**:
- Single command installs everything
- Easy to manage all skills together
- Automatic updates for all skills

**Cons**:
- Installs all skills even if you only need one

### Pattern 2: Individual Skill Installation

```bash
# Install only research-memory
curl -sSL https://raw.githubusercontent.com/syfyufei/research-memory/main/install.sh | bash
```

**Pros**:
- Minimal installation (only what you need)
- Direct access to skill-specific configuration
- Can use different versions per skill

**Cons**:
- Need to update each skill separately
- More management overhead for multiple skills

### Pattern 3: Local Development

```bash
# For marketplace development
cd /path/to/llm-research-marketplace
./install.sh

# For skill development
cd /path/to/research-memory
./install.sh
```

**Pros**:
- Test changes immediately
- Full control over configuration
- Can modify and iterate quickly

**Cons**:
- Requires local clones
- Manual sync between repositories

## File Relationships

### Marketplace Configuration Files

**llm-research-marketplace/.claude-plugin/marketplace.json**:
```json
{
  "name": "LLM-Research-Marketplace",
  "plugins": [
    {
      "name": "llm-research",
      "source": "./"
    }
  ]
}
```
- Defines the marketplace
- Points to the current directory as the plugin source

**llm-research-marketplace/.claude-plugin/plugin.json**:
```json
{
  "name": "llm-research",
  "description": "Collection of LLM research skills..."
}
```
- Defines the marketplace itself as a plugin
- Contains metadata for the skills collection

### Individual Skill Configuration Files

**research-memory/.claude-plugin/marketplace.json**:
```json
{
  "name": "research-memory-marketplace",
  "plugins": [
    {
      "name": "research-memory",
      "source": "./"
    }
  ]
}
```
- Allows research-memory to be installed standalone
- Independent marketplace for this skill only

**research-memory/.claude-plugin/plugin.json**:
```json
{
  "name": "research-memory",
  "description": "Academic research memory management..."
}
```
- Defines the skill as a standalone plugin
- Contains skill-specific metadata

## Adding New Skills

### Step 1: Create Skill Repository

1. Create a new repository (e.g., `new-skill`)
2. Structure like research-memory:
   ```
   new-skill/
   ├── .claude-plugin/
   │   ├── marketplace.json
   │   └── plugin.json
   ├── skills/
   │   └── new-skill.md
   ├── handlers.py (if needed)
   └── install.sh
   ```

### Step 2: Add to Marketplace

1. Copy skill definition:
   ```bash
   cp /path/to/new-skill/skills/new-skill.md \
      /path/to/llm-research-marketplace/skills/
   ```

2. Update marketplace README:
   - Add to "Available Skills" section
   - Document usage examples

3. Commit and push:
   ```bash
   cd llm-research-marketplace
   git add skills/new-skill.md README.md
   git commit -m "Add new-skill to marketplace"
   git push
   ```

### Step 3: Test Both Installation Methods

```bash
# Test marketplace installation
cd llm-research-marketplace
./install.sh

# Test standalone installation
cd new-skill
./install.sh
```

## Version Management

### Marketplace Versioning

Update version in `llm-research-marketplace/.claude-plugin/plugin.json`:
```json
{
  "version": "1.1.0"
}
```

### Individual Skill Versioning

Update version in `research-memory/.claude-plugin/plugin.json`:
```json
{
  "version": "0.3.0"
}
```

### Sync Strategy

1. Update skill in its repository
2. Bump skill version
3. Copy updated skill.md to marketplace
4. Optionally bump marketplace version
5. Test both installation methods

## Best Practices

1. **Single Source of Truth**: Always edit skills in their individual repositories
2. **Regular Syncs**: Copy updated skills to marketplace regularly
3. **Version Consistency**: Update versions when making changes
4. **Test Both Paths**: Verify both marketplace and standalone installation work
5. **Documentation**: Keep both README files up to date
6. **Git Tags**: Tag versions for easy rollback

## Future Extensibility

This architecture supports:
- Adding more skills to the marketplace
- Each skill maintaining its own repository
- Users choosing between marketplace or individual installation
- Independent versioning and updates
- Collaborative development on individual skills

## References

- Superpowers pattern: https://github.com/obra/superpowers
- Claude Code documentation: https://docs.anthropic.com/claude-code
- Individual skill repo: https://github.com/syfyufei/research-memory
