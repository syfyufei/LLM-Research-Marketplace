# LLM Research Marketplace - Usage Guide

## Installation Verification

After running the install script, you can verify the installation in a Claude Code session:

### In Claude Code Terminal or Chat

```bash
# List all plugins
/plugin list

# Check marketplace status
/plugin marketplace list
```

You should see:
- Marketplace: `LLM-Research-Marketplace`
- Plugin: `llm-research` (version 1.0.0)

## Using Skills

### research-memory Skill

The research-memory skill is automatically available after installation. Use natural language to trigger it:

#### Starting a Session

```
"Research Memory, help me get back up to speed with my project"
"用 research-memory 恢复一下项目状态"
"今天应该做什么？"
```

This will:
- Load your project overview
- Show recent devlog entries (last 5 by default)
- Display current TODOs
- Suggest a work plan

#### Logging Your Work

```
"Log this work session to Research Memory"
"帮我记录今天的工作"
"把这个实验结果记到 research-memory 里"
```

This will:
- Analyze your conversation
- Extract structured information (experiments, decisions, phases)
- Update memory files (devlog.md, experiments.csv, decisions.md, todos.md)

#### Querying History

```
"我们之前为什么放弃过这个方案？"
"Search for our decisions about spatial lag models"
"查一下之前关于变量构造的讨论"
```

This will:
- Search across memory files
- Return relevant excerpts with context
- Show timestamps and research phases

## Memory File Structure

After first use, research-memory creates a `memory/` directory in your project:

```
your-project/
└── memory/
    ├── project-overview.md   # Long-term project info
    ├── devlog.md            # Session logs by phase
    ├── decisions.md         # Key decisions & rationale
    ├── experiments.csv      # Structured experiment records
    └── todos.md             # Current TODO items
```

All files are plain text (Markdown/CSV) and can be:
- Edited manually
- Version controlled with Git
- Shared with collaborators

## Configuration

You can customize the skill behavior via `config/config.json`:

```json
{
    "bootstrap": {
        "recent_entries_count": 5,
        "include_todos": true,
        "suggest_work_plan": true
    },
    "logging": {
        "auto_timestamp": true,
        "phase_sections": ["DGP", "data_preprocess", "data_analyse", "modeling", "robustness", "writing", "infra", "notes"]
    },
    "search": {
        "max_results": 10,
        "include_context": true,
        "context_lines": 3
    }
}
```

## Management Commands

### Update to Latest Version

```bash
# In terminal
claude plugin update llm-research

# In Claude Code session
/plugin update llm-research
```

### Uninstall

```bash
# In terminal
claude plugin uninstall llm-research

# In Claude Code session
/plugin uninstall llm-research
```

### Reinstall

If you need to reinstall:

```bash
# Remove marketplace
claude plugin marketplace remove LLM-Research-Marketplace

# Remove plugin
claude plugin uninstall llm-research

# Reinstall
./install.sh
```

## Troubleshooting

### Skill Not Triggering

1. Verify installation in Claude Code session:
   ```
   /plugin list
   ```

2. Check that the skill file exists:
   ```
   ls skills/research-memory.md
   ```

3. Try explicitly mentioning the skill:
   ```
   "Use the research-memory skill to bootstrap my project"
   ```

### Files Not Created

The memory files are created on first use. If they don't appear:

1. Check write permissions in your project directory
2. Look for error messages in Claude Code output
3. Manually create the `memory/` directory:
   ```bash
   mkdir -p memory
   ```

### Update Not Working

If updates don't apply:

1. Uninstall completely:
   ```bash
   claude plugin uninstall llm-research
   claude plugin marketplace remove LLM-Research-Marketplace
   ```

2. Reinstall:
   ```bash
   cd /path/to/llm-research-marketplace
   ./install.sh
   ```

## Development & Contribution

### Adding Custom Skills

1. Create a new `.md` file in `skills/`:
   ```markdown
   ---
   name: my-skill
   description: My custom skill description
   ---

   # My Skill

   [Skill documentation...]
   ```

2. Update `README.md` to list the new skill

3. Test locally:
   ```bash
   claude plugin update llm-research
   ```

### Local Development

For development on skills:

```bash
cd /path/to/llm-research-marketplace
git pull  # Get latest changes

# Make your edits to skills/*.md

# Reinstall to test
./install.sh
```

## Examples

See the [README.md](README.md) for detailed examples of using the research-memory skill in various scenarios.

## Support

For issues or questions:
- GitHub Issues: [syfyufei/llm-research-marketplace](https://github.com/syfyufei/llm-research-marketplace/issues)
- Individual skill repos: [syfyufei/research-memory](https://github.com/syfyufei/research-memory)
