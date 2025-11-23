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

## Overview of Commands

Here is a brief overview of the commands that you can execute using CookCLI. A deeper dive on each command is linked at the top of the section.

### Recipe Command

The `recipe` command is used for parsing and displaying recipe files. The full breakdown of this command can be found [here](https://cooklang.org/cli/commands/recipe/). See below for some basic usage options:

- Want to read a recipe? Run `cook recipe "Name"`. The file extension is optional, though it works with .cook and .menu files.
- You can also use standard input, or the direct path to the file. 
- Need recipe scaling? Add `:2`, `:0.25`, etc., or `--scale 4`. This works for menus too (and scales every linked recipe).
- Can’t remember the path? `cook recipe "Pizza"` searches current and recipe dirs, auto-adds `.cook`.
- Choose your format: the default is human-readable, or you can choose from JSON, YAML, Markdown, LaTeX, Schema, and Cooklang formats!
- To save output: `cooke recipe name -o file.ext` (format inferred from the extension or specified with the `-f` flag).
- CookCLI can find recipes without the full path (name only). This works recursively!
- Troubleshooting: If something isn’t found, check your directory and escape spaces in names.

### Shopping List Command

The `shopping-list` command makes shopping for ingredients easy by organizing and creating shopping lists based off one or multiple recipes! Find out more about the command [at this link](https://cooklang.org/cli/commands/shopping-list/), and see below for some basic examples and uses cases:

- Make a list using `cook shopping-list "Recipe.cook"` or combine multiples (`cook shopping-list "Pasta.cook" "Salad.cook"`).
- You can use patterns and wildcards as well: (`cook shopping-list *.cook`, `Dinner/*.cook`).
- Scale the needed ingredients per recipe with `cook shopping-list "Pizza:2" "Salad"` or mix scales (`"Pasta:3" "Bread:0.5" "Soup:2"`).
- You can scale with `.menu` too. Menu scaling multiplies with recipe scales (`"2 Day Plan.menu:2"`).
- Formats: default is human readable and grouped by aisle (`--plain` for flat list).
- Also supported is JSON, YAML, and Markdown formatting. Save with `-o file.ext` (format inferred).
- `Aisle.conf`: use `./config/aisle.conf` (or `--aisle path`) to group items by store section.
- `Pantry.conf`: list what you already have in `./config/pantry.conf` (or `--pantry path`) to auto-exclude from shopping lists.
- Recipe references are handled automatically. Includes are followed by default; skip them with `--ignore-references`.
- Shopping lists can be saved to files with `-o list.txt`. Adding `--ingredients-only` excludes quantities.
- See some advanced use cases and handy examples at the link above!
- Troubleshooting: run `cook doctor aisle` to find and fix missing aisle categories; use full paths if a recipe isn’t found (`cook shopping-list ~/recipes/Pizza.cook`).

## Server Command

The `server` command starts a local web server which makes your recipe collection viewable in an attractive web browser page. An exhaustive resource on the command is to be found [here](https://cooklang.org/cli/commands/server/). Below are some examples and usage:

