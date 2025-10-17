---
name: peter-hook
description: Run and lint code using peter-hook git hooks manager. Use this when users want to run hooks manually, lint code against all files, validate hook configurations, check what hooks are available, or troubleshoot hook execution issues.
---

# Peter Hook Runtime Operations

This skill provides access to peter-hook runtime operations for running and linting code using configured git hooks.

## When to Use This Skill

- Running hooks manually against changed files (pre-commit, pre-push, etc.)
- Linting code by running hooks against all matching files
- Validating hook configurations
- Discovering what hooks are available
- Checking peter-hook health and configuration
- Troubleshooting hook execution issues
- Testing hook behavior with dry-run mode

## CLI Tool Location

The peter-hook binary should be available at: `$HOME/.local/bin/peter-hook` or in system PATH.

Verify with:
```bash
which peter-hook
peter-hook version
```

## What is Peter Hook?

Peter Hook is a hierarchical git hooks manager for monorepos that:
- Runs configured hooks from `hooks.toml` files
- Supports per-file hierarchical resolution (different paths can have different hooks)
- Enables intelligent file targeting (only run hooks for changed files)
- Provides lint mode for running hooks on all files in a directory
- Supports parallel execution where safe

## Core Runtime Commands

### Run Hooks (Git Event Mode)

Run hooks for a specific git event (pre-commit, pre-push, etc.) on changed files:

```bash
# Run hooks for pre-commit event (staged + working directory changes)
peter-hook run pre-commit

# Run on all files instead of only changed files
peter-hook run pre-commit --all-files

# Test what would run without executing (dry-run)
peter-hook run pre-commit --dry-run

# Run with debug output
peter-hook run pre-commit --debug

# Run hooks for other git events
peter-hook run pre-push
peter-hook run commit-msg .git/COMMIT_EDITMSG
peter-hook run post-commit
```

**How it works:**
1. Detects changed files from git
2. For each changed file, finds nearest `hooks.toml`
3. Runs hooks defined for that event from the relevant config
4. Only runs hooks whose file patterns match the changed files (unless `run_always = true`)

**When to use:**
- Before committing to catch issues early
- Before pushing to validate changes
- Testing hook behavior manually
- Debugging why hooks failed during git operations

**Output:**
- Shows each hook's execution status
- Displays stdout/stderr from failing hooks
- Reports overall pass/fail status

### Lint Mode (All Files)

Run hooks on **all matching files** in current directory and subdirectories:

```bash
# Run a hook in lint mode on all matching files
peter-hook lint <hook-name>

# Run with dry-run to see what would execute
peter-hook lint <hook-name> --dry-run

# Run with debug output
peter-hook lint <hook-name> --debug

# Examples
peter-hook lint ruff-check      # Run ruff on all .py files
peter-hook lint clippy           # Run clippy on all .rs files
peter-hook lint eslint           # Run eslint on all .js files
peter-hook lint format-check     # Check formatting on all files
```

**How lint mode differs from run:**
- Treats current directory as repository root (not git root)
- Discovers **all** non-ignored files matching patterns (not just changed)
- No git operations performed
- Respects `.gitignore` rules hierarchically

**Execution by hook type:**
- `per-file` (default): All files passed as arguments → `tool file1 file2 file3`
- `in-place`: Hook runs once in config directory → `pytest` (autodiscovery)
- `other`: Hook receives files via template variables (`{CHANGED_FILES}`, etc.)

**When to use:**
- Running formatters/linters on entire codebase
- Pre-CI validation of all files in a directory
- Cleaning up code quality across a project
- One-off checks without git operations
- Testing hooks against full file sets

**Example workflow:**
```bash
# Validate all Python files in current project
cd backend/
peter-hook lint ruff-check

# Format all Rust files
cd src/
peter-hook lint rust-format

# Run all hooks in a group
peter-hook lint pre-commit
```

### Validate Configuration

Validate hook configuration and check for errors:

```bash
# Basic validation
peter-hook validate

# Validate with import diagnostics
peter-hook validate --trace-imports

# Get JSON output (for programmatic use)
peter-hook validate --trace-imports --json

# Validate with debug output
peter-hook validate --debug
```

**What it checks:**
- TOML syntax validity
- Hook definition completeness (required fields)
- Group references (all included hooks exist)
- Dependency cycles
- Conflicting options (e.g., `files` + `run_always`)
- Import paths and overrides
- Template variable usage

