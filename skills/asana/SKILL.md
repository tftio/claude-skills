---
name: asana
description: Interface for Asana project management using asana-cli. Use this skill when users want to find tasks, update tickets, create new tasks, list projects, check task status, search for work, manage dependencies, or perform any Asana-related work management operations. (project, gitignored)
---

# Asana Skill

Interface for interacting with Asana through the `asana-cli` command-line tool. This skill enables comprehensive Asana operations including tasks, projects, sections, tags, custom fields, and batch operations.

## Tool Location

**Binary:** `$HOME/.local/bin/asana-cli`

**Verify Installation:**
```bash
$HOME/.local/bin/asana-cli --version
$HOME/.local/bin/asana-cli doctor
```

**Configuration:** `~/.config/asana-cli/config.toml` (Linux/macOS)

## Authentication

### Setup Personal Access Token

```bash
# Interactively set token (prompted securely)
$HOME/.local/bin/asana-cli config set token

# Or provide token directly
$HOME/.local/bin/asana-cli config set token --token "your_pat_here"

# Test token validity
$HOME/.local/bin/asana-cli config test

# View configuration (token redacted)
$HOME/.local/bin/asana-cli config get
```

### Environment Variables

- `ASANA_PAT` - Personal Access Token (overrides config file)
- `ASANA_WORKSPACE` - Default workspace GID
- `ASANA_BASE_URL` - API base URL override (for testing)
- `ASANA_CLI_CONFIG_HOME` - Config directory override
- `ASANA_CLI_DATA_HOME` - Data directory override

### Default Configuration

```bash
# Set default workspace
$HOME/.local/bin/asana-cli config set workspace --workspace "1234567890"

# Set default assignee
$HOME/.local/bin/asana-cli config set assignee --assignee "user@example.com"
```

## Output Formats

All list/show commands support multiple output formats via `--output`:

- `table` - Human-readable table (default in interactive mode)
- `json` - JSON for scripting and programmatic use (RECOMMENDED for parsing)
- `csv` - Comma-separated values for spreadsheet import
- `markdown` - Markdown-formatted tables for documentation

**Example:**
```bash
$HOME/.local/bin/asana-cli task list --output json
$HOME/.local/bin/asana-cli project list --output csv
```

## Task Operations

### Listing Tasks

```bash
# Basic list (uses defaults from config)
$HOME/.local/bin/asana-cli task list

# Filter by project
$HOME/.local/bin/asana-cli task list --project "1234567890"

# Filter by section within a project
$HOME/.local/bin/asana-cli task list --project "1234567890" --section "9876543210"

# Filter by assignee (email or GID)
$HOME/.local/bin/asana-cli task list --assignee "user@example.com"
$HOME/.local/bin/asana-cli task list --assignee "1234567890"

# Filter by completion status
$HOME/.local/bin/asana-cli task list --completed false
$HOME/.local/bin/asana-cli task list --completed true

# Filter by due date
$HOME/.local/bin/asana-cli task list --due-before "2025-12-31"
$HOME/.local/bin/asana-cli task list --due-after "2025-01-01"

# Include subtasks
$HOME/.local/bin/asana-cli task list --include-subtasks

# Sort and limit results
$HOME/.local/bin/asana-cli task list --sort due_on --limit 10
# Sort options: name, due_on, created_at, modified_at, assignee

# Request additional fields
$HOME/.local/bin/asana-cli task list --fields custom_fields --fields tags

# JSON output for parsing
$HOME/.local/bin/asana-cli task list --output json --completed false
```

### Searching Tasks

