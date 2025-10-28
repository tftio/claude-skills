---
description: Pull request review using pr-auditor agent
---

# Review Pull Request

Activate the **pr-auditor** skill to perform a comprehensive pull request review.

The pr-auditor agent will:
- Fetch PR details from GitHub using the github skill
- Load relevant technical standards via the prompt skill based on file types
- Analyze code changes in PR diff against loaded standards
- Run linting tools on changed files only
- Review database patterns for PostgreSQL/ORM usage
- Check API patterns for FastAPI best practices
- Post review comments to GitHub PR
- Update linked Asana tasks with review status
- Provide approval/request changes/block recommendation

If the user hasn't specified a PR number, ask which pull request to review.
