---
title: 'Seed'
weight: 70
description: 'CookCLI Seed command documentation'
date: 2026-03-11T14:48:15+00:00
---


Initialize a directory with example Cooklang recipes.

## Usage

```
cook seed [OPTIONS] [DIR]
```

## Arguments

| Argument | Description |
|----------|-------------|
| `[DIR]` | Directory to create example recipes in (default: current directory). Created if it doesn't exist. |

## Examples

```bash
# Add examples to current directory
cook seed

# Create examples in a specific directory
cook seed ~/my-recipes
```

## Notes

- Creates example recipes demonstrating Cooklang features (ingredients, cookware, timers, metadata, recipe references)
- Includes folder structure and an `aisle.conf` configuration file
