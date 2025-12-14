# truth-verification:track

**Goal**: Track the execution of analysis scripts and record data dependencies to enable reproducibility verification and analysis traceability.

**When to use**: After running analysis scripts, track their execution to document data lineage and enable reproducibility validation.

---

## Preparation

Before running this command:

1. Ensure `.truth/manifest.json` exists (run `/truth-verification:init` if needed)
2. Register input data files first (run `/truth-verification:register` for all source data)
3. Have the analysis script file available
4. Know which files are inputs and outputs for the script
5. Optional: Note any parameters used in the script execution

---

## Execution

### Track script execution with inputs and outputs:
```bash
/truth-verification:track --script codes/analysis.py --inputs data/raw/dataset.csv --outputs data/cleaned/results.csv
```

### Track with multiple inputs:
```bash
/truth-verification:track --script codes/preprocessing.py --inputs data/raw/raw1.csv,data/raw/raw2.csv --outputs data/cleaned/merged.csv
```

### Track with execution parameters:
```bash
/truth-verification:track --script codes/analysis.py \
  --inputs data/raw/dataset.csv \
  --outputs data/cleaned/results.csv \
  --parameters "threshold=0.75,method=zscore"
```

### Track with execution duration:
```bash
/truth-verification:track --script codes/analysis.py \
  --inputs data/raw/dataset.csv \
  --outputs data/cleaned/results.csv \
  --execution-duration 45
```

### Auto-register outputs if not yet registered:
```bash
/truth-verification:track --script codes/analysis.py \
  --inputs data/raw/dataset.csv \
  --outputs data/cleaned/results.csv \
  --auto-register-outputs
```

---

## What Happens

1. **Script Validation**:
   - Verifies script file exists and is readable
   - Extracts script hash (SHA256) for tracking
   - Validates script format based on extension

2. **Input Verification**:
   - Checks all input files are registered in manifest
   - Verifies file hashes match registered values
   - Warns if input files have been modified since registration

3. **Output Handling**:
   - Checks if output files exist
   - Registers outputs if not already registered (with `--auto-register-outputs`)
   - Records output file paths and hashes

4. **Dependency Graph Creation**:
   - Creates edges in dependency graph:
     - Input files → Script (relationship: "input")
     - Script → Output files (relationship: "produces")
   - Links previous script outputs to current script inputs
   - Builds complete lineage chain

5. **Manifest Update**:
   - Adds entry to `analysis_scripts` array
   - Adds entries to `dependencies` array
   - Records execution metadata in manifest
   - Updates `last_updated` timestamp

6. **Research Memory Integration** (if enabled):
   - Logs execution event to `memory/devlog.md` (if using research-memory skill)
   - Records: script name, inputs, outputs, execution time
   - Tags entry with `#data-tracking`

7. **Logging**:
   - Records event in `.truth/logs/track.log`
   - Shows summary of tracked dependencies

---

## Output Examples

### Successful tracking:
```
✓ Tracked script execution
  Script: codes/analysis.py
  Inputs: data/raw/dataset.csv (verified ✓)
  Outputs: data/cleaned/results.csv (registered & hashed)
  Dependencies: 2 edges added
  Duration: 45 seconds
  Status: Complete
```

### With warnings:
```
⚠ Tracked script execution (with warnings)
  Script: codes/analysis.py
  Inputs: data/raw/dataset.csv (MODIFIED since registration!)
    Expected hash: a7b3f8d9...
    Current hash:  c9d5b1a4...
  Outputs: data/cleaned/results.csv (registered & hashed)
  Dependencies: 2 edges added

  Warning: Input data modified! Reproducibility may be affected.
```

---

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| "Script file not found" | Script path doesn't exist | Verify script file path |
| "Input file not registered" | Input file not in manifest | Run `/truth-verification:register --file <input>` first |
| "Output file not found" | Output file doesn't exist | Run script first to generate output, or use `--dry-run` to preview |
| "Hash mismatch on input" | Input file was modified | Investigate modification or re-register with `--update` |
| "Invalid manifest" | `.truth/manifest.json` corrupted | Restore from backup or reinitialize |

---

## Success Indicators

After successful execution:

1. Command returns summary with all dependencies listed
2. Manifest contains new entries:
   - `analysis_scripts`: New script entry with execution metadata
   - `dependencies`: New edges linking inputs → script → outputs
3. `.truth/logs/track.log` contains execution record
4. If research-memory enabled: New entry in `memory/devlog.md`

---

## Dependency Graph Structure

The manifest's `dependencies` array tracks relationships:

```json
{
  "id": "dep_001",
  "type": "data_to_script",
  "from": "data/raw/dataset.csv",
  "to": "codes/analysis.py",
  "relationship": "input",
  "created_at": "2025-12-15T14:30:00Z"
}
```

Graph types:
- **data_to_script**: Data file feeds into a script
- **script_to_result**: Script produces a result
- **result_to_script**: Previous result feeds into current script

---

## Advanced Scenarios

### Track with dry-run (preview dependencies):
```bash
/truth-verification:track --script codes/analysis.py \
  --inputs data/raw/dataset.csv \
  --outputs data/cleaned/results.csv \
  --dry-run
```

Shows what dependencies would be created without modifying manifest.

### Track with external input (outside project):
```bash
/truth-verification:track --script codes/download.py \
  --external-inputs "https://api.example.com/data" \
  --outputs data/raw/downloaded.csv
```

Records external data sources that scripts depend on.

### Track with full lineage history:
```bash
/truth-verification:track --script codes/pipeline.py \
  --inputs data/raw/raw.csv \
  --outputs data/final/results.csv \
  --include-intermediate results/step1.csv,results/step2.csv
```

Documents all intermediate processing steps for complete traceability.

### Check script before tracking:
```bash
/truth-verification:track --script codes/analysis.py \
  --validate-inputs \
  --validate-outputs
```

Validates all inputs are registered and all outputs exist before tracking.

---

## Integration with research-memory

When research-memory is installed, tracking automatically logs:

**In memory/devlog.md**:
```markdown
## 2025-12-15 14:30 - Data Analysis Pipeline #data-tracking
Ran analysis script with:
- Input: data/raw/dataset.csv (verified ✓)
- Output: data/cleaned/results.csv (456 KB)
- Duration: 45 seconds
- Status: Complete

Dependency graph updated with 2 edges.
```

This creates an audit trail in your research memory.

---

## Next Steps

After tracking script execution:

1. **Verify outputs**: `/truth-verification:verify --file data/cleaned/results.csv`
2. **Track next step**: If outputs feed into another script, track that too
3. **Check reproducibility**: `/truth-verification:reproduce` (Phase 3) to validate complete chain
4. **Generate audit**: `/truth-verification:audit` (Phase 4) to create full report

---

## Related Commands

- `/truth-verification:register` - Register data files and outputs
- `/truth-verification:verify` - Check data integrity
- `/truth-verification:reproduce` - Validate reproducibility of complete chains (Phase 3)
- `/truth-verification:audit` - Generate comprehensive audit reports (Phase 4)
- `/research-memory:remember` - Log analysis work to memory (when research-memory installed)
