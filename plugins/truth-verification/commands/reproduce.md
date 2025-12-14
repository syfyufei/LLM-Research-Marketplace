# truth-verification:reproduce

**Goal**: Validate that research results are reproducible by verifying the complete dependency chain from source data through analysis scripts to final outputs.

**When to use**: Before publishing or sharing research, ensure all data and scripts form a complete reproducible chain.

---

## Preparation

Before running this command:

1. Ensure `.truth/manifest.json` exists with registered files
2. Register data sources: `/truth-verification:register --recursive --dir data/`
3. Track script execution: `/truth-verification:track --script codes/...`
4. Optional: Run `/truth-verification:verify` to ensure current data integrity

---

## Execution

### Check reproducibility of complete project:
```bash
/truth-verification:reproduce
```

### Generate detailed reproducibility report:
```bash
/truth-verification:reproduce --generate-report --output reproduce-report.md
```

### Show only reproducibility score:
```bash
/truth-verification:reproduce --score-only
```

### Check reproducibility for specific output:
```bash
/truth-verification:reproduce --target data/cleaned/results.csv
```

### Trace backwards from output to all inputs:
```bash
/truth-verification:reproduce --trace-back data/cleaned/results.csv
```

### Export report as JSON for tools:
```bash
/truth-verification:reproduce --generate-report --format json --output reproduce.json
```

---

## What Happens

1. **Dependency Graph Analysis**:
   - Loads dependency graph from manifest
   - Identifies all data → script → result chains
   - Detects cycles or broken links
   - Validates graph structure integrity

2. **Data Validation**:
   - Verifies all input files exist and match registered hashes
   - Checks all intermediate files are registered
   - Validates output files exist and are accessible
   - Reports missing or modified files

3. **Script Traceability**:
   - Confirms all scripts are registered and accessible
   - Verifies script hashes haven't changed
   - Validates execution parameters are recorded
   - Reports any scripts with missing metadata

4. **Reproducibility Scoring**:
   - Calculates score based on configuration weights:
     - Input integrity (40 points): All inputs verified
     - Script traceability (30 points): All scripts recorded
     - Output attribution (20 points): All outputs linked to scripts
     - No orphaned data (10 points): No unregistered files
   - Produces score 0-100
   - Rates as: Poor (<60), Fair (60-75), Good (75-90), Excellent (>90)

5. **Dependency Tracing**:
   - Traces complete lineage for each output
   - Shows which inputs contributed to which outputs
   - Identifies redundant files or unused data
   - Detects missing intermediate steps

6. **Report Generation**:
   - Summary: Overall reproducibility score and rating
   - Detailed chain breakdown: Which data → which script → which output
   - Issues found: Missing files, broken chains, unregistered data
   - Recommendations: What needs to be added for reproducibility
   - Timeline: When each step was executed

7. **Manifest Update**:
   - Records reproducibility score in manifest
   - Updates `reproducibility_status` field
   - Adds timestamp of reproducibility check

---

## Output Examples

### Excellent reproducibility:
```
✓ Reproducibility Validation Complete
  Status: EXCELLENT (95/100)

Summary:
  Input integrity: ✓ 100% (5/5 files verified)
  Script traceability: ✓ 100% (3/3 scripts recorded)
  Output attribution: ✓ 100% (8/8 outputs linked)
  No orphaned data: ✓ 100% (0 orphaned files)

Reproducibility Score: 95/100 - EXCELLENT
  Can be reproduced with high confidence.
  Ready for publication.

Dependency Chains (3 found):
  ✓ Chain 1: data/raw/raw1.csv
              → codes/preprocessing.py
              → data/cleaned/merged.csv
              → codes/analysis.py
              → paper/figures/results.png (8 steps, all traceable)

  ✓ Chain 2: data/raw/metrics.csv
              → codes/merge.py
              → data/cleaned/metrics.csv (2 steps, all traceable)

  ✓ Chain 3: data/cleaned/merged.csv + codes/statistical.py
              → paper/manuscripts/results.md (complete)
```

### Issues found:
```
⚠ Reproducibility Validation Complete (with issues)
  Status: FAIR (68/100)

Summary:
  Input integrity: ⚠ 80% (4/5 files verified, 1 MODIFIED)
  Script traceability: ✓ 100% (3/3 scripts recorded)
  Output attribution: ⚠ 75% (6/8 outputs linked)
  No orphaned data: ❌ 0% (2 orphaned files detected)

Reproducibility Score: 68/100 - FAIR
  Can be reproduced but some issues exist.
  Recommend fixing before publication.

Issues Detected:
  ❌ Input file modified: data/raw/dataset.csv
     Expected hash: a7b3f8d9e2c1...
     Current hash:  c9d5b1a4e2f3...
     Impact: Results from this file may not be reproducible

  ❌ Output not attributed: results/preliminary.csv
     Not linked to any script in manifest
     Suggestion: Track the script that generated it

  ⚠ Orphaned data: data/raw/backup_2025-12-01.csv
     Registered but never used in any script
     Suggestion: Remove or cite in paper

Recommendations:
  1. Investigate modified input: data/raw/dataset.csv
  2. Re-register modified file or restore from backup
  3. Track the script that generated results/preliminary.csv
  4. Remove orphaned file: data/raw/backup_2025-12-01.csv
  5. Re-run /reproduce to validate fixes
```