```bash
# Full-text search (requires workspace)
$HOME/.local/bin/asana-cli task search --workspace "1234567890" --query "bug fix"

# Search with filters
$HOME/.local/bin/asana-cli task search \
  --workspace "1234567890" \
  --query "authentication" \
  --assignee "user@example.com" \
  --completed false

# Search by date ranges
$HOME/.local/bin/asana-cli task search \
  --workspace "1234567890" \
  --created-after "2025-01-01" \
  --due-before "2025-12-31"

# Filter by task properties
$HOME/.local/bin/asana-cli task search \
  --workspace "1234567890" \
  --blocked true \
  --has-attachments true

# Sort and limit search results
$HOME/.local/bin/asana-cli task search \
  --workspace "1234567890" \
  --query "performance" \
  --sort-by modified_at \
  --sort-ascending \
  --limit 20
# Sort options: modified_at, likes, created_at
```

### Showing Task Details

```bash
# Show task details
$HOME/.local/bin/asana-cli task show "1234567890"

# Request additional fields
$HOME/.local/bin/asana-cli task show "1234567890" --fields custom_fields --fields tags

# JSON output for parsing
$HOME/.local/bin/asana-cli task show "1234567890" --output json
```

### Creating Tasks

```bash
# Basic task creation
$HOME/.local/bin/asana-cli task create \
  --name "Fix authentication bug" \
  --workspace "1234567890"

# Create with full details
$HOME/.local/bin/asana-cli task create \
  --name "Implement user dashboard" \
  --workspace "1234567890" \
  --project "9876543210" \
  --section "5555555555" \
  --assignee "user@example.com" \
  --notes "Design requirements in PRD doc" \
  --due-on "next Friday" \
  --tag "feature" \
  --tag "frontend"

# Create subtask
$HOME/.local/bin/asana-cli task create \
  --name "Write unit tests" \
  --parent "1234567890" \
  --assignee "user@example.com"

# Create with HTML notes
$HOME/.local/bin/asana-cli task create \
  --name "Documentation update" \
  --workspace "1234567890" \
  --html-notes "<p>Update the <strong>API docs</strong></p>"

# Create with custom fields
$HOME/.local/bin/asana-cli task create \
  --name "Deploy to production" \
  --workspace "1234567890" \
  --custom-field "Priority=High" \
  --custom-field "Environment=Production"

# Interactive creation (prompts for missing values)
$HOME/.local/bin/asana-cli task create --interactive

# Natural language dates accepted
# Examples: "tomorrow", "next Monday", "2025-12-31", "in 2 weeks"
```

### Updating Tasks

```bash
# Update task name
$HOME/.local/bin/asana-cli task update "1234567890" --name "New task name"

# Assign/reassign task
$HOME/.local/bin/asana-cli task update "1234567890" --assignee "user@example.com"
$HOME/.local/bin/asana-cli task update "1234567890" --clear-assignee

# Mark complete/incomplete
$HOME/.local/bin/asana-cli task update "1234567890" --complete
$HOME/.local/bin/asana-cli task update "1234567890" --incomplete

# Update due dates (natural language accepted)
$HOME/.local/bin/asana-cli task update "1234567890" --due-on "next Friday"
$HOME/.local/bin/asana-cli task update "1234567890" --due-at "2025-12-31 14:00"
$HOME/.local/bin/asana-cli task update "1234567890" --clear-due-on

# Update notes
$HOME/.local/bin/asana-cli task update "1234567890" --notes "Updated description"
$HOME/.local/bin/asana-cli task update "1234567890" --html-notes "<p>HTML content</p>"
$HOME/.local/bin/asana-cli task update "1234567890" --clear-notes

# Update tags (replaces existing)
$HOME/.local/bin/asana-cli task update "1234567890" --tag "bug" --tag "urgent"
$HOME/.local/bin/asana-cli task update "1234567890" --clear-tags

# Update followers (replaces existing)
$HOME/.local/bin/asana-cli task update "1234567890" --follower "user1@example.com" --follower "user2@example.com"
$HOME/.local/bin/asana-cli task update "1234567890" --clear-followers

# Update project associations (replaces existing)
$HOME/.local/bin/asana-cli task update "1234567890" --project "9876543210"
$HOME/.local/bin/asana-cli task update "1234567890" --clear-projects

# Update custom fields
$HOME/.local/bin/asana-cli task update "1234567890" --custom-field "Status=In Progress" --custom-field "Priority=High"

# Set/clear parent task
$HOME/.local/bin/asana-cli task update "1234567890" --parent "9999999999"
$HOME/.local/bin/asana-cli task update "1234567890" --clear-parent
```

