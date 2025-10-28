---
description: Infrastructure as Code quality audit using infrastructure-auditor agent
---

# Audit Infrastructure

Activate the **infrastructure-auditor** skill to perform an Infrastructure as Code quality audit.

The infrastructure-auditor agent will:
- Load devops standards from prompter's `devops.architecture` and `devops.deployment` profiles
- Research modern IaC best practices (current as of January 2025)
- Audit Terraform, Docker, and GitHub Actions for security and quality
- Run infrastructure linting tools (TFLint, Trivy, Checkov, Hadolint)
- Verify compliance with multi-tenant architecture patterns
- Maintain audit documentation in `docs/infrastructure-audit.md`
- Track issues in TODO format with file:line references

If the user hasn't specified what to audit, ask which infrastructure code to audit.
