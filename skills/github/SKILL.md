---
name: github
description: Interface for GitHub using gh CLI. Use this skill when users want to create, view, edit, or close issues; create, review, or merge pull requests; manage projects; create repositories; manage releases; search code or issues; or perform any GitHub-related operations.
---

# GitHub CLI Integration

This skill provides access to GitHub through the `gh` command-line tool (GitHub CLI v2.82.0+).

## When to Use This Skill

- Creating, viewing, editing, or closing issues
- Creating, reviewing, merging, or managing pull requests
- Managing GitHub Projects (v2)
- Creating or managing repositories
- Managing releases and assets
- Searching code, commits, issues, or pull requests
- Managing labels and milestones
- Working with GitHub Actions workflows
- Assigning work to GitHub Copilot

## CLI Tool

The GitHub CLI (`gh`) should be available in the system PATH. Verify with:
```bash
gh --version
```

## Command Structure

All commands follow this pattern:
```bash
gh <command> <subcommand> [flags]
```

Core commands:
- `issue` - Manage issues
- `pr` - Manage pull requests
- `project` - Work with GitHub Projects
- `repo` - Manage repositories
- `release` - Manage releases
- `label` - Manage labels
- `search` - Search across GitHub
- `run` - View GitHub Actions runs
- `workflow` - View GitHub Actions workflows

## Issue Operations

### Creating Issues

```bash
# Create an issue interactively
gh issue create

# Create with title and body
gh issue create --title "Bug report" --body "Description here"

# Create with labels
gh issue create --title "Bug" --label "bug" --label "priority"

# Create with assignees
gh issue create --title "Task" --assignee "@me"
gh issue create --title "Task" --assignee "username"
gh issue create --title "Task" --assignee "@copilot"  # Assign to Copilot (2025 feature)

# Create with milestone
gh issue create --title "Task" --milestone "v1.0"

# Create and add to project
gh issue create --title "Task" --project "Roadmap"

# Create from template
gh issue create --template "bug_report.md"

# Create in specific repo
gh issue create --repo owner/repo --title "Task"

# Read body from file
gh issue create --title "Task" --body-file body.txt

# Create and open in browser
gh issue create --web
```

### Listing Issues

```bash
# List open issues
gh issue list

# List all issues (including closed)
gh issue list --state all

# List closed issues
gh issue list --state closed

# Filter by assignee
gh issue list --assignee "@me"
gh issue list --assignee "username"

# Filter by author
gh issue list --author "username"

# Filter by label (multiple labels = AND)
gh issue list --label "bug" --label "priority"

# Filter by milestone
gh issue list --milestone "v1.0"

# Limit results
gh issue list --limit 50

# Advanced search
gh issue list --search "error no:assignee sort:created-asc"

# Output as JSON
gh issue list --json number,title,state,author,assignees,labels

# Different repo
gh issue list --repo owner/repo

# Open in web browser
gh issue list --web
```

### Viewing Issues

```bash
# View issue details
gh issue view 123

# View in browser
gh issue view 123 --web

# View with comments
gh issue view 123 --json body,comments

# Different repo
gh issue view 123 --repo owner/repo

# View by URL
gh issue view https://github.com/owner/repo/issues/123
```

### Editing Issues

```bash
# Edit title
gh issue edit 123 --title "New title"

# Edit body
gh issue edit 123 --body "Updated description"

# Read body from file
gh issue edit 123 --body-file updated.txt

# Add assignees
gh issue edit 123 --add-assignee "@me"
gh issue edit 123 --add-assignee "username,other-user"
gh issue edit 123 --add-assignee "@copilot"

# Remove assignees
gh issue edit 123 --remove-assignee "username"

# Add labels
gh issue edit 123 --add-label "bug,priority"

# Remove labels
gh issue edit 123 --remove-label "wontfix"

# Set milestone
gh issue edit 123 --milestone "v1.0"

# Remove milestone
gh issue edit 123 --remove-milestone

# Add to project
gh issue edit 123 --add-project "Roadmap"

# Remove from project
gh issue edit 123 --remove-project "Old Project"

# Edit multiple issues at once
gh issue edit 123 456 789 --add-label "needs-review"
```

