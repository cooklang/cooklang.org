---
title: 'Commands'
weight: 20
description: 'CookCLI commands documentation'
---

A command-line interface for managing and working with Cooklang recipes.

| Command | Alias | Description |
|---------|-------|-------------|
| [recipe](recipe) | `r` | Parse, validate and display recipe files |
| [shopping-list](shopping-list) | `sl` | Generate a combined shopping list from recipes |
| [server](server) | `s` | Start a web server to browse recipes |
| [search](search) | `f` | Search through your recipe collection |
| [import](import) | `i` | Import recipes from websites |
| [report](report) | `rp` | Generate custom reports using templates |
| [doctor](doctor) | | Analyze recipes for issues |
| [pantry](pantry) | `p` | Manage and analyze pantry inventory |
| [seed](seed) | | Initialize with example recipes |
| [lsp](lsp) | | Start the Language Server Protocol server |
| [update](update) | `u` | Update CookCLI to the latest version |

## Installation

### macOS (Homebrew)
```bash
brew install cookcli
```

### Build from Source
```bash
git clone https://github.com/cooklang/cookcli.git
cd cookcli
cargo build --release
```

## Global Options

| Option | Description |
|--------|-------------|
| `-v, --verbose...` | Increase verbosity (`-v` info, `-vv` debug, `-vvv` trace) |
| `-h, --help` | Print help |
| `-V, --version` | Print version |

## Quick Start

```bash
cook seed                                     # Create example recipes
cook recipe "Neapolitan Pizza"                # View a recipe
cook shopping-list "Neapolitan Pizza" "Easy Pancakes"  # Shopping list
cook server --open                            # Browse in browser
```

For the Cooklang markup language, see the [language specification](https://cooklang.org/docs/spec).
