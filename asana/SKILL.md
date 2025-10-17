---
name: asana
description: Interface for Asana project management using asana-cli. Use this skill when users want to find tasks, update tickets, create new tasks, list projects, check task status, search for work, manage dependencies, or perform any Asana-related work management operations.
---

# Asana Project Management

This skill provides access to Asana project management through the asana-cli command-line tool located at `$HOME/.local/bin/asana-cli`.

## When to Use This Skill

- Searching for tasks or tickets (fuzzy search)
- Creating new tasks or tickets
- Updating existing tasks (status, assignee, notes, dates, etc.)
- Listing projects or workspaces
- Checking task details
- Managing task assignments and followers
- Managing subtasks and dependencies
- Querying task status or progress
- Batch operations on multiple tasks

## CLI Tool Location

The asana-cli binary is located at: `$HOME/.local/bin/asana-cli`

Always use the full path `$HOME/.local/bin/asana-cli` when executing commands.

## Command Structure

All commands follow this pattern:
```bash
$HOME/.local/bin/asana-cli <command> <subcommand> [OPTIONS] [ARGS]
```

Main commands:
- `task` - Task operations (list, show, create, update, delete, search)
- `project` - Project operations (list, show, create, update, delete)
- `config` - Manage configuration
- `doctor` - Check health and configuration

## Task Operations

### Listing Tasks

```bash
# List all tasks
$HOME/.local/bin/asana-cli task list

# List incomplete tasks only
$HOME/.local/bin/asana-cli task list --completed false

# List completed tasks
$HOME/.local/bin/asana-cli task list --completed true

# List tasks for specific assignee (use email or gid)
$HOME/.local/bin/asana-cli task list --assignee user@example.com

# List tasks in a specific project
$HOME/.local/bin/asana-cli task list --project PROJECT_GID

# List tasks with workspace filter
$HOME/.local/bin/asana-cli task list --workspace WORKSPACE_GID

# List with due date filters
$HOME/.local/bin/asana-cli task list --due-before "2025-12-31"
$HOME/.local/bin/asana-cli task list --due-after "2025-01-01"

# Sort tasks (name, due_on, created_at, modified_at, assignee)
$HOME/.local/bin/asana-cli task list --sort due_on

# Limit number of results
$HOME/.local/bin/asana-cli task list --limit 20

# Include subtasks
$HOME/.local/bin/asana-cli task list --include-subtasks

# Output as JSON for parsing
$HOME/.local/bin/asana-cli task list --output json
```

### Searching Tasks

```bash
# Fuzzy search for tasks
$HOME/.local/bin/asana-cli task search "keyword"

# Search within workspace
$HOME/.local/bin/asana-cli task search "keyword" --workspace WORKSPACE_GID

# Search with limit
$HOME/.local/bin/asana-cli task search "keyword" --limit 10

# Search recent tasks only
$HOME/.local/bin/asana-cli task search "keyword" --recent-only

# Output as JSON
$HOME/.local/bin/asana-cli task search "keyword" --output json
```

### Showing Task Details

```bash
# Show task details (gid is the task identifier)
$HOME/.local/bin/asana-cli task show TASK_GID

# Show with additional fields
$HOME/.local/bin/asana-cli task show TASK_GID --fields comments --fields attachments

# Output as JSON for parsing
$HOME/.local/bin/asana-cli task show TASK_GID --output json
```

### Creating Tasks

```bash
# Create a basic task (name is required)
$HOME/.local/bin/asana-cli task create --name "Task title"

# Create with workspace
$HOME/.local/bin/asana-cli task create --name "Task title" --workspace WORKSPACE_GID

# Create with project
$HOME/.local/bin/asana-cli task create --name "Task title" --project PROJECT_GID

# Create with assignee (email or gid)
$HOME/.local/bin/asana-cli task create --name "Task title" --assignee user@example.com

# Create with notes (plain text)
$HOME/.local/bin/asana-cli task create --name "Task title" --notes "Task description"

# Create with HTML notes
$HOME/.local/bin/asana-cli task create --name "Task title" --html-notes "<p>HTML description</p>"

# Create with due date (natural language accepted)
$HOME/.local/bin/asana-cli task create --name "Task title" --due-on "tomorrow"
$HOME/.local/bin/asana-cli task create --name "Task title" --due-on "2025-12-31"

# Create with due date and time
$HOME/.local/bin/asana-cli task create --name "Task title" --due-at "2025-12-31 14:00"

# Create with start date
$HOME/.local/bin/asana-cli task create --name "Task title" --start-on "2025-01-01"

# Create with tags
$HOME/.local/bin/asana-cli task create --name "Task title" --tag TAG_GID

# Create with followers
$HOME/.local/bin/asana-cli task create --name "Task title" --follower user@example.com

# Create as subtask
$HOME/.local/bin/asana-cli task create --name "Subtask title" --parent PARENT_TASK_GID

# Create with section
$HOME/.local/bin/asana-cli task create --name "Task title" --project PROJECT_GID --section SECTION_GID

# Interactive mode (prompts for missing values)
$HOME/.local/bin/asana-cli task create --interactive

# Output as JSON
$HOME/.local/bin/asana-cli task create --name "Task title" --output json
```

