# Asana CLI Examples

This directory contains example JSON outputs from various `asana-cli` commands to help Claude understand the data structures returned by the API.

## Task Examples

### Task List Output

Example output from `asana-cli task list --output json`:

```json
[
  {
    "gid": "1234567890123456",
    "name": "Fix authentication bug",
    "resource_type": "task",
    "assignee": {
      "gid": "9876543210987654",
      "name": "John Doe",
      "email": "john@example.com"
    },
    "completed": false,
    "due_on": "2025-11-15",
    "modified_at": "2025-10-27T10:30:00.000Z",
    "projects": [
      {
        "gid": "5555555555555555",
        "name": "Backend Team"
      }
    ]
  },
  {
    "gid": "1111111111111111",
    "name": "Implement user dashboard",
    "resource_type": "task",
    "assignee": {
      "gid": "9876543210987654",
      "name": "John Doe",
      "email": "john@example.com"
    },
    "completed": false,
    "due_on": "2025-11-30",
    "modified_at": "2025-10-26T15:45:00.000Z",
    "projects": [
      {
        "gid": "6666666666666666",
        "name": "Frontend Team"
      }
    ],
    "tags": [
      {
        "gid": "7777777777777777",
        "name": "feature"
      }
    ]
  }
]
```

### Task Detail Output

Example output from `asana-cli task show <gid> --output json`:

```json
{
  "gid": "1234567890123456",
  "name": "Fix authentication bug",
  "resource_type": "task",
  "assignee": {
    "gid": "9876543210987654",
    "name": "John Doe",
    "email": "john@example.com"
  },
  "assignee_status": "today",
  "completed": false,
  "completed_at": null,
  "created_at": "2025-10-20T08:00:00.000Z",
  "dependencies": [
    {
      "gid": "2222222222222222",
      "name": "Write test suite"
    }
  ],
  "dependents": [],
  "due_at": null,
  "due_on": "2025-11-15",
  "start_on": "2025-11-01",
  "html_notes": "<body><p>User authentication fails when using OAuth2 flow.</p></body>",
  "notes": "User authentication fails when using OAuth2 flow.",
  "memberships": [
    {
      "project": {
        "gid": "5555555555555555",
        "name": "Backend Team"
      },
      "section": {
        "gid": "8888888888888888",
        "name": "In Progress"
      }
    }
  ],
  "modified_at": "2025-10-27T10:30:00.000Z",
  "num_hearts": 0,
  "num_likes": 2,
  "parent": null,
  "projects": [
    {
      "gid": "5555555555555555",
      "name": "Backend Team"
    }
  ],
  "tags": [
    {
      "gid": "3333333333333333",
      "name": "bug"
    },
    {
      "gid": "4444444444444444",
      "name": "urgent"
    }
  ],
  "workspace": {
    "gid": "1010101010101010",
    "name": "My Workspace"
  },
  "followers": [
    {
      "gid": "9876543210987654",
      "name": "John Doe",
      "email": "john@example.com"
    },
    {
      "gid": "5432109876543210",
      "name": "Jane Smith",
      "email": "jane@example.com"
    }
  ],
  "custom_fields": [
    {
      "gid": "1231231231231231",
      "name": "Priority",
      "type": "enum",
      "enum_value": {
        "gid": "4564564564564564",
        "name": "High",
        "color": "red"
      }
    },
    {
      "gid": "7897897897897897",
      "name": "Story Points",
      "type": "number",
      "number_value": 5
    }
  ]
}
```

## Project Examples

### Project List Output

Example output from `asana-cli project list --output json`:

```json
[
  {
    "gid": "5555555555555555",
    "name": "Backend Team",
    "resource_type": "project",
    "archived": false,
    "created_at": "2025-01-15T10:00:00.000Z",
    "modified_at": "2025-10-27T09:00:00.000Z",
    "owner": {
      "gid": "9876543210987654",
      "name": "John Doe",
      "email": "john@example.com"
    },
    "workspace": {
      "gid": "1010101010101010",
      "name": "My Workspace"
    }
  },
  {
    "gid": "6666666666666666",
    "name": "Frontend Team",
    "resource_type": "project",
    "archived": false,
    "created_at": "2025-01-20T10:00:00.000Z",
    "modified_at": "2025-10-26T14:00:00.000Z",
    "owner": {
      "gid": "5432109876543210",
      "name": "Jane Smith",
      "email": "jane@example.com"
    },
    "workspace": {
      "gid": "1010101010101010",
      "name": "My Workspace"
    }
  }
]
```

### Project Detail Output

Example output from `asana-cli project show <gid> --output json`:

```json
{
  "gid": "5555555555555555",
  "name": "Backend Team",
  "resource_type": "project",
  "archived": false,
  "color": "light-green",
  "created_at": "2025-01-15T10:00:00.000Z",
  "current_status": {
    "gid": "9999999999999999",
    "text": "On track for Q4 delivery",
    "color": "green",
    "created_at": "2025-10-25T12:00:00.000Z",
    "created_by": {
      "gid": "9876543210987654",
      "name": "John Doe"
    }
  },
  "due_on": "2025-12-31",
  "html_notes": "<body><p>Backend services and API development</p></body>",
  "notes": "Backend services and API development",
  "members": [
    {
      "gid": "9876543210987654",
      "name": "John Doe",
      "email": "john@example.com"
    },
    {
      "gid": "5432109876543210",
      "name": "Jane Smith",
      "email": "jane@example.com"
    }
  ],
  "modified_at": "2025-10-27T09:00:00.000Z",
  "owner": {
    "gid": "9876543210987654",
    "name": "John Doe",
    "email": "john@example.com"
  },
  "public": true,
  "start_on": "2025-01-15",
  "workspace": {
    "gid": "1010101010101010",
    "name": "My Workspace"
  },
  "custom_fields": [
    {
      "gid": "1231231231231231",
      "name": "Status",
      "type": "enum",
      "enum_value": {
        "gid": "7897897897897897",
        "name": "In Progress",
        "color": "blue"
      }
    }
  ]
}
```

## Section Examples

### Section List Output

Example output from `asana-cli section list --project <gid> --output json`:

```json
[
  {
    "gid": "8888888888888888",
    "name": "In Progress",
    "resource_type": "section",
    "project": {
      "gid": "5555555555555555",
      "name": "Backend Team"
    },
    "created_at": "2025-01-15T10:05:00.000Z"
  },
  {
    "gid": "9999999999999999",
    "name": "Review",
    "resource_type": "section",
    "project": {
      "gid": "5555555555555555",
      "name": "Backend Team"
    },
    "created_at": "2025-01-15T10:06:00.000Z"
  },
  {
    "gid": "1010101010101010",
    "name": "Done",
    "resource_type": "section",
    "project": {
      "gid": "5555555555555555",
      "name": "Backend Team"
    },
    "created_at": "2025-01-15T10:07:00.000Z"
  }
]
```

## Workspace Examples

### Workspace List Output

Example output from `asana-cli workspace list --output json`:

```json
[
  {
    "gid": "1010101010101010",
    "name": "My Workspace",
    "resource_type": "workspace",
    "is_organization": true
  },
  {
    "gid": "2020202020202020",
    "name": "Personal Projects",
    "resource_type": "workspace",
    "is_organization": false
  }
]
```

## User Examples

### User List Output

Example output from `asana-cli user list --workspace <gid> --output json`:

```json
[
  {
    "gid": "9876543210987654",
    "name": "John Doe",
    "email": "john@example.com",
    "resource_type": "user",
    "photo": {
      "image_128x128": "https://example.com/photo.jpg"
    }
  },
  {
    "gid": "5432109876543210",
    "name": "Jane Smith",
    "email": "jane@example.com",
    "resource_type": "user",
    "photo": null
  }
]
```

