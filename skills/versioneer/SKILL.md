---
name: versioneer
description: Manage project versions with versioneer. Use this when users want to bump versions (major, minor, patch), sync version files, verify version consistency, or check version status across build systems.
---

# Versioneer Version Management

This skill provides access to version management through the `versioneer` CLI tool, which synchronizes VERSION files with build system version declarations.

## When to Use This Skill

- Bumping versions (major, minor, patch releases)
- Synchronizing version files across build systems
- Verifying version consistency
- Checking version status
- Resetting versions
- Checking versioneer health and configuration

## CLI Tool Location

The versioneer binary should be available in the system PATH at: `$HOME/.local/bin/versioneer`

Verify with:
```bash
which versioneer
versioneer --version
```

## What is Versioneer?

Versioneer is a tool that maintains version consistency across different build systems. It:
- Keeps a single source of truth in a `VERSION` file
- Synchronizes that version to build system files (Cargo.toml, pyproject.toml, package.json)
- Detects which build systems are present in a project
- Ensures all version declarations stay in sync

## Command Structure

```bash
versioneer <command> [options]
```

## Core Commands

### Show Current Version

Display the current version from the VERSION file:

```bash
# Show current version
versioneer show
```

**Output**: Just the version number (e.g., `1.2.3`)

**Use when**: Need to know what version the project is currently on

### Check Version Status

Show which build systems are detected and their current versions:

```bash
# Show detected build systems
versioneer status
```

**Output**: Lists detected files:
- Cargo.toml (Rust)
- pyproject.toml (Python)
- package.json (Node.js)

**Use when**: Need to see what build systems are present and if they're recognized

### Verify Synchronization

Check if all version files are synchronized:

```bash
# Verify all versions match
versioneer verify
```

**Output**:
- Success: No output (exit code 0)
- Failure: Lists files that are out of sync

**Use when**:
- Before creating releases
- After manual edits to version files
- In CI/CD pipelines as a quality gate
- Troubleshooting version mismatches

### Synchronize Versions

Synchronize all build system files to match the VERSION file:

```bash
# Sync all version files
versioneer sync
```

**What it does**:
1. Reads the VERSION file
2. Updates Cargo.toml (if present)
3. Updates pyproject.toml (if present)
4. Updates package.json (if present)

**Use when**:
- After manually editing VERSION file
- After bumping version with other tools
- Fixing out-of-sync versions
- Initializing a new project

**Important**: Always commit the changes after sync

### Check Health

Run health check to validate configuration:

```bash
# Check versioneer health
versioneer doctor
```

**Output shows**:
- ✅/❌ VERSION file status
- ✅/❌ Build system detection
- ✅/❌ Synchronization status
- ✅/❌ Update status

**Use when**:
- Troubleshooting issues
- Setting up new projects
- Verifying installation

## Version Bumping

Versioneer supports semantic versioning (MAJOR.MINOR.PATCH):

### Bump Patch Version

For bug fixes and minor changes (1.2.3 → 1.2.4):

```bash
# Bump patch version
versioneer patch
```

**When to use**:
- Bug fixes
- Documentation updates
- Small improvements
- No API changes

### Bump Minor Version

For new features, backwards-compatible (1.2.3 → 1.3.0):

```bash
# Bump minor version
versioneer minor
```

**When to use**:
- New features
- Backwards-compatible additions
- Significant improvements
- No breaking changes

### Bump Major Version

For breaking changes (1.2.3 → 2.0.0):

```bash
# Bump major version
versioneer major
```

**When to use**:
- Breaking API changes
- Major rewrites
- Incompatible changes
- New major milestone

### After Bumping

After any bump command:
1. VERSION file is updated
2. All build system files are automatically synced
3. Changes are ready to commit
4. Still need to create git tag manually or use release workflow

**Example bump workflow**:
```bash
# Bump version
versioneer patch

# Verify the change
versioneer show
# Output: 1.2.4

# Verify synchronization
versioneer verify

# Commit the changes
git add VERSION Cargo.toml Cargo.lock  # Include relevant files
git commit -m "chore: bump version to $(versioneer show)"

# Tag the release
git tag v$(versioneer show)

# Push tag
git push origin v$(versioneer show)
```

## Reset Version