### Deleting Tasks

```bash
# Delete a task permanently
$HOME/.local/bin/asana-cli task delete "1234567890"
```

### Batch Operations

```bash
# Create multiple tasks from JSON file
$HOME/.local/bin/asana-cli task create-batch --file tasks.json

# Create from CSV file
$HOME/.local/bin/asana-cli task create-batch --file tasks.csv

# Continue on errors
$HOME/.local/bin/asana-cli task create-batch --file tasks.json --continue-on-error

# Update multiple tasks from file
$HOME/.local/bin/asana-cli task update-batch --file updates.json

# Complete multiple tasks
$HOME/.local/bin/asana-cli task complete-batch --file task_ids.json
```

**JSON Batch Format Example:**
```json
[
  {
    "name": "Task 1",
    "workspace": "1234567890",
    "assignee": "user@example.com",
    "due_on": "2025-12-31"
  },
  {
    "name": "Task 2",
    "workspace": "1234567890",
    "notes": "Description here"
  }
]
```

### Subtasks

```bash
# List subtasks
$HOME/.local/bin/asana-cli task subtasks list "1234567890"

# Create subtask
$HOME/.local/bin/asana-cli task subtasks create "1234567890" \
  --name "Subtask name" \
  --assignee "user@example.com"

# Convert task to subtask
$HOME/.local/bin/asana-cli task subtasks convert "1234567890" --parent "9876543210"

# Detach subtask (make it a top-level task)
$HOME/.local/bin/asana-cli task subtasks convert "1234567890" --detach
```

### Dependencies

```bash
# List tasks this task depends on
$HOME/.local/bin/asana-cli task depends-on list "1234567890"

# Add dependency (this task depends on another)
$HOME/.local/bin/asana-cli task depends-on add "1234567890" "9876543210"

# Remove dependency
$HOME/.local/bin/asana-cli task depends-on remove "1234567890" "9876543210"

# List tasks blocked by this task
$HOME/.local/bin/asana-cli task blocks list "1234567890"

# Add dependent (another task depends on this one)
$HOME/.local/bin/asana-cli task blocks add "1234567890" "9876543210"

# Remove dependent
$HOME/.local/bin/asana-cli task blocks remove "1234567890" "9876543210"
```

### Project Memberships

```bash
# List projects containing this task
$HOME/.local/bin/asana-cli task projects list "1234567890"

# Add task to project
$HOME/.local/bin/asana-cli task projects add "1234567890" "9876543210"

# Add to project in specific section
$HOME/.local/bin/asana-cli task projects add "1234567890" "9876543210" --section "5555555555"

# Remove from project
$HOME/.local/bin/asana-cli task projects remove "1234567890" "9876543210"
```

### Followers

```bash
# List task followers
$HOME/.local/bin/asana-cli task followers list "1234567890"

# Add followers
$HOME/.local/bin/asana-cli task followers add "1234567890" "user@example.com"

# Remove followers
$HOME/.local/bin/asana-cli task followers remove "1234567890" "user@example.com"
```

### Tags

```bash
# List tags on task
$HOME/.local/bin/asana-cli task tags list "1234567890"

# Add tag to task
$HOME/.local/bin/asana-cli task tags add "1234567890" "urgent"

# Remove tag from task
$HOME/.local/bin/asana-cli task tags remove "1234567890" "urgent"
```

### Comments (Stories)

