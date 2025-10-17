---
name: prompt
description: Load prompter profiles to incorporate engineering standards and guidelines into the current session. Use this when asked to "load prompt", "use prompter profile", "apply standards from prompter", or "check against prompter rules".
---

# Prompter Integration

This skill integrates the `prompter` CLI tool to load modular instruction sets (prompts) from a curated library into the current Claude session.

## When to Use This Skill

- User requests to load a specific prompter profile ("load the planning prompt", "use the rust CLI standards")
- User wants to apply engineering standards mid-session ("follow the backend guidelines")
- User asks what prompter profiles are available
- User wants to check work against defined standards
- User needs to look up specific rules or patterns

## What is Prompter?

`prompter` is a CLI tool that maintains a library of modular instruction fragments (in `~/.local/prompter/library/`) and combines them into profiles for different development workflows (configured in `~/.config/prompter/config.toml`).

**Key concept**: Prompter was designed to generate initial prompts for LLM sessions. This skill allows using those instructions mid-session, which is non-standard but useful for incorporating standards on-demand.

## Command Structure

```bash
# List available profiles
prompter list

# Render a profile (outputs instruction set)
prompter run <profile-name>

# Shorthand (equivalent to run)
prompter <profile-name>

# Check tool health
prompter doctor

# Validate configuration
prompter validate
```

## Primary Capability: Load Profile Instructions

### Listing Available Profiles

Always start by showing available profiles:

```bash
# List all profiles
prompter list
```

Common profiles include:
- `planning` - Plan creation with TODO tracking
- `full-stack.backend` - Python/database backend development
- `full-stack.python` - Python development (no database)
- `cli.rust` - Rust CLI tool development
- `cli.rust.full` - Rust CLI with full quality tooling
- `execute-plan.python-backend` - Execute Python backend plans
- `execute-plan.rust-cli` - Execute Rust CLI plans
- `devops.architecture` - Infrastructure architecture
- `rust.full` - Complete Rust development stack
- `python.full` - Complete Python development stack

### Loading a Profile

When user requests a profile:

```bash
# Load profile instructions
prompter run planning

# Shorthand works too
prompter planning
```

**After loading:**
1. Read the output (can be large - 100s to 1000s of lines)
2. Summarize the key rules and standards for the user
3. Incorporate the instructions as working guidance for subsequent tasks
4. Be mindful of token usage - consider summarizing lengthy sections

### Important Notes

**Token Usage Warning:**
- Prompter outputs can be very large (1000+ lines for complex profiles)
- Each profile includes multiple markdown fragments
- Consider summarizing key sections rather than including all verbatim

**Instruction Precedence:**
- Prompter instructions supplement Claude's base capabilities
- If conflicts arise, clarify with the user
- User's explicit instructions take precedence over loaded profiles

**Session Context:**
- Prompter output starts with "You are an LLM coding agent..." - this is meant for session start
- When used mid-session, treat as additional guidance, not session initialization
- Acknowledge that this is non-standard usage

## Secondary Capability: Query for Specific Guidance

Instead of loading entire profiles, search for specific topics:

```bash
# Load profile and search for specific section
prompter run python.full | grep -A 10 "linting"

# Search for keywords
prompter run rust.full | grep -i "error handling"

# Show specific categories
prompter run engineering.stack | grep -A 20 "# Shell"
```

**Workflow:**
1. User asks "What are the Python linting rules?"
2. Run `prompter run python.full | grep -A 10 "linting"`
3. Extract and present the relevant section
4. Offer to load the full profile if more context is needed

**Common Queries:**
- Shell patterns: `grep -A 20 "shell"`
- Testing standards: `grep -A 15 "test"`
- Error handling: `grep -i "error"`
- Documentation: `grep -A 10 "documentation"`
- Version management: `grep -A 15 "version"`

## Tertiary Capability: Validate Against Standards

Check current work against prompter standards:

```bash
# Load relevant profile
prompter run cli.rust

# Compare current code/structure against the standards
# Extract key rules and check for compliance
```

**Validation Workflow:**

1. **Identify the relevant profile** based on the work type
2. **Load the profile**: `prompter run <profile>`
3. **Extract key standards** from the output
4. **Review current work** against those standards
5. **Report findings**:
   - What follows the standards
   - What deviates from the standards
   - Recommendations for alignment

**Example Validation Scenarios:**