### Updating Tasks

```bash
# Mark task complete
$HOME/.local/bin/asana-cli task update TASK_GID --complete

# Mark task incomplete
$HOME/.local/bin/asana-cli task update TASK_GID --incomplete

# Update task name
$HOME/.local/bin/asana-cli task update TASK_GID --name "New task name"

# Update notes (plain text)
$HOME/.local/bin/asana-cli task update TASK_GID --notes "Updated notes"

# Clear notes
$HOME/.local/bin/asana-cli task update TASK_GID --clear-notes

# Update with HTML notes
$HOME/.local/bin/asana-cli task update TASK_GID --html-notes "<p>Updated HTML</p>"

# Reassign task
$HOME/.local/bin/asana-cli task update TASK_GID --assignee user@example.com

# Remove assignee
$HOME/.local/bin/asana-cli task update TASK_GID --clear-assignee

# Update due date (natural language accepted)
$HOME/.local/bin/asana-cli task update TASK_GID --due-on "next Friday"
$HOME/.local/bin/asana-cli task update TASK_GID --due-on "2025-12-31"

# Clear due date
$HOME/.local/bin/asana-cli task update TASK_GID --clear-due-on

# Update due date with time
$HOME/.local/bin/asana-cli task update TASK_GID --due-at "2025-12-31 14:00"

# Update start date
$HOME/.local/bin/asana-cli task update TASK_GID --start-on "2025-01-01"

# Set parent task (make it a subtask)
$HOME/.local/bin/asana-cli task update TASK_GID --parent PARENT_TASK_GID

# Remove parent
$HOME/.local/bin/asana-cli task update TASK_GID --clear-parent

# Update tags (replaces existing)
$HOME/.local/bin/asana-cli task update TASK_GID --tag TAG_GID

# Clear all tags
$HOME/.local/bin/asana-cli task update TASK_GID --clear-tags

# Update followers (replaces existing)
$HOME/.local/bin/asana-cli task update TASK_GID --follower user@example.com

# Update project associations (replaces existing)
$HOME/.local/bin/asana-cli task update TASK_GID --project PROJECT_GID

# Clear projects
$HOME/.local/bin/asana-cli task update TASK_GID --clear-projects

# Update custom fields
$HOME/.local/bin/asana-cli task update TASK_GID --custom-field "Priority=High"

# Output as JSON
$HOME/.local/bin/asana-cli task update TASK_GID --complete --output json
```

### Deleting Tasks

```bash
# Delete a task
$HOME/.local/bin/asana-cli task delete TASK_GID
```

### Batch Operations

```bash
# Create multiple tasks from structured input
$HOME/.local/bin/asana-cli task create-batch

# Update multiple tasks from structured input
$HOME/.local/bin/asana-cli task update-batch

# Complete multiple tasks from structured input
$HOME/.local/bin/asana-cli task complete-batch
```

### Managing Subtasks

```bash
# See subtask help
$HOME/.local/bin/asana-cli task subtasks --help
```

### Managing Dependencies

```bash
# Manage tasks this task depends on
$HOME/.local/bin/asana-cli task depends-on --help

# Manage tasks blocked by this task
$HOME/.local/bin/asana-cli task blocks --help
```

### Managing Task Projects and Followers

```bash
# Manage project memberships
$HOME/.local/bin/asana-cli task projects --help

# Manage task followers
$HOME/.local/bin/asana-cli task followers --help
```

## Project Operations

### Listing Projects

```bash
# List all projects
$HOME/.local/bin/asana-cli project list

# List projects in workspace
$HOME/.local/bin/asana-cli project list --workspace WORKSPACE_GID

# List projects for team
$HOME/.local/bin/asana-cli project list --team TEAM_GID

# Filter by archived status
$HOME/.local/bin/asana-cli project list --archived false

# Sort projects (name, created_at, modified_at)
$HOME/.local/bin/asana-cli project list --sort name

# Limit results
$HOME/.local/bin/asana-cli project list --limit 20

# Use inline filter expressions
$HOME/.local/bin/asana-cli project list --filter "name~Engineering"

# Output as JSON
$HOME/.local/bin/asana-cli project list --output json
```

### Showing Project Details

```bash
# Show project details
$HOME/.local/bin/asana-cli project show PROJECT_GID

# Output as JSON
$HOME/.local/bin/asana-cli project show PROJECT_GID --output json
```

### Creating Projects

```bash
# See create help
$HOME/.local/bin/asana-cli project create --help
```

