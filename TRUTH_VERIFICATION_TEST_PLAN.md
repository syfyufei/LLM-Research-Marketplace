# truth-verification (v0.1.0) Phase 1 Testing Plan

This document outlines all test cases for the truth-verification skill v0.1.0 release, focusing on core functionality: initialization, data registration with SHA256 hashing, integrity verification, and status reporting.

## Test Environment Setup

```bash
cd /Users/adriansun/Documents/GitHub/LLM-Research-Marketplace
# Marketplace is already installed from previous v3.0.0 setup
```

## Test Cases

### Test 1: Marketplace Discovery and Plugin Installation
**Objective**: Verify truth-verification plugin is discoverable and installable from the marketplace

**Steps**:
```bash
/plugin marketplace search LLM-Research-Marketplace
/plugin install truth-verification@LLM-Research-Marketplace
/plugin list
/help | grep truth-verification
```

**Expected Results**:
- Marketplace search shows "truth-verification" (v0.1.0)
- Plugin installs successfully
- `/plugin list` shows "truth-verification" as installed
- `/help` displays 8 truth-verification commands:
  - truth-verification:init
  - truth-verification:register
  - truth-verification:track
  - truth-verification:verify
  - truth-verification:cite-check
  - truth-verification:reproduce
  - truth-verification:audit
  - truth-verification:status

**Status**: ⏳ Pending

---

### Test 2: Initialize .truth/ Infrastructure
**Objective**: Verify `/truth-verification:init` creates required directory structure and manifest

**Steps**:
```bash
mkdir -p /tmp/test-truth-verification && cd /tmp/test-truth-verification

# Create project structure
mkdir -p data/raw data/cleaned codes paper/figures paper/manuscripts memory

# Initialize truth-verification
/truth-verification:init

# Verify structure
ls -la .truth/
cat .truth/manifest.json | jq .
cat .gitignore | grep .truth
```

**Expected Results**:
- `.truth/` directory created with subdirectories:
  - `.truth/manifest.json` - Empty manifest with valid JSON structure
  - `.truth/hashes/` - Directory for hash storage
  - `.truth/logs/` - Directory for execution logs
  - `.truth/reports/` - Directory for generated reports
- `.gitignore` includes `.truth/` line
- Manifest contains:
  - `version`: "1.0.0"
  - `initialized_at`: Valid ISO timestamp
  - Empty `data_sources`, `analysis_scripts`, `results` arrays
  - `integrity_status` field

**Status**: ⏳ Pending

---

### Test 3: Register Data Files with SHA256 Hashing
**Objective**: Verify `/truth-verification:register` computes hashes and updates manifest

**Steps**:
```bash
cd /tmp/test-truth-verification

# Create test data files
echo "id,value,category\n1,100,A\n2,200,B\n3,300,A" > data/raw/dataset.csv
echo "x,y\n1,5\n2,10" > data/raw/metrics.csv

# Register files
/truth-verification:register --recursive --dir data/raw

# Verify registration
cat .truth/manifest.json | jq '.data_sources | length'
cat .truth/manifest.json | jq '.data_sources[0]'
ls .truth/hashes/
```

**Expected Results**:
- Command outputs: "Registered 2 files"
- Manifest now contains 2 entries in `data_sources`:
  - Each entry has:
    - `path`: File path (e.g., "data/raw/dataset.csv")
    - `hash_sha256`: Valid SHA256 hash (64 hex characters)
    - `size_bytes`: File size in bytes
    - `registered_at`: ISO timestamp
    - `integrity_status`: "verified"
- Hash files created:
  - `.truth/hashes/data_raw_dataset.csv.sha256`
  - `.truth/hashes/data_raw_metrics.csv.sha256`
- Log entry in `.truth/logs/register.log`

**Status**: ⏳ Pending

---

### Test 4: Verify Data Integrity (Unmodified Files)
**Objective**: Verify `/truth-verification:verify` confirms unchanged files

**Steps**:
```bash
cd /tmp/test-truth-verification

# Verify immediately after registration (files unchanged)
/truth-verification:verify

# Check manifest updates
cat .truth/manifest.json | jq '.data_sources[0].last_verified'
cat .truth/manifest.json | jq '.integrity_status'
```