Reset version to a specific value or to 0.0.0:

```bash
# Reset to 0.0.0
versioneer reset

# Reset to specific version
versioneer reset 2.0.0
```

**Use when**:
- Starting a new project
- Fixing incorrect version numbers
- Resetting after mistakes
- Testing version workflows

**Warning**: This overwrites the VERSION file and syncs all build systems

## Integration with Git Workflows

### Pre-commit Hook Pattern

Verify versions before commits:

```bash
# In pre-commit hook
versioneer verify || {
    echo "Error: Version files are out of sync"
    echo "Run 'versioneer sync' to fix"
    exit 1
}
```

### Pre-push Hook Pattern

Verify versions before pushing:

```bash
# In pre-push hook (via peter-hook or similar)
versioneer verify || {
    echo "Error: Version files out of sync"
    echo "Run 'versioneer sync' and commit"
    exit 1
}
```

### Release Workflow Pattern

Typical release workflow with versioneer:

```bash
# 1. Bump version
versioneer patch  # or minor, or major

# 2. Update dependencies (for Rust)
cargo update

# 3. Build and test
cargo build --release
cargo test

# 4. Commit version bump
git add VERSION Cargo.toml Cargo.lock
git commit -m "chore: bump version to $(versioneer show)"

# 5. Create and push tag
VERSION=$(versioneer show)
git tag v$VERSION
git push origin main
git push origin v$VERSION

# 6. CI/CD creates release automatically
```

### Justfile Integration

Common just recipes using versioneer:

```just
# Show current version
version:
    @versioneer show

# Verify versions are synced
verify:
    versioneer verify

# Bump patch version
bump-patch:
    versioneer patch
    @echo "Bumped to $(versioneer show)"

# Release workflow
release VERSION:
    #!/usr/bin/env bash
    set -euo pipefail

    # Verify clean working directory
    if [[ -n $(git status --porcelain) ]]; then
        echo "Error: Working directory not clean"
        exit 1
    fi

    # Verify version format
    if [[ ! "{{VERSION}}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Error: Version must be in format v1.2.3"
        exit 1
    fi

    # Extract version without 'v' prefix
    VERSION_NUM="${{VERSION}#v}"

    # Verify it matches current version
    CURRENT=$(versioneer show)
    if [[ "$VERSION_NUM" != "$CURRENT" ]]; then
        echo "Error: Requested version $VERSION_NUM doesn't match current $(versioneer show)"
        echo "Run 'versioneer patch/minor/major' first"
        exit 1
    fi

    # Verify versions are synced
    versioneer verify

    # Push tag
    git tag {{VERSION}}
    git push origin {{VERSION}}

    echo "✅ Released {{VERSION}}"
```

## Build System Support

Versioneer supports multiple build systems:

### Rust (Cargo.toml)

```toml
[package]
name = "my-project"
version = "1.2.3"  # Synchronized by versioneer
```

### Python (pyproject.toml)

```toml
[project]
name = "my-project"
version = "1.2.3"  # Synchronized by versioneer
```

### Node.js (package.json)

```json
{
  "name": "my-project",
  "version": "1.2.3"  # Synchronized by versioneer
}
```

### VERSION File

The single source of truth:

```
1.2.3
```

**Location**: Project root directory
**Format**: Plain text, just the version number
**No newlines**: Should be exactly "1.2.3" with no trailing newline

## Workflow Guidelines

### Before Bumping Version

1. **Verify current state**:
   ```bash
   versioneer show    # Know current version
   versioneer verify  # Ensure synced
   versioneer status  # See detected build systems
   ```

2. **Check working directory**:
   ```bash
   git status  # Should be clean
   ```

3. **Decide bump type**:
   - Patch: Bug fixes only
   - Minor: New features, no breaking changes
   - Major: Breaking changes

### After Bumping Version

1. **Verify the bump**:
   ```bash
   versioneer show    # Confirm new version
   versioneer verify  # Confirm sync
   ```

2. **Update lock files** (for package managers):
   ```bash
   cargo update    # Rust
   # or
   uv lock         # Python
   # or
   npm install     # Node.js
   ```

3. **Commit changes**:
   ```bash
   git add VERSION Cargo.toml Cargo.lock  # All affected files
   git commit -m "chore: bump version to $(versioneer show)"
   ```