### Closing Issues

```bash
# Close an issue
gh issue close 123

# Close with comment
gh issue close 123 --comment "Fixed in PR #456"

# Close with reason
gh issue close 123 --reason "completed"
gh issue close 123 --reason "not planned"
```

### Reopening Issues

```bash
# Reopen a closed issue
gh issue reopen 123
```

### Commenting on Issues

```bash
# Add a comment
gh issue comment 123 --body "Thanks for reporting!"

# Read comment from file
gh issue comment 123 --body-file comment.txt

# Open editor for comment
gh issue comment 123 --editor
```

### Other Issue Operations

```bash
# Pin an issue
gh issue pin 123

# Unpin an issue
gh issue unpin 123

# Lock conversation
gh issue lock 123

# Unlock conversation
gh issue unlock 123

# Delete an issue (careful!)
gh issue delete 123

# Transfer to another repo
gh issue transfer 123 --repo destination-owner/destination-repo

# View issue status for current repo
gh issue status

# Manage linked branches (develop)
gh issue develop 123
```

## Pull Request Operations

### Creating Pull Requests

```bash
# Create PR interactively
gh pr create

# Create with title and body
gh pr create --title "Fix bug" --body "Description here"

# Auto-fill from commits
gh pr create --fill

# Auto-fill from first commit
gh pr create --fill-first

# Include verbose commit messages
gh pr create --fill-verbose

# Create as draft
gh pr create --draft

# Create with base branch
gh pr create --base main

# Create with head branch
gh pr create --head feature-branch

# Create with reviewers
gh pr create --reviewer username,other-user
gh pr create --reviewer myorg/team-name

# Create with assignees
gh pr create --assignee "@me"

# Create with labels
gh pr create --label "bug" --label "backport"

# Add to milestone
gh pr create --milestone "v1.0"

# Add to project
gh pr create --project "Roadmap"

# From template
gh pr create --template pull_request_template.md

# Disable maintainer edits
gh pr create --no-maintainer-edit

# Dry run (don't actually create)
gh pr create --dry-run

# Different repo
gh pr create --repo owner/repo

# Open in browser
gh pr create --web
```

### Listing Pull Requests

```bash
# List open PRs
gh pr list

# List all PRs
gh pr list --state all

# List merged PRs
gh pr list --state merged

# List closed PRs
gh pr list --state closed

# Filter by author
gh pr list --author "@me"

# Filter by assignee
gh pr list --assignee "username"

# Filter by label
gh pr list --label "bug"

# Filter by base branch
gh pr list --base main

# Filter by head branch
gh pr list --head feature-branch

# Filter draft PRs
gh pr list --draft

# Limit results
gh pr list --limit 50

# Advanced search
gh pr list --search "status:success review:required"

# Find PR that introduced a commit
gh pr list --search "<SHA>" --state merged

# Output as JSON
gh pr list --json number,title,state,author,reviewDecision,mergeable

# Different repo
gh pr list --repo owner/repo

# Open in browser
gh pr list --web
```

### Viewing Pull Requests

```bash
# View PR details
gh pr view 123

# View in browser
gh pr view 123 --web

# View with comments
gh pr view 123 --json body,comments,reviews

# Different repo
gh pr view 123 --repo owner/repo

# View current branch's PR
gh pr view

# View by URL
gh pr view https://github.com/owner/repo/pull/123
```

### Checking Out Pull Requests

```bash
# Check out a PR locally
gh pr checkout 123

# Check out by branch name
gh pr checkout feature-branch

# Force checkout
gh pr checkout 123 --force
```

### Viewing PR Diff

```bash
# View PR diff
gh pr diff 123

# View specific file
gh pr diff 123 -- path/to/file.txt

# Show patch format
gh pr diff 123 --patch
```

### Checking PR Status

