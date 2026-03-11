---
title: 'CookCLI — Command-Line Recipe Manager and Shopping List Generator'
date: 2021-05-20T15:14:39+10:00
summary: CookCLI is a free, open-source command-line tool that generates shopping lists from recipes, runs a local recipe server, imports recipes from websites, and automates your cooking workflow.
---


CookCLI is a free, open-source command-line tool for working with [Cooklang](https://cooklang.org/docs/spec/) recipe files. It parses `.cook` files, generates combined shopping lists from multiple recipes, runs a local web server to browse your collection, imports recipes from websites, and scales servings — all from the terminal.

## Commands

| Command | Alias | Description |
|---------|-------|-------------|
| [recipe](commands/recipe) | `r` | Parse, validate and display recipe files |
| [shopping-list](commands/shopping-list) | `sl` | Generate a combined shopping list from recipes |
| [server](commands/server) | `s` | Start a web server to browse recipes |
| [search](commands/search) | `f` | Search through your recipe collection |
| [import](commands/import) | `i` | Import recipes from websites |
| [report](commands/report) | `rp` | Generate custom reports using templates |
| [doctor](commands/doctor) | | Analyze recipes for issues |
| [pantry](commands/pantry) | `p` | Manage and analyze pantry inventory |
| [seed](commands/seed) | | Initialize with example recipes |
| [lsp](commands/lsp) | | Start the Language Server Protocol server |
| [update](commands/update) | `u` | Update CookCLI to the latest version |

