# Adrian Skills

A curated collection of Claude Code skills for research and development workflows, following the [superpowers](https://github.com/obra/superpowers) marketplace pattern.

## Available Skills

### research-memory
Academic research memory management skill for tracking project continuity, decisions, and experiments across sessions.

**Features:**
- Session Bootstrap: Quickly restore project state and recent progress
- Session Logging: Document research activities with structured phase segmentation
- Historical Query: Search past decisions, experiments, and insights

**Usage:**

Core commands:
```bash
/research-memory:bootstrap    # Restore project context
/research-memory:status       # Quick status overview
/research-memory:remember     # Remember current session
/research-memory:query        # Search history
```

Analysis & reporting:
```bash
/research-memory:timeline     # Show project timeline
/research-memory:summary      # Generate full summary
/research-memory:review       # Review time period
/research-memory:insights     # Get AI insights
/research-memory:checkpoint   # Create checkpoint
```

Natural language:
```
"Research Memory, help me get back up to speed with my project"
"Show me a quick status"
"Remember this work session"
"Generate a project summary for my weekly meeting"
```

## Installation

In Claude Code, register the marketplace first:

```bash
/plugin marketplace add syfyufei/adrian-marketplace
```

Then install the plugin from this marketplace:

```bash
/plugin install adrian-skills@adrian-skills-marketplace
```

### Verify Installation

Check that commands appear:

```bash
/help
```

```
# Should see 9 commands:
# /research-memory:bootstrap - Restore project context and generate work plan
# /research-memory:status - Quick project status overview
# /research-memory:remember - Remember current work session
# /research-memory:query - Query research memory history
# /research-memory:timeline - Visualize project timeline
# /research-memory:summary - Generate comprehensive project summary
# /research-memory:review - Review work in a specific time period
# /research-memory:insights - Get AI-powered insights and suggestions
# /research-memory:checkpoint - Create a named checkpoint of current state
```

All skills will be available for use immediately via slash commands or natural language.

## Structure

This is a monorepo following the superpowers pattern:

```
adrian-marketplace/
├── .claude-plugin/
│   ├── marketplace.json      # Marketplace definition
│   └── plugin.json          # Plugin metadata
├── skills/
│   └── research-memory.md   # Research memory skill
├── install.sh               # Installation script
└── README.md                # This file
```

## Adding New Skills

To add new skills to this marketplace:

1. Create a new `.md` file in the `skills/` directory
2. Follow the skill format with frontmatter:
   ```markdown
   ---
   name: skill-name
   description: Skill description
   ---
   # Skill documentation...
   ```
3. Update this README to list the new skill
4. Commit and push to GitHub

## Individual Skill Repositories

For development and standalone installation, each skill has its own repository:

- **research-memory**: [syfyufei/research-memory](https://github.com/syfyufei/research-memory)

Users can install skills either:
- From this marketplace (all skills together)
- From individual repositories (single skill)

## Usage

After installation, skills are automatically available in Claude Code sessions. Simply use natural language to trigger them:

```
"Research Memory, bootstrap my project context"
"Log this session to research memory"
```

## Management Commands

```bash
# List installed plugins
claude plugin list

# Update to latest version
claude plugin update adrian-skills

# Uninstall
claude plugin uninstall adrian-skills
```

## Contributing

This is a personal skills collection. Skills are curated and tested before inclusion.

## Documentation

- **[USAGE.md](USAGE.md)**: Detailed usage guide, verification, and troubleshooting
- **[ARCHITECTURE.md](ARCHITECTURE.md)**: System architecture and relationship with individual skill repositories

## License

MIT License. Individual skills may have their own licenses.