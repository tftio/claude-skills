# Versioneer Examples

This directory contains example outputs and workflows for the versioneer skill.

## Purpose

These examples help Claude understand:
- What versioneer commands output
- Common version management workflows
- Error messages and troubleshooting
- Integration patterns with git, CI/CD, and task runners

## Command Outputs

### Show Current Version

```bash
$ versioneer show
1.2.3
```

Simple output - just the version number. Useful for:
- Scripting: `VERSION=$(versioneer show)`
- Display: `echo "Current: $(versioneer show)"`
- Comparisons: Check against git tags

### Status Check

```bash
$ versioneer status
Detected build systems:
  - Cargo.toml
  - pyproject.toml

Current versions:
  VERSION:       1.2.3
  Cargo.toml:    1.2.3
  pyproject.toml: 1.2.3
```

Shows:
- Which build system files are detected
- Current version in each file
- Useful for understanding project setup

### Health Check (Success)

```bash
$ versioneer doctor
🏥 versioneer health check
==========================

Version Files:
  ✅ VERSION file: /path/to/project/VERSION

Build Systems:
  ✅ Cargo.toml detected (version: 1.2.3)
  ✅ pyproject.toml detected (version: 1.2.3)

Synchronization:
  ✅ All version files are synchronized

Updates:
  ✅ Running latest version (v2.0.3)

✨ Everything looks healthy!
```

### Health Check (Issues Found)

```bash
$ versioneer doctor
🏥 versioneer health check
==========================

Version Files:
  ❌ VERSION file error: File not found at /path/to/project/VERSION

Build Systems:
  ❌ No build system files detected
  ℹ️  At least one build system file (Cargo.toml, pyproject.toml, package.json) is required

Synchronization:
  ❌ Versions are out of sync
  ℹ️  VERSION: 1.2.3, Cargo.toml: 1.2.2

Updates:
  ✅ Running latest version (v2.0.3)

❌ Issues found - see above for details
```

### Verify Success

```bash
$ versioneer verify
$ echo $?
0
```

No output when successful - just exits with 0.

### Verify Failure

```bash
$ versioneer verify
Error: Version files are out of sync
  VERSION:       1.2.3
  Cargo.toml:    1.2.2
  pyproject.toml: 1.2.3

Run 'versioneer sync' to synchronize
$ echo $?
1
```

Shows which files are out of sync and suggests fix.

### Sync Operation

```bash
$ versioneer sync
Reading VERSION: 1.2.3
Synchronized Cargo.toml to 1.2.3
Synchronized pyproject.toml to 1.2.3
```

Shows each file that was updated.

### Version Bumps

```bash
$ versioneer patch
Updated VERSION: 1.2.3 → 1.2.4
Synchronized Cargo.toml to 1.2.4
Synchronized pyproject.toml to 1.2.4

$ versioneer minor
Updated VERSION: 1.2.4 → 1.3.0
Synchronized Cargo.toml to 1.3.0
Synchronized pyproject.toml to 1.3.0

$ versioneer major
Updated VERSION: 1.3.0 → 2.0.0
Synchronized Cargo.toml to 2.0.0
Synchronized pyproject.toml to 2.0.0
```

### Reset Operation

```bash
$ versioneer reset 0.1.0
Reset VERSION to 0.1.0
Synchronized Cargo.toml to 0.1.0
Synchronized pyproject.toml to 0.1.0
```

## Workflow Examples

### Example 1: Simple Patch Release

Complete workflow for a patch release:

```bash
# Check current state
$ versioneer show
1.2.3

$ versioneer verify
$ echo $?
0

# Bump patch version
$ versioneer patch
Updated VERSION: 1.2.3 → 1.2.4
Synchronized Cargo.toml to 1.2.4

# Update lock files (Rust example)
$ cargo update
    Updating crates.io index
    Updating Cargo.lock

# Commit changes
$ git status
On branch main
Changes not staged for commit:
  modified:   VERSION
  modified:   Cargo.toml
  modified:   Cargo.lock

$ git add VERSION Cargo.toml Cargo.lock
$ git commit -m "chore: bump version to 1.2.4"
[main abc1234] chore: bump version to 1.2.4
 3 files changed, 3 insertions(+), 3 deletions(-)

# Create and push tag
$ git tag v1.2.4
$ git push origin main
$ git push origin v1.2.4
```

### Example 2: Fixing Out-of-Sync Versions

When versions don't match:

