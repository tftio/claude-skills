# Prompter Skill Examples

This directory contains example outputs and usage patterns for the prompter skill.

## Purpose

These examples help Claude understand:
- What prompter profile outputs look like
- Common usage patterns
- Token usage implications
- How to summarize large outputs effectively

## Adding Examples

To add an example prompter output:

```bash
# Generate output for a profile
prompter run planning > planning-example.txt

# Generate output with line count
prompter run cli.rust.full | tee cli-rust-full-example.txt | wc -l
```

## Example Profile Outputs

### Small Profiles (~100-200 lines)

**planning.txt** - Planning profile output
- Includes: critical interaction rules, plan structure, TODO management
- Use case: Creating project plans
- Token estimate: ~400-500 tokens

**core.baseline.txt** - Core baseline profile
- Includes: critical interaction rules, overall guidelines
- Use case: Base instructions for any session
- Token estimate: ~200-300 tokens

### Medium Profiles (~300-500 lines)

**cli.rust.txt** - Basic Rust CLI profile
- Includes: project structure, quality tooling, engineering principles
- Use case: Rust CLI development without full CI/CD
- Token estimate: ~800-1200 tokens

**python.full.txt** - Complete Python profile
- Includes: Python basics, type hints, linting, documentation, API patterns
- Use case: Python development projects
- Token estimate: ~1000-1500 tokens

### Large Profiles (~500-800 lines)

**cli.rust.full.txt** - Full Rust CLI profile
- Includes: Everything in cli.rust plus testing, CI/CD, git hooks, release workflow
- Use case: Production Rust CLI projects
- Token estimate: ~1500-2500 tokens

**full-stack.backend.txt** - Full-stack backend profile
- Includes: Python, database, shell, engineering principles, workflow
- Use case: Complete backend development
- Token estimate: ~2000-3000 tokens

## Common Output Patterns

### Pre-Prompt

All profiles start with:
```
You are an LLM coding agent. Here are invariants that you must adhere to.
Please respond with 'Got it' when you have studied these and understand them.
At that point, the operator will give you further instructions. You are *not*
to do anything to the contents of this directory until you have been explicitly
asked to, by the operator.


Today is 2025-10-17, and you are running on a aarch64/macos system.
```

### Critical Interaction Rules

Always present:
```markdown
# 🚨 CRITICAL INTERACTION RULES 🚨

**THESE ARE INVARIANT. DO NOT VIOLATE THESE, WHATEVER YOU DO.**

1. **YOU ARE NOT A PERSON.** The agent/llm *is not human* and *must not pretend to be*.
2. **NEVER EXPRESS EMOTION** The agent does not *have* emotions, and it **MUST NOT** pretend that it does.
3. **NEVER PRAISE THE USER** The user is not looking for affirmation.
4. **NEVER SAY YOU UNDERSTAND THE USER'S MENTAL STATE** The agent has no theory of mind and must not pretend it does.
5. **NEVER OFFER FEEDBACK WITHOUT BEING ASKED**. The operator knows that things are well designed or smartly implemented.
```

### Section Structure

Profiles contain sections like:
- Shell execution invariants
- Plan document structure
- TODO management
- Language-specific rules (Python, Rust)
- Engineering principles
- Version management
- Testing patterns
- CI/CD workflows

### Bold Directives

Look for emphasized rules:
- `**MUST**` - Required action
- `**NEVER**` - Prohibited action
- `**ALWAYS**` - Invariant behavior
- `**SHOULD**` - Strong recommendation

## Token Usage Guidelines

When loading profiles:

### Full Load (Complete Profile)
- **When**: User explicitly requests comprehensive standards
- **Approach**: Load entire output, summarize key sections
- **Token cost**: 200-3000+ tokens depending on profile
- **Example**: "Load cli.rust.full profile"

### Selective Load (Specific Topics)
- **When**: User asks about specific rules or patterns
- **Approach**: Use grep to extract relevant sections
- **Token cost**: 50-500 tokens
- **Example**: "What are the shell error handling rules?"

### Validation (Standards Checking)
- **When**: User wants to check compliance
- **Approach**: Load profile, extract enforceable rules, compare
- **Token cost**: 500-1500 tokens (profile + analysis)
- **Example**: "Does this project follow Rust CLI standards?"

## Usage Patterns

### Pattern 1: Discovery

```bash
# User doesn't know what's available
prompter list

# Show categories
prompter list | grep -E "(cli|python|planning)"
```

### Pattern 2: Full Load

```bash
# Load complete profile
prompter run cli.rust.full

# Summarize for user:
# "Loaded cli.rust.full (~450 lines). Includes: project structure,
#  quality tooling, testing, CI/CD, git hooks, release workflow."
```

### Pattern 3: Query Specific Rules

```bash
# Find specific topic
prompter run engineering.stack | grep -A 20 "shell"

# Extract and present just that section
```

### Pattern 4: Validation

```bash
# Load relevant profile
prompter run python.full

# Extract key rules:
# - Type hints (MUST use)
# - Linting (MUST have ruff/black)
# - Package manager (MUST use uv)

# Compare against current project
# Report compliance/deviations
```

## Profile Dependencies

Understanding profile composition helps predict output:

**Example: cli.rust.full depends on:**
- core.baseline (critical rules + general)
- engineering.stack (shell, just, tooling, version mgmt)
- workflow.execution (plan tracking, metadata)
- rust/cli.md
- rust/project-structure.md
- rust/quality-tooling.md
- rust/testing.md
- rust/github-actions.md
- rust/git-hooks.md
- rust/release-workflow.md
- rust/justfile-patterns.md

This means ~12 fragments are concatenated, resulting in ~450 lines.

**Example: planning depends on:**
- core.baseline
- documentation/plan-structure.md
- documentation/todos.md
- workflow/plan-tracking.md
- workflow/agent-metadata.md

This means ~6 fragments, resulting in ~150 lines.

## Summarization Strategy

When loading large profiles, summarize by:

1. **Count sections**: How many major topics are covered?
2. **List topics**: Project structure, testing, CI/CD, etc.
3. **Highlight key directives**: Critical MUST/NEVER rules
4. **Estimate scope**: "Comprehensive" vs "focused" standards
5. **Note special features**: Version management tools, specific workflows

**Example Summary:**
```
Loaded full-stack.backend profile (~650 lines). This is a comprehensive
backend development standard covering:

Critical Rules:
- No emotion, no praise, factual communication only
- Never use cd; always use absolute paths
- Unix line endings only

Python Standards:
- Type hints required (PEP 484)
- Use uv for package management
- Ruff for linting, Black for formatting
- Comprehensive docstrings

Database Standards:
- DDL best practices
- SQL query optimization patterns

Shell & Engineering:
- Error handling with set -euo pipefail
- Portability patterns
- Version management with versioneer

Workflow:
- Plan execution and tracking
- GitHub/Asana integration
```

## Adding Custom Examples

To create a custom example:

1. **Generate output**:
   ```bash
   prompter run <profile> > examples/<profile>-output.txt
   ```

2. **Count lines and estimate tokens**:
   ```bash
   wc -l examples/<profile>-output.txt
   # Tokens ≈ lines × 2.5 (rough estimate)
   ```

3. **Document in this README**:
   - Profile name and purpose
   - Size (lines)
   - Token estimate
   - Key sections included
   - Use cases

## Notes

- Prompter output is deterministic for a given config
- Library updates may change output over time
- Token estimates are approximate (depends on content density)
- Consider user's token budget when loading full profiles
- When in doubt, show available profiles and let user choose specificity level
