# truth-verification Skill

**Version**: 0.4.0
**Status**: Production Ready
**Last Updated**: 2025-12-15

## Overview

The `truth-verification` skill ensures research integrity by tracking data provenance, verifying source authenticity, and preventing fabricated claims. It creates an audit chain from raw data through analysis scripts to final results, enabling reproducible research with cryptographic integrity verification.

### What It Does

- **Data Tracking**: Records every data file with SHA256 hashing
- **Provenance Chain**: Maintains dependencies between data → analysis → results
- **Integrity Verification**: Detects unauthorized modifications to tracked files
- **Citation Validation**: Ensures all paper claims reference actual registered data
- **Reproducibility Scoring**: Computes 0-100 scores based on dependency completeness
- **Audit Reporting**: Generates comprehensive reports with timelines and anomaly detection

## When to Use

Use `truth-verification` in these scenarios:

1. **Paper Writing**: Before finalizing papers, verify all cited data exists and is registered
2. **Data Analysis**: Register data sources before analysis to prevent accidental modifications
3. **Results Reporting**: Track which analysis scripts produced which results
4. **Compliance Audits**: Generate proof of research methodology for peer review or institutional audits
5. **Collaborative Research**: Ensure team members don't accidentally corrupt shared data
6. **Reproducibility Verification**: Confirm all dependencies exist before sharing research

## Integration with Other Skills

### research-memory
- Log data registration events in `memory/devlog.md`
- Track reproducibility scores as research progresses
- Use `/research-memory:insights` to correlate data integrity with research phases

### project-management
- Integrates with standard project structure (data/raw, data/cleaned, codes, paper/)
- `/truth-verification:status` respects project validation rules
- Supports validation within `/project-management:validate --check-integrity true`

## Core Concepts

### Manifest File
Located at `.truth/manifest.json`, this is the central registry containing:
- **data_sources**: Registered files with SHA256 hashes and metadata
- **analysis_scripts**: Execution records linking inputs to outputs
- **results**: Generated files and their dependencies
- **dependencies**: Graph structure showing data → script → result flows

### Integrity Verification
Uses SHA256 hashing to detect ANY modification:
- File size changes
- Content edits
- Permission changes
- Timestamp updates

### Reproducibility Score
Calculated 0-100 based on:
- All input data files still exist and match registered hashes (40 points)
- All analysis scripts present and traceable (30 points)
- All output files present and properly attributed (20 points)
- No unregistered data files in project (10 points)

## Quick Start

```bash
# Initialize tracking in a project
/truth-verification:init

# Register existing data files
/truth-verification:register --file data/raw/dataset.csv

# Record script execution
/truth-verification:track --script codes/analysis.py --inputs data/raw/dataset.csv --outputs data/cleaned/results.csv

# Verify nothing was modified
/truth-verification:verify

# Check paper citations
/truth-verification:cite-check --paper paper/manuscript.md

# Generate reproducibility report
/truth-verification:reproduce

# Get project status
/truth-verification:status
```

## Commands

| Command | Purpose | Key Parameters |
|---------|---------|-----------------|
| `init` | Initialize .truth/ infrastructure | `--force`: Overwrite existing manifest |
| `register` | Register data files with hashing | `--file`, `--recursive`, `--exclude-patterns` |
| `track` | Record analysis execution | `--script`, `--inputs`, `--outputs`, `--parameters` |
| `verify` | Check file integrity | `--file`, `--report-format` |
| `cite-check` | Validate paper citations | `--paper`, `--strict-mode` |
| `reproduce` | Check reproducibility | `--score-only`, `--generate-report` |
| `audit` | Generate audit reports | `--format`, `--include-timeline` |
| `status` | Show verification dashboard | `--detail-level` |

## Best Practices

1. **Initialize Early**: Run `/truth-verification:init` at project start
2. **Register Before Analysis**: Register data sources before processing
3. **Track Systematically**: Log every major analysis step
4. **Verify Regularly**: Run `/verify` weekly or after data changes
5. **Cite Properly**: Use exact file paths in papers (e.g., `data/raw/dataset.csv:line42`)
6. **Archive Results**: Keep `.truth/manifest.json` in version control
7. **Document Scripts**: Include clear comments in analysis scripts about dependencies

## Configuration

Configuration is stored in `plugins/truth-verification/config/config.json`:

- `hash_algorithm`: SHA256 (default)
- `monitored_directories`: Dirs to watch for unregistered files
- `verification_mode`: strict | lenient
- `scoring_weights`: Reproducibility calculation weights
- `integration_settings`: research-memory, project-management integration options

## Common Scenarios

### Scenario 1: Detecting Data Corruption
```
1. Register all data files: /truth-verification:register --recursive
2. Work on analysis...
3. Run /truth-verification:verify
→ "data/raw/dataset.csv: MODIFIED (hash mismatch)"
```

### Scenario 2: Validating Paper Before Submission
```
1. /truth-verification:cite-check --paper paper/manuscript.md --strict-mode
→ Lists all referenced data and whether each exists in manifest
→ Identifies orphaned data files not cited anywhere
```

### Scenario 3: Ensuring Reproducibility for Peers
```
1. /truth-verification:reproduce --generate-report
→ Generates report showing:
   - Which data files feed into which scripts
   - Which scripts produce which results
   - Reproducibility score (e.g., 87/100)
   - What's missing to reach 100%
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `.truth/` dir not created | Run `/truth-verification:init --force` |
| Files show as modified but unchanged | Hash mismatch may indicate binary vs text mode; verify file integrity |
| Citation validation finds unmatched refs | Check exact file paths match registered names |
| Low reproducibility score | Run `/truth-verification:status` for detailed suggestions |

## Version History

- **0.1.0** (2025-12-15): Initial release with core commands (init, register, track, verify, status)

## Future Enhancements

- Phase 2: Track command, analysis dependency graphs, research-memory integration
- Phase 3: cite-check and reproduce commands with scoring
- Phase 4: audit command with timeline and anomaly detection
- Phase 5: Large file optimization, data versioning, collaborative features

## See Also

- `plugins/truth-verification/docs/truth-verification.md` - Detailed command documentation
- `USAGE.md` - Integration patterns with research-memory and project-management
- `ARCHITECTURE.md` - Technical architecture of manifest system
