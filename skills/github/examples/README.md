# GitHub CLI Examples

This directory is for optional reference materials that can help Claude understand the output format of the `gh` CLI tool.

## Purpose

Adding example outputs here allows Claude to:
- Better parse and format CLI responses
- Understand the data structure returned by commands
- Handle edge cases more effectively
- Work with JSON output structures

## What to Add

You can optionally add files like:

### `issue-list.json`
Example output from listing issues:
```json
[
  {
    "number": 123,
    "title": "Bug: Application crashes on startup",
    "state": "open",
    "author": {
      "login": "username"
    },
    "assignees": [
      {
        "login": "developer"
      }
    ],
    "labels": [
      {
        "name": "bug"
      },
      {
        "name": "priority"
      }
    ],
    "createdAt": "2025-10-15T10:00:00Z",
    "url": "https://github.com/owner/repo/issues/123"
  }
]
```

### `pr-list.json`
Example output from listing pull requests:
```json
[
  {
    "number": 456,
    "title": "Fix: Resolve startup crash",
    "state": "open",
    "author": {
      "login": "developer"
    },
    "isDraft": false,
    "reviewDecision": "APPROVED",
    "mergeable": "MERGEABLE",
    "baseRefName": "main",
    "headRefName": "fix/startup-crash",
    "url": "https://github.com/owner/repo/pull/456"
  }
]
```

### `issue-view.json`
Example output from viewing issue details:
```json
{
  "number": 123,
  "title": "Bug: Application crashes on startup",
  "body": "When launching the application with --debug flag, it crashes immediately.",
  "state": "open",
  "author": {
    "login": "username"
  },
  "assignees": [
    {
      "login": "developer"
    }
  ],
  "labels": [
    {
      "name": "bug"
    }
  ],
  "milestone": {
    "title": "v1.0"
  },
  "comments": [
    {
      "author": {
        "login": "developer"
      },
      "body": "I can reproduce this. Working on a fix.",
      "createdAt": "2025-10-15T14:30:00Z"
    }
  ],
  "createdAt": "2025-10-15T10:00:00Z",
  "updatedAt": "2025-10-15T14:30:00Z",
  "url": "https://github.com/owner/repo/issues/123"
}
```

### `pr-view.json`
Example output from viewing PR details:
```json
{
  "number": 456,
  "title": "Fix: Resolve startup crash",
  "body": "Fixes #123\n\nThis PR resolves the startup crash by...",
  "state": "open",
  "isDraft": false,
  "author": {
    "login": "developer"
  },
  "baseRefName": "main",
  "headRefName": "fix/startup-crash",
  "reviewDecision": "APPROVED",
  "mergeable": "MERGEABLE",
  "additions": 25,
  "deletions": 10,
  "changedFiles": 3,
  "reviews": [
    {
      "author": {
        "login": "reviewer"
      },
      "state": "APPROVED",
      "body": "LGTM!",
      "createdAt": "2025-10-16T09:00:00Z"
    }
  ],
  "statusCheckRollup": {
    "state": "SUCCESS"
  },
  "createdAt": "2025-10-15T16:00:00Z",
  "url": "https://github.com/owner/repo/pull/456"
}
```

### `repo-list.json`
Example output from listing repositories:
```json
[
  {
    "name": "my-project",
    "description": "A sample project",
    "url": "https://github.com/username/my-project",
    "isPrivate": false,
    "isFork": false,
    "primaryLanguage": {
      "name": "JavaScript"
    },
    "stargazerCount": 42,
    "forkCount": 7
  }
]
```

### `release-list.json`
Example output from listing releases:
```json
[
  {
    "tagName": "v1.0.0",
    "name": "Version 1.0.0",
    "isPrerelease": false,
    "isDraft": false,
    "createdAt": "2025-10-01T12:00:00Z",
    "publishedAt": "2025-10-01T12:00:00Z",
    "url": "https://github.com/owner/repo/releases/tag/v1.0.0"
  }
]
```

### `project-list.json`
Example output from listing projects:
```json
[
  {
    "number": 1,
    "title": "Roadmap",
    "state": "OPEN",
    "url": "https://github.com/users/username/projects/1"
  }
]
```

### `search-issues.json`
Example output from searching issues:
```json
[
  {
    "number": 789,
    "title": "Feature request: Dark mode",
    "repository": {
      "nameWithOwner": "owner/repo"
    },
    "state": "open",
    "author": {
      "login": "user"
    },
    "url": "https://github.com/owner/repo/issues/789"
  }
]
```

## How to Use

1. Run your actual `gh` commands with `--json` flag to capture output
2. Save representative examples in this directory
3. Update the SKILL.md to reference these files if needed

## Note

These examples are optional. The skill will work without them by using `gh` commands dynamically. However, having examples can help Claude:
- Understand expected data structures
- Parse complex nested JSON
- Handle edge cases (null values, empty arrays, etc.)
- Format output for users more effectively