```bash
# View CI checks
gh pr checks 123

# Watch checks (refresh automatically)
gh pr checks 123 --watch

# View in browser
gh pr checks 123 --web
```

### Editing Pull Requests

```bash
# Edit title
gh pr edit 123 --title "New title"

# Edit body
gh pr edit 123 --body "Updated description"

# Change base branch
gh pr edit 123 --base develop

# Add reviewers
gh pr edit 123 --add-reviewer username,other-user

# Remove reviewers
gh pr edit 123 --remove-reviewer username

# Add assignees
gh pr edit 123 --add-assignee "@me"

# Add labels
gh pr edit 123 --add-label "needs-review"

# Add to milestone
gh pr edit 123 --milestone "v1.0"

# Add to project
gh pr edit 123 --add-project "Roadmap"

# Remove from project
gh pr edit 123 --remove-project "Old Project"
```

### Reviewing Pull Requests

```bash
# Approve PR
gh pr review 123 --approve

# Approve with comment
gh pr review 123 --approve --body "LGTM!"

# Request changes
gh pr review 123 --request-changes --body "Please address these issues"

# Comment (no approval/rejection)
gh pr review 123 --comment --body "Some thoughts"

# Read review body from file
gh pr review 123 --approve --body-file review.txt

# Review current branch's PR
gh pr review --approve
```

### Merging Pull Requests

```bash
# Merge (use repo's default method)
gh pr merge 123

# Merge with merge commit
gh pr merge 123 --merge

# Squash and merge
gh pr merge 123 --squash

# Rebase and merge
gh pr merge 123 --rebase

# Auto-merge when checks pass
gh pr merge 123 --auto

# Disable auto-merge
gh pr merge 123 --disable-auto

# Delete branch after merge
gh pr merge 123 --delete-branch

# Custom merge commit message
gh pr merge 123 --subject "Fix critical bug" --body "Details here"

# Admin merge (bypass requirements)
gh pr merge 123 --admin

# Match specific head commit
gh pr merge 123 --match-head-commit abc123

# Merge current branch's PR
gh pr merge
```

### Other PR Operations

```bash
# Close PR
gh pr close 123
gh pr close 123 --comment "Closing because..."

# Reopen PR
gh pr reopen 123

# Mark as ready for review
gh pr ready 123

# Update PR branch with base branch
gh pr update-branch 123

# Lock conversation
gh pr lock 123

# Unlock conversation
gh pr unlock 123

# Comment on PR
gh pr comment 123 --body "Great work!"

# View PR status for current repo
gh pr status
```

## Project Operations

**Note:** Project operations require the `project` scope. Authorize with:
```bash
gh auth refresh -s project
```

### Listing Projects

```bash
# List projects for owner
gh project list --owner username
gh project list --owner org-name

# Limit results
gh project list --owner username --limit 20

# Output as JSON
gh project list --owner username --json number,title,state
```

### Viewing Projects

```bash
# View project
gh project view 1 --owner username

# View in browser
gh project view 1 --owner username --web
```

### Creating Projects

```bash
# Create project
gh project create --owner username --title "Roadmap"

# Create for organization
gh project create --owner org-name --title "Team Board"
```

### Editing Projects

```bash
# Edit project
gh project edit 1 --owner username --title "New Title"
gh project edit 1 --owner username --description "New description"
```

### Closing/Deleting Projects

```bash
# Close project
gh project close 1 --owner username

# Delete project
gh project delete 1 --owner username
```

### Managing Project Fields

```bash
# List fields
gh project field-list 1 --owner username

# Create field
gh project field-create 1 --owner username --name "Priority" --data-type "SINGLE_SELECT"

# Delete field
gh project field-delete 1 --owner username --field-id FIELD_ID
```

### Managing Project Items