**Expected Results**:
- Output shows: "Files verified: 2, Files modified: 0, Files missing: 0"
- Status: "ALL DATA INTEGRITY VERIFIED ✓"
- Manifest updated:
  - `last_verified` timestamps set for all files
  - `integrity_status.overall_status`: "verified"
  - `integrity_status.files_verified`: 2
  - `integrity_status.files_with_issues`: 0

**Status**: ⏳ Pending

---

### Test 5: Detect File Modifications
**Objective**: Verify `/truth-verification:verify` detects when registered files are modified

**Steps**:
```bash
cd /tmp/test-truth-verification

# Modify a registered file
echo "id,value,category\n1,100,A\n2,200,B\n3,300,A\n4,400,C" >> data/raw/dataset.csv

# Verify (should detect modification)
/truth-verification:verify

# Check detailed output
/truth-verification:verify --report-format detailed
```

**Expected Results**:
- Output shows: "Files verified: 2, Files modified: 1, Files missing: 0"
- Status: "INTEGRITY ISSUES DETECTED"
- Listed as modified:
  - `data/raw/dataset.csv`: MODIFIED (hash mismatch)
  - Shows expected hash vs. current hash
  - Shows modification time
- `data/raw/metrics.csv`: VERIFIED (unchanged)
- Manifest updated:
  - `integrity_status.files_with_issues`: 1
  - `integrity_status.overall_status`: "modified"

**Status**: ⏳ Pending

---

### Test 6: View Status Dashboard
**Objective**: Verify `/truth-verification:status` displays project health summary

**Steps**:
```bash
cd /tmp/test-truth-verification

# Restore modified file first
git checkout data/raw/dataset.csv 2>/dev/null || echo "id,value,category\n1,100,A\n2,200,B\n3,300,A" > data/raw/dataset.csv

# View status
/truth-verification:status

# Get detailed status
/truth-verification:status --detail-level full
```

**Expected Results**:
- Displays dashboard with:
  - Project name and location
  - Overall status: ✓ HEALTHY (once file is restored)
  - Data Sources section:
    - Registered files: 2
    - Total size: (actual combined size)
    - Integrity status: ✓ All verified
    - Last verification timestamp
  - Analysis Scripts: 0 (none tracked yet)
  - Results: 0 (none tracked yet)
  - Dependencies: 0 (none tracked yet)
  - Integration status: research-memory (not configured), project-management (not configured)
  - Recommendations section

**Status**: ⏳ Pending

---

### Test 7: Single File Registration and Verification
**Objective**: Verify workflow for registering and verifying individual files

**Steps**:
```bash
cd /tmp/test-truth-verification

# Create a new data file
echo "timestamp,value\n2025-12-15T10:00:00Z,42.5\n2025-12-15T11:00:00Z,43.2" > data/raw/timeseries.csv

# Register single file
/truth-verification:register --file data/raw/timeseries.csv

# Verify single file
/truth-verification:verify --file data/raw/timeseries.csv

# Verify all files
/truth-verification:verify
```

**Expected Results**:
- Single file registration: "Registered 1 file"
- Single file verification: "Files verified: 1, Files modified: 0"
- All files verification: "Files verified: 3" (original 2 + new 1)
- Manifest contains 3 entries in `data_sources`

**Status**: ⏳ Pending

---

### Test 8: Manifest Integrity
**Objective**: Verify manifest.json structure and JSON validity

**Steps**:
```bash
cd /tmp/test-truth-verification

# Validate JSON structure
cat .truth/manifest.json | jq . > /dev/null && echo "✓ Valid JSON"

# Check required fields
cat .truth/manifest.json | jq 'keys'

# Check schema
cat .truth/manifest.json | jq '.version'
cat .truth/manifest.json | jq '.data_sources | map(.hash_sha256) | length'
cat .truth/manifest.json | jq '.integrity_status.overall_status'
```

**Expected Results**:
- Manifest is valid JSON (no parsing errors)
- Required top-level fields present:
  - `version`
  - `manifest_schema_version`
  - `initialized_at`
  - `last_updated`
  - `project_root`
  - `data_sources`
  - `analysis_scripts`
  - `results`
  - `dependencies`
  - `verification_log`
  - `integrity_status`
  - `metadata`
- Each registered file has required fields:
  - `path`, `hash_sha256`, `size_bytes`, `registered_at`

**Status**: ⏳ Pending

---

### Test 9: Error Handling - Missing Manifest
**Objective**: Verify graceful handling when .truth/ doesn't exist

