# CookCLI: Getting Started

The CookCLI helps you manage recipes, generate shopping lists, and automate your cooking workflow with familiar command-line tools.

You can download the latest Cook CLI release using [GitHub Releases](https://github.com/cooklang/cookcli/releases).

For a more in-depth review of the CLI commands and their usages, [use this page](https://cooklang.org/cli/commands/).

## Install the Cook CLI Program
```bash
# macOS (Homebrew)
brew install cooklang/tap/cookcli

# Build from source
git clone https://github.com/cooklang/cookcli.git
cd cookcli
cargo build --release
```

## Core Commands
- **[recipe](https://cooklang.org/cli/commands/recipe)**: Show recipes in various outputs (Cooklang, JSON, etc.).
- **[shopping-list](https://cooklang.org/cli/commands/shopping-list)**: Combine ingredients from multiple recipes.
- **[server](https://cooklang.org/cli/commands/server)**: Browse your recipes in a local web UI.
- **[search](https://cooklang.org/cli/commands/search)**: Find recipes by ingredient or text.
- **[import](https://cooklang.org/cli/commands/import)**: Convert web recipes into Cooklang.
- **[update](https://cooklang.org/cli/commands/update)**: Fetch the latest CookCLI release.
- **[doctor](https://cooklang.org/cli/commands/doctor)**: Validate recipes.
- **[seed](https://cooklang.org/cli/commands/seed)**: Drop example recipes into the current directory.
- **[report](https://cooklang.org/cli/commands/report)**: Build custom reports from templates.

## Global Flags

CookCLI allows several options that apply to all commands globally.

They are:
- Base path, used to specify the directory of your recipes. For example: `cook --base-path ~/my-recipes recipe "Pizza.cook"` or short `-b`.
- Logging verbosity levels, with four different levels of granularity. They are: none (default), `-v` (info), `-vv` (debug), `-vvv` (trace).

## Quick Start
```bash
# Add sample recipes to current directory
cook seed

# View a recipe
cook recipe "Neapolitan Pizza.cook"

# Create a shopping list for multiple recipes
cook shopping-list "Neapolitan Pizza.cook" "Caesar Salad.cook"

# Start a local server
cook server

# Run from another directory with verbose logging
cook -b ~/recipes -vv server
```

## CookCLI Philosophy
- Everything is a plain-text file that you control.
- Human-readable recipes, no special sauce needed.
- Small, composable UNIX commands.
- Works offline, all the time.

## Recipe Files
Cooklang `.cook` files capture structured recipes. This is the simple Cooklang markup language, no long hours of study required.

Example:
```
---
title: Simple Pasta
time: 20 minutes
servings: 2
---

Bring @water{2%liters} to a boil in a large #pot.
Add @pasta{200%g} and cook for ~{10%minutes}.
Drain, then mix with @olive oil{2%tbsp} and @parmesan{50%g}.
```

For more details, check out [this page on the Cooklang specifications](https://cooklang.org/docs/spec/).


## Configuration Locations

Configuration files are located in these directories:
- `./config/`
- `~/.config/cooklang/`
- `/etc/cooklang/`

### Aisle Configuration (`aisle.conf`)

Cooklang allows for an `aisle.conf` file to be added, allowing for organizing shopping lists by the section or aisle of the store.
```
[produce]
tomatoes
basil
garlic

[dairy]
mozzarella
parmesan
```

## Tips
- Scale recipes with the `:` symbol. For example: `cook recipe "Pizza.cook:2"` or `cook shopping-list "Pasta.cook:3"`.
- Combine with standard UNIX tools. For example: `cook search chicken | head -5` or `cook shopping-list $(ls *Pasta*.cook)`,
- Validate recipes for errors with validate. Example: `cook doctor validate`.

## Help
Use `cook --help` or `cook <command> --help` for detailed usage.