# work-start

CLI tool to create `.work-metadata.toml` files for work tracking integration.

## Installation

The script uses `uv` with inline dependencies, so it's self-contained. Just ensure `uv` is installed:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## Usage

### Quick Start

With explicit Asana task and GitHub project:

```bash
./bin/work-start \
  --asana-ticket https://app.asana.com/0/1234567890/9876543210 \
  --github-project 42
```

### Interactive Mode

Prompts for all required information:

```bash
./bin/work-start --interactive
```

### Create New GitHub Project

Create a GitHub Project board for this work:

```bash
./bin/work-start \
  --asana-ticket https://app.asana.com/0/123/456 \
  --create-project "Authentication Feature"
```

### With Optional Defaults

Specify default assignee and labels:

```bash
./bin/work-start \
  --asana-ticket https://app.asana.com/0/123/456 \
  --github-project 42 \
  --assignee jsmith \
  --labels "backend,authentication"
```

## Options

| Option | Description |
|--------|-------------|
| `--asana-ticket` | Asana task URL or GID |
| `--github-project` | GitHub Project URL or number |
| `--create-project NAME` | Create new GitHub Project with name |
| `--assignee` | Default GitHub assignee (username) |
| `--labels` | Default labels (comma-separated) |
| `--interactive` | Interactive mode (prompts for values) |
| `--output` | Output file path (default: `.work-metadata.toml`) |

## Input Formats

### Asana Task

Accepts either format:
- Full URL: `https://app.asana.com/0/1234567890/9876543210`
- GID only: `9876543210`

### GitHub Project

Accepts:
- Full URL: `https://github.com/orgs/orgname/projects/42`
- Number only: `42`

## Output

Creates `.work-metadata.toml` in the current directory:

```toml
[project]
name = "my-repo"
github_url = "https://github.com/org/my-repo"

[work]
asana_task = "https://app.asana.com/0/1234567890/9876543210"
github_project = "42"
started_at = "2025-11-01T10:30:00Z"

[tracking]
default_assignee = "jsmith"
default_labels = ["backend", "authentication"]
```

## Requirements

- Git repository (must be run from within a repo)
- GitHub CLI (`gh`) installed and authenticated
- `uv` for running the script

## Integration with Skills

Once created, this file is automatically used by:
- **plan-architect**: Creates GitHub issues with metadata defaults
- **plan-executor**: Updates Asana at checkpoints during execution
- **github skill**: Uses defaults for issue/PR creation
- **asana skill**: Knows which task to update

## Important Notes

**This file is MODEL-MANAGED ONLY**. Do not edit it manually. It should be managed exclusively by:
- This `work-start` script (initial creation)
- Claude Code skills and agents (updates during work)

**Add to .gitignore**:
```gitignore
# Work tracking metadata (worktree-specific, model-managed only)
.work-metadata.toml
```
