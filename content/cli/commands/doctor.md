---
title: 'Doctor'
weight: 60
description: 'CookCLI Doctor command documentation'
date: 2026-02-26T12:59:18+00:00
---


Analyze your recipe collection for issues and improvements.

## Usage

```
cook doctor [OPTIONS] [COMMAND]
```

## Subcommands

### `validate`

Validate all recipes for syntax errors and warnings.

```
cook doctor validate [OPTIONS]
```

| Option | Description |
|--------|-------------|
| `-b, --base-path <PATH>` | Directory to scan for recipe files (default: current directory) |
| `--strict` | Exit with error code 1 if any issues are found (useful for CI/CD) |

Checks for: syntax errors, warnings, missing recipe references, invalid units or quantities.

### `aisle`

Check for ingredients missing from your aisle configuration.

```
cook doctor aisle [OPTIONS]
```

| Option | Description |
|--------|-------------|
| `-b, --base-path <PATH>` | Directory to scan for recipe files (default: current directory) |

Finds ingredients not assigned to any store section in `aisle.conf`.

### `pantry`

Check which recipe ingredients are in your pantry inventory.

```
cook doctor pantry [OPTIONS]
```

| Option | Description |
|--------|-------------|
| `-b, --base-path <PATH>` | Directory to scan for recipe files (default: current directory) |

Shows which ingredients are already tracked in `pantry.conf`.

## Examples

```bash
# Run all checks
cook doctor

# Validate recipes
cook doctor validate

# Strict mode for CI/CD
cook doctor validate --strict

# Check for uncategorized ingredients
cook doctor aisle

# Check pantry coverage
cook doctor pantry
```
