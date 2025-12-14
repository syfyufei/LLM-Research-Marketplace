# truth-verification:audit

**Goal**: Generate comprehensive audit reports documenting research methodology, data provenance, and analysis lineage for publication, compliance, and reproducibility verification.

**When to use**: Before publication, before sharing research, for compliance audits, or to create reproducible research archives.

---

## Preparation

Before running this command:

1. Ensure `.truth/manifest.json` exists with complete tracking
2. Register all data files
3. Track all script executions
4. Run `/truth-verification:verify` to confirm data integrity
5. Run `/truth-verification:reproduce` to validate reproducibility
6. Optional: Run `/truth-verification:cite-check` to validate citations

---

## Execution

### Generate default audit report (Markdown):
```bash
/truth-verification:audit
```

### Generate with timeline:
```bash
/truth-verification:audit --include-timeline
```

### Generate JSON report for systems:
```bash
/truth-verification:audit --format json --output audit-report.json
```

### Generate HTML report for web viewing:
```bash
/truth-verification:audit --format html --output audit-report.html
```

### Generate with full details:
```bash
/truth-verification:audit --detail-level full --include-timeline --include-anomalies
```

### Generate publication-ready report:
```bash
/truth-verification:audit --format markdown \
  --include-timeline \
  --include-recommendations \
  --output publication-audit.md
```

### Generate with anomaly detection:
```bash
/truth-verification:audit --include-anomalies --anomaly-sensitivity high
```

---

## What Happens

1. **Data Collection**:
   - Loads complete manifest with all tracking data
   - Collects all registration, execution, and verification logs
   - Gathers timeline information from timestamps
   - Extracts dependency graph and reproducibility metrics

2. **Analysis**:
   - Validates all data sources and their provenance
   - Traces complete lineage from inputs → scripts → outputs
   - Detects anomalies:
     - Files modified after registration
     - Missing scripts or data
     - Broken dependency chains
     - Orphaned data
     - Unusual patterns (very large jumps in file size, unexpected modifications)
   - Evaluates reproducibility
   - Checks for policy violations

3. **Timeline Generation** (optional):
   - Creates chronological record of:
     - When data was registered
     - When scripts were executed
     - When verifications occurred
     - When modifications were detected
     - All significant events with timestamps

4. **Anomaly Detection** (optional):
   - Identifies suspicious patterns:
     - Data modified after analysis claimed to be complete
     - Scripts with very long/short execution times
     - Unusual modifications to input data
     - Files added to manifest much later than creation
     - Gaps in tracking
   - Provides risk assessments

5. **Report Generation**:
   - Creates formatted report in selected format
   - Includes summary statistics
   - Lists all data sources with provenance
   - Documents all analysis steps
   - Shows complete dependency chains
   - Provides reproducibility assessment
   - Lists issues and recommendations
   - Includes timeline (if requested)
   - Includes anomaly analysis (if requested)

6. **Manifest Update**:
   - Records audit generation in manifest
   - Adds audit metadata and timestamp
   - Updates audit_status field

---

## Output Examples

### Markdown Audit Report (Sample):
```
# Research Audit Report

## Executive Summary
- Project: test-project
- Generated: 2025-12-15T15:00:00Z
- Status: AUDIT COMPLETE ✓
- Reproducibility Score: 95/100 (Excellent)
- Issues Found: 0 critical, 0 warnings

## Data Inventory

### Registered Data Sources (5 files)
1. data/raw/dataset.csv
   - Registered: 2025-12-15T10:00:00Z
   - Hash: a7b3f8d9e2c1b4f6a8e9c2d5f7a8b3c1
   - Size: 2.5 MB
   - Status: ✓ Verified
   - Integrity: ✓ Unchanged since registration

2. data/raw/metrics.csv
   - Registered: 2025-12-15T10:05:00Z
   - Hash: b8c4a9e3d1f2c5a8b1d4e7f9a2c5d8e1
   - Size: 1.2 MB
   - Status: ✓ Verified
   - Integrity: ✓ Unchanged since registration

... (more data sources)

## Analysis Scripts (3 tracked)
1. codes/preprocessing.py
   - First executed: 2025-12-15T11:00:00Z (45 seconds)
   - Executions: 3 total
   - Inputs: data/raw/dataset.csv, data/raw/metrics.csv
   - Outputs: data/cleaned/merged.csv
   - Status: ✓ All executions complete

2. codes/analysis.py
   - First executed: 2025-12-15T12:30:00Z (120 seconds)
   - Executions: 2 total
   - Inputs: data/cleaned/merged.csv
   - Outputs: paper/figures/results.png, paper/data/analysis.json
   - Status: ✓ All executions complete

... (more scripts)

## Dependency Chains
### Chain 1: Primary Analysis Pipeline
  data/raw/dataset.csv (2.5 MB)
    → preprocessing.py (45 sec)
    → data/cleaned/merged.csv (2.3 MB) ✓
    → analysis.py (120 sec)
    → paper/figures/results.png (456 KB) ✓
    → paper/manuscript.md (references results)

Status: ✓ COMPLETE AND TRACEABLE

### Chain 2: Metrics Processing
  data/raw/metrics.csv (1.2 MB)
    → merge.py (30 sec)
    → data/cleaned/metrics.csv (1.1 MB) ✓

Status: ✓ COMPLETE AND TRACEABLE

## Timeline of Events

2025-12-15T10:00:00Z - Registered data/raw/dataset.csv (2.5 MB)
2025-12-15T10:05:00Z - Registered data/raw/metrics.csv (1.2 MB)
2025-12-15T10:30:00Z - Registered codes/preprocessing.py
2025-12-15T11:00:00Z - Executed preprocessing.py (45 seconds)
2025-12-15T11:05:00Z - Generated data/cleaned/merged.csv (2.3 MB)
2025-12-15T12:30:00Z - Executed analysis.py (120 seconds)
2025-12-15T12:32:00Z - Generated paper/figures/results.png (456 KB)
2025-12-15T14:00:00Z - Verified all data files (✓ all unchanged)
2025-12-15T14:30:00Z - Validated reproducibility score: 95/100

## Reproducibility Assessment
Score: 95/100 (EXCELLENT)
- Input Integrity: 40/40 ✓
- Script Traceability: 30/30 ✓
- Output Attribution: 20/20 ✓
- No Orphaned Data: 5/10 (5 extra files marked as backup)

Recommendation: READY FOR PUBLICATION

## Anomalies Detected
None - All systems normal.

## Compliance Summary
✓ All data sources registered with cryptographic hashes
✓ All analysis steps traced with execution metadata
✓ All outputs attributed to generating scripts
✓ No data modifications after analysis completion
✓ Complete dependency graph with no broken links
✓ Reproducibility score exceeds 90 (excellent range)

## Recommendations
1. Archive this audit report with the manuscript
2. Commit .truth/ directory to version control
3. Share audit report with collaborators
4. Consider publishing with full reproducibility support

---
Generated by truth-verification v0.4.0
Audit Report Version: 1.0.0
```