---

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| "No dependencies found" | No scripts tracked yet | Run `/truth-verification:track` for each script |
| "Input file missing" | Referenced file no longer exists | Restore from backup or remove from manifest |
| "Broken dependency chain" | Script or output file missing | Register missing files or re-track scripts |
| "Invalid manifest" | `.truth/manifest.json` corrupted | Restore from backup or reinitialize |

---

## Reproducibility Score Breakdown

**Input Integrity (40 points)**:
- 40 pts: All registered input files exist and match hashes
- 30 pts: 75%+ of input files verified
- 20 pts: 50%+ of input files verified
- 10 pts: <50% of input files verified
- 0 pts: No input files verified or verified = false

**Script Traceability (30 points)**:
- 30 pts: All scripts recorded with parameters and timestamps
- 20 pts: 75%+ of scripts have metadata
- 10 pts: 50%+ of scripts have metadata
- 5 pts: <50% of scripts have metadata
- 0 pts: No scripts tracked

**Output Attribution (20 points)**:
- 20 pts: All outputs linked to generating scripts
- 15 pts: 75%+ of outputs attributed
- 10 pts: 50%+ of outputs attributed
- 5 pts: 25%+ of outputs attributed
- 0 pts: No outputs attributed

**No Orphaned Data (10 points)**:
- 10 pts: All registered data files used in scripts
- 5 pts: 50%+ of data files used
- 0 pts: <50% of data files used or many orphaned files

---

## Reproducibility Levels

| Score | Level | Meaning | Action |
|-------|-------|---------|--------|
| 90-100 | Excellent | Fully reproducible, ready for publication | Publish with confidence |
| 75-89 | Good | Mostly reproducible, minor issues | Address recommendations before publication |
| 60-74 | Fair | Partially reproducible, significant issues | Fix issues before sharing |
| <60 | Poor | Barely reproducible, major gaps | Major work needed to ensure reproducibility |

---

## Advanced Scenarios

### Trace specific output backwards:
```bash
/truth-verification:reproduce --trace-back data/cleaned/results.csv
```

Shows complete lineage: which inputs → which scripts → this output.

### Check reproducibility for publication:
```bash
/truth-verification:reproduce --generate-report \
  --include-recommendations \
  --format markdown \
  --output publication-audit.md
```

Generates publication-ready documentation.

### Compare reproducibility over time:
```bash
/truth-verification:reproduce --compare-with-date "2025-12-01T00:00:00Z"
```

Shows how reproducibility score changed since specific date.

### Validate for specific paper:
```bash
/truth-verification:reproduce --target paper/manuscripts/main.md \
  --include-cited-data-only
```

Only validates data cited in the specified paper.

---

## Reproducibility Workflow

**Before Publication**:
```bash
# 1. Register all data
/truth-verification:register --recursive --dir data/

# 2. Track all scripts
/truth-verification:track --script codes/preprocessing.py ...
/truth-verification:track --script codes/analysis.py ...
/truth-verification:track --script codes/visualization.py ...

# 3. Verify data integrity
/truth-verification:verify

# 4. Check reproducibility
/truth-verification:reproduce --generate-report

# 5. Fix any issues found
# ... investigate and fix issues ...

# 6. Re-validate
/truth-verification:reproduce --score-only

# 7. Publish when score > 90
```

---

## Integration with other commands

**Complete publication workflow**:
```bash
/truth-verification:init
/truth-verification:register --recursive --dir data/
/truth-verification:track --script codes/...
/truth-verification:verify
/truth-verification:reproduce --generate-report  # This command
/truth-verification:cite-check --paper paper/manuscript.md --strict-mode
/truth-verification:audit --include-timeline
# Ready for publication!
```

---

## Next Steps

After validation:

1. **If score > 90**: Proceed to citation validation and publication
2. **If score 75-90**: Address recommendations before publishing
3. **If score < 75**: Fix critical issues before sharing
4. **Generate audit**: `/truth-verification:audit` for final report
5. **Archive**: Commit `.truth/` with manuscript in version control

---

## Related Commands

- `/truth-verification:register` - Register data files
- `/truth-verification:track` - Record script execution
- `/truth-verification:verify` - Check data integrity
- `/truth-verification:cite-check` - Validate citations (Phase 3)
- `/truth-verification:audit` - Generate audit reports (Phase 4)
