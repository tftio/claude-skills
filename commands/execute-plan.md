---
description: Execute a multi-phase plan using plan-executor agent
---

# Execute Plan

Activate the **plan-executor** skill and use it to execute the plan specified by the user.

The plan-executor agent will:
- Read the plan from `docs/plans/{plan-name}/`
- Verify git status is clean
- Load technical standards via the prompt skill
- Execute phases systematically with git workflow
- Update GitHub issues and Asana tasks
- Follow all quality gates and testing requirements
- Use versioneer for version management
- Run peter-hook hooks for code quality

If the user hasn't specified a plan name, ask which plan in `docs/plans/` to execute.