### Updating Projects

```bash
# See update help
$HOME/.local/bin/asana-cli project update --help
```

### Managing Project Members

```bash
# Manage project members
$HOME/.local/bin/asana-cli project members --help
```

## Configuration and Health

```bash
# Check CLI health and configuration
$HOME/.local/bin/asana-cli doctor

# Manage configuration
$HOME/.local/bin/asana-cli config --help

# Show version
$HOME/.local/bin/asana-cli version
```

## Output Formats

The CLI supports multiple output formats via `--output`:

- `table` - Human-readable table (default for interactive use)
- `json` - JSON format for scripting and parsing
- `csv` - CSV export
- `markdown` - Markdown tables

**Always use `--output json` when you need to parse the output programmatically.**

## Important Notes

### Task Identifiers

- Task identifiers are called "gid" (global ID)
- Always use the gid returned from search/list operations
- Don't guess or construct gids

### Natural Language Dates

The CLI accepts natural language for dates:
- "tomorrow", "next Friday", "in 2 weeks"
- ISO format: "2025-12-31"
- With time: "2025-12-31 14:00"

### Email vs GID

Many fields accept either:
- Email addresses: `user@example.com`
- GID identifiers: `1234567890`

Use email when available as it's more user-friendly.

## Workflow Guidelines

### Before Running Commands

1. **Check CLI availability**: Verify the tool is accessible with `asana-cli doctor`
2. **Get help if uncertain**: Use `--help` on any command/subcommand
3. **Use JSON output for parsing**: Add `--output json` when you need structured data

### When Searching for Work

1. Start with `task search` for fuzzy matching
2. Use `task list` with filters for precise queries
3. Use `--output json` to parse results
4. Present results clearly to the user with task gid, name, status, assignee

### When Creating Tasks

1. Minimum required field is `--name`
2. Use `--workspace` or `--project` to specify location
3. Natural language works for dates: `--due-on "next Friday"`
4. Use `--output json` to capture the created task's gid

### When Updating Tasks

1. First fetch task details with `task show TASK_GID`
2. Show user what will change
3. Use specific flags: `--complete`, `--name`, `--assignee`, etc.
4. Use `--clear-*` flags to remove values

### Error Handling

If a command fails:
1. Check the error message for details
2. Verify authentication with `asana-cli doctor`
3. Confirm gids are valid (from search/list results)
4. Check command syntax with `--help`

## Example Workflows

### Finding Your Incomplete Tasks

```bash
# List incomplete tasks assigned to you
$HOME/.local/bin/asana-cli task list --assignee me --completed false --output json

# Show details for specific task
$HOME/.local/bin/asana-cli task show TASK_GID --output json
```

### Searching and Completing a Task

```bash
# Search for task
$HOME/.local/bin/asana-cli task search "feature request" --output json

# Mark it complete
$HOME/.local/bin/asana-cli task update TASK_GID --complete
```

### Creating and Assigning a Task

```bash
# List available projects
$HOME/.local/bin/asana-cli project list --output json

# Create task with full details
$HOME/.local/bin/asana-cli task create \
  --name "Implement new feature" \
  --notes "Detailed description here" \
  --project PROJECT_GID \
  --assignee engineer@company.com \
  --due-on "next Friday" \
  --output json
```

### Finding Overdue Tasks

```bash
# List tasks due before today
$HOME/.local/bin/asana-cli task list --due-before "today" --completed false --output json
```

## Best Practices

1. **Always use `--output json` for parsing**: Makes data extraction reliable
2. **Use gids from search/list results**: Never guess or construct gids
3. **Leverage natural language dates**: More intuitive than ISO format
4. **Check configuration first**: Run `doctor` if authentication fails
5. **Use email addresses**: More user-friendly than gids for assignees
6. **Verify before destructive operations**: Show task details before updating/deleting
7. **Respect rate limits**: Don't execute rapid sequential API calls

## Troubleshooting

- **Command not found**: Verify `$HOME/.local/bin/asana-cli` exists and is executable
- **Permission denied**: Check file permissions: `ls -l $HOME/.local/bin/asana-cli`
- **Authentication errors**: Run `$HOME/.local/bin/asana-cli doctor` to check config
- **Invalid gid**: Use `task search` or `task list` to get valid gids
- **API errors**: Check error message details, may indicate rate limits or permissions

## Advanced Features

The CLI supports advanced operations:

- **Subtasks**: Create hierarchical task structures with `--parent`
- **Dependencies**: Manage task dependencies and blockers
- **Batch operations**: Create/update/complete multiple tasks at once
- **Custom fields**: Set organization-specific fields with `--custom-field`
- **Followers**: Subscribe users to task notifications with `--follower`
- **Filter expressions**: Use inline filters with project list operations
- **Shell completions**: Generate with `asana-cli completions`

Explore these with `--help` on specific subcommands.
