# Justfile for managing Claude Skills installation

# Default recipe shows available commands
default:
    @just --list

# Install skills and agents by symlinking to ~/.claude/
install:
    #!/usr/bin/env bash
    set -euo pipefail

    # Create directories if they don't exist
    mkdir -p ~/.claude/skills
    mkdir -p ~/.claude/agents

    # Get absolute path to repo
    REPO_DIR="$(pwd)"

    # Symlink each skill
    echo "Installing skills..."
    for skill in skills/*/; do
        skill_name=$(basename "$skill")
        target="$HOME/.claude/skills/$skill_name"

        if [ -L "$target" ]; then
            echo "  ✓ $skill_name (already linked)"
        elif [ -e "$target" ]; then
            echo "  ⚠ $skill_name (exists but not a symlink, skipping)"
        else
            ln -s "$REPO_DIR/$skill" "$target"
            echo "  + $skill_name"
        fi
    done

    # Symlink each agent
    echo "Installing agents..."
    for agent in agents/*.md; do
        agent_name=$(basename "$agent")
        target="$HOME/.claude/agents/$agent_name"

        if [ -L "$target" ]; then
            echo "  ✓ $agent_name (already linked)"
        elif [ -e "$target" ]; then
            echo "  ⚠ $agent_name (exists but not a symlink, skipping)"
        else
            ln -s "$REPO_DIR/$agent" "$target"
            echo "  + $agent_name"
        fi
    done

    echo "✓ Installation complete"

# Uninstall skills and agents by removing symlinks
uninstall:
    #!/usr/bin/env bash
    set -euo pipefail

    # Get absolute path to repo
    REPO_DIR="$(pwd)"

    # Remove skill symlinks
    echo "Uninstalling skills..."
    for skill in skills/*/; do
        skill_name=$(basename "$skill")
        target="$HOME/.claude/skills/$skill_name"

        if [ -L "$target" ] && [ "$(readlink "$target")" = "$REPO_DIR/$skill" ]; then
            rm "$target"
            echo "  - $skill_name"
        elif [ -L "$target" ]; then
            echo "  ⚠ $skill_name (symlink points elsewhere, skipping)"
        else
            echo "  · $skill_name (not installed)"
        fi
    done

    # Remove agent symlinks
    echo "Uninstalling agents..."
    for agent in agents/*.md; do
        agent_name=$(basename "$agent")
        target="$HOME/.claude/agents/$agent_name"

        if [ -L "$target" ] && [ "$(readlink "$target")" = "$REPO_DIR/$agent" ]; then
            rm "$target"
            echo "  - $agent_name"
        elif [ -L "$target" ]; then
            echo "  ⚠ $agent_name (symlink points elsewhere, skipping)"
        else
            echo "  · $agent_name (not installed)"
        fi
    done

    echo "✓ Uninstallation complete"

# Show installation status
status:
    #!/usr/bin/env bash
    set -euo pipefail

    REPO_DIR="$(pwd)"

    echo "Skills:"
    for skill in skills/*/; do
        skill_name=$(basename "$skill")
        target="$HOME/.claude/skills/$skill_name"

        if [ -L "$target" ] && [ "$(readlink "$target")" = "$REPO_DIR/$skill" ]; then
            echo "  ✓ $skill_name"
        elif [ -L "$target" ]; then
            echo "  ⚠ $skill_name (linked to $(readlink "$target"))"
        elif [ -e "$target" ]; then
            echo "  ✗ $skill_name (exists but not linked)"
        else
            echo "  · $skill_name (not installed)"
        fi
    done

    echo ""
    echo "Agents:"
    for agent in agents/*.md; do
        agent_name=$(basename "$agent")
        target="$HOME/.claude/agents/$agent_name"

        if [ -L "$target" ] && [ "$(readlink "$target")" = "$REPO_DIR/$agent" ]; then
            echo "  ✓ $agent_name"
        elif [ -L "$target" ]; then
            echo "  ⚠ $agent_name (linked to $(readlink "$target"))"
        elif [ -e "$target" ]; then
            echo "  ✗ $agent_name (exists but not linked)"
        else
            echo "  · $agent_name (not installed)"
        fi
    done