**Steps**:
```bash
mkdir -p /tmp/test-truth-verification-2 && cd /tmp/test-truth-verification-2

# Try to verify without initializing
/truth-verification:verify 2>&1 || true

# Try to register without initializing
/truth-verification:register --file data/test.csv 2>&1 || true

# Now initialize and retry
/truth-verification:init
/truth-verification:register --file data/test.csv
```

**Expected Results**:
- First verify attempt: Error message directing user to run `/truth-verification:init`
- First register attempt: Error message or auto-initialization
- After init, operations succeed

**Status**: ⏳ Pending

---

### Test 10: Dry-run Mode
**Objective**: Verify `--dry-run` option shows what would happen without committing

**Steps**:
```bash
cd /tmp/test-truth-verification

# Create new files
echo "data1" > data/raw/file1.txt
echo "data2" > data/raw/file2.txt

# Dry run registration
/truth-verification:register --recursive --dir data/raw --dry-run

# Verify files NOT added to manifest
cat .truth/manifest.json | jq '.data_sources | map(.path)' | grep -q "file1.txt" && echo "ERROR: Files added in dry-run" || echo "✓ Dry-run didn't modify manifest"

# Actually register
/truth-verification:register --recursive --dir data/raw

# Verify files NOW added
cat .truth/manifest.json | jq '.data_sources | map(.path)' | grep "file1.txt"
```

**Expected Results**:
- Dry-run shows preview: "Would register 2 files (file1.txt, file2.txt)"
- Manifest unchanged after dry-run
- Actual registration adds files to manifest
- Final verify shows all files

**Status**: ⏳ Pending

---

## Test Execution Summary

| Test Case | Expected | Actual | Status |
|-----------|----------|--------|--------|
| Test 1: Plugin Discovery | Plugin discoverable and installs | | ⏳ |
| Test 2: Initialize | .truth/ directory created with manifest | | ⏳ |
| Test 3: Register Files | Files registered with SHA256 hashes | | ⏳ |
| Test 4: Verify Success | All files verified (unchanged) | | ⏳ |
| Test 5: Detect Modifications | Modified files detected | | ⏳ |
| Test 6: Status Dashboard | Dashboard displays project health | | ⏳ |
| Test 7: Single File Ops | Individual file registration/verification | | ⏳ |
| Test 8: Manifest Structure | JSON valid, all fields present | | ⏳ |
| Test 9: Error Handling | Graceful errors when not initialized | | ⏳ |
| Test 10: Dry-run Mode | Preview mode works without commits | | ⏳ |

**Overall Status**: ⏳ Pending

---

## Success Criteria

✅ All 10 test cases pass
✅ Plugin installs without "llm-research" conflicts
✅ All 5 Phase 1 commands functional (init, register, verify, status, + skeletons)
✅ Manifest follows template structure
✅ SHA256 hashes computed correctly
✅ File modifications reliably detected
✅ Status dashboard displays all statistics
✅ Error messages are helpful and actionable
✅ Dry-run mode doesn't modify manifest
✅ All JSON structures valid

---

## Phase 1 Command Availability

Fully implemented and testable:
- ✅ `/truth-verification:init` - Initialize infrastructure
- ✅ `/truth-verification:register` - Register data files with hashing
- ✅ `/truth-verification:verify` - Check data integrity
- ✅ `/truth-verification:status` - Display status dashboard

Skeleton implementations (Phase 2-4):
- ⏳ `/truth-verification:track` - Record script execution (Phase 2)
- ⏳ `/truth-verification:cite-check` - Validate citations (Phase 3)
- ⏳ `/truth-verification:reproduce` - Check reproducibility (Phase 3)
- ⏳ `/truth-verification:audit` - Generate audit reports (Phase 4)

---

## Next Steps

1. Execute all 10 test cases in live Claude Code environment
2. Document any bugs or issues encountered
3. Record actual vs. expected results in summary table
4. If all tests pass, prepare for Phase 2 implementation (track command)
5. If issues found, log as GitHub issues or plan fixes

---

## Notes

- Tests use `/tmp/test-truth-verification` for isolated testing
- Clean up after testing: `rm -rf /tmp/test-truth-verification*`
- All tests can be run in sequence without side effects
- Manual verification of hash values recommended to validate SHA256 correctness
- Status command output may vary based on research-memory/project-management integration status