4. **Create tag**:
   ```bash
   git tag v$(versioneer show)
   ```

5. **Push**:
   ```bash
   git push origin main
   git push origin v$(versioneer show)
   ```

### When Versions Are Out of Sync

If `versioneer verify` fails:

1. **Check which files are out of sync**:
   ```bash
   versioneer status
   cat VERSION
   grep version Cargo.toml  # or pyproject.toml, package.json
   ```

2. **Determine the correct version**:
   - VERSION file is the source of truth
   - If VERSION is wrong, edit it manually
   - If build system files are wrong, don't edit them

3. **Synchronize**:
   ```bash
   versioneer sync
   ```

4. **Verify fix**:
   ```bash
   versioneer verify
   ```

5. **Commit sync**:
   ```bash
   git add VERSION Cargo.toml  # etc.
   git commit -m "chore: sync version files to $(versioneer show)"
   ```

### Setting Up New Project

1. **Create VERSION file**:
   ```bash
   echo "0.1.0" > VERSION
   ```

2. **Sync to build systems**:
   ```bash
   versioneer sync
   ```

3. **Verify setup**:
   ```bash
   versioneer doctor
   versioneer verify
   ```

4. **Commit initial version**:
   ```bash
   git add VERSION Cargo.toml  # etc.
   git commit -m "chore: initialize version management"
   ```

## Best Practices

### Version Management Rules

1. **NEVER manually edit version in build system files** (Cargo.toml, pyproject.toml, package.json)
   - Always use `versioneer patch/minor/major`
   - Or edit VERSION file and run `versioneer sync`

2. **ALWAYS verify before tagging**:
   ```bash
   versioneer verify || exit 1
   git tag v$(versioneer show)
   ```

3. **ALWAYS use v prefix for git tags** (e.g., v1.2.3, not 1.2.3)

4. **NEVER create tags without version bump**:
   - Bump version first
   - Commit version bump
   - Then create tag

5. **ALWAYS commit version bumps separately**:
   - Don't mix version bumps with feature commits
   - Use "chore: bump version to X.Y.Z" commit message

### Semantic Versioning Guidelines

Follow semantic versioning strictly:

- **MAJOR**: Breaking changes, incompatible API changes
- **MINOR**: New features, backwards-compatible
- **PATCH**: Bug fixes, backwards-compatible

**Examples**:
- Fix typo in docs → `versioneer patch`
- Add new CLI flag → `versioneer minor`
- Remove deprecated function → `versioneer major`
- Fix crash bug → `versioneer patch`
- Add new optional parameter → `versioneer minor`
- Change required parameter type → `versioneer major`

### CI/CD Integration

**GitHub Actions validation**:
```yaml
- name: Verify version sync
  run: versioneer verify

- name: Check version matches tag
  if: startsWith(github.ref, 'refs/tags/')
  run: |
    TAG=${GITHUB_REF#refs/tags/v}
    VERSION=$(versioneer show)
    if [[ "$TAG" != "$VERSION" ]]; then
      echo "Error: Tag $TAG doesn't match version $VERSION"
      exit 1
    fi
```

### Git Hooks (via peter-hook or similar)

**Pre-commit hook**:
- Verify versions are synced
- Prevent commits if out of sync

**Pre-push hook**:
- Verify versions are synced
- Verify tag format if pushing tags
- Prevent push if verification fails

## Common Use Cases

### Preparing a Patch Release

```bash
# Verify current state
versioneer show
versioneer verify

# Bump patch version
versioneer patch

# New version is now 1.2.4 (was 1.2.3)
echo "New version: $(versioneer show)"

# Update lock files
cargo update

# Commit
git add VERSION Cargo.toml Cargo.lock
git commit -m "chore: bump version to $(versioneer show)"

# Tag
git tag v$(versioneer show)

# Push
git push origin main v$(versioneer show)
```

### Fixing Out-of-Sync Versions

```bash
# Check status
versioneer verify
# Error: Versions out of sync

# See what's detected
versioneer status
versioneer show  # Shows VERSION file content

# Check build system file
grep version Cargo.toml

# Sync VERSION to build systems
versioneer sync

# Verify fix
versioneer verify

# Commit
git add VERSION Cargo.toml
git commit -m "chore: sync version files"
```

