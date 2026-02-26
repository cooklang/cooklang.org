---
title: 'Search'
weight: 40
description: 'CookCLI Search command documentation'
date: 2026-02-26T12:59:19+00:00
---


Search through your recipe collection for matching text.

## Usage

```
cook search [OPTIONS] <TERMS>...
```

## Arguments

| Argument | Description |
|----------|-------------|
| `<TERMS>...` | One or more search terms. Multiple terms are treated as AND (all must match). |

## Options

| Option | Description |
|--------|-------------|
| `-b, --base-dir <DIR>` | Directory to search for recipes (default: current directory, recursive) |

## Examples

```bash
# Find recipes mentioning chicken
cook search chicken

# Find recipes with both chicken and rice
cook search chicken rice

# Search in a specific directory
cook search -b ~/recipes pasta
```

## Notes

- Searches through recipe titles, ingredients, instructions, and metadata
- Case-insensitive
- Results are ranked by relevance
