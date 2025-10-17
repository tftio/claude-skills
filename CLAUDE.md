# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains Claude Skills - modular capability definitions that teach Claude how to interact with external tools and services. Each skill is a self-contained directory with documentation that Claude loads when relevant operations are requested.

**Repository:** `git@github.com:tftio/claude-skills.git`

## Architecture

### Skill Structure

Each skill follows this pattern:

```
skill-name/
├── SKILL.md          # Required: Skill definition with YAML frontmatter
└── examples/         # Optional: Reference materials for CLI output formats
    └── README.md
```

**SKILL.md Format:**
- **YAML frontmatter** with `name` and `description` fields
- `description` must explain what the skill does AND when to use it (triggers)
- Markdown body with comprehensive command documentation
- Sections: command syntax, examples, workflows, best practices, troubleshooting

### Current Skills

1. **asana/** - Asana project management via `$HOME/.local/bin/asana-cli`
2. **github/** - GitHub operations via `gh` CLI
3. **prompt/** - Load prompter profiles to apply engineering standards mid-session
4. **versioneer/** - Version management with semantic versioning support

### Agent Definitions

Agent definitions are in the `agents/` directory and define specialized workflows:

1. **planning-architect.md** - Creates structured multi-phase project plans with requirements gathering
2. **plan-executor.md** - Executes documented plans with git integration and progress tracking

## Working with Skills

### Creating a New Skill

1. Create directory: `mkdir -p skill-name/examples`
2. Create `SKILL.md` with frontmatter:
   ```yaml
   ---
   name: skill-name
   description: Clear description of functionality and usage triggers
   ---
   ```
3. Document the CLI tool comprehensively:
   - Tool location and verification commands
   - All command structures and subcommands
   - Complete flag documentation with examples
   - Output format options (especially JSON for parsing)
   - Workflow guidelines and best practices
   - Error handling and troubleshooting

4. Add examples directory with README explaining optional reference materials

### Updating Existing Skills

When updating skills after CLI tool changes:

1. **Research the tool first**: Run `--help` commands to understand current syntax
2. **Document accurately**: Use exact flag names, subcommands, and argument formats
3. **Include new features**: Note version-specific capabilities (e.g., "@copilot" assignee in GitHub)
4. **Update workflows**: Revise best practices if command patterns change
5. **Preserve structure**: Maintain consistent organization across skills

### Key Documentation Principles

- **Command exactness**: Document precise syntax, not approximations
- **Output format emphasis**: Always highlight JSON output options for programmatic use
- **Special values**: Document shortcuts like `@me`, natural language dates, email vs GID
- **Scope requirements**: Note when commands need special auth scopes
- **Context awareness**: Explain when repo context matters vs when `--repo` is needed

## Agent Definitions

Agent definitions in `agents/` are specialized workflow templates that combine skills with specific methodologies:

**Structure:**
```yaml
---
name: agent-name
description: What it does and when to use it
tools: Read, Write, Edit, Bash  # Available tools
model: sonnet                    # Recommended model
---
```

**planning-architect**: Creates multi-phase project plans
- Gathers requirements through questioning
- Loads technical standards via prompt skill
- Creates `docs/plans/{name}/` with overview.md and phase_*.md files
- Documents rationale, assumptions, and acceptance criteria

**plan-executor**: Delivers planned work systematically
- Reads plans from `docs/plans/`
- Creates phase branches, commits work, updates trackers
- Integrates with GitHub issues and Asana tasks
- Follows loaded technical standards
- Uses versioneer for version management

## Permissions Model

Permissions are configured in `.claude/settings.local.json`:

```json
{
  "permissions": {
    "allow": [
      "WebSearch",
      "mcp__fetch__fetch",
      "Bash($HOME/.local/bin/asana-cli task:*)",
      "Bash($HOME/.local/bin/asana-cli:*)",
      "Bash(gh:*)",
      "Bash(prompter:*)",
      "Bash(versioneer:*)"
    ]
  }
}
```

**Pattern:**
- `Bash(command:*)` - Allow all subcommands of a CLI tool
- `Bash(command subcommand:*)` - Allow specific subcommand and its operations

When adding new skills, update permissions to allow the tool's commands.

## Skill Installation

Skills in this repository can be installed to Claude Code in two ways:

1. **Copy**: `cp -r skill-name ~/.claude/skills/`
2. **Symlink**: `ln -s $(pwd)/skill-name ~/.claude/skills/skill-name`

Symlinks are preferred during development to keep changes in version control.

## Design Philosophy

### Tool-Centric Approach

Skills wrap existing CLI tools rather than implementing APIs directly. This provides:
- Token efficiency (tools handle implementation details)
- Reliability (mature CLI tools vs generated code)
- Flexibility (users control tool versions and configuration)

### Progressive Disclosure

Skills use frontmatter descriptions for initial matching (few tokens), only loading full documentation when activated. Keep descriptions:
- Concise but complete
- Trigger-aware (mention common user phrases)
- Capability-focused (what it enables, not how)

### JSON-First for Parsing

All skills should emphasize JSON output modes:
- Reliable structured data vs parsing human-readable tables
- Enable complex filtering with `jq` or similar tools
- Document available JSON fields for each command
- Show examples of JSON parsing in workflows

## Common Patterns

### Natural Language Support

Document when tools accept natural language:
- Dates: "tomorrow", "next Friday", "2025-12-31"
- Users: emails vs IDs, `@me` shortcuts
- Relative references: "current branch", "latest release"

### Multi-Format Output

Standard output formats to document:
- `table` - Default human-readable
- `json` - Programmatic use (emphasize this)
- `csv` - Export/import scenarios
- `markdown` - Documentation generation

### Authentication Patterns

Document auth requirements:
- Where credentials are stored
- How to verify auth status (`tool auth status`, `tool doctor`)
- Special scope requirements (`gh auth refresh -s project`)
- Troubleshooting auth errors

### Error Handling

Every skill should include:
- Common error messages and their meanings
- How to check tool availability and version
- Permission and authentication troubleshooting
- Network/API error guidance

## Examples Directory

The `examples/` subdirectory in each skill is optional but useful for:
- Showing complex JSON response structures
- Documenting edge cases (null values, empty arrays)
- Helping Claude parse nested data
- Providing reference for custom formatting

Add example outputs by running commands with `--output json` and saving representative responses.

## Testing Skills

After creating or updating a skill:

1. **Verify CLI tool**: Ensure the tool is installed and accessible
2. **Test commands**: Run example commands to verify syntax accuracy
3. **Check JSON output**: Validate JSON field names match documentation
4. **Test in Claude**: Install skill and verify Claude recognizes triggers
5. **Validate workflows**: Confirm example workflows execute correctly

## Notes

- This is a documentation project, not application code
- No build system or tests in traditional sense
- Changes are immediately effective when skills are installed/symlinked
- Version control helps track CLI tool changes over time
- Skills are portable - can be shared across teams via git

## References

### Claude Skills Documentation

These resources were used to understand the Claude Skills system and architecture:

**Official Anthropic Resources:**
- [Claude Skills Announcement](https://www.anthropic.com/news/skills) - Official feature announcement (October 16, 2025)
- [Claude Skills Engineering Blog](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills) - Technical deep-dive on Agent Skills design pattern
- [Claude Code Skills Documentation](https://docs.claude.com/en/docs/claude-code/skills) - Official documentation for using skills with Claude Code
- [Anthropic Skills Repository](https://github.com/anthropics/skills) - Official examples and templates

**Community Resources:**
- [Simon Willison: "Claude Skills are awesome"](https://simonwillison.net/2025/Oct/16/claude-skills/) - Detailed analysis and comparison with MCP

**Reference Examples:**
- [Template Skill](https://github.com/anthropics/skills/blob/main/template-skill/SKILL.md) - Basic template for creating skills
- [Slack GIF Creator Skill](https://github.com/anthropics/skills/blob/main/slack-gif-creator/SKILL.md) - Complex example with Python scripts
- [Document Skills](https://github.com/anthropics/skills/tree/main/document-skills) - Production skills for .docx, .xlsx, .pptx, .pdf

### Key Concepts

From the research:
- Skills are folders with instructions, scripts, and resources that Claude loads dynamically
- Progressive disclosure: Only frontmatter is loaded initially (few tokens), full content loaded when relevant
- Skills are composable: Multiple skills can be active simultaneously
- Skills are portable: Same format works across Claude.ai, Claude Code, and API
- Skills can execute code: Provide reliability for tasks where code is more reliable than token generation