```bash
# List comments on task
$HOME/.local/bin/asana-cli task comments list "1234567890"

# Add comment
$HOME/.local/bin/asana-cli task comments add "1234567890" --text "This looks great!"

# Show specific comment
$HOME/.local/bin/asana-cli task comments show "comment_gid"

# Update comment
$HOME/.local/bin/asana-cli task comments update "comment_gid" --text "Updated comment"

# Delete comment
$HOME/.local/bin/asana-cli task comments delete "comment_gid"
```

### Attachments

```bash
# List attachments on task
$HOME/.local/bin/asana-cli task attachments list "1234567890"

# Upload attachment
$HOME/.local/bin/asana-cli task attachments upload "1234567890" --file "/path/to/file.pdf"

# Show attachment details
$HOME/.local/bin/asana-cli task attachments show "attachment_gid"

# Delete attachment
$HOME/.local/bin/asana-cli task attachments delete "attachment_gid"
```

### Moving Tasks Between Sections

```bash
# Move task to section
$HOME/.local/bin/asana-cli task move-to-section "1234567890" --section "5555555555"

# Move with position control
$HOME/.local/bin/asana-cli task move-to-section "1234567890" \
  --section "5555555555" \
  --insert-before "9876543210"

$HOME/.local/bin/asana-cli task move-to-section "1234567890" \
  --section "5555555555" \
  --insert-after "9876543210"
```

## Project Operations

### Listing Projects

```bash
# List all projects
$HOME/.local/bin/asana-cli project list

# Filter by workspace
$HOME/.local/bin/asana-cli project list --workspace "1234567890"

# Filter by team
$HOME/.local/bin/asana-cli project list --team "9876543210"

# Filter archived projects
$HOME/.local/bin/asana-cli project list --archived false
$HOME/.local/bin/asana-cli project list --archived true

# Sort results
$HOME/.local/bin/asana-cli project list --sort name
$HOME/.local/bin/asana-cli project list --sort created_at
$HOME/.local/bin/asana-cli project list --sort modified_at

# Inline filtering
$HOME/.local/bin/asana-cli project list --filter "name~Frontend"
$HOME/.local/bin/asana-cli project list --filter "archived=false" --filter "workspace=1234567890"

# Use saved filter
$HOME/.local/bin/asana-cli project list --filter-saved "active-projects"

# Save filter for reuse
$HOME/.local/bin/asana-cli project list \
  --filter "workspace=1234567890" \
  --filter "archived=false" \
  --save-filter "active-projects"

# Limit results
$HOME/.local/bin/asana-cli project list --limit 10

# Request additional fields
$HOME/.local/bin/asana-cli project list --fields custom_fields --fields members

# JSON output
$HOME/.local/bin/asana-cli project list --output json
```

**Filter Expression Syntax:**
- `field=value` - Exact match
- `field!=value` - Not equal
- `field~regex` - Regex match
- `field:substring` - Contains substring

### Showing Project Details

```bash
# Show project details
$HOME/.local/bin/asana-cli project show "1234567890"

# Request additional fields
$HOME/.local/bin/asana-cli project show "1234567890" --fields custom_fields --fields members

# JSON output
$HOME/.local/bin/asana-cli project show "1234567890" --output json
```

### Creating Projects

```bash
# Basic project creation
$HOME/.local/bin/asana-cli project create \
  --name "New Project" \
  --workspace "1234567890"

# Create with full details
$HOME/.local/bin/asana-cli project create \
  --name "Q1 2025 Roadmap" \
  --workspace "1234567890" \
  --team "9876543210" \
  --notes "Project charter and requirements" \
  --owner "user@example.com" \
  --start-on "2025-01-01" \
  --due-on "2025-03-31" \
  --public true

# Add members during creation
$HOME/.local/bin/asana-cli project create \
  --name "Team Project" \
  --workspace "1234567890" \
  --member "user1@example.com" \
  --member "user2@example.com"

# Create with custom fields
$HOME/.local/bin/asana-cli project create \
  --name "Client Engagement" \
  --workspace "1234567890" \
  --custom-field "Status=Planning" \
  --custom-field "Budget=50000"

# Create from template (bundled or custom)
$HOME/.local/bin/asana-cli project create \
  --template standard_project \
  --var project_name="CLI Demo" \
  --var workspace_gid="1234567890" \
  --var team_gid="9876543210" \
  --var owner_email="user@example.com"

# Interactive creation
$HOME/.local/bin/asana-cli project create --interactive
```

