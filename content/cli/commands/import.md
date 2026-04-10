---
title: 'Import'
weight: 50
description: 'CookCLI Import command documentation'
date: 2026-04-10T18:01:50+00:00
---


Import recipes from websites and convert to Cooklang format.

Requires the `OPENAI_API_KEY` environment variable for conversion to Cooklang. Without the key, you can still download the original recipe content with `--skip-conversion`. Alternatively, use the [cook.md converter](https://cooklang.org/docs/getting-started#build-your-recipe-collection).

## Usage

```
cook import [OPTIONS] <URL>
```

## Arguments

| Argument | Description |
|----------|-------------|
| `<URL>` | URL of the recipe webpage to import. Works with sites using Recipe Schema.org markup. |

## Options

| Option | Description |
|--------|-------------|
| `-s, --skip-conversion` | Output original recipe data without converting to Cooklang |
| `--metadata <FORMAT>` | Metadata format: `frontmatter` (default), `json`, `yaml`, `none` |
| `--metadata-only` | Output only metadata, no recipe content |

## Examples

```bash
# Import and convert to Cooklang
cook import https://www.bbcgoodfood.com/recipes/chicken-bacon-pasta

# Save to file
cook import https://example.com/recipe > lasagna.cook

# Get raw data without conversion
cook import https://example.com/recipe --skip-conversion

# Extract metadata only as JSON
cook import https://example.com/recipe --metadata-only --metadata json
```
