---
title: 'Recipe'
weight: 10
description: 'CookCLI Recipe command documentation'
date: 2026-03-10T07:59:24+00:00
---


Parse and display Cooklang recipe files.

## Usage

```
cook recipe [OPTIONS] [RECIPE]
```

## Arguments

| Argument | Description |
|----------|-------------|
| `[RECIPE]` | Recipe file to read (stdin if not specified). Supports full path, relative path, recipe name, or scaling syntax (`recipe.cook:2`). The `.cook` extension is optional. |

## Options

| Option | Description |
|--------|-------------|
| `-f, --format <FORMAT>` | Output format: `human` (default), `json`, `yaml`, `cooklang`, `markdown`, `latex`, `typst`, `schema` |
| `-s, --scale <SCALE>` | Scaling factor for ingredient quantities (default: 1) |
| `-o, --output <FILE>` | Output file (format inferred from extension) |
| `--pretty` | Pretty-print JSON and YAML output |

## Examples

```bash
# View a recipe
cook recipe "Neapolitan Pizza"

# Scale a recipe 2x
cook recipe "Pasta.cook:2"

# Export as JSON
cook recipe "Neapolitan Pizza" -f json --pretty

# Save as Markdown
cook recipe "Neapolitan Pizza" -f markdown -o pizza.md

# Read from stdin
cat recipe.cook | cook recipe

# View a menu file
cook recipe "2 Day Plan.menu"
```

## Notes

- The `.cook` extension is optional and added automatically
- Scaling can use inline `:N` syntax or `--scale N` flag; inline takes precedence
- Menu files (`.menu`) are supported and scaling applies to all referenced recipes
- Output format is inferred from `-o` file extension when `-f` is not specified
