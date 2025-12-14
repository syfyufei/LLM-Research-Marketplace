# truth-verification Skill Complete Documentation

**Version**: 0.4.0 (Phases 2-4 Complete)
**Status**: Production Ready
**Updated**: 2025-12-15

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Quick Start](#quick-start)
4. [Core Concepts](#core-concepts)
5. [Commands Reference](#commands-reference)
6. [Usage Patterns](#usage-patterns)
7. [Integration](#integration)
8. [Advanced Topics](#advanced-topics)
9. [Troubleshooting](#troubleshooting)

---

## Overview

The **truth-verification** skill ensures research integrity through comprehensive data provenance tracking, integrity verification, and reproducibility validation. It creates an immutable audit trail from raw data through analysis to final results.

### Problem It Solves

- **Prevents Data Fabrication**: SHA256 hashing proves data authenticity
- **Ensures Reproducibility**: Complete dependency chains verify every result
- **Enables Accountability**: Audit trails document all modifications
- **Supports Compliance**: Generates publication-ready audit reports
- **Catches Errors Early**: Real-time modification detection

### Key Features

| Feature | Phase | Status |
|---------|-------|--------|
| Data Registration & Hashing | 1 | ✅ Complete |
| Integrity Verification | 1 | ✅ Complete |
| Status Dashboard | 1 | ✅ Complete |
| Script Tracking & Dependencies | 2 | ✅ Complete |
| research-memory Integration | 2 | ✅ Complete |
| Citation Validation | 3 | ✅ Complete |
| Reproducibility Scoring | 3 | ✅ Complete |
| Audit Reports (Markdown/JSON/HTML) | 4 | ✅ Complete |
| Timeline & Anomaly Detection | 4 | ✅ Complete |
| Large File Optimization | 5 | ⏳ Planned |
| Data Versioning | 5 | ⏳ Planned |
| Collaboration Features | 5 | ⏳ Planned |

---

## Installation

### Prerequisites

- Claude Code v1.0+
- marketplace.json configured for LLM-Research-Marketplace
- Write access to project directory

### Install Skill

```bash
./install.sh  # Install marketplace first if needed
/plugin install truth-verification@LLM-Research-Marketplace
```

### Verify Installation

```bash
/plugin list  # Should show "truth-verification"
/help | grep truth-verification  # Should list 8 commands
```

---

## Quick Start

### 5-Minute Setup

```bash
# 1. Initialize in your project
/truth-verification:init

# 2. Register your data
/truth-verification:register --recursive --dir data/raw

# 3. Check status
/truth-verification:status

# 4. Verify nothing changed
/truth-verification:verify
```

### Before Publication Workflow

```bash
# 1. Initialize
/truth-verification:init

# 2. Register all data files
/truth-verification:register --recursive --dir data/

# 3. Track your analysis scripts
/truth-verification:track --script codes/analysis.py \
  --inputs data/raw/dataset.csv \
  --outputs data/cleaned/results.csv

# 4. Verify data integrity
/truth-verification:verify

# 5. Validate reproducibility
/truth-verification:reproduce --generate-report

# 6. Check paper citations
/truth-verification:cite-check --paper paper/manuscript.md --strict-mode

# 7. Generate final audit
/truth-verification:audit --include-timeline --format markdown

# 8. Ready for publication! 📚
```

---

## Core Concepts

### 1. Manifest File (`.truth/manifest.json`)

Central registry of all tracked data, scripts, and results:

```json
{
  "version": "1.0.0",
  "data_sources": [{
    "path": "data/raw/dataset.csv",
    "hash_sha256": "a7b3f8d9...",
    "registered_at": "2025-12-15T10:00:00Z",
    "integrity_status": "verified"
  }],
  "analysis_scripts": [{
    "path": "codes/analysis.py",
    "inputs": ["data/raw/dataset.csv"],
    "outputs": ["data/cleaned/results.csv"]
  }],
  "dependencies": [{
    "from": "data/raw/dataset.csv",
    "to": "codes/analysis.py",
    "relationship": "input"
  }]
}
```

**Key Properties**:
- Immutable record of data provenance
- Version-controlled along with code
- Machine-parseable for automation
- Source of truth for reproducibility checks

### 2. SHA256 Hashing

Cryptographic hashes verify file authenticity:

```
Original file → [SHA256] → a7b3f8d9e2c1b4f6a8e9c2d5f7a8b3c1
Modified file → [SHA256] → c9d5b1a4e2f3d6a9c2e5f8a1d4g7h0a3
                           ↑ Completely different!
```

**Hash Guarantees**:
- ANY byte changed → completely different hash
- Same file → identical hash (100% reliable)
- One-way function (can't fake a hash)
- Enables cryptographic verification

### 3. Dependency Graph

Shows data lineage: which files feed into which scripts:

```
data/raw/raw.csv (2.5 MB)
    ↓ [registered]
codes/preprocessing.py
    ↓ [executed]
data/cleaned/merged.csv (2.3 MB)
    ↓ [depends on]
codes/analysis.py
    ↓ [generates]
paper/figures/results.png
```

**Enables**:
- Backward tracing: Which inputs led to this output?
- Forward tracing: What depends on this data?
- Completeness check: All files properly attributed?
- Reproducibility: Can we regenerate results?

### 4. Reproducibility Score (0-100)

Quantifies how reproducible your research is:

| Score | Level | Meaning |
|-------|-------|---------|
| 90-100 | Excellent | Fully reproducible, publish now |
| 75-89 | Good | Mostly reproducible, fix minor issues |
| 60-74 | Fair | Partially reproducible, significant work needed |
| <60 | Poor | Barely traceable, major gaps |

**Scoring Formula**:
```
Score = (Input Integrity × 40%) +
        (Script Traceability × 30%) +
        (Output Attribution × 20%) +
        (No Orphaned Data × 10%)
```

### 5. Integrity Verification

Regular checks that data hasn't changed:

```
Day 1: Register dataset.csv → hash: a7b3f8d9
Day 2: Verify dataset.csv → hash: a7b3f8d9 ✓ Unchanged
Day 3: Verify dataset.csv → hash: c9d5b1a4 ❌ MODIFIED!
```

**Alert**: File was modified on Day 3 - reproducibility may be compromised

---

## Commands Reference

### Phase 1 Commands (v0.1.0)

#### `/truth-verification:init`
Initialize tracking infrastructure in project.

```bash
/truth-verification:init                  # Standard init
/truth-verification:init --force          # Overwrite existing
```

#### `/truth-verification:register`
Register data files with SHA256 hashing.

```bash
/truth-verification:register --file data/raw/dataset.csv
/truth-verification:register --recursive --dir data/raw
/truth-verification:register --recursive --dir data/ --dry-run
```

#### `/truth-verification:verify`
Check that registered files haven't been modified.

```bash
/truth-verification:verify                # Verify all
/truth-verification:verify --file data/raw/dataset.csv  # Verify one
/truth-verification:verify --directory data/           # Verify directory
```

#### `/truth-verification:status`
Display project verification dashboard.

```bash
/truth-verification:status
/truth-verification:status --detail-level full
/truth-verification:status --format json
```

---

### Phase 2 Commands (v0.2.0)

#### `/truth-verification:track`
Record script execution and data dependencies.

```bash
/truth-verification:track --script codes/analysis.py \
  --inputs data/raw/dataset.csv \
  --outputs data/cleaned/results.csv

/truth-verification:track --script codes/analysis.py \
  --inputs data/raw/dataset.csv,data/raw/metrics.csv \
  --outputs data/cleaned/results.csv \
  --parameters "threshold=0.75,method=zscore"
```

**Integrates with research-memory** to log execution events in `memory/devlog.md`.

---

### Phase 3 Commands (v0.3.0)

#### `/truth-verification:cite-check`
Validate that all data references in papers match registered files.

```bash
/truth-verification:cite-check --paper paper/manuscript.md

/truth-verification:cite-check --directory paper/manuscripts \
  --recursive \
  --strict-mode  # Fail if any citations unresolved

/truth-verification:cite-check --paper manuscript.md \
  --report-orphaned-data  # Show unused registered data
```

#### `/truth-verification:reproduce`
Validate reproducibility of complete analysis pipeline.

```bash
/truth-verification:reproduce                    # Check overall
/truth-verification:reproduce --score-only       # Just show score
/truth-verification:reproduce --generate-report  # Detailed report
/truth-verification:reproduce --trace-back data/cleaned/results.csv  # Lineage
```

---

### Phase 4 Commands (v0.4.0)

#### `/truth-verification:audit`
Generate comprehensive audit reports.

```bash
/truth-verification:audit                        # Default markdown
/truth-verification:audit --format json          # Machine-parseable
/truth-verification:audit --format html          # Web-viewable
/truth-verification:audit --include-timeline     # With timeline
/truth-verification:audit --include-anomalies    # Detect issues
/truth-verification:audit --detail-level full    # Maximum detail
```

**Supports**:
- Markdown (default, human-readable)
- JSON (machine-parseable)
- HTML (interactive web viewing)

**Includes**:
- Data inventory with provenance
- Script execution history
- Complete dependency chains
- Reproducibility assessment
- Timeline of events
- Anomaly detection
- Compliance checklist

---

## Usage Patterns

### Pattern 1: Data Analysis Project

```bash
# Initialize
/truth-verification:init

# Register raw data
/truth-verification:register --recursive --dir data/raw

# Track preprocessing
/truth-verification:track --script codes/preprocessing.py \
  --inputs "data/raw/raw1.csv,data/raw/raw2.csv" \
  --outputs data/cleaned/merged.csv

# Track analysis
/truth-verification:track --script codes/analysis.py \
  --inputs data/cleaned/merged.csv \
  --outputs "data/results/analysis.json,paper/figures/plot.png"

# Verify everything
/truth-verification:verify
/truth-verification:reproduce --score-only
```

### Pattern 2: Publication Preparation

```bash
# Ensure all data is registered
/truth-verification:register --recursive --dir data/

# Track all scripts
/truth-verification:track --script codes/preprocessing.py ...
/truth-verification:track --script codes/analysis.py ...

# Validate citations
/truth-verification:cite-check --paper paper/manuscript.md --strict-mode

# Generate reproducibility report
/truth-verification:reproduce --generate-report --output reproduce.md

# Generate audit trail
/truth-verification:audit --include-timeline --output audit-trail.md

# Publish with documentation!
```

### Pattern 3: Compliance Audit

```bash
# Comprehensive audit for compliance
/truth-verification:audit \
  --detail-level full \
  --include-timeline \
  --include-anomalies \
  --anomaly-sensitivity high \
  --format markdown \
  --output compliance-audit.md

# Review issues
# Fix any anomalies
# Re-audit if needed
```

### Pattern 4: Collaborative Research

```bash
# Each team member tracks their work
/truth-verification:track --script codes/my-analysis.py ...

# Generate status before handoff
/truth-verification:status --format json > status.json

# Other teammate checks
/truth-verification:reproduce --generate-report
/truth-verification:verify

# Regular syncs ensure consistency
```

---

## Integration

### With research-memory

Automatically logs tracking events:

```markdown
## 2025-12-15 14:30 - Data Analysis #data-tracking
Ran analysis script:
- Input: data/raw/dataset.csv (verified ✓)
- Output: data/cleaned/results.csv
- Duration: 45 seconds
- Dependency graph: 2 edges added
```

### With project-management

Respects project directory structure:

```
project/
├── .truth/                  ← Manifest here
├── data/raw/               ← Monitored
├── data/cleaned/           ← Monitored
├── codes/                  ← Scripts tracked
├── paper/figures/          ← Outputs tracked
└── paper/manuscripts/      ← Citations checked
```

### With Git/Version Control

Archive manifest with code:

```bash
git add .truth/manifest.json
git commit -m "Add data provenance tracking"
git add paper/audit-trail.md
git commit -m "Add reproducibility audit"
```

---

## Advanced Topics

### Large Files (>100MB)

Streaming hash computation:

```bash
# Automatically uses streaming for large files
/truth-verification:register --file large-dataset.bin

# No memory issues, even with 1GB+ files
```

### External Data Sources

Document external dependencies:

```bash
/truth-verification:track --script codes/download.py \
  --external-inputs "s3://bucket/data.csv" \
  --outputs data/raw/downloaded.csv
```

### Multiple Analysis Chains

Complex projects with multiple independent analyses:

```
data/raw/data.csv → script1.py → results1.csv
data/raw/data.csv → script2.py → results2.csv
results1.csv + results2.csv → merge.py → final.csv
```

All tracked and reproducible!

### Dry-Run Mode

Preview what would be tracked without committing:

```bash
/truth-verification:register --recursive --dir data/ --dry-run
# Shows files to be registered without modifying manifest
```

---

## Troubleshooting

### Issue: "Manifest not found"

**Cause**: Not initialized in this project
**Solution**: Run `/truth-verification:init`

### Issue: "File modified but I didn't change it"

**Cause**: File regenerated or timestamp updated
**Solution**:
- If legitimate: Run `/truth-verification:register --file <file> --update`
- If accidental: Restore from backup

### Issue: Low reproducibility score

**Cause**: Missing tracked data or scripts
**Solution**: Run `/truth-verification:reproduce --generate-report` to see details

### Issue: Citation validation fails

**Cause**: Paper references data not in manifest
**Solution**: Either:
- Register missing file: `/truth-verification:register --file <file>`
- Fix citation in paper: Update reference to registered file

### Issue: "No dependencies found"

**Cause**: Scripts not tracked
**Solution**: Use `/truth-verification:track` for each analysis script

---

## Performance Considerations

| Operation | Time | Notes |
|-----------|------|-------|
| Register 100 files | <1 sec | Fast, uses streaming |
| Verify 100 files | 2-5 sec | Hash computation |
| Track script | <1 sec | Metadata only |
| Reproduce check | 1-2 sec | Graph analysis |
| Generate audit | 2-5 sec | Report rendering |

**Optimization**: Large file hashing happens asynchronously

---

## Version History

- **v0.4.0** (2025-12-15): Phases 2-4 complete - Full feature set
- **v0.3.0** (2025-12-15): Phase 3 - Citation validation & reproducibility
- **v0.2.0** (2025-12-15): Phase 2 - Script tracking & research-memory integration
- **v0.1.0** (2025-12-15): Phase 1 - Core functionality (init, register, verify, status)

---

## FAQ

**Q: Will truth-verification slow down my work?**
A: No - initialization and commands are lightweight (<1 sec for most operations)

**Q: Can I start tracking mid-project?**
A: Yes - register data and track scripts retroactively

**Q: What if I need to modify data after registering?**
A: Re-register with `/truth-verification:register --update`

**Q: Does this work with external data sources?**
A: Yes - use `--external-inputs` to document external dependencies

**Q: Can I remove or modify the manifest?**
A: Not recommended - manifest is the source of truth for reproducibility

**Q: How do I handle large datasets?**
A: Streaming mode automatically activates for files >10MB

---

## See Also

- Main skill definition: `truth-verification.md`
- Command documentation: Individual command `.md` files
- Configuration: `config/config.json`
- Marketplace: `../../.claude-plugin/marketplace.json`

---

**For questions or issues, refer to the marketplace documentation or GitHub repository.**
