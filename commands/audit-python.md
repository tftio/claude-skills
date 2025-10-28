---
description: Python code quality audit using python-auditor agent
---

# Audit Python Code

Activate the **python-auditor** skill to perform a comprehensive Python code quality audit.

The python-auditor agent will:
- Load current project standards from prompter's `python.full` profile
- Research modern Python best practices (current as of January 2025)
- Audit Python code for quality, standards compliance, and best practices
- Run project linting tools (ruff, ty, interrogate)
- Maintain audit documentation in `docs/code-audit.md`
- Track issues in TODO format with file:line references
- Document findings in CHANGELOG format with dates

If the user hasn't specified what to audit, ask which Python files or modules to audit.