### Starting a New Release

```bash
# Check what type of changes were made
git log --oneline v1.2.3..HEAD

# Decide: patch, minor, or major?
# Let's say minor (new features added)

versioneer minor

# Version is now 1.3.0
# Proceed with release workflow...
```

### Validating Before Tag Push

```bash
# Before pushing tag
versioneer verify || {
    echo "ERROR: Versions out of sync!"
    echo "Run 'versioneer sync' and commit"
    exit 1
}

# If verify passes, push tag
git push origin v$(versioneer show)
```

## Troubleshooting

### Command Not Found

```bash
# Check if installed
which versioneer

# Check version
versioneer --version

# If not found, install from:
# https://github.com/tftio/versioneer
```

### VERSION File Not Found

```bash
# Create VERSION file
echo "0.1.0" > VERSION

# Sync to build systems
versioneer sync
```

### Versions Out of Sync

```bash
# Run sync
versioneer sync

# If still failing, check:
versioneer doctor

# Manually check files
cat VERSION
grep version Cargo.toml
```

### Wrong Version After Bump

```bash
# Check current version
versioneer show

# If wrong, reset and bump again
versioneer reset 1.2.3  # Set to correct base
versioneer patch        # Bump to 1.2.4
```

### Build System Not Detected

```bash
# Check status
versioneer status

# Output: "No build system files detected"
# Solution: Ensure at least one exists:
# - Cargo.toml
# - pyproject.toml
# - package.json
```

### Doctor Reports Issues

```bash
versioneer doctor

# Follow the reported issues:
# - Create missing VERSION file
# - Add build system file (Cargo.toml, etc.)
# - Run versioneer sync
# - Verify with versioneer verify
```

## Examples

### Example 1: Typical Patch Release

```bash
# Current version: 1.2.3
$ versioneer show
1.2.3

# Bump patch
$ versioneer patch
Updated VERSION to 1.2.4
Synchronized Cargo.toml to 1.2.4

# Verify
$ versioneer verify
$ echo $?
0

# Commit and tag
$ git add VERSION Cargo.toml Cargo.lock
$ git commit -m "chore: bump version to 1.2.4"
$ git tag v1.2.4
$ git push origin main v1.2.4
```

### Example 2: Fixing Sync Issues

```bash
# Check sync
$ versioneer verify
Error: Version mismatch
VERSION: 1.2.3
Cargo.toml: 1.2.2

# Sync from VERSION (source of truth)
$ versioneer sync
Synchronized Cargo.toml to 1.2.3

# Verify fix
$ versioneer verify
$ echo $?
0

# Commit
$ git add Cargo.toml
$ git commit -m "chore: sync Cargo.toml to VERSION"
```

### Example 3: New Project Setup

```bash
# Create VERSION
$ echo "0.1.0" > VERSION

# Check what's detected
$ versioneer status
Detected build systems:
  - Cargo.toml

# Sync
$ versioneer sync
Synchronized Cargo.toml to 0.1.0

# Verify
$ versioneer verify
$ versioneer doctor
✅ Everything looks healthy!

# Commit
$ git add VERSION Cargo.toml
$ git commit -m "chore: initialize version management"
```

## Integration with Other Tools

### With Just (Task Runner)

Add versioneer commands to Justfile:

```just
# Show current version
version:
    @versioneer show

# Verify version sync
check:
    versioneer verify

# Bump patch
patch:
    versioneer patch

# Bump minor
minor:
    versioneer minor

# Bump major
major:
    versioneer major
```

### With Git Hooks

Configure peter-hook or similar:

```toml
# .peter.toml
[hooks.pre-push]
commands = [
    "versioneer verify"
]
```

### With CI/CD

```yaml
# .github/workflows/ci.yml
jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install versioneer
        run: |
          curl -fsSL https://raw.githubusercontent.com/tftio/versioneer/main/install.sh | sh
      - name: Verify versions
        run: versioneer verify
```

## Notes

- Versioneer is v2.0.3 as of October 2025
- VERSION file is the single source of truth
- Never manually edit versions in build system files
- Always verify before creating releases
- Use semantic versioning consistently
- Commit version bumps separately from features