---
description: Create a multi-phase project plan using plan-architect agent
---

# Create Plan

Activate the **plan-architect** skill and use it to create a structured project plan.

The plan-architect agent will:
- Gather requirements through systematic questioning
- Load relevant technical standards via the prompt skill
- Break work into ordered, manageable phases
- Create `docs/plans/{plan-name}/` with overview.md and phase files
- Document rationale, assumptions, and acceptance criteria
- Link to GitHub issues and Asana tasks for tracking
- Present the completed plan for approval

If the user hasn't specified what to plan, ask what feature or project they want to plan.