**Python Project:**
```bash
# Load Python standards
prompter run python.full

# Check for:
# - Type hints usage (from python/type-hints.md)
# - Linting setup (from python/linting.md)
# - Documentation structure (from python/documentation.md)
# - Package manager (should use uv per python/uv-package-manager.md)
```

**Rust CLI Project:**
```bash
# Load Rust CLI standards
prompter run cli.rust.full

# Check for:
# - Project structure (from rust/project-structure.md)
# - Quality tooling setup (from rust/quality-tooling.md)
# - Testing patterns (from rust/testing.md)
# - Release workflow (from rust/release-workflow.md)
```

**Shell Scripts:**
```bash
# Load shell standards
prompter run engineering.stack | grep -A 50 "shell"

# Check for:
# - Error handling (set -euo pipefail)
# - Portability (#!/usr/bin/env bash)
# - Style conventions
```

## Profile Categories

Profiles are organized by purpose:

### Planning Profiles
- `planning` - General planning structure
- `planning.full-stack` - Full-stack project planning
- `planning.devops` - DevOps/infrastructure planning

### Execution Profiles
- `execute-plan.python-backend` - Python backend execution
- `execute-plan.rust-cli` - Rust CLI execution
- `execute-plan.documentation` - Documentation work
- `execute-plan.database` - Database work
- `execute-plan.shell-scripting` - Shell script work
- `execute-plan.infrastructure` - Infrastructure work

### Language-Specific Profiles
- `python.full` - Complete Python stack
- `python.api` - Python API development
- `rust.full` - Complete Rust stack
- `cli.rust` - Rust CLI basics
- `cli.rust.full` - Rust CLI with full tooling

### Domain Profiles
- `full-stack.backend` - Backend development
- `devops.architecture` - Architecture planning
- `devops.deployment` - Deployment work
- `database.all` - Database development

### Component Profiles
- `core.baseline` - Critical interaction rules
- `engineering.stack` - Engineering principles
- `workflow.execution` - Plan execution patterns
- `workflow.planning` - Planning patterns
- `environment.defaults` - Platform/tooling defaults
- `tooling.cli` - CLI tool standards
- `tooling.version-management` - Version management

## Workflow Guidelines

### When User Requests a Profile

1. **List profiles first** if they don't specify one:
   ```bash
   prompter list
   ```

2. **Verify profile exists** before running

3. **Run the profile**:
   ```bash
   prompter run <profile-name>
   ```

4. **Summarize for user**:
   - "Loading the `<profile>` profile which includes:"
   - List the key sections/topics covered
   - Note the size: "This is a comprehensive set of rules (~X lines)"

5. **Incorporate guidance**:
   - Use the loaded rules as working standards
   - Reference specific rules when relevant
   - Cite the profile when following its patterns

### When User Asks "What Rules Apply?"

1. **Check for .agent-metadata.toml** in current directory - it may specify a default profile

2. **Infer from context**:
   - Rust project with Cargo.toml → suggest `cli.rust` or `rust.full`
   - Python project with pyproject.toml → suggest `python.full`
   - Documentation task → suggest `execute-plan.documentation`
   - Planning phase → suggest `planning`

3. **Offer options**: "Based on this being a Rust CLI project, I can load `cli.rust` or `cli.rust.full` (with testing/CI/release standards)"

### When Validating

1. **Load the relevant profile**
2. **Extract enforceable rules** (look for MUST, NEVER, ALWAYS directives)
3. **Categorize findings**:
   - ✅ Compliant
   - ⚠️ Minor deviations
   - ❌ Major violations
4. **Provide actionable recommendations**

## Tool Configuration

**Location**: `~/.config/prompter/config.toml`
**Library**: `~/.local/prompter/library/`
**Version**: Check with `prompter doctor`

**Health Check:**
```bash
prompter doctor
```

Output should show:
- ✅ Config file location and validity
- ✅ Library directory location
- ✅ Version status

## Output Format

Prompter outputs concatenated markdown with:
- Default pre-prompt: "You are an LLM coding agent..."
- All fragments from the profile's dependency tree
- Fragments organized by topic (shell, python, workflow, etc.)
- Bold directives: **MUST**, **NEVER**, **ALWAYS**

## Best Practices

1. **Show available profiles first**: Users may not know what's available
2. **Summarize before incorporating**: Don't dump 1000 lines without context
3. **Reference the source**: When following a rule, cite the profile
4. **Validate configuration**: If things seem wrong, run `prompter doctor`
5. **Check for updates**: Library and config are in git repos that may evolve
6. **Token awareness**: Large profiles consume significant tokens
7. **Profile selection**: Prefer specific profiles over broad ones when possible