### Updating Projects

```bash
# Update project name
$HOME/.local/bin/asana-cli project update "1234567890" --name "Updated Name"

# Update notes/description
$HOME/.local/bin/asana-cli project update "1234567890" --notes "New description"

# Update dates
$HOME/.local/bin/asana-cli project update "1234567890" --start-on "2025-01-01" --due-on "2025-12-31"

# Change owner
$HOME/.local/bin/asana-cli project update "1234567890" --owner "user@example.com"

# Archive/unarchive
$HOME/.local/bin/asana-cli project update "1234567890" --archived true
$HOME/.local/bin/asana-cli project update "1234567890" --archived false

# Update visibility
$HOME/.local/bin/asana-cli project update "1234567890" --public false
```

### Deleting Projects

```bash
# Delete project permanently
$HOME/.local/bin/asana-cli project delete "1234567890"
```

### Managing Project Members

```bash
# List project members
$HOME/.local/bin/asana-cli project members list "1234567890"

# Add member
$HOME/.local/bin/asana-cli project members add "1234567890" "user@example.com"

# Remove member
$HOME/.local/bin/asana-cli project members remove "1234567890" "user@example.com"
```

## Section Operations

```bash
# List sections in a project
$HOME/.local/bin/asana-cli section list --project "1234567890"

# Show section details
$HOME/.local/bin/asana-cli section show "5555555555"

# Create section
$HOME/.local/bin/asana-cli section create --project "1234567890" --name "In Progress"

# List tasks in section
$HOME/.local/bin/asana-cli section tasks "5555555555"
```

## Tag Operations

```bash
# List tags in workspace
$HOME/.local/bin/asana-cli tag list --workspace "1234567890"

# Show tag details
$HOME/.local/bin/asana-cli tag show "tag_gid"

# Create tag
$HOME/.local/bin/asana-cli tag create --workspace "1234567890" --name "urgent"

# Update tag
$HOME/.local/bin/asana-cli tag update "tag_gid" --name "high-priority"

# Delete tag
$HOME/.local/bin/asana-cli tag delete "tag_gid"
```

## Custom Field Operations

```bash
# List custom fields in workspace
$HOME/.local/bin/asana-cli custom-field list --workspace "1234567890"

# Show custom field details
$HOME/.local/bin/asana-cli custom-field show "field_gid"
```

## Workspace Operations

```bash
# List workspaces for current user
$HOME/.local/bin/asana-cli workspace list

# Show workspace details
$HOME/.local/bin/asana-cli workspace show "1234567890"

# JSON output
$HOME/.local/bin/asana-cli workspace list --output json
```

## User Operations

```bash
# List users in workspace
$HOME/.local/bin/asana-cli user list --workspace "1234567890"

# Show user details
$HOME/.local/bin/asana-cli user show "user_gid"
$HOME/.local/bin/asana-cli user show "user@example.com"

# Show current authenticated user
$HOME/.local/bin/asana-cli user me

# JSON output
$HOME/.local/bin/asana-cli user list --output json
```

## Work Tracking Integration

**CRITICAL**: Check for `.work-metadata.toml` for current work context.

**This file is MODEL-MANAGED ONLY** - Never manually edit it. Created by `work-start` tool, updated by agents.

**If file does not exist**, instruct operator to create it:
```bash
if [ ! -f .work-metadata.toml ]; then
  echo "ERROR: .work-metadata.toml not found"
  echo ""
  echo "Create it using: work-start --interactive"
  echo "See: work-start --help"
  exit 1
fi
```

**If file exists**, read Asana task:
```bash
# Read Asana task from work metadata
ASANA_TASK=$(toml get .work-metadata.toml work.asana_task 2>/dev/null || echo "")

# Extract task GID from URL if needed
if [[ "$ASANA_TASK" == https://app.asana.com/* ]]; then
  TASK_ID=$(echo "$ASANA_TASK" | grep -oE '[0-9]+$')
else
  TASK_ID="$ASANA_TASK"
fi
```

**Load work tracking standards** using the prompt skill:

```bash
# Load workflow standards for Asana updates
prompter workflow.issue-tracking
```

This provides:
- Asana update checkpoints (when to update, what to include)
- `.work-metadata.toml` discovery and parsing
- Linking workflow between Asana tasks and GitHub issues/PRs
- What belongs in Asana vs GitHub

### When to Update Asana

**Update at checkpoints only** - Not continuously:

1. **Work start**: Status → "In Progress"
   ```bash
   $HOME/.local/bin/asana-cli task update "$TASK_ID" \
     --notes "$(cat <<EOF
Starting work on this task.

Breaking down into GitHub issues for detailed tracking.
EOF
)"
   ```

2. **GitHub issues created**: Add comment with issue links
   ```bash
   $HOME/.local/bin/asana-cli task comments add "$TASK_ID" \
     --text "Created engineering tasks:
- Authentication schema: https://github.com/org/repo/issues/101
- JWT implementation: https://github.com/org/repo/issues/102
- Middleware integration: https://github.com/org/repo/issues/103"
   ```

3. **PRs opened**: Add comment with PR links
   ```bash
   $HOME/.local/bin/asana-cli task comments add "$TASK_ID" \
     --text "Implementation PRs:
- https://github.com/org/repo/pull/234 (JWT + middleware)
- https://github.com/org/repo/pull/235 (tests + docs)"
   ```

4. **Work complete**: Status → "Complete" with summary
   ```bash
   $HOME/.local/bin/asana-cli task update "$TASK_ID" --complete
   $HOME/.local/bin/asana-cli task comments add "$TASK_ID" \
     --text "$(cat <<EOF
Completed. All PRs merged, authentication fully implemented.

Summary:
- Implemented JWT-based authentication with 24hr token expiry
- Added middleware to all protected endpoints
- Full test coverage including edge cases
- API docs updated with authentication examples

Delivered in PRs: #234, #235
EOF
)"
   ```

### What NOT to Put in Asana

**Asana is for high-level product tracking only**:

- ❌ **NO implementation details** - "Fixed bug in token validation logic at jwt.py:142"
- ❌ **NO technical decisions** - "Chose HS256 over RS256 because..."
- ❌ **NO code snippets or examples**
- ❌ **NO debugging notes or troubleshooting**

**All technical details belong in GitHub issues.**

### What DOES Belong in Asana

- ✅ **Status updates** - "In Progress", "Complete"
- ✅ **Links to GitHub** - Issues and PR URLs
- ✅ **High-level summaries** - "Authentication implemented and tested"
- ✅ **Delivery confirmation** - "Deployed to production"

### Example: Good vs Bad Asana Updates

**Bad (too much technical detail)**:
```
Updated JWT validation middleware to use UTC-aware datetime
comparisons instead of naive datetimes. This fixes the bug where
tokens weren't expiring correctly due to timezone offset issues
in the comparison logic at lines 142-145 of jwt.py.
```

**Good (high-level, links to details)**:
```
Fixed token expiry validation bug. Details in PR #245.
```

## Common Workflows

### Daily Task Review

```bash
# Check your incomplete tasks
$HOME/.local/bin/asana-cli task list \
  --assignee "me" \
  --completed false \
  --sort due_on \
  --output table

# Find overdue tasks
$HOME/.local/bin/asana-cli task list \
  --assignee "me" \
  --completed false \
  --due-before "today" \
  --output table
```

### Project Setup