**JSON output format:**
```json
{
  "imports": [
    {
      "file": "../hooks.lib.toml",
      "status": "success",
      "hooks_imported": ["rust-format", "rust-lint"]
    }
  ],
  "overrides": [
    {
      "name": "rust-lint",
      "original_source": "../hooks.lib.toml",
      "override_source": "./hooks.toml"
    }
  ],
  "cycles": [],
  "unused": []
}
```

**When to use:**
- After editing hooks.toml
- Before committing configuration changes
- Troubleshooting hook issues
- Understanding import merge order
- In CI/CD pipelines as quality gate

### Check Health

Run health check to validate peter-hook setup:

```bash
# Check health
peter-hook doctor

# With debug output
peter-hook doctor --debug
```

**Example output:**
```
🏥 peter-hook health check
==========================

Git Repository:
  ✅ Git repository found
  ✅ Git hooks installed

Configuration:
  ✅ hooks.toml found
  ✅ Configuration valid

Updates:
  ✅ Running latest version (v3.2.1)

✅ Everything looks healthy!
```

**What it checks:**
- Git repository detection
- hooks.toml file presence
- Configuration validity
- Git hooks installation status
- Version status

**When to use:**
- Troubleshooting hook issues
- Verifying setup after installation
- Diagnosing configuration problems
- Checking if hooks.toml exists

### List Available Hooks

List all hooks and groups defined in configuration:

```bash
# List hooks
peter-hook list

# With debug output
peter-hook list --debug
```

**Example output:**
```
Git hooks installed in this repository:
  - pre-commit
  - pre-push
  - commit-msg
```

**When to use:**
- Discovering what hooks are configured
- Checking what git events have hooks
- Verifying hook installation
- Understanding available lint targets

## Understanding hooks.toml Configuration

Peter Hook uses `hooks.toml` files to define hooks. Here's what you need to know for runtime operations:

### Hook Definition Structure

```toml
[hooks.hook-name]
command = "cargo clippy"                    # Command to run
description = "Run clippy linter"           # Description
modifies_repository = false                 # Safety flag (false = read-only, true = modifies files)
files = ["**/*.rs", "Cargo.toml"]          # File patterns (optional)
execution_type = "per-file"                 # How files are passed (per-file | in-place | other)
depends_on = ["format"]                     # Dependencies (optional)
run_always = false                          # Ignore file targeting (optional)
```

### Hook Groups

```toml
[groups.pre-commit]
includes = ["format", "lint", "test"]       # Hooks to run
execution = "parallel"                      # parallel | sequential | force-parallel
description = "Pre-commit validation"
```

### Execution Types

**`per-file` (default):**
- Files passed as command arguments
- Example: `eslint file1.js file2.js file3.js`
- Use for: linters, formatters, type checkers

**`in-place`:**
- Hook runs once in config directory
- Tool discovers files itself
- Example: `pytest` (finds test files), `jest`, `cargo test`
- Use for: test runners, tools with auto-discovery

**`other`:**
- Manual file handling via template variables
- Example: `custom-tool {CHANGED_FILES}`
- Use for: custom tools, scripts that need special file handling

### File Targeting

```toml
# Hook only runs if matching files changed
files = ["**/*.rs"]

# Hook always runs regardless of changes
run_always = true

# No files = always runs
# (no files field)
```

**Glob patterns:**
- `**/*.rs` - All .rs files recursively
- `*.toml` - TOML files in config directory
- `src/**/*.py` - Python files in src/
- `**/*.{js,ts}` - JavaScript or TypeScript files

### Template Variables

Available in commands, workdir, and env:

```toml
{HOOK_DIR}              # Directory containing hooks.toml
{REPO_ROOT}             # Git repository root
{WORKING_DIR}           # Current working directory
{PROJECT_NAME}          # Name of directory containing hooks.toml
{HOME_DIR}              # User's home directory
{CHANGED_FILES}         # Space-delimited changed files
{CHANGED_FILES_LIST}    # Newline-delimited changed files
{CHANGED_FILES_FILE}    # Path to temp file with changed files
```

## Common Workflows

### Running Hooks Before Commit

```bash
# Check what hooks would run
peter-hook list

# Run pre-commit hooks manually
peter-hook run pre-commit

# If issues found, fix and re-run
# ... make fixes ...
peter-hook run pre-commit

# Dry-run to see what would execute
peter-hook run pre-commit --dry-run
```

### Linting Entire Codebase

```bash
# Validate configuration first
peter-hook validate

# List available hooks
peter-hook list

# Run specific linter on all files
peter-hook lint rust-lint

# Run formatter on all files
peter-hook lint rust-format

# Run entire pre-commit suite on all files
peter-hook lint pre-commit
```