## Common Use Cases

### Starting a New Rust CLI Project

```bash
# Load standards
prompter run cli.rust.full

# Key sections will include:
# - Project structure patterns
# - Quality tooling (clippy, rustfmt)
# - Testing approaches
# - GitHub Actions CI/CD
# - Git hooks with peter-hook
# - Release workflow with versioneer
# - Justfile patterns
```

### Writing a Plan

```bash
# Load planning standards
prompter run planning

# Covers:
# - Plan document structure
# - TODO management
# - Agent metadata configuration
# - GitHub/Asana integration
```

### Python Backend Work

```bash
# Load backend standards
prompter run full-stack.backend

# Includes:
# - Python basics, type hints, uv package manager
# - Linting and documentation
# - API generation and testing
# - Database DDL and SQL standards
# - Shell error handling and portability
# - Engineering principles
```

### Looking Up Specific Rules

```bash
# What are the shell rules?
prompter run engineering.stack | grep -A 30 "shell"

# What are the Python linting standards?
prompter run python.full | grep -A 20 "linting"

# What's the release workflow?
prompter run rust.full | grep -A 40 "release"
```

## Troubleshooting

**Profile not found:**
- Run `prompter list` to see available profiles
- Check spelling and case sensitivity
- Verify config exists: `cat ~/.config/prompter/config.toml`

**Command not found:**
- Verify prompter is installed: `which prompter`
- Check version: `prompter --version`
- Run health check: `prompter doctor`

**Output seems wrong:**
- Validate configuration: `prompter validate`
- Check for config errors in `~/.config/prompter/config.toml`
- Verify library exists: `ls ~/.local/prompter/library/`

**Large output:**
- Use specific profiles instead of broad ones
- Query specific sections with grep
- Ask user if they want full profile or just summary

## Example Session Flow

```
User: "Load the Rust CLI standards"

Claude: Let me show you the available Rust profiles first:
[Runs: prompter list | grep rust]

Available Rust profiles:
- cli.rust - Basic Rust CLI standards
- cli.rust.full - Full Rust CLI with testing, CI/CD, release workflow
- rust.full - Complete Rust development stack
- rust.quality - Quality tooling and testing
- rust.github-actions - CI/CD and release workflow
- rust.project - Project structure and patterns

Would you like the full cli.rust.full profile (includes everything) or just cli.rust (basics)?

User: "Full please"

Claude: Loading cli.rust.full profile...
[Runs: prompter run cli.rust.full]
[Reads output]

Loaded cli.rust.full profile (~450 lines). This includes:

**Critical Interaction Rules:**
- No emotion, no praise, factual communication only
- Never use Windows line endings
- Never use cd; use absolute paths in commands

**Engineering Standards:**
- Shell error handling and portability
- Version management with versioneer
- CLI tool standards

**Rust-Specific:**
- Project structure (src/, tests/, examples/)
- Quality tooling (clippy, rustfmt, cargo-audit)
- Testing patterns with extensive assertions
- GitHub Actions CI/CD pipeline
- Git hooks with peter-hook
- Release workflow with versioneer and GitHub Actions
- Justfile patterns for task automation

I'll now follow these standards for Rust CLI development. What would you like to work on?

User: "Check if this project follows the standards"

Claude: I'll validate the current project against the cli.rust.full standards.
[Reviews project structure, Cargo.toml, tests/, .github/workflows/, etc.]

**Validation Results:**

✅ Compliant:
- Project structure follows src/ layout
- Cargo.toml has proper metadata
- Tests are in tests/ directory
- GitHub Actions workflow present

⚠️ Minor deviations:
- Missing pre-push git hooks (peter-hook not configured)
- No Justfile for task automation
- codecov.io integration not set up

❌ Major violations:
- Version in Cargo.toml doesn't match VERSION file (versioneer not in sync)
- Missing release workflow in GitHub Actions

Would you like me to address any of these issues?
```

## Notes

**This is non-standard prompter usage**: Prompter was designed to generate initial prompts for new LLM sessions. Using it mid-session to load additional standards is a creative adaptation that works but wasn't the original intent.

**Token efficiency**: Consider the trade-off between loading full profiles (comprehensive but token-heavy) versus querying specific sections (efficient but requires knowing what to look for).

**Evolution**: The prompter library and profiles are maintained in git repositories and may evolve. Run `prompter doctor` and check library updates periodically.