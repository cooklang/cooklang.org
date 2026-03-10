---
title: 'Pantry'
weight: 99
description: 'CookCLI Pantry command documentation'
date: 2026-03-10T07:52:27+00:00
---


Manage and analyze your pantry inventory.

## Usage

```
cook pantry [OPTIONS] <COMMAND>
```

## Options

| Option | Description |
|--------|-------------|
| `-b, --base-path <PATH>` | Base path for recipes and configuration files |
| `-f, --format <FORMAT>` | Output format: `human` (default), `json`, `yaml` |

## Subcommands

### `depleted` (alias: `d`)

Show items that are out of stock or have low quantities.

```
cook pantry depleted [OPTIONS]
```

| Option | Description |
|--------|-------------|
| `--all` | Show all items including those without quantities |

Items are flagged when current quantity is at or below the `low` threshold. Without a `low` threshold, uses heuristics.

### `expiring` (alias: `e`)

Show items that are expiring soon.

```
cook pantry expiring [OPTIONS]
```

| Option | Description |
|--------|-------------|
| `-d, --days <DAYS>` | Number of days to look ahead (default: 7) |
| `--include-unknown` | Include items without expiry dates |

### `recipes` (alias: `r`)

List recipes that can be made with items currently in pantry.

```
cook pantry recipes [OPTIONS]
```

| Option | Description |
|--------|-------------|
| `-p, --partial` | Include partial matches (most ingredients available) |
| `--threshold <PERCENT>` | Minimum percentage of ingredients for partial matches (default: 75) |

### `plan`

Analyze ingredient usage across recipes to help plan pantry items.

```
cook pantry plan [OPTIONS]
```

| Option | Description |
|--------|-------------|
| `-n, --max-ingredients <N>` | Maximum number of ingredients to show (default: all needed for 100% coverage) |
| `-s, --skip <N>` | Skip the first N ingredients (default: 0) |
| `-m, --allow-missing <N>` | Allow recipes to be considered cookable even if N ingredients are missing (default: 0) |

## Configuration

The pantry inventory is defined in `pantry.conf` (TOML format), searched in:
1. `./config/pantry.conf` — local to recipe directory
2. `~/.config/cook/pantry.conf` — global configuration

### Format

```toml
[fridge]
milk = { quantity = "500%ml", low = "200%ml", expire = "2025-09-20" }
eggs = { quantity = "12", low = "6", bought = "2025-09-10", expire = "2025-09-25" }
butter = "250%g"

[pantry]
flour = { quantity = "2%kg", low = "500%g" }
salt = "1%kg"
```

Item attributes: `quantity`, `low` (threshold), `bought` (date), `expire` (date). Simple format (`item = "quantity"`) also supported.

## Examples

```bash
# Show low/out-of-stock items
cook pantry depleted

# Items expiring in the next 14 days
cook pantry expiring --days 14

# Recipes you can fully make
cook pantry recipes

# Recipes with at least 60% of ingredients
cook pantry recipes --partial --threshold 60

# Plan pantry stocking
cook pantry plan

# JSON output
cook pantry -f json depleted
```

## Notes

- Unit comparisons only work when units match (e.g., `g` vs `g`, not `kg` vs `g`)
- For items without units, use plain numbers (e.g., `eggs = { quantity = "6", low = "12" }`)