### Validating Hook Configuration Changes

```bash
# After editing hooks.toml
peter-hook validate

# Check import merge order and overrides
peter-hook validate --trace-imports

# Get structured diagnostics
peter-hook validate --trace-imports --json | jq .

# Test hooks without executing
peter-hook run pre-commit --dry-run
peter-hook lint clippy --dry-run
```

### Troubleshooting Hook Failures

```bash
# Check health
peter-hook doctor

# Validate configuration
peter-hook validate

# Run with debug output
peter-hook run pre-commit --debug

# Test individual hook in lint mode
peter-hook lint failing-hook

# Dry-run to see execution plan
peter-hook run pre-commit --dry-run
```

### Understanding File Targeting

```bash
# See what hooks would run for staged changes
peter-hook run pre-commit --dry-run

# Force all hooks to run regardless of files
peter-hook run pre-commit --all-files

# Run on all files for specific hook
peter-hook lint hook-name
```

## Hierarchical Hook Resolution

Peter Hook supports **per-file hierarchical resolution** - each changed file independently finds its nearest `hooks.toml`:

```
/monorepo/
├── hooks.toml                  # Defines: pre-push
└── backend/
    ├── hooks.toml              # Defines: pre-commit
    └── api/
        └── server.rs           # Modified file
```

**When running `pre-commit`:**
1. `server.rs` walks up to find nearest `hooks.toml` with pre-commit hooks
2. Finds `/monorepo/backend/hooks.toml`
3. Runs hooks from that config in `/monorepo/backend/` directory
4. Only runs hooks whose file patterns match the changed files

**When running `pre-push`:**
1. `server.rs` walks up to find nearest `hooks.toml` with pre-push hooks
2. Doesn't find it in `/monorepo/backend/hooks.toml`
3. Falls back to `/monorepo/hooks.toml`
4. Runs hooks from root config

**Benefits:**
- Different paths can have different quality standards
- Only relevant hooks run based on changed files
- Monorepo subprojects can have their own validation
- Gradual migration possible (add strict rules to new code only)

## Output and Exit Codes

**Exit codes:**
- `0` - All hooks passed
- `1` - One or more hooks failed
- `1` - Configuration validation failed

**Output format:**
- Shows which hooks are running
- Displays execution progress
- Reports stdout/stderr from failing hooks
- Summarizes final status

**Debug mode:**
```bash
peter-hook run pre-commit --debug
```
- Shows verbose execution details
- Displays file matching logic
- Shows template variable expansion
- Useful for troubleshooting

## Dry-Run Mode

Test what would run without executing:

```bash
# See what would run for pre-commit
peter-hook run pre-commit --dry-run

# See what files would be checked
peter-hook lint clippy --dry-run

# Output shows:
# - Which hooks would execute
# - What files match patterns
# - Execution order
# - No actual commands run
```

**When to use dry-run:**
- Understanding file targeting
- Verifying configuration changes
- Debugging why hooks run/don't run
- Testing new hook definitions
- Documentation of hook behavior

## Integration Patterns

### With Just (Task Runner)

```just
# Run pre-commit hooks
pre-commit:
    peter-hook run pre-commit

# Lint all files
lint:
    peter-hook lint pre-commit

# Validate configuration
validate:
    peter-hook validate --trace-imports
```

### With CI/CD

```yaml
# GitHub Actions
- name: Validate hooks
  run: peter-hook validate

- name: Run all hooks
  run: peter-hook run pre-commit --all-files
```

### With Other Tools

```bash
# Run hooks before git commit
git add -A
peter-hook run pre-commit && git commit -m "message"

# Format then lint
peter-hook lint format && peter-hook lint lint

# Validate before pushing
peter-hook validate && git push
```

## Troubleshooting

### Hook Not Running

```bash
# Check if hook is defined
peter-hook list

# Validate configuration
peter-hook validate

# Check file targeting with dry-run
peter-hook run pre-commit --dry-run

# Run with debug output
peter-hook run pre-commit --debug
```

### Configuration Invalid

```bash
# Validate and see errors
peter-hook validate

# Check import issues
peter-hook validate --trace-imports

# Get structured diagnostics
peter-hook validate --trace-imports --json | jq .
```

### Hook Execution Failed

```bash
# Run with debug output
peter-hook run pre-commit --debug

# Run individual hook in lint mode
peter-hook lint failing-hook

# Check if command exists
which <command>

# Verify file patterns match
peter-hook run pre-commit --dry-run
```

### No hooks.toml Found

```bash
# Check if file exists
ls -la hooks.toml

# Run doctor
peter-hook doctor

# Check if you're in the right directory
pwd
```

