# LLM Research Marketplace

LLM Research Marketplace is a curated collection of three independent Claude Code skills: `research-memory`, `project-management`, and `skill-squared`. Instead of a single large plugin, this repository acts as a marketplace, allowing you to install only the skills you need.

## Marketplace Snapshot

| Skill | Version | Purpose | Commands |
| --- | --- | --- | --- |
| research-memory | 0.2.0 | Academic research memory management | 10 |
| project-management | 0.1.0 | Standardized project scaffolding & validation | 4 |
| skill-squared | 0.1.0 | Skill creation, extension, and validation | 4 |

Total commands available: **18**

## Installation

First, add the repository as a new marketplace. You can do this by running the local script or by adding it manually within Claude Code.

**Option A: Run the script**
```bash
./install.sh
```
This will add the local directory as a marketplace named `LLM-Research-Marketplace`.

**Option B: Manual Install**
```bash
/plugin marketplace add https://github.com/syfyufei/llm-research-marketplace
```

### Install Individual Skills

Once the marketplace is added, you can search for and install the skills you want:

```bash
# See what's available
/plugin marketplace search LLM-Research-Marketplace

# Install one or more skills
/plugin install research-memory@LLM-Research-Marketplace
/plugin install project-management@LLM-Research-Marketplace
/plugin install skill-squared@LLM-Research-Marketplace
```

### Verify Installation

Check your installed plugins:
```bash
/plugin list
```
If you installed all three, the output should show `research-memory`, `project-management`, and `skill-squared`.

## Quick Start Workflow

1. **Install the skills you need** – See the Installation section above.
2. **Create a project workspace** – `/project-management:create` scaffolds directories and templates.
3. **Track research progress** – `/research-memory:bootstrap` and `/research-memory:remember` manage development logs.
4. **Build new skills** – `/skill-squared:create` scaffolds a new, standalone Claude Code skill.

## Directory Layout

The repository is now structured as a marketplace containing multiple plugins.

```
llm-research-marketplace/
├── .claude-plugin/
│   └── marketplace.json      # Defines the marketplace and points to the plugins
├── plugins/
│   ├── research-memory/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json   # Defines the 'research-memory' plugin
│   │   ├── commands/         # 10 command files
│   │   └── research-memory.md
│   ├── project-management/
│   │   └── ...               # Structure for 'project-management' plugin
│   └── skill-squared/
│       └── ...               # Structure for 'skill-squared' plugin
├── templates/
│   ├── project/
│   └── skill/
├── config/
│   └── marketplace-config.json
├── docs/
│   ├── research-memory.md
│   ├── project-management.md
│   └── skill-squared.md
├── install.sh
└── README.md
```

## Management Commands

Manage each skill individually.

```bash
# List installed plugins
/plugin list

# Update a specific skill to its latest version
/plugin update research-memory

# Remove a skill you no longer need
/plugin uninstall project-management
```

## Development Notes

- Source repositories remain available for deep development:
  - `/Users/adriansun/Documents/GitHub/research-memory`
  - `/Users/adriansun/Documents/GitHub/project-management`
  - `/Users/adriansun/Documents/GitHub/skill-squared`
- Sync changes into this marketplace with `/skill-squared:sync` to keep the unified plugin current.

## License

MIT License applies to the marketplace and all included skills.
