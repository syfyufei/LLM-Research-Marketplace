# truth-verification:cite-check

**Goal**: Validate that all data references in papers and manuscripts correspond to registered data sources, ensuring no fabricated citations.

**When to use**: Before finalizing papers, ensure every data claim references actual registered files.

---

## Preparation

Before running this command:

1. Ensure `.truth/manifest.json` exists with registered data files
2. Have paper/manuscript files to validate (Markdown, LaTeX, or plain text)
3. Ensure data files are registered in manifest (run `/truth-verification:register` if needed)
4. Optional: Define citation patterns for your domain

---

## Execution

### Check citations in a paper file:
```bash
/truth-verification:cite-check --paper paper/manuscript.md
```

### Check all papers in a directory:
```bash
/truth-verification:cite-check --directory paper/manuscripts
```

### Strict mode (fail on unresolved references):
```bash
/truth-verification:cite-check --paper paper/manuscript.md --strict-mode
```

### Include orphaned data (data not cited anywhere):
```bash
/truth-verification:cite-check --paper paper/manuscript.md --report-orphaned-data
```

### Custom citation patterns:
```bash
/truth-verification:cite-check --paper paper/manuscript.md \
  --patterns "data/.*\.csv,file:data/[a-zA-Z0-9_-]+\.(csv|json)"
```

### Generate detailed report:
```bash
/truth-verification:cite-check --paper paper/manuscript.md \
  --report-format detailed --output citation-report.txt
```

---

## What Happens

1. **Paper Scanning**:
   - Reads paper file (supports .md, .tex, .txt formats)
   - Extracts all potential data references using citation patterns
   - Handles different reference formats:
     - File paths: `data/raw/dataset.csv`
     - Labeled references: `file:data/raw/dataset.csv`
     - URL references: `https://example.com/data.csv`
     - Line citations: `data/raw/dataset.csv:line42`

2. **Reference Validation**:
   - Checks each referenced file exists in manifest
   - Verifies file hashes if available
   - Identifies missing or unregistered files
   - Flags external URLs (may be outside manifest scope)

3. **Orphaned Data Detection** (optional):
   - Scans manifest for registered files
   - Checks if each file is referenced in papers
   - Reports data files never cited anywhere
   - Suggests either removing data or citing it

4. **Citation Index Creation**:
   - Builds index of all citations and their locations
   - Records line numbers and context
   - Groups citations by file

5. **Report Generation**:
   - Summary: Total files referenced, verified, unresolved
   - Detailed list of all citations
   - Issues found (missing refs, unregistered files)
   - Recommendations for fixing issues

6. **Manifest Update** (optional):
   - Adds citations array to manifest (if `--update-manifest`)
   - Records verified citations with timestamps
   - Tracks which data appears in which papers

---

## Output Examples

### All citations verified:
```
✓ Citation Validation Complete
  Paper: paper/manuscript.md
  Total references: 12
  Verified: 12
  Unregistered: 0
  External: 0
  Status: ALL CITATIONS VERIFIED ✓

Verified Citations:
  ✓ data/raw/dataset.csv (line 23)
  ✓ data/raw/metrics.csv (line 45)
  ✓ data/cleaned/results.csv (line 78)
  ... (9 more verified)
```

### Issues found:
```
⚠ Citation Validation Complete (with issues)
  Paper: paper/manuscript.md
  Total references: 12
  Verified: 10
  Unregistered: 2
  External: 0

Unregistered References:
  ❌ data/raw/missing_dataset.csv (line 89)
     Status: FILE NOT IN MANIFEST
     Suggestion: Register file with /truth-verification:register

  ❌ results/analysis_output.csv (line 102)
     Status: FILE NOT IN MANIFEST
     Suggestion: Register file or correct citation

Orphaned Data (in manifest but not cited):
  ⚠ data/raw/old_backup.csv - Never cited in papers
     Suggestion: Remove if obsolete, or add citation if needed
```

---

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| "Paper file not found" | File path doesn't exist | Verify paper file location |
| "No citations found" | Paper has no data references | Check citation patterns match your format |
| "Invalid manifest" | `.truth/manifest.json` corrupted | Restore from backup or reinitialize |
| "Cannot read paper file" | Permission denied or corrupted file | Check file permissions |

---

## Success Indicators

After successful execution:

1. Command returns citation validation summary
2. All referenced files exist in manifest
3. If unresolved references found, displays suggestions for fixing them
4. Orphaned data identified (if `--report-orphaned-data`)
5. Citation index created in manifest (if `--update-manifest`)

---

## Citation Patterns

Supported formats:
- **File paths**: `data/raw/dataset.csv`
- **Labeled refs**: `data:raw/dataset.csv` or `file:data/raw/dataset.csv`
- **Line citations**: `data/raw/dataset.csv:42` (reference specific line)
- **Markdown links**: `[Dataset](data/raw/dataset.csv)`
- **LaTeX citations**: `\cite{data/raw/dataset.csv}`
- **URLs**: `https://example.com/data.csv`

Default patterns defined in `config/config.json`:
```json
"citation_patterns": [
  "file:path/to/file",
  "data/[a-zA-Z0-9_-]+\\.csv",
  "codes/[a-zA-Z0-9_-]+\\.py",
  "paper/figures/[a-zA-Z0-9_-]+\\.(png|jpg|pdf)"
]
```

---

## Strict Mode

In strict mode (`--strict-mode`):
- Command fails if any references unresolved
- Returns non-zero exit code
- Suitable for CI/CD pipelines and publication automation
- Forces all citations to be verified before proceeding

```bash
/truth-verification:cite-check --paper manuscript.md --strict-mode
# Returns error if any citations unverified
```

---

## Advanced Scenarios

### Check multiple papers:
```bash
/truth-verification:cite-check --directory paper/manuscripts --recursive
```

Validates all papers in directory and subdirectories.

### Cross-reference papers (data used in multiple papers):
```bash
/truth-verification:cite-check --directory paper/manuscripts \
  --cross-reference --report-data-usage
```

Shows which data files appear in which papers.

### Audit trail (when data was cited):
```bash
/truth-verification:cite-check --paper manuscript.md \
  --include-audit-trail
```

Records when each citation was first verified.

### Fix citations automatically:
```bash
/truth-verification:cite-check --paper manuscript.md \
  --auto-fix-paths
```

Attempts to find correctly spelled file paths and suggest corrections.

---

## Integration with verification workflow

**Complete validation workflow**:
```bash
# 1. Initialize
/truth-verification:init

# 2. Register all data
/truth-verification:register --recursive --dir data/

# 3. Track script execution
/truth-verification:track --script codes/analysis.py ...

# 4. Verify data integrity
/truth-verification:verify

# 5. Check paper citations
/truth-verification:cite-check --paper paper/manuscript.md --strict-mode

# 6. Generate reproducibility report
/truth-verification:reproduce --generate-report

# 7. Publish with confidence
```

---

## Next Steps

After validating citations:

1. **Fix unverified references**: Register missing files or correct citations
2. **Remove orphaned data**: Delete unused files or add citations
3. **Check reproducibility**: `/truth-verification:reproduce` to validate complete chain
4. **Generate audit**: `/truth-verification:audit` before publication
5. **Archive manifest**: Commit `.truth/` to version control with manuscript

---

## Related Commands

- `/truth-verification:register` - Register data files
- `/truth-verification:track` - Record script execution
- `/truth-verification:reproduce` - Validate reproducibility (Phase 3)
- `/truth-verification:audit` - Generate comprehensive audit reports (Phase 4)
- `/truth-verification:verify` - Check data integrity
