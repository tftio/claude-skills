# Asana CLI Examples

This directory is for optional reference materials that can help Claude understand the output format of your asana-cli tool.

## Purpose

Adding example outputs here allows Claude to:
- Better parse and format CLI responses
- Understand the data structure returned by commands
- Handle edge cases more effectively

## What to Add

You can optionally add files like:

### `list-output.json`
Example output from listing tasks:
```json
{
  "tasks": [
    {
      "id": "1234567890",
      "name": "Example task",
      "status": "incomplete",
      "assignee": "user@example.com",
      "due_date": "2025-10-20",
      "project": "Engineering"
    }
  ]
}
```

### `task-details.json`
Example output from showing a specific task:
```json
{
  "id": "1234567890",
  "name": "Example task",
  "description": "Detailed description here",
  "status": "incomplete",
  "assignee": "user@example.com",
  "created_at": "2025-10-15T10:00:00Z",
  "modified_at": "2025-10-16T14:30:00Z",
  "due_date": "2025-10-20",
  "project": {
    "id": "9876543210",
    "name": "Engineering"
  },
  "tags": ["frontend", "bug"],
  "comments": []
}
```

### `projects-output.json`
Example output from listing projects:
```json
{
  "projects": [
    {
      "id": "9876543210",
      "name": "Engineering",
      "workspace": "Company Workspace"
    },
    {
      "id": "1111111111",
      "name": "Marketing",
      "workspace": "Company Workspace"
    }
  ]
}
```

## How to Use

1. Run your actual asana-cli commands and capture the output
2. Save representative examples in this directory
3. Update the SKILL.md to reference these files if needed

## Note

These examples are optional. The skill will work without them by using `--help` to discover command syntax dynamically.