```bash
# Discover the problem
$ versioneer verify
Error: Version files are out of sync
  VERSION:       1.2.3
  Cargo.toml:    1.2.2
  pyproject.toml: 1.2.3

# Check status for more detail
$ versioneer status
Detected build systems:
  - Cargo.toml
  - pyproject.toml

Current versions:
  VERSION:       1.2.3  ← Source of truth
  Cargo.toml:    1.2.2  ← Out of sync
  pyproject.toml: 1.2.3

# Sync from VERSION file
$ versioneer sync
Reading VERSION: 1.2.3
Synchronized Cargo.toml to 1.2.3
No change needed for pyproject.toml (already 1.2.3)

# Verify fix
$ versioneer verify
$ echo $?
0

# Commit the sync
$ git add Cargo.toml
$ git commit -m "chore: sync Cargo.toml to VERSION"
```

### Example 3: New Project Setup

Setting up version management in a new project:

```bash
# Initial state - no VERSION file
$ versioneer doctor
🏥 versioneer health check
==========================

Version Files:
  ❌ VERSION file error: File not found

Build Systems:
  ✅ Cargo.toml detected (version: 0.1.0)

Synchronization:
  ❌ Cannot verify - VERSION file missing

# Create VERSION file
$ echo "0.1.0" > VERSION

# Sync to build systems
$ versioneer sync
Reading VERSION: 0.1.0
Synchronized Cargo.toml to 0.1.0

# Verify setup
$ versioneer doctor
🏥 versioneer health check
==========================

Version Files:
  ✅ VERSION file: /path/to/project/VERSION

Build Systems:
  ✅ Cargo.toml detected (version: 0.1.0)

Synchronization:
  ✅ All version files are synchronized

✨ Everything looks healthy!

# Commit initial setup
$ git add VERSION Cargo.toml
$ git commit -m "chore: initialize version management with versioneer"
```

### Example 4: Pre-push Hook Validation

Git hook catching version sync issues:

```bash
$ git push origin main
Running pre-push hook...
Verifying version sync...

Error: Version files are out of sync
  VERSION:       1.3.0
  Cargo.toml:    1.2.4

Run 'versioneer sync' and commit the changes
error: failed to push some refs to 'origin'

# Fix the issue
$ versioneer sync
Reading VERSION: 1.3.0
Synchronized Cargo.toml to 1.3.0

$ git add Cargo.toml
$ git commit -m "chore: sync Cargo.toml to VERSION"

# Now push succeeds
$ git push origin main
Running pre-push hook...
Verifying version sync...
✅ Version files synchronized

Everything up-to-date
```

### Example 5: CI/CD Validation

GitHub Actions checking version consistency:

```yaml
# .github/workflows/ci.yml
- name: Verify version sync
  run: |
    versioneer verify || {
      echo "::error::Version files out of sync"
      echo "Run 'versioneer sync' locally and commit"
      exit 1
    }

- name: Verify tag matches version
  if: startsWith(github.ref, 'refs/tags/v')
  run: |
    TAG_VERSION=${GITHUB_REF#refs/tags/v}
    FILE_VERSION=$(versioneer show)

    if [[ "$TAG_VERSION" != "$FILE_VERSION" ]]; then
      echo "::error::Tag v$TAG_VERSION doesn't match VERSION $FILE_VERSION"
      exit 1
    fi

    echo "✅ Tag matches version: $FILE_VERSION"
```

Output when versions match:
```
Run versioneer verify
✅ Version files synchronized

Run TAG_VERSION=1.2.4
✅ Tag matches version: 1.2.4
```

Output when versions don't match:
```
Run versioneer verify
Error: Version files are out of sync
  VERSION:       1.2.4
  Cargo.toml:    1.2.3

::error::Version files out of sync
Run 'versioneer sync' locally and commit
Error: Process completed with exit code 1
```

### Example 6: Justfile Integration

Using versioneer in task automation:

```just
# Justfile

# Show current version
version:
    @versioneer show

# Verify versions are synced
verify:
    versioneer verify

# Bump patch version
bump-patch:
    versioneer patch
    cargo update
    git add VERSION Cargo.toml Cargo.lock
    git commit -m "chore: bump version to $(versioneer show)"

# Full release workflow
release VERSION:
    #!/usr/bin/env bash
    set -euo pipefail

    # Verify clean working tree
    if [[ -n $(git status --porcelain) ]]; then
        echo "Error: Working directory not clean"
        exit 1
    fi

    # Verify version format (v1.2.3)
    if [[ ! "{{VERSION}}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Error: Version must be v1.2.3 format"
        exit 1
    fi

    # Check version matches
    VERSION_NUM="${{VERSION}#v}"
    CURRENT=$(versioneer show)

    if [[ "$VERSION_NUM" != "$CURRENT" ]]; then
        echo "Error: Tag $VERSION_NUM != current $CURRENT"
        echo "Run 'just bump-patch' or similar first"
        exit 1
    fi

    # Verify sync
    versioneer verify

    # Create and push tag
    git tag {{VERSION}}
    git push origin main {{VERSION}}

    echo "✅ Released {{VERSION}}"
```

Running these commands:

```bash
$ just version
1.2.3

$ just verify
$ echo $?
0

$ just bump-patch
Updated VERSION: 1.2.3 → 1.2.4
Synchronized Cargo.toml to 1.2.4
    Updating crates.io index
    Updating Cargo.lock
[main def5678] chore: bump version to 1.2.4
 3 files changed, 3 insertions(+), 3 deletions(-)

$ just release v1.2.4
✅ Released v1.2.4
```

## Error Scenarios

### Missing VERSION File

```bash
$ versioneer show
Error: VERSION file not found at /path/to/project/VERSION

Create a VERSION file with the desired version:
  echo "0.1.0" > VERSION

Then sync to build systems:
  versioneer sync
```

### No Build Systems Detected

```bash
$ versioneer status
Error: No build system files detected

At least one of these files is required:
  - Cargo.toml (Rust)
  - pyproject.toml (Python)
  - package.json (Node.js)

Create one of these files before using versioneer
```

### Version Format Error

```bash
$ versioneer reset invalid
Error: Invalid version format: invalid

Version must be in format: MAJOR.MINOR.PATCH
Examples:
  - 1.0.0
  - 0.1.0
  - 2.3.4
```

## Integration Patterns

### Pattern 1: Manual Release

Developer-driven release:
1. `versioneer patch` (or minor/major)
2. `cargo update` (update lock files)
3. `git add` + `git commit`
4. `git tag v$(versioneer show)`
5. `git push` (triggers CI/CD)

### Pattern 2: Automated Release via Just

Using just recipe:
1. `just bump-patch` (bumps, commits)
2. `just release v$(versioneer show)` (tags, pushes)
3. CI/CD handles rest

### Pattern 3: Validation-First

Prevent issues with hooks:
1. Pre-commit: `versioneer verify`
2. Pre-push: `versioneer verify`
3. CI: `versioneer verify`
4. CI: Tag version matches file version

### Pattern 4: Monorepo Workspace

For projects with multiple packages:
- Each package has its own VERSION file
- Each has its own build system file
- Run versioneer in each package directory
- Coordinate versions manually or with workspace scripts

## Common Mistakes

### Mistake 1: Editing Build System Version Directly

```bash
# ❌ WRONG
$ vim Cargo.toml  # Manually change version to 1.2.4

# ✅ RIGHT
$ versioneer patch  # Automatically updates VERSION and Cargo.toml
```

### Mistake 2: Creating Tag Without Bump

```bash
# ❌ WRONG
$ git tag v1.2.4  # Tag doesn't match VERSION file (still 1.2.3)

# ✅ RIGHT
$ versioneer patch      # Now VERSION is 1.2.4
$ git add VERSION Cargo.toml
$ git commit -m "chore: bump version to 1.2.4"
$ git tag v1.2.4
```

### Mistake 3: Forgetting to Verify

```bash
# ❌ WRONG (may push mismatched versions)
$ versioneer patch
$ git push origin v1.2.4

# ✅ RIGHT
$ versioneer patch
$ versioneer verify  # Ensure all synced
$ git commit ...
$ git push origin v1.2.4
```

### Mistake 4: Not Updating Lock Files

```bash
# ❌ INCOMPLETE
$ versioneer patch
$ git add VERSION Cargo.toml
$ git commit -m "bump"
# Cargo.lock still has old version!

# ✅ COMPLETE
$ versioneer patch
$ cargo update  # Update lock file
$ git add VERSION Cargo.toml Cargo.lock
$ git commit -m "chore: bump version to $(versioneer show)"
```

## Notes

- All examples use Rust (Cargo.toml) for consistency
- Python would use `uv lock` instead of `cargo update`
- Node.js would use `npm install` instead of `cargo update`
- Always commit version changes separately from feature changes
- Use semantic versioning consistently
- Verify before pushing tags
