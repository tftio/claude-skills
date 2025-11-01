# Justfile for managing tftio-dev-tools plugin installation

# Default recipe shows available commands
default:
    @just --list

# Install plugin by symlinking entire repository to ~/.claude/plugins/
install:
    #!/usr/bin/env bash
    set -euo pipefail

    # Get absolute path to repo
    REPO_DIR="$(pwd)"

    # Install work-start to ~/.local/bin
    echo "Installing work-start..."
    mkdir -p ~/.local/bin

    SCRIPT="$REPO_DIR/bin/work-start"
    BIN_TARGET="$HOME/.local/bin/work-start"

    if [ ! -f "$SCRIPT" ]; then
        echo "✗ bin/work-start not found in repository"
        exit 1
    fi

    if [ -L "$BIN_TARGET" ] && [ "$(readlink "$BIN_TARGET")" = "$SCRIPT" ]; then
        echo "✓ work-start already installed"
    elif [ -e "$BIN_TARGET" ]; then
        echo "  Removing existing work-start and reinstalling..."
        rm "$BIN_TARGET"
        ln -s "$SCRIPT" "$BIN_TARGET"
        echo "✓ work-start installed"
    else
        ln -s "$SCRIPT" "$BIN_TARGET"
        echo "✓ work-start installed"
    fi

    chmod +x "$SCRIPT"

    # Check if ~/.local/bin is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo "⚠ Warning: ~/.local/bin is not in your PATH"
        echo "  Add to your shell profile: export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi

    echo ""
    echo "Installing plugin..."

    # Create plugins directory if it doesn't exist
    mkdir -p ~/.claude/plugins

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
        echo "  • work-start tool for creating .work-metadata.toml"
    fi

# Install bin/work-start to ~/.local/bin
install-bin:
    #!/usr/bin/env bash
    set -euo pipefail

    # Create bin directory if it doesn't exist
    mkdir -p ~/.local/bin

    # Get absolute path to script
    SCRIPT="$(pwd)/bin/work-start"
    TARGET="$HOME/.local/bin/work-start"

    if [ ! -f "$SCRIPT" ]; then
        echo "✗ bin/work-start not found in repository"
        exit 1
    fi

    if [ -L "$TARGET" ]; then
        echo "✓ work-start already installed (symlinked)"
        echo "  Target: $(readlink "$TARGET")"
    elif [ -e "$TARGET" ]; then
        echo "⚠ work-start exists but is not a symlink"
        echo "  Removing and reinstalling..."
        rm "$TARGET"
        ln -s "$SCRIPT" "$TARGET"
        echo "✓ work-start installed"
    else
        ln -s "$SCRIPT" "$TARGET"
        echo "✓ work-start installed"
        echo "  Symlinked: $SCRIPT → $TARGET"
    fi

    # Ensure it's executable
    chmod +x "$SCRIPT"

    # Check if ~/.local/bin is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo ""
        echo "⚠ Warning: ~/.local/bin is not in your PATH"
        echo "  Add this to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
        echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi

# Uninstall plugin by removing symlink
uninstall:
    #!/usr/bin/env bash
    set -euo pipefail

    REPO_DIR="$(pwd)"

    # Uninstall work-start from ~/.local/bin
    echo "Uninstalling work-start..."
    SCRIPT="$REPO_DIR/bin/work-start"
    BIN_TARGET="$HOME/.local/bin/work-start"

    if [ -L "$BIN_TARGET" ] && [ "$(readlink "$BIN_TARGET")" = "$SCRIPT" ]; then
        rm "$BIN_TARGET"
        echo "✓ work-start uninstalled"
    elif [ -L "$BIN_TARGET" ]; then
        echo "⚠ work-start symlink points elsewhere: $(readlink "$BIN_TARGET")"
        echo "  Not removing (doesn't match this repo)"
    elif [ -e "$BIN_TARGET" ]; then
        echo "⚠ work-start exists but is not a symlink"
        echo "  Remove $BIN_TARGET manually if needed"
    else
        echo "· work-start not installed"
    fi

    echo ""
    echo "Uninstalling plugin..."

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

# Uninstall bin/work-start from ~/.local/bin
uninstall-bin:
    #!/usr/bin/env bash
    set -euo pipefail

    SCRIPT="$(pwd)/bin/work-start"
    TARGET="$HOME/.local/bin/work-start"

    if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" = "$SCRIPT" ]; then
        rm "$TARGET"
        echo "✓ work-start uninstalled successfully"
    elif [ -L "$TARGET" ]; then
        echo "⚠ work-start symlink points elsewhere: $(readlink "$TARGET")"
        echo "  Not removing (doesn't match this repo)"
    elif [ -e "$TARGET" ]; then
        echo "⚠ work-start exists but is not a symlink"
        echo "  Remove $TARGET manually if needed"
    else
        echo "· work-start not installed"
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

    # Check work-start installation
    echo ""
    echo "─────────────────────────────────────────────"
    echo ""
    WORK_START_SCRIPT="$REPO_DIR/bin/work-start"
    WORK_START_TARGET="$HOME/.local/bin/work-start"

    echo "Tool: work-start"
    echo ""

    if [ -L "$WORK_START_TARGET" ] && [ "$(readlink "$WORK_START_TARGET")" = "$WORK_START_SCRIPT" ]; then
        echo "Status: ✓ Installed"
        echo "Target: $WORK_START_TARGET → $(readlink "$WORK_START_TARGET")"
        echo ""
        echo "Purpose: Create .work-metadata.toml for work tracking"
        echo "Usage:   work-start --asana-ticket <url> --github-project <number>"
    elif [ -L "$WORK_START_TARGET" ]; then
        echo "Status: ⚠ Installed but points elsewhere"
        echo "Target: $WORK_START_TARGET → $(readlink "$WORK_START_TARGET")"
    elif [ -e "$WORK_START_TARGET" ]; then
        echo "Status: ⚠ Exists but not a symlink"
        echo "Target: $WORK_START_TARGET"
    else
        echo "Status: · Not installed"
        echo ""
        echo "Run 'just install-bin' to install work-start"
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