```bash
# List items
gh project item-list 1 --owner username

# Add issue to project
gh project item-add 1 --owner username --url https://github.com/owner/repo/issues/123

# Add PR to project
gh project item-add 1 --owner username --url https://github.com/owner/repo/pull/456

# Create draft issue in project
gh project item-create 1 --owner username --title "New task" --body "Description"

# Edit item
gh project item-edit --project-id PROJECT_ID --id ITEM_ID --field-id FIELD_ID --text "Value"

# Archive item
gh project item-archive --project-id PROJECT_ID --id ITEM_ID

# Delete item
gh project item-delete --project-id PROJECT_ID --id ITEM_ID
```

### Linking Projects

```bash
# Link project to repo
gh project link 1 --owner username --repo owner/repo

# Unlink project from repo
gh project unlink 1 --owner username --repo owner/repo
```

## Repository Operations

### Creating Repositories

```bash
# Create repo interactively
gh repo create

# Create with name
gh repo create my-repo

# Create with description
gh repo create my-repo --description "My project"

# Create private repo
gh repo create my-repo --private

# Create public repo
gh repo create my-repo --public

# Create with README, .gitignore, license
gh repo create my-repo --add-readme --gitignore Node --license MIT

# Clone after creating
gh repo create my-repo --clone

# Create from template
gh repo create my-repo --template owner/template-repo

# Create in organization
gh repo create org-name/repo-name
```

### Listing Repositories

```bash
# List your repos
gh repo list

# List org repos
gh repo list org-name

# Limit results
gh repo list --limit 50

# Filter by language
gh repo list --language javascript

# Include forks
gh repo list --source

# Output as JSON
gh repo list --json name,description,url,isPrivate
```

### Viewing Repositories

```bash
# View repo details
gh repo view

# View specific repo
gh repo view owner/repo

# View in browser
gh repo view owner/repo --web
```

### Cloning Repositories

```bash
# Clone a repo
gh repo clone owner/repo

# Clone to specific directory
gh repo clone owner/repo target-dir
```

### Forking Repositories

```bash
# Fork a repo
gh repo fork owner/repo

# Fork and clone
gh repo fork owner/repo --clone

# Fork to organization
gh repo fork owner/repo --org org-name

# Set remote name
gh repo fork owner/repo --remote-name upstream
```

### Editing Repositories

```bash
# Edit repo settings
gh repo edit owner/repo --description "New description"
gh repo edit owner/repo --homepage "https://example.com"
gh repo edit owner/repo --enable-issues
gh repo edit owner/repo --enable-wiki
gh repo edit owner/repo --visibility public
```

### Other Repo Operations

```bash
# Archive repo
gh repo archive owner/repo

# Unarchive repo
gh repo unarchive owner/repo

# Rename repo
gh repo rename new-name

# Delete repo (careful!)
gh repo delete owner/repo

# Set default repo for directory
gh repo set-default owner/repo

# Sync fork with upstream
gh repo sync owner/repo
```

## Release Operations

### Creating Releases

```bash
# Create release
gh release create v1.0.0

# Create with title and notes
gh release create v1.0.0 --title "Version 1.0" --notes "Release notes here"

# Read notes from file
gh release create v1.0.0 --notes-file CHANGELOG.md

# Auto-generate notes
gh release create v1.0.0 --generate-notes

# Create as draft
gh release create v1.0.0 --draft

# Create as prerelease
gh release create v1.0.0 --prerelease

# Upload assets
gh release create v1.0.0 --notes "Release" ./dist/*.zip

# Different repo
gh release create v1.0.0 --repo owner/repo
```

### Listing Releases

```bash
# List releases
gh release list

# Limit results
gh release list --limit 10

# Different repo
gh release list --repo owner/repo
```

### Viewing Releases

```bash
# View latest release
gh release view

# View specific release
gh release view v1.0.0

# View in browser
gh release view v1.0.0 --web
```

### Downloading Release Assets

```bash
# Download all assets from latest release
gh release download

# Download from specific release
gh release download v1.0.0

# Download specific pattern
gh release download v1.0.0 --pattern "*.zip"

# Download to directory
gh release download v1.0.0 --dir ./downloads
```

### Editing Releases

```bash
# Edit release
gh release edit v1.0.0 --title "New title"
gh release edit v1.0.0 --notes "Updated notes"
gh release edit v1.0.0 --draft=false
gh release edit v1.0.0 --prerelease=false
```

### Uploading Assets

```bash
# Upload assets to existing release
gh release upload v1.0.0 ./dist/*.zip

# Overwrite existing assets
gh release upload v1.0.0 ./dist/app.zip --clobber
```

### Deleting Releases

```bash
# Delete release (keeps tag)
gh release delete v1.0.0

# Delete release and tag
gh release delete v1.0.0 --cleanup-tag

# Skip confirmation
gh release delete v1.0.0 --yes
```

### Verifying Releases (2025 Security Feature)

```bash
# Verify release attestation
gh release verify v1.0.0

# Verify specific asset
gh release verify-asset asset-file.zip --repo owner/repo --tag v1.0.0
```

## Search Operations

### Searching Issues

```bash
# Search issues
gh search issues "bug"

# Search with qualifiers
gh search issues "bug is:open label:priority"

# Search in specific org
gh search issues "bug org:github"

# Limit results
gh search issues "bug" --limit 20

# Output as JSON
gh search issues "bug" --json number,title,url

# Exclude results (use -- to prevent - being interpreted as flag)
gh search issues -- "bug -label:wontfix"
```

### Searching Pull Requests

```bash
# Search PRs
gh search prs "fix"

# Search with qualifiers
gh search prs "fix is:merged"

# Search by author
gh search prs "author:username"
```

### Searching Repositories

```bash
# Search repos
gh search repos "machine learning"

# Search with qualifiers
gh search repos "stars:>1000 language:python"

# Search in org
gh search repos "topic:react org:facebook"
```

### Searching Code

```bash
# Search code
gh search code "function parseJSON"

# Search with qualifiers
gh search code "class auth" --language typescript

# Search in repo
gh search code "TODO" --repo owner/repo
```

### Searching Commits

```bash
# Search commits
gh search commits "fix bug"

# Search by author
gh search commits "author:username"

# Search in date range
gh search commits "merge" --author-date ">2025-01-01"
```

## Label Operations

```bash
# List labels
gh label list

# Create label
gh label create "priority" --description "High priority" --color "ff0000"

# Edit label
gh label edit "priority" --name "high-priority" --color "00ff00"

# Delete label
gh label delete "old-label"

# Clone labels from another repo
gh label clone source-owner/source-repo

# Different repo
gh label list --repo owner/repo
```

## GitHub Actions

### Workflow Operations

```bash
# List workflows
gh workflow list

# View workflow details
gh workflow view workflow.yml

# Enable workflow
gh workflow enable workflow.yml

# Disable workflow
gh workflow disable workflow.yml

# Run workflow
gh workflow run workflow.yml
```

### Run Operations

```bash
# List recent runs
gh run list

# View run details
gh run view 123456

# Watch run progress
gh run watch 123456

# View run logs
gh run view 123456 --log

# Cancel run
gh run cancel 123456

# Rerun run
gh run rerun 123456

# Download run artifacts
gh run download 123456
```

## Advanced Features

### Authentication

```bash
# Login
gh auth login

# Check auth status
gh auth status

# Refresh auth with additional scopes
gh auth refresh -s project

# Logout
gh auth logout
```

### API Access

```bash
# Make API request
gh api repos/owner/repo/issues

# POST request
gh api repos/owner/repo/issues -f title="New issue" -f body="Description"

# Pagination
gh api --paginate repos/owner/repo/issues
```

### Aliases

```bash
# Create alias
gh alias set bugs 'issue list --label bug'

# Use alias
gh bugs

# List aliases
gh alias list

# Delete alias
gh alias delete bugs
```

### Configuration

```bash
# Set editor
gh config set editor vim

# Set default protocol
gh config set git_protocol ssh

# View config
gh config list
```

## Output Formats

Use `--json` flag for machine-readable output:
```bash
gh issue list --json number,title,state,author,labels

gh pr list --json number,title,author,reviewDecision

gh repo list --json name,url,isPrivate
```

