# Justfile for managing tftio-dev-tools plugin installation

# Default recipe shows available commands
default:
    @just --list

# Install plugin by symlinking entire repository to ~/.claude/plugins/
install:
    #!/usr/bin/env bash
    set -euo pipefail

    # Create plugins directory if it doesn't exist
    mkdir -p ~/.claude/plugins

    # Get absolute path to repo
    REPO_DIR="$(pwd)"
    TARGET="$HOME/.claude/plugins/tftio-dev-tools"

    if [ -L "$TARGET" ]; then
        echo "✓ Plugin already installed (symlinked)"
        echo "  Target: $(readlink "$TARGET")"
    elif [ -e "$TARGET" ]; then
        echo "⚠ Plugin exists but is not a symlink"
        echo "  Remove $TARGET manually if you want to reinstall"
        exit 1
    else
        ln -s "$REPO_DIR" "$TARGET"
        echo "✓ Plugin installed successfully"
        echo "  Symlinked: $REPO_DIR → $TARGET"
        echo ""
        echo "Plugin provides:"
        echo "  • 5 CLI tool skills (asana, github, prompt, versioneer, peter-hook)"
        echo "  • 6 workflow agents (plan-architect, plan-executor, greybeard, etc.)"
        echo "  • 6 slash commands (/create-plan, /execute-plan, /review-code, etc.)"
    fi

# Uninstall plugin by removing symlink
uninstall:
    #!/usr/bin/env bash
    set -euo pipefail

    REPO_DIR="$(pwd)"
    TARGET="$HOME/.claude/plugins/tftio-dev-tools"

    if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" = "$REPO_DIR" ]; then
        rm "$TARGET"
        echo "✓ Plugin uninstalled successfully"
    elif [ -L "$TARGET" ]; then
        echo "⚠ Plugin symlink points elsewhere: $(readlink "$TARGET")"
        echo "  Not removing (doesn't match this repo)"
    elif [ -e "$TARGET" ]; then
        echo "⚠ Plugin exists but is not a symlink"
        echo "  Remove $TARGET manually if needed"
    else
        echo "· Plugin not installed"
    fi

# Reinstall plugin (uninstall then install)
reinstall: uninstall install

# Show installation status
status:
    #!/usr/bin/env bash
    set -euo pipefail

    REPO_DIR="$(pwd)"
    TARGET="$HOME/.claude/plugins/tftio-dev-tools"

    echo "Plugin: tftio-dev-tools"
    echo "Repository: $REPO_DIR"
    echo ""

    if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" = "$REPO_DIR" ]; then
        echo "Status: ✓ Installed"
        echo "Target: $TARGET → $(readlink "$TARGET")"
        echo ""
        echo "Provides:"
        echo "  Skills (5):"
        echo "    • asana      - Asana project management"
        echo "    • github     - GitHub operations"
        echo "    • prompt     - Load prompter standards"
        echo "    • versioneer - Version management"
        echo "    • peter-hook - Git hooks management"
        echo ""
        echo "  Agents (6):"
        echo "    • plan-architect          - Create multi-phase plans"
        echo "    • plan-executor           - Execute documented plans"
        echo "    • greybeard               - Senior code review"
        echo "    • infrastructure-auditor  - IaC quality audit"
        echo "    • pr-auditor              - Pull request review"
        echo "    • python-auditor          - Python code audit"
        echo ""
        echo "  Commands (6):"
        echo "    • /create-plan             - Create project plan"
        echo "    • /execute-plan            - Execute plan phases"
        echo "    • /review-code             - Senior code review"
        echo "    • /audit-infrastructure    - Audit IaC"
        echo "    • /audit-python            - Audit Python code"
        echo "    • /review-pr               - Review pull request"
    elif [ -L "$TARGET" ]; then
        echo "Status: ⚠ Installed but points elsewhere"
        echo "Target: $TARGET → $(readlink "$TARGET")"
    elif [ -e "$TARGET" ]; then
        echo "Status: ⚠ Exists but not a symlink"
        echo "Target: $TARGET"
    else
        echo "Status: · Not installed"
        echo ""
        echo "Run 'just install' to install the plugin"
    fi

# Validate plugin structure
validate:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Validating plugin structure..."

    # Check marketplace.json exists
    if [ -f ".claude-plugin/marketplace.json" ]; then
        echo "✓ .claude-plugin/marketplace.json exists"
    else
        echo "✗ .claude-plugin/marketplace.json missing"
        exit 1
    fi

    # Check skills
    echo ""
    echo "Skills:"
    for skill in skills/*/SKILL.md; do
        if [ -f "$skill" ]; then
            skill_name=$(basename $(dirname "$skill"))
            echo "  ✓ $skill_name"
        fi
    done

    # Check agents
    echo ""
    echo "Agents:"
    for agent in agents/*/SKILL.md; do
        if [ -f "$agent" ]; then
            agent_name=$(basename $(dirname "$agent"))
            echo "  ✓ $agent_name"
        fi
    done

    # Check commands
    echo ""
    echo "Commands:"
    for cmd in commands/*.md; do
        if [ -f "$cmd" ]; then
            cmd_name=$(basename "$cmd" .md)
            echo "  ✓ /$cmd_name"
        fi
    done

    echo ""
    echo "✓ Plugin structure valid"
