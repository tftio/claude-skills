# Peter Hook Examples

This directory contains example outputs from peter-hook commands to help Claude understand the tool's output formats and structure.

## Contents

### validate-output.json
Example output from `peter-hook validate --trace-imports --json` showing:
- Import resolution diagnostics
- Hook overrides
- Dependency cycles (if any)
- Unused imports

Useful for understanding import merge order and configuration validation.

### doctor-output.txt
Example output from `peter-hook doctor` showing:
- Git repository status
- Configuration file status
- Validation results
- Update status

Useful for troubleshooting setup issues.

### list-output.txt
Example output from `peter-hook list` showing:
- Installed git hooks
- Available events

Useful for discovering what hooks are configured.

### hooks-example.toml
Reference example of a hooks.toml configuration showing:
- Hook definitions
- Groups
- File targeting
- Dependencies
- Execution types

Useful for understanding hook configuration when helping users write or modify hooks.toml files.

## Usage

These examples help Claude:
1. Understand peter-hook output formats
2. Parse JSON validation diagnostics
3. Interpret doctor health check results
4. Recognize hook configuration patterns
5. Provide accurate guidance on hook setup

## Notes

- Examples are representative outputs, not exhaustive
- Actual output may vary based on peter-hook version
- JSON output is most useful for programmatic parsing
- Examples focus on common use cases and patterns