```bash
# 1. Create project from template
PROJECT_ID=$($HOME/.local/bin/asana-cli project create \
  --template standard_project \
  --var project_name="Q1 Roadmap" \
  --var workspace_gid="1234567890" \
  --output json | jq -r '.gid')

# 2. Add team members
$HOME/.local/bin/asana-cli project members add "$PROJECT_ID" "user1@example.com"
$HOME/.local/bin/asana-cli project members add "$PROJECT_ID" "user2@example.com"

# 3. Create initial tasks
$HOME/.local/bin/asana-cli task create \
  --name "Project kickoff meeting" \
  --project "$PROJECT_ID" \
  --assignee "user1@example.com" \
  --due-on "next Monday"
```

### Bulk Task Updates

```bash
# 1. Export tasks to JSON
$HOME/.local/bin/asana-cli task list \
  --project "1234567890" \
  --output json > tasks.json

# 2. Process with jq or script
jq '.[] | select(.assignee==null) | .gid' tasks.json > unassigned.txt

# 3. Update in batch
while read task_id; do
  $HOME/.local/bin/asana-cli task update "$task_id" --assignee "user@example.com"
done < unassigned.txt
```

### Finding Blocked Work

```bash
# Find tasks that are blocked
$HOME/.local/bin/asana-cli task search \
  --workspace "1234567890" \
  --blocked true \
  --completed false \
  --output table

# Show dependencies for a task
$HOME/.local/bin/asana-cli task depends-on list "1234567890"
```

### Sprint Planning

```bash
# 1. List ready tasks
$HOME/.local/bin/asana-cli task search \
  --workspace "1234567890" \
  --project "1234567890" \
  --completed false \
  --output json > ready_tasks.json

# 2. Move selected tasks to "Sprint" section
SECTION_ID="5555555555"
cat ready_tasks.json | jq -r '.[] | .gid' | while read task_id; do
  $HOME/.local/bin/asana-cli task move-to-section "$task_id" --section "$SECTION_ID"
done
```

### Reporting

```bash
# Export project tasks to CSV for reporting
$HOME/.local/bin/asana-cli task list \
  --project "1234567890" \
  --output csv > project_report.csv

# Get task counts by assignee
$HOME/.local/bin/asana-cli task list \
  --project "1234567890" \
  --output json | \
  jq -r 'group_by(.assignee.name) | map({assignee: .[0].assignee.name, count: length})'
```

## Troubleshooting

### Verify Installation and Auth

```bash
# Check CLI health
$HOME/.local/bin/asana-cli doctor

# Test configuration
$HOME/.local/bin/asana-cli config test

# View config (token redacted)
$HOME/.local/bin/asana-cli config get
```

### Common Issues

**Authentication Errors:**
```bash
# Token expired or invalid
$HOME/.local/bin/asana-cli config set token  # Re-enter token
$HOME/.local/bin/asana-cli config test  # Verify

# Or use environment variable
export ASANA_PAT="your_new_token"
$HOME/.local/bin/asana-cli config test
```

**Permission Errors:**
- Ensure PAT has required scopes for operations
- Check workspace/project access permissions in Asana web UI

**Not Found Errors:**
- Verify GIDs are correct using `--output json`
- Check resource hasn't been deleted
- Ensure you have access to the workspace/project

**Rate Limiting:**
- CLI handles rate limits automatically with retries
- Consider reducing `--limit` values for large queries
- Use caching (automatic) for repeated queries

### Debug Mode

Enable verbose logging via environment variable:
```bash
RUST_LOG=debug $HOME/.local/bin/asana-cli task list
```

## Best Practices

### Use JSON for Scripting

Always use `--output json` when parsing CLI output in scripts:
```bash
# Good - reliable structured data
TASK_GID=$($HOME/.local/bin/asana-cli task create --name "Test" --workspace "123" --output json | jq -r '.gid')

# Bad - parsing table output is fragile
# Don't do this
```

### Leverage Saved Filters