Use `--jq` for filtering JSON:
```bash
gh issue list --json number,title --jq '.[] | select(.number > 100)'
```

Use `--template` for custom formatting:
```bash
gh issue list --json number,title --template '{{range .}}#{{.number}}: {{.title}}{{"\n"}}{{end}}'
```

## Important Notes

### Special Assignee Values

- `@me` - Assign to yourself
- `@copilot` - Assign to GitHub Copilot (requires Copilot Pro+ or Enterprise, not available on GHES)

### Project Scope

Project operations require authorization:
```bash
gh auth refresh -s project
```

### Repository Context

Most commands auto-detect the repo from git remote. Override with:
```bash
gh <command> --repo owner/repo
```

### Argument Formats

Issues and PRs accept multiple formats:
- By number: `123`
- By URL: `https://github.com/owner/repo/issues/123`
- By branch name (PRs only): `feature-branch`

## Workflow Guidelines

### Before Running Commands

1. **Check authentication**: Verify with `gh auth status`
2. **Verify repo context**: Commands use current directory's git remote
3. **Use `--help`**: Get command-specific help with `gh <command> <subcommand> --help`
4. **Use JSON for parsing**: Add `--json` flag for programmatic use

### When Creating Issues or PRs

1. Use `--title` and `--body` for non-interactive creation
2. Use `@me` for self-assignment
3. Use `@copilot` to assign to GitHub Copilot
4. Specify `--repo` if not in repo directory
5. Use `--json` to capture created issue/PR number

### When Listing or Searching

1. Start with basic filters (`--state`, `--label`, `--author`)
2. Use `--search` for advanced queries
3. Use `--json` with `--jq` for complex filtering
4. Use `--limit` to control result count

### When Merging PRs

1. Check CI status first with `gh pr checks`
2. Review with `gh pr review` before merging
3. Use `--auto` for merge queue integration
4. Use `--delete-branch` to clean up after merge

## Best Practices

1. **Always use `--json` for parsing**: Reliable machine-readable output
2. **Use `--repo` for cross-repo operations**: Don't rely on directory context
3. **Leverage `@me` shortcut**: More intuitive than usernames
4. **Use `@copilot` for AI assistance**: Assign issues to Copilot for automated work
5. **Check auth status first**: Run `gh auth status` if commands fail
6. **Use `--web` for complex operations**: Opens GitHub UI when CLI is limiting
7. **Verify releases with attestations**: Use `gh release verify` for security
8. **Use merge queues**: Prefer `--auto` merge for repos with queue enabled

## Troubleshooting

- **Authentication errors**: Run `gh auth login` or `gh auth refresh`
- **Project scope errors**: Run `gh auth refresh -s project`
- **Command not found**: Install gh CLI: https://cli.github.com/
- **Permission denied**: Check repo permissions and auth status
- **Not in a git repo**: Either `cd` to repo or use `--repo` flag
- **Can't find issue/PR**: Verify number/URL and repo context

## Advanced Examples

### Bulk Operations

```bash
# Close multiple issues
for issue in 123 124 125; do gh issue close $issue; done

# Add label to all open bugs
gh issue list --label bug --json number --jq '.[].number' | xargs -I {} gh issue edit {} --add-label triaged
```

### Complex Searches

```bash
# Find stale PRs
gh pr list --search "is:open updated:<2025-01-01"

# Find unassigned P0 issues
gh issue list --search "is:open label:P0 no:assignee"
```

### Integration with Other Tools

```bash
# Export issues to CSV
gh issue list --json number,title,state,author --jq -r '.[] | [.number,.title,.state,.author.login] | @csv' > issues.csv

# Create issue from template
gh issue create --title "$(cat title.txt)" --body "$(cat body.md)"
```

## See Also

- GitHub CLI Manual: https://cli.github.com/manual
- GitHub Search Syntax: https://docs.github.com/en/search-github
- GitHub API: https://docs.github.com/en/rest