### Command Not Found

```bash
# Check if installed
which peter-hook

# Check version
peter-hook version

# Verify PATH
echo $PATH | grep -o "[^:]*\.local/bin"
```

## Examples

### Example 1: Running Pre-Commit Hooks

```bash
# See what's configured
$ peter-hook list
Git hooks installed in this repository:
  - pre-commit
  - pre-push

# Validate configuration
$ peter-hook validate
✓ Configuration is valid

# Run pre-commit hooks
$ peter-hook run pre-commit
Running hook: format-check... ✓
Running hook: clippy-check... ✓
Running hook: test-all... ✓
All hooks passed!

# Or dry-run first
$ peter-hook run pre-commit --dry-run
Would run hooks for pre-commit:
  - format-check (matches **/*.rs)
  - clippy-check (matches **/*.rs, Cargo.toml)
  - test-all (run_always = true)
```

### Example 2: Linting All Files

```bash
# Validate first
$ peter-hook validate
✓ Configuration is valid

# Run formatter on all Rust files
$ peter-hook lint rust-format
Running hook: rust-format
  Processing 45 files...
  Formatted 3 files
✓ Hook passed

# Run entire pre-commit suite on all files
$ peter-hook lint pre-commit
Running hook: format-check... ✓
Running hook: clippy-check... ✓
Running hook: test-all... ✓
All hooks passed!
```

### Example 3: Troubleshooting Hook Issues

```bash
# Check health
$ peter-hook doctor
🏥 peter-hook health check
==========================
Git Repository: ✅
Configuration: ✅
Updates: ✅

# Validate with diagnostics
$ peter-hook validate --trace-imports
✓ Configuration is valid
  Imports: ../hooks.lib.toml
  Overrides: rust-lint (local overrides imported)
  No cycles detected

# Test with dry-run
$ peter-hook run pre-commit --dry-run
Would run hooks for pre-commit:
  - format-check
  - clippy-check

# Run with debug
$ peter-hook run pre-commit --debug
[DEBUG] Resolved config: /repo/hooks.toml
[DEBUG] Changed files: src/lib.rs, Cargo.toml
[DEBUG] Hook 'format-check' matches files
...
```

### Example 4: Working with File Targeting

```bash
# See what would run for current changes
$ git status --short
M  src/lib.rs
M  README.md

$ peter-hook run pre-commit --dry-run
Would run hooks for pre-commit:
  - rust-format (matches src/lib.rs)
  - rust-lint (matches src/lib.rs)
  - rust-test (matches src/lib.rs)
  - security-scan (run_always = true)

# Note: No docs hooks run because only .rs files changed
# security-scan always runs regardless

# Force all hooks
$ peter-hook run pre-commit --all-files
# Runs ALL hooks regardless of changed files
```

## Notes

- Peter Hook version 3.2.1 as of October 2025
- Configuration file: `hooks.toml` in repository
- Hierarchical resolution: each file finds nearest config
- File targeting: hooks only run if patterns match (unless `run_always = true`)
- Parallel execution: read-only hooks run in parallel, modifying hooks run sequentially
- Template variables use `{VAR}` syntax (not `${VAR}` - changed in v3.0.0)
- Lint mode treats current directory as root
- JSON output available for validation diagnostics

## Best Practices

### Running Hooks

1. **Validate before running**: `peter-hook validate` catches config errors
2. **Use dry-run**: Test with `--dry-run` to understand execution
3. **Debug when needed**: Add `--debug` for troubleshooting
4. **Run manually before commit**: Catch issues early with `peter-hook run pre-commit`

### Linting

1. **Lint before CI**: Run `peter-hook lint` on all files before pushing
2. **Target specific paths**: `cd` to subdirectory and lint from there
3. **Test hooks individually**: `peter-hook lint hook-name` for focused checks
4. **Use dry-run**: See what files would be checked before executing

### Configuration Validation

1. **Validate after changes**: Always run `peter-hook validate` after editing hooks.toml
2. **Check imports**: Use `--trace-imports` to understand merge order
3. **Use JSON output**: Parse structured diagnostics with `jq` in scripts
4. **Test with dry-run**: Verify hooks run as expected before committing config

### Troubleshooting

1. **Start with doctor**: Run `peter-hook doctor` for health check
2. **Validate config**: Run `peter-hook validate` to catch errors
3. **Use debug mode**: Add `--debug` to see detailed execution
4. **Test individually**: Run hooks one at a time to isolate issues
5. **Check file targeting**: Use `--dry-run` to see file matching logic