### Current User Output

Example output from `asana-cli user me --output json`:

```json
{
  "gid": "9876543210987654",
  "name": "John Doe",
  "email": "john@example.com",
  "resource_type": "user",
  "photo": {
    "image_128x128": "https://example.com/photo.jpg"
  },
  "workspaces": [
    {
      "gid": "1010101010101010",
      "name": "My Workspace"
    },
    {
      "gid": "2020202020202020",
      "name": "Personal Projects"
    }
  ]
}
```

## Tag Examples

### Tag List Output

Example output from `asana-cli tag list --workspace <gid> --output json`:

```json
[
  {
    "gid": "3333333333333333",
    "name": "bug",
    "resource_type": "tag",
    "color": "red",
    "workspace": {
      "gid": "1010101010101010",
      "name": "My Workspace"
    }
  },
  {
    "gid": "7777777777777777",
    "name": "feature",
    "resource_type": "tag",
    "color": "blue",
    "workspace": {
      "gid": "1010101010101010",
      "name": "My Workspace"
    }
  },
  {
    "gid": "4444444444444444",
    "name": "urgent",
    "resource_type": "tag",
    "color": "orange",
    "workspace": {
      "gid": "1010101010101010",
      "name": "My Workspace"
    }
  }
]
```

## Custom Field Examples

### Custom Field List Output

Example output from `asana-cli custom-field list --workspace <gid> --output json`:

```json
[
  {
    "gid": "1231231231231231",
    "name": "Priority",
    "resource_type": "custom_field",
    "type": "enum",
    "enum_options": [
      {
        "gid": "4564564564564564",
        "name": "High",
        "color": "red",
        "enabled": true
      },
      {
        "gid": "7897897897897897",
        "name": "Medium",
        "color": "yellow",
        "enabled": true
      },
      {
        "gid": "1011011011011011",
        "name": "Low",
        "color": "green",
        "enabled": true
      }
    ],
    "workspace": {
      "gid": "1010101010101010",
      "name": "My Workspace"
    }
  },
  {
    "gid": "7897897897897897",
    "name": "Story Points",
    "resource_type": "custom_field",
    "type": "number",
    "precision": 0,
    "workspace": {
      "gid": "1010101010101010",
      "name": "My Workspace"
    }
  },
  {
    "gid": "3213213213213213",
    "name": "Due Date",
    "resource_type": "custom_field",
    "type": "date",
    "workspace": {
      "gid": "1010101010101010",
      "name": "My Workspace"
    }
  },
  {
    "gid": "6546546546546546",
    "name": "Description",
    "resource_type": "custom_field",
    "type": "text",
    "workspace": {
      "gid": "1010101010101010",
      "name": "My Workspace"
    }
  }
]
```

## Comments (Stories) Examples

### Comment List Output

Example output from `asana-cli task comments list <gid> --output json`:

```json
[
  {
    "gid": "1212121212121212",
    "resource_type": "story",
    "created_at": "2025-10-27T09:15:00.000Z",
    "created_by": {
      "gid": "9876543210987654",
      "name": "John Doe"
    },
    "text": "I've started working on this bug. Initial investigation shows it's related to token expiration.",
    "type": "comment"
  },
  {
    "gid": "3434343434343434",
    "resource_type": "story",
    "created_at": "2025-10-27T10:30:00.000Z",
    "created_by": {
      "gid": "5432109876543210",
      "name": "Jane Smith"
    },
    "text": "Thanks for the update! Let me know if you need help with the OAuth implementation.",
    "type": "comment"
  }
]
```

## Notes

- All GIDs shown are examples and should be replaced with actual values from your Asana workspace
- Dates are in ISO 8601 format
- Null values indicate optional fields that aren't set
- Custom fields vary by workspace configuration
- Use `--fields` flag to request additional data not shown by default
