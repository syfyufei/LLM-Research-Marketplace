# LLM Research Marketplace

LLM Research Marketplace is a curated collection of five independent Claude Code skills: `research-memory`, `project-management`, `skill-squared`, `truth-verification`, and `academic-figures`. Instead of a single large plugin, this repository acts as a marketplace, allowing you to install only the skills you need.

## Marketplace Snapshot

| Skill | Version | Purpose | Commands |
| --- | --- | --- | --- |
| research-memory | 0.2.0 | Academic research memory management | 10 |
| project-management | 0.1.0 | Standardized project scaffolding & validation | 4 |
| skill-squared | 0.1.0 | Skill creation, extension, and validation | 4 |
| truth-verification | 1.0.0 | Research integrity & data provenance tracking | 8 |
| academic-figures | 0.1.0 | Publication-ready figures with grayscale & Chinese support | 6 |

Total commands available: **32**

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

### Install All Skills

```bash
/plugin install research-memory@LLM-Research-Marketplace
/plugin install project-management@LLM-Research-Marketplace
/plugin install skill-squared@LLM-Research-Marketplace
/plugin install truth-verification@LLM-Research-Marketplace
/plugin install academic-figures@LLM-Research-Marketplace
```

### Verify Installation

Check your installed plugins:
```bash
/plugin list
```
If you installed all five, the output should show `research-memory`, `project-management`, `skill-squared`, `truth-verification`, and `academic-figures`.

## Quick Start Workflow

1. **Install the skills you need** – See the Installation section above.
2. **Ensure research integrity** – `/truth-verification:init` and `/truth-verification:register` establish data provenance tracking.
3. **Create a project workspace** – `/project-management:create` scaffolds directories and templates.
4. **Track research progress** – `/research-memory:bootstrap` and `/research-memory:remember` manage development logs.
5. **Generate publication figures** – `/academic-figures:line`, `/academic-figures:bar`, `/academic-figures:dotwhisker` create grayscale charts.
6. **Build new skills** – `/skill-squared:create` scaffolds a new, standalone Claude Code skill.

## Directory Layout

The repository is now structured as a marketplace containing multiple plugins.

```
llm-research-marketplace/
├── .claude-plugin/
│   └── marketplace.json              # Marketplace definition with 5 plugins
├── plugins/
│   ├── research-memory/
│   │   ├── .claude-plugin/plugin.json
│   │   ├── commands/                 # 10 command files
│   │   ├── config/config.json
│   │   ├── docs/
│   │   └── research-memory.md
│   ├── project-management/
│   │   ├── .claude-plugin/plugin.json
│   │   ├── commands/                 # 4 command files
│   │   ├── templates/project/        # Bundled templates
│   │   ├── config/config.json
│   │   ├── docs/
│   │   └── project-management.md
│   ├── skill-squared/
│   │   ├── .claude-plugin/plugin.json
│   │   ├── commands/                 # 4 command files
│   │   ├── templates/skill/          # Bundled templates
│   │   ├── config/config.json
│   │   ├── docs/
│   │   └── skill-squared.md
│   ├── truth-verification/
│   │   ├── .claude-plugin/plugin.json
│   │   ├── commands/                 # 8 command files
│   │   ├── templates/truth/          # Bundled templates
│   │   ├── config/config.json
│   │   ├── docs/
│   │   ├── README.md
│   │   └── truth-verification.md
│   └── academic-figures/
│       ├── .claude-plugin/plugin.json
│       ├── commands/                 # 6 command files
│       ├── templates/python/         # Python code templates
│       ├── config/config.json
│       ├── docs/
│       ├── README.md
│       └── academic-figures.md
├── docs/                             # Marketplace-level docs
├── install.sh
├── ARCHITECTURE.md
├── CLAUDE.md
├── AGENTS.md
├── USAGE.md
├── TRUTH_VERIFICATION_TEST_PLAN.md
├── TRUTH_VERIFICATION_COMPLETION_SUMMARY.md
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

## Skill Overview

### truth-verification (v1.0.0) - NEW! 🔐
Research integrity and data provenance tracking. Ensures all data analysis and paper writing are based on real data, preventing AI hallucinations.
- **8 commands** for tracking data, verifying integrity, checking reproducibility, and generating audit reports
- SHA256 cryptographic hashing for all files
- Reproducibility scoring (0-100) with publication workflows
- Audit trails and anomaly detection
- [Documentation](plugins/truth-verification/README.md)

### research-memory (v0.2.0)
Academic research memory management with devlogs, checkpoints, and insights.
- **10 commands** for tracking research progress and managing memories
- Automatic recovery of project context
- Timeline tracking and insight generation

### project-management (v0.1.0)
Standardized project scaffolding, restructuring, and validation.
- **4 commands** for creating projects, validating structure, and generating status
- Bundled project templates
- Compliance scoring

### skill-squared (v0.1.0)
Skill creation, extension, sync, and validation for Claude Code.
- **4 commands** for creating new skills and syncing updates
- Bundled skill templates
- Marketplace integration

### academic-figures (v0.1.0) - NEW!
Generate publication-ready academic figures with grayscale styling and Chinese font support.
- **6 commands** for line charts, bar charts, dot-whisker plots, scatter plots, and maps
- Grayscale/B&W styling suitable for academic publishing
- Full Chinese character support (STFangsong font)
- 300 DPI high-resolution output (PDF + PNG)
- [Documentation](plugins/academic-figures/README.md)

## Development Notes

- Source repositories remain available for deep development:
  - `/Users/adriansun/Documents/GitHub/research-memory`
  - `/Users/adriansun/Documents/GitHub/project-management`
  - `/Users/adriansun/Documents/GitHub/skill-squared`
  - `/Users/adriansun/Documents/GitHub/truth-verification` (new)
- Sync changes from standalone repos into this marketplace with `/skill-squared:sync` to keep skills up-to-date.

## Migration from v2.x (Unified Plugin)

If you previously installed the unified "llm-research" plugin version 2.x:

1. **Uninstall the old plugin**:
   ```bash
   /plugin uninstall llm-research
   ```

2. **Update to v3.x** (independent plugins):
   ```bash
   cd /path/to/llm-research-marketplace
   git pull
   ./install.sh
   ```

3. **Install the plugins you need**:
   ```bash
   # You can now install plugins individually or all five:
   /plugin install research-memory@LLM-Research-Marketplace
   /plugin install project-management@LLM-Research-Marketplace
   /plugin install skill-squared@LLM-Research-Marketplace
   /plugin install truth-verification@LLM-Research-Marketplace
   /plugin install academic-figures@LLM-Research-Marketplace
   ```

4. **Verify the new structure**:
   ```bash
   /plugin list       # Should show 5 separate plugins
   /help              # Should show 32 commands (or fewer if you installed selectively)
   ```

### What Changed in v3.x

- **Independent Plugins**: Each skill is now a fully self-contained plugin that can be installed/uninstalled separately
- **Plugin-Local Resources**: Templates and configuration files are bundled within each plugin instead of shared at the marketplace root
- **Better Isolation**: Plugins no longer depend on shared resources, making them truly installable as independent units
- **Selective Installation**: You can now install only the plugins you need instead of getting all features

## License

MIT License applies to the marketplace and all included skills.
