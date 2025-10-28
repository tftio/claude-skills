# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains Claude Skills and workflow agents packaged as Claude Code plugins. Skills are modular capability definitions that teach Claude how to interact with external tools and services. Agents are specialized workflow templates that combine multiple skills for complex tasks. The plugin system enables easy distribution and installation via marketplaces.

**Repository:** `git@github.com:tftio/claude-skills.git`

### Architecture Levels

1. **Skills** (Agent Skills Spec 1.0) - Individual capabilities that Claude uses autonomously
2. **Agents** - Specialized workflow templates that combine skills for complex tasks
3. **Plugins** - Distribution packaging that bundles skills and agents for marketplace installation

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

Skills in the `skills/` directory:

1. **asana/** - Asana project management via `$HOME/.local/bin/asana-cli`
2. **github/** - GitHub operations via `gh` CLI
3. **prompt/** - Load prompter profiles to apply engineering standards mid-session
4. **versioneer/** - Version management with semantic versioning support
5. **peter-hook/** - Git hooks management via `peter-hook` CLI

### Agent Definitions

Agents in the `agents/` directory are specialized workflow templates using SKILL.md format:

1. **plan-architect/** - Creates structured multi-phase project plans with requirements gathering
2. **plan-executor/** - Executes documented plans with git integration and progress tracking
3. **greybeard/** - Senior engineering code reviewer focused on maintainability and tech debt prevention
4. **infrastructure-auditor/** - Infrastructure as Code quality auditor for Terraform, Docker, GitHub Actions
5. **pr-auditor/** - Pull request auditor for Python/FastAPI/PostgreSQL projects
6. **python-auditor/** - Python code quality auditor using project standards

**Note:** Agents are skills that define specialized workflows. They use the same SKILL.md format but focus on orchestrating complex, multi-step processes rather than wrapping single CLI tools.

### Slash Commands

The plugin includes slash commands for explicit invocation of workflow agents:

| Command | Agent | Purpose |
|---------|-------|---------|
| `/create-plan` | plan-architect | Create structured multi-phase project plans |
| `/execute-plan` | plan-executor | Execute documented plans with git integration |
| `/review-code` | greybeard | Senior engineering code review for maintainability |
| `/audit-python` | python-auditor | Python code quality audit against standards |
| `/audit-infrastructure` | infrastructure-auditor | IaC quality audit (Terraform, Docker, Actions) |
| `/review-pr` | pr-auditor | Pull request review with tracker integration |

**How slash commands work:**
- User types `/command-name` for explicit invocation
- Command loads corresponding agent skill
- Agent executes with full workflow instructions
- Also available: natural language ("execute the auth plan") triggers agents autonomously

**Example:**
```bash
# Explicit via slash command
/execute-plan auth-feature

# Implicit via natural language
claude "Execute the plan in docs/plans/auth-feature"
```

Both invoke the same agent, both work identically.

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

## Plugin System

### What Are Plugins?

Plugins are a **packaging and distribution mechanism** for bundling related skills and agents together. They enable marketplace-based installation and team distribution. Plugins do NOT replace skills - they organize and distribute them.

**Key relationship:**
- **Skills** = Individual capabilities (the actual functionality)
- **Plugins** = Bundles of related skills (the packaging/distribution)
- **Agents** = Workflow-focused skills (specialized multi-step processes)

### Plugin Structure

This repository defines plugins in `.claude-plugin/marketplace.json`:

```json
{
  "name": "tftio-claude-skills",
  "owner": { "name": "tftio", "email": "jfb@tftio.com" },
  "metadata": {
    "description": "Professional development and project management skills",
    "version": "1.0.0"
  },
  "plugins": [
    {
      "name": "development-tools",
      "description": "GitHub, version management, and git hooks",
      "skills": ["./skills/github", "./skills/versioneer", "./skills/peter-hook"]
    },
    {
      "name": "workflow-agents",
      "description": "Specialized workflow agents for planning and execution",
      "skills": ["./agents/plan-architect", "./agents/plan-executor", ...]
    }
  ]
}
```

### Installing the Plugin

**For local development (recommended):**
```bash
# Install plugin via symlink (uses justfile)
just install

# Check installation status
just status

# Reinstall after changes
just reinstall

# Uninstall
just uninstall

# Validate structure
just validate
```

**From marketplace (future):**
```bash
# Add this repository as a marketplace
/plugin marketplace add tftio/claude-skills

# Install the plugin
/plugin install tftio-dev-tools@tftio
```

### The Unified Plugin: tftio-dev-tools

This repository provides a single comprehensive plugin containing:

**CLI Tool Skills (5):**
- asana, github, prompt, versioneer, peter-hook

**Workflow Agents (6):**
- plan-architect, plan-executor, greybeard, infrastructure-auditor, pr-auditor, python-auditor

**Slash Commands (6):**
- /create-plan, /execute-plan, /review-code, /audit-python, /audit-infrastructure, /review-pr

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

## Migration to Plugin System (January 2025)

This repository was migrated from standalone skills/agents to the unified plugin system:

**What Changed:**
- Added `.claude-plugin/marketplace.json` for plugin definition
- Converted agent `.md` files to `agent-name/SKILL.md` subdirectories
- Consolidated 4 separate plugins into 1 comprehensive plugin
- Created 6 slash commands for explicit agent invocation
- Updated justfile for plugin-based installation

**What Stayed The Same:**
- Skills remain SKILL.md files with YAML frontmatter (Agent Skills Spec 1.0)
- Agents are still skills, just workflow-focused
- Individual skill/agent functionality unchanged
- Agents work autonomously AND via slash commands

**Why This Architecture?**
- **Single plugin** - One installation gets everything
- **Slash commands** - Explicit invocation for complex workflows
- **Autonomous triggering** - Natural language still works
- **Professional packaging** - Ready for marketplace distribution
- **Development friendly** - `just install` symlinks entire repo

The plugin system is purely a distribution enhancement, not an architectural shift.

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

From the research (January 2025):
- **Agent Skills Spec 1.0** is the current standard (released October 2025)
- Skills are folders with SKILL.md files containing instructions and resources
- Progressive disclosure: Only frontmatter loaded initially, full content when relevant
- Skills are composable: Multiple skills active simultaneously
- Skills are portable: Same format works across Claude.ai, Claude Code, and API
- **Plugins** are packaging/distribution, not a replacement for skills
- **Agents** (this repo's term) are workflow-focused skills using the same SKILL.md format
- **Subagents** (Anthropic API term) refers to using smaller models as helpers

### Skills vs Plugins vs Agents

| Concept | Purpose | Format | Invocation |
|---------|---------|--------|------------|
| **Skill** | Individual capability | SKILL.md with YAML frontmatter | Model-invoked (Claude decides) |
| **Agent** | Workflow orchestration | SKILL.md (same as skill) | Model-invoked (Claude decides) |
| **Plugin** | Distribution packaging | marketplace.json | User-installed |
| **Slash Command** | Explicit user action | command.md | User-invoked (/command) |

**Note:** This repository's "agents" are skills that focus on workflows rather than tool wrapping. They're not a separate concept in the Agent Skills Spec - just our organizational pattern.
