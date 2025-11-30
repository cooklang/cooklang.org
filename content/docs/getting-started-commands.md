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

Here is a list of core commands that you will use with CookCLI. Click on each one to navigate to the respective webpage for thorough documentation.

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

CookCLI is grounded in a few basic tenets:

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

Here is a brief overview of the commands that you can execute using CookCLI. A deeper dive on each command is linked at the top of the section, and the command basics are included in a short list below.

### Recipe Command

The `recipe` command is used for parsing and displaying recipe files. The full breakdown of this command can be found [here](https://cooklang.org/cli/commands/recipe/).

- Want to read a recipe? Run `cook recipe "Name"`. The file extension is optional, though it works with .cook and .menu files.
- You can also use standard input, or the direct path to the file. 
- Need recipe scaling? Add `:2`, `:0.25`, etc., or `--scale 4`. This works for menus too (and scales every linked recipe).
- Can’t remember the path? `cook recipe "Pizza"` searches current and recipe dirs, auto-adds `.cook`.
- Choose your format: the default is human-readable, or you can choose from JSON, YAML, Markdown, LaTeX, Schema, and Cooklang formats!
- To save output: `cooke recipe name -o file.ext` (format inferred from the extension or specified with the `-f` flag).
- CookCLI can find recipes without the full path (name only). This works recursively!
- Troubleshooting: If something isn’t found, check your directory and escape spaces in names.

### Shopping List Command

The `shopping-list` command makes shopping for ingredients easy by organizing and creating shopping lists based off one or multiple recipes! Find out more about the command [at this link](https://cooklang.org/cli/commands/shopping-list/).

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

The `server` command starts a local web server which makes your recipe collection viewable in an attractive web browser page. An exhaustive resource on the command is to be found [here](https://cooklang.org/cli/commands/server/).

- Simply use `cook server` to serve the current directory at `http://localhost:9080`.
- Point at other directories: `cook server ~/my-recipes` or `cd ~/my-recipes && cook server` to host a different collection.
- Swap ports with `--port` followed by the desired port number. Add `--host` to reach it from other devices (`http://YOUR-IP:PORT`).
- Web UI features: tree view browsing, search, quick preview cards, full recipe pages with ingredients and steps, plus built-in scaling controls that adjust servings and quantities on the fly.
- Shopping from the couch: select multiple recipes in the web UI, set scaling amounts per recipe, and generate a combined shopping list you can print or export.
- The web UI has a mobile-friendly, responsive layout that works well on any device.
- Use the local network sharing feature to access your recipes on different devices or share it with your family and friends simultaneously.
- Keep the server running by setting it up as a background service (systemd/launchd) to auto-start on boot, or run in Docker.
- Quick shortcuts: add aliases like `alias recipes='cook server ~/recipes --open'`, bookmark frequently used recipe URLs, or add the site to a phone or tablet home screen for an app-like feel.
- Troubleshooting: if the port is busy, pick another (`--port 8081`); if other devices can’t connect, re-check the `--host` flag, firewall rules, and your IP address; reduce oversized images if pages load slowly.
- Security basics: the default hosting is local-only; when using `--host` ensure that you stay on trusted networks, consider a firewall, and use a reverse proxy with authentication if exposing the server beyond your LAN.

## Search Command

The `search` command helps find recipes quickly by allowing users to search for titles, ingredients, instructions, and even the recipe metadata. This simplifies the process of finding out what recipes you have but may have lost track of, or what you can cook if you only have certain ingredients. A deeper dive into this command and the many ways to use it can be found [here](https://cooklang.org/cli/commands/search/).

- A basic `cook search chicken` returns matches for `chicken` sorted by relevance. You can add more words (`cook search chicken mushrooms`), or quote phrases (`cook search "olive oil"`).
- Search is not case-sensitive by default, and you can point at a specific directory with `-b` (e.g., `cook search -b ~/recipes/italian pasta`).
- What gets searched: filenames/titles, ingredients, instructions, metadata (tags, cuisine, time), and notes.
- Find recipes by pantry items (`cook search beans rice`), cook time (`cook search "30 minutes"`), dietary tags (`cook search vegan`, `cook search gluten-free`), cooking method (`cook search "slow cooker"`), or cuisine (`cook search italian`).
- Advanced uses include piping searches directly into shopping lists, immediately viewing search results with `fzf`, and breaking down search results into the specific ingredients required.
- Shape the results with shell tools such as `grep`, `sort`, `uniq`, and (of course) `|`.
- For improved searchability, add metadata like `tags`, `time`, `cuisine`, and dietary labels in your recipes. It's also recommended to organize folders when your recipe collections grow.
- See the link above for a list of detailed examples for integrating these tools into useful scripts and workflows! These will dramatically enhance your search experience and even allow you to utilize fuzzy finders (`fzf`, `dmenu`, and `rofi`).
- Troubleshooting: if nothing shows up, simplify terms, check spelling, and confirm you are in the right directory; if you get too many results, add more specific words and search terms, move to subdirectories, or filter with `grep`; for large collections, search narrower directories, organize recipes into specific folders, and consider using search tools like `ripgrep`.

## Import Command

The `import` command fetches recipes from websites and converts them to Cooklang. A complete reference is available [here](https://cooklang.org/cli/commands/import/).

- Basic importing: `cook import https://www.bbcgoodfood.com/recipes/chicken-bacon-pasta` grabs the recipe and prints Cooklang to stdout.
- Conversion needs an OpenAI key. Without it, you can still download the recipe content. Add `cook.md/` before the URL of any recipe from a website to use the `cook.md` converter as an alternative.
- The import functionality should work with most recipe websites, especially those that utilize Recipe Schema.org markup.
- Flags to note: `--skip-conversion` gets the raw data from a website without converting to Cooklang format; `--metadata` allows for specifying metadata options like `json`, `yaml`, and others. This will extract many metadata fields for future reference.
- Save cleanly to a file by using shell redirects to store recipes (`cook import [URL] > \"Pasta Carbonara.cook\"`) or append to collections.
- Non-standard site data can be grabbed with `--skip-conversion > raw.txt`, then formatted into Cooklang manually with your editor.
- Troubleshooting: 403 or blocked? Save locally first. No recipe found? Site may lack markup, so try using `--skip-conversion`. Partial results? Some sites split pages; you might need to combine manually.
- Best practices: always review imports for quantities, cook times, and steps or missing info; adjust metric/imperial as needed; keep attribution (source URL, author, imported date) so credit stays with the recipe.

## Doctor Command

The `doctor` command checks the health of your recipe collection (syntax, references, metadata). A full reference is available [here](https://cooklang.org/cli/commands/doctor/). Below are some examples and usage:

- For a quick health check, `cook doctor` runs every available check on your whole recipe collection and reports any issues.
- Validate recipe syntax and structure with `cook doctor validate`. This flags parse errors, invalid units/quantities, deprecated syntax, and broken references.
- Point at specific folders with `-b` narrow the scope (`cook doctor validate -b ~/recipes/italian`).
- Using `cook doctor aisle` finds ingredients missing from `aisle.conf` so shopping lists stay categorized and ingredients stay assigned to respective store sections.
- Common fixes: normalize timers (`~{30%minutes}`), add units (`@salt{2%tsp}`), replace old `>>` metadata with `---` headings, and ensure proper metadata verbiage is used (`servings` instead of `serves x`).
- Reference hygiene: catch missing or circular references before they break menus.
- Find detailed automation usage and CI/CD actions in the link above.
- You can use shell tools (`sed`, `find`, `grep`) and scripts to standardize timer units or metadata across many files after doctor reports patterns.
- Aisle configuration: generate `aisle.conf` files from existing recipes using shell utilities, and account for the layouts of different stores (choose which `.conf` file you used based on the store you will be shopping at).
- Troubleshooting: if doctor reports nothing but you expect issues, confirm you are in the right directory and files use `.cook` extensions; for aisle warnings, update or add the correct `aisle.conf`.

## Seed Command

The `seed` command populates a directory with example Cooklang recipes. A full reference is available at [this link](https://cooklang.org/cli/commands/seed/).

- Run `cook seed` to create a full set of example recipes in the current directory.
- Use `cook seed <directory>` to seed into a specific folder (the directory will be created if it doesn’t exist).
- The command generates a structured set of folders (Breakfast, Dinners, Shared, etc.) with `.cook` example files.
- A default `aisle.conf` is included under `config/` for shopping-list categorization.
- A `README.md` is added to explain the recipes.
- The example recipes are designed to fully demonstrate the many Cooklang features and recipe categories supported.
- Beginners can study these sample recipes to learn the Cooklang syntax, as well as the numerous ways it can be used to enhance your recipe crafting and storing.
- See the link above for some example commands and a quick start guide for new users.
- For a seperate test environment, run seeding inside a temporary directory (`cd $(mktemp -d)` then `cook seed`).
- After seeding, get your hands dirty with recipe building and saving! This is the best way to learn, after all.

## Report Command

The `report` command generates custom outputs from recipes using Minijinja templates. A full reference is available at [this page](https://cooklang.org/cli/commands/report/).

- Run `cook report -t template.jinja recipe.cook` to process a recipe through a template and output the result.
- The command parses the recipe, applies scaling, loads aisle and pantry configs, passes data to Jinja2, and outputs the report.
- Templates receive all recipe fields including title, servings, time, description, ingredients, steps, and metadata.
- Use all configurations together with datastore, aisle, and pantry files to produce cost reports, nutrition sheets, or filtered lists.
- Scale recipes before processing using the standard scaling process (`cook report -t template.jinja "Cake.cook:2"`).
- Datastore integration allows adding nutritional info, cost data, dietary classifications, and custom metadata.
- Aisle configuration is supported and groups ingredients into store sections inside templates.
- Pantry configuration (`pantry.conf` file in `config/` directory) filters out items already in inventory so shopping lists only show what you need.
- Save output to a file using shell redirection, like `cook report -t card.jinja recipe.cook > recipe-card.md`.
- Advanced uses support conditional logic, calculations, loops, and formatted output tables.
- Supported uses also include meal planning for a weekly meal plan, creating a recipe book, and creating reusable recipe components for simplifying of future recipe builds.
- Reports can be integrated with functionality such as generating PDFs (Pandoc or wkhtmltopdf), email newsletters, or social media.
- Visit the link above for example uses, command blocks to save or reference, and more.
- Tips: set default values to streamline your workflow; add filters (such as cases) to standardize recipe text; script conditional loops for reporting automation.
- Troubleshooting: Template not found? Try verifying template paths; Getting errors? Consider checking variables and using defaults.