Save frequently used filters to reduce typing:
```bash
# Save filter
$HOME/.local/bin/asana-cli project list \
  --filter "workspace=1234567890" \
  --filter "archived=false" \
  --save-filter "active"

# Reuse filter
$HOME/.local/bin/asana-cli project list --filter-saved "active"
```

### Use Natural Language for Dates

The CLI accepts natural language for date inputs:
- `"today"`, `"tomorrow"`, `"next Friday"`
- `"in 2 weeks"`, `"next month"`
- `"2025-12-31"` (ISO format also supported)

### Default Workspace and Assignee

Set defaults to reduce command verbosity:
```bash
$HOME/.local/bin/asana-cli config set workspace --workspace "1234567890"
$HOME/.local/bin/asana-cli config set assignee --assignee "me@example.com"

# Now these work without flags
$HOME/.local/bin/asana-cli task list
$HOME/.local/bin/asana-cli task create --name "Quick task"
```

### Batch Operations for Efficiency

Use batch operations for bulk changes:
```bash
# Better - single batch operation
$HOME/.local/bin/asana-cli task create-batch --file tasks.json

# Slower - individual creates in loop
# Avoid for > 5 tasks
```

### Request Only Needed Fields

Minimize API usage by requesting only required fields:
```bash
# If you need custom fields
$HOME/.local/bin/asana-cli task list --fields custom_fields

# If you need everything
$HOME/.local/bin/asana-cli task list --fields custom_fields --fields tags --fields memberships
```

## Advanced Features

### Templates

Templates support variable substitution for project creation:

**Standard Template (bundled):**
```bash
$HOME/.local/bin/asana-cli project create \
  --template standard_project \
  --var project_name="My Project" \
  --var workspace_gid="1234567890"
```

**Custom Templates:**
Place in `~/.local/share/asana-cli/templates/custom.toml`:
```toml
name = "{{project_name}}"
workspace = "{{workspace_gid}}"
owner = "{{owner_email}}"

[[sections]]
name = "Backlog"

[[sections]]
name = "In Progress"

[[sections]]
name = "Done"
```

### Inline Filters

Use filter expressions for complex queries:
```bash
# Regex matching
$HOME/.local/bin/asana-cli project list --filter "name~^Frontend"

# Substring search
$HOME/.local/bin/asana-cli project list --filter "name:Dashboard"

# Multiple conditions
$HOME/.local/bin/asana-cli project list \
  --filter "workspace=1234567890" \
  --filter "archived=false" \
  --filter "name~2025"
```

### Caching

CLI caches API responses automatically:
- Cache location: `~/.local/share/asana-cli/cache/`
- Offline mode: Works with cached data when network unavailable
- Cache cleared on config changes

## Shell Completions

Generate completion scripts for your shell:
```bash
# Bash
$HOME/.local/bin/asana-cli completions bash > ~/.local/share/bash-completion/completions/asana-cli

# Zsh
$HOME/.local/bin/asana-cli completions zsh > /usr/local/share/zsh/site-functions/_asana-cli

# Fish
$HOME/.local/bin/asana-cli completions fish > ~/.config/fish/completions/asana-cli.fish

# PowerShell
$HOME/.local/bin/asana-cli completions powershell > ~/Documents/PowerShell/Scripts/asana-cli.ps1
```

## Version Information

```bash
# Show version
$HOME/.local/bin/asana-cli version

# Show license
$HOME/.local/bin/asana-cli license

# Update to latest version
$HOME/.local/bin/asana-cli update
```

## Additional Resources

- [asana-cli Repository](https://github.com/tftio/asana-cli)
- [Asana API Documentation](https://developers.asana.com/docs)
- Configuration: `~/.config/asana-cli/config.toml`
- Cache: `~/.local/share/asana-cli/cache/`
- Templates: `~/.local/share/asana-cli/templates/`
- Filters: `~/.local/share/asana-cli/filters/`