---

## Report Formats

### Markdown Format
- Human-readable
- Suitable for documentation
- Can be included in papers
- Good for version control
- Default format

### JSON Format
- Machine-parseable
- Suitable for tools and systems
- Complete structured data
- Enables automated analysis
- Good for dashboards

### HTML Format
- Web-viewable
- Interactive navigation
- Formatted for presentation
- Shareable via email or web
- Includes styling and navigation

---

## Anomaly Sensitivity Levels

**Low**: Only critical issues (missing files, broken chains)
**Medium**: Critical + significant issues (modified data, missing metadata)
**High**: All issues including minor inconsistencies

---

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| "No data to audit" | Manifest is empty | Register files and track scripts first |
| "Invalid manifest" | Manifest corrupted | Restore from backup or reinitialize |
| "Cannot generate report" | Disk space or permission issue | Check disk and permissions |
| "Invalid format" | Unsupported report format | Use json, markdown, or html |

---

## Success Indicators

After successful execution:

1. Audit report generated in selected format
2. Report includes all sections:
   - Executive summary
   - Data inventory
   - Analysis scripts
   - Dependency chains
   - Timeline (if requested)
   - Anomalies (if requested)
   - Recommendations
3. Report file created at specified output path
4. Manifest updated with audit metadata

---

## Advanced Scenarios

### Generate with full forensics:
```bash
/truth-verification:audit --detail-level forensic \
  --include-timeline \
  --include-anomalies \
  --anomaly-sensitivity high \
  --format markdown
```

Creates detailed analysis suitable for investigations.

### Compare audits over time:
```bash
/truth-verification:audit --compare-with-previous-audit
```

Shows what changed since last audit.

### Generate for specific data subset:
```bash
/truth-verification:audit --include-only "data/raw/*,paper/*"
```

Only audits specific directories.

### Generate with external reviewer summary:
```bash
/truth-verification:audit --format markdown \
  --executive-summary-only \
  --output executive-audit-summary.md
```

Creates concise summary for external reviewers.

---

## Publication Integration

**Complete publication workflow**:
```bash
# 1. Initialize and track all work
/truth-verification:init
/truth-verification:register --recursive --dir data/
/truth-verification:track --script codes/...
/truth-verification:verify

# 2. Validate reproducibility and citations
/truth-verification:reproduce --generate-report
/truth-verification:cite-check --paper paper/manuscript.md --strict-mode

# 3. Generate final audit
/truth-verification:audit --include-timeline --format markdown --output audit-trail.md

# 4. Publish with complete reproducibility documentation
# Include audit-trail.md with submission
# Archive .truth/ with code repository
# Share reproducibility badge or DOI
```

---

## Compliance and Regulatory

Use audit reports for:
- **Research Ethics**: Document data handling and modification tracking
- **Data Privacy**: Track access and modifications
- **Regulatory Compliance**: Create audit trails for compliance audits
- **Fraud Detection**: Anomaly detection helps identify suspicious patterns
- **Institutional Policies**: Demonstrate compliance with research standards

---

## Next Steps

After audit generation:

1. **Review report**: Check for issues and recommendations
2. **Address anomalies**: Investigate any detected anomalies
3. **Archive report**: Save audit report with manuscript/code
4. **Share with team**: Provide audit report to collaborators
5. **Publish**: Submit with full reproducibility documentation

---

## Related Commands

- `/truth-verification:register` - Register data files
- `/truth-verification:track` - Record script execution
- `/truth-verification:verify` - Check data integrity
- `/truth-verification:reproduce` - Validate reproducibility
- `/truth-verification:cite-check` - Validate citations
