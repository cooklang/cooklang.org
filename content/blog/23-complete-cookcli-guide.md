---
title: "The Complete CookCLI Guide: From Install to Daily Use"
date: 2026-02-28
weight: 60
summary: "A hands-on walkthrough of CookCLI covering installation, parsing recipes, generating shopping lists, scaling servings, and every command you'll actually use."
---

If you keep your recipes as `.cook` files, CookCLI is the tool that makes them useful. Parse a recipe, generate a combined shopping list from a week's worth of dinners, serve your whole collection on your local network, scale any dish to any number of servings — all from the terminal.

This guide covers every major command with real examples. You should be able to go from zero to productive in one sitting.

## Installation

**macOS** via Homebrew is the easiest path:

```bash
brew install cooklang/tap/cook
```

**Linux and macOS binary** — download the latest release directly from GitHub:

```bash
curl -L https://github.com/cooklang/CookCLI/releases/latest/download/cook-linux-amd64.tar.gz | tar xz
sudo mv cook /usr/local/bin/
```

Check the [releases page](https://github.com/cooklang/CookCLI/releases) for the right binary for your architecture.

**Docker** — useful for trying it out without installing anything permanently:

```bash
docker run -v $(pwd):/recipes ghcr.io/cooklang/cookcli:0.23.0 cook --help
```

Verify the install worked:

```bash
cook --version
```

## Your First Recipe

If you don't have any `.cook` files yet, the `seed` command creates a set of example recipes to explore:

```bash
cook seed my-recipes
cd my-recipes
ls
```

You'll see a handful of recipes. Open one in your editor to see the format, then parse it with `cook recipe`:

```bash
cook recipe "Mashed Potatoes.cook"
```

The output shows the recipe broken into structured sections — metadata, ingredients with quantities, cookware, and the method steps. This is the parsed representation CookCLI works from.

Let's write a recipe from scratch. Save this as `risotto.cook`:

```cooklang
---
servings: 4
time: 45 minutes
tags: italian, comfort, vegetarian
---

= Prepare the base

Warm @chicken stock{1%litre} in a #small saucepan over low heat. Keep it at a gentle simmer throughout.

Melt @butter{30%g} in a #large heavy-bottomed pan over medium heat. Add @shallots{2}(finely diced) and @garlic{2%cloves}(minced). Sweat for ~{5%minutes} until soft and translucent.

= Cook the rice

Add @arborio rice{320%g} and stir to coat in the butter. Toast for ~{2%minutes} until the edges of the grains turn translucent.

Pour in @dry white wine{150%ml} and stir until fully absorbed.

Add the warm stock one ladle at a time, stirring constantly and waiting until each addition is absorbed before adding the next. This will take ~risotto cooking{18%minutes} total.

= Finish

Remove from heat. Stir in @cold butter{20%g} and @parmesan{60%g}(freshly grated). Season with @salt{} and @black pepper{} to taste.

> Rest the risotto for 2 minutes before serving — it loosens to the right consistency on its own.

Serve in warm bowls.
```

Parse it:

```bash
cook recipe risotto.cook
```

```
Risotto

Ingredients:
  chicken stock       1 litre
  butter              30 g
  shallots            2
  garlic              2 cloves
  arborio rice        320 g
  dry white wine      150 ml
  cold butter         20 g
  parmesan            60 g
  salt
  black pepper

Cookware:
  small saucepan
  large heavy-bottomed pan
```

The parser pulls every ingredient out of prose and into a clean list. That's the foundation everything else builds on.

## Shopping Lists

This is the feature that makes keeping recipes in Cooklang format worth it.

Say you're planning Monday through Wednesday: risotto, a pasta sauce, and a roast chicken. Generate one combined shopping list:

```bash
cook shopping-list risotto.cook pasta-sauce.cook roast-chicken.cook
```

CookCLI merges ingredients across all three recipes, combining identical items. If risotto and pasta sauce both call for garlic, you get one line: "garlic: 4 cloves" — not two separate entries.

**Scaling per recipe** — if you're cooking the pasta for six people but only two for the risotto, use `:N` syntax per recipe:

```bash
cook shopping-list risotto.cook:2 pasta-sauce.cook:6 roast-chicken.cook:4
```

Each recipe scales independently. The quantities on the shopping list reflect the scaled amounts.

**Organizing by aisle** — create an `aisle.conf` file to group ingredients by where they live in your store:

```
[produce]
shallots
garlic
lemon

[dairy]
butter
parmesan
cream

[meat]
chicken

[dry goods]
arborio rice
pasta
```

```bash
cook shopping-list -a aisle.conf risotto.cook pasta-sauce.cook
```

The output groups ingredients under produce, dairy, meat, and so on instead of listing them alphabetically. Practical when you're actually walking the store.

**Excluding pantry staples** — if you always have olive oil, salt, and stock on hand, create a `pantry.conf` listing those items and pass it with `-p`:

```bash
cook shopping-list -p pantry.conf risotto.cook pasta-sauce.cook
```

Pantry items are excluded from the list automatically.

## The Recipe Server

`cook server` starts a local web interface for browsing your recipes from any device on your network:

```bash
cook server my-recipes/
```

By default it runs on port 9080. Open `http://localhost:9080` in a browser. You'll see your recipe collection as a browseable library — search by name, filter by tag, click through to formatted recipe views.

**Access from your phone or tablet** — this is the practical use case. Start the server on your computer, find your local IP address, and open `http://192.168.x.x:9080` on whatever device is propped up in the kitchen. The interface is mobile-friendly.

To bind to all interfaces explicitly:

```bash
cook server my-recipes/ --host 0.0.0.0 --port 9080
```

Change the port with `--port` if something else is already running on 9080. The server reads `.cook` files directly from disk, so any changes you make to recipes are reflected immediately on reload.

## Scaling Recipes

Any `cook recipe` call accepts a `:N` suffix to scale to N servings:

```bash
cook recipe risotto.cook:2
```

This scales a 4-serving recipe down to 2. All ingredient quantities adjust proportionally. 320g arborio rice becomes 160g. 1 litre of stock becomes 500ml.

```bash
cook recipe risotto.cook:8
```

Scale it up to 8 servings and the quantities double.

**Fixed ingredients** — sometimes a quantity shouldn't scale. Salt, spices, or seasoning additions that you'd adjust by taste rather than math. Mark them fixed with `=`:

```cooklang
Season with @salt{=1%tsp} and @black pepper{=0.5%tsp} to taste.
```

Fixed ingredients stay at their stated quantity regardless of the `:N` multiplier.

Scaling works identically in shopping lists:

```bash
cook shopping-list risotto.cook:8 roast-chicken.cook:6
```

Eight servings of risotto plus six servings of chicken, combined and totalled.

## Search and Discovery

Once you have more than a handful of recipes, finding what you can make from what you have becomes useful. `cook search` queries your recipe collection:

```bash
cook search garlic
```

Returns every recipe that contains garlic as an ingredient.

```bash
cook search chicken lemon rosemary
```

Search by multiple terms to find recipes that match all of them. Useful when you have specific ingredients you want to use up.

Search also matches recipe names and metadata:

```bash
cook search italian
cook search vegetarian
```

If you've tagged recipes consistently in frontmatter, these queries surface the right results fast.

## Pantry Management

The `cook pantry` subcommands handle tracking what you have on hand. This pairs well with shopping lists — you know what you have, CookCLI knows what you need.

Check what's running low:

```bash
cook pantry depleted
```

See what's expiring soon:

```bash
cook pantry expiring
```

Find out which recipes you can make from current pantry stock:

```bash
cook pantry recipes
```

This cross-references your pantry against your recipe collection and returns what you can cook right now without a trip to the store.

Plan meals based on what's available:

```bash
cook pantry plan
```

The pantry subcommands are more useful the more consistently you maintain your pantry data, but even partial tracking helps — especially for staples and things you buy in bulk.

## Importing Recipes

Found a recipe online you want to add to your collection? `cook import` fetches a URL and converts it to `.cook` format:

```bash
cook import https://example.com/some-recipe
```

This requires an OpenAI API key set as an environment variable:

```bash
export OPENAI_API_KEY=your-key-here
cook import https://example.com/some-recipe
```

The import command fetches the page, extracts the recipe content, and uses the language model to convert it into valid Cooklang syntax. Review the output before saving — it's good but not always perfect, especially for recipes with unusual formats or vague ingredient quantities.

Redirect the output to a file:

```bash
cook import https://example.com/some-recipe > imported-recipe.cook
```

## Validating Recipes

`cook doctor validate` checks your `.cook` files for syntax errors and common issues:

```bash
cook doctor validate risotto.cook
```

Run it on a whole directory:

```bash
cook doctor validate my-recipes/
```

The `--strict` flag is useful in CI — it returns a non-zero exit code on any warning, not just errors:

```bash
cook doctor validate --strict my-recipes/
```

Add this to a pre-commit hook or CI pipeline if you want to catch broken recipes before they land in your main collection. Malformed ingredient syntax, unclosed sections, missing metadata — doctor surfaces these before they cause problems downstream.

## Editor Integration

If you use a code editor with LSP support, `cook lsp` starts the Cooklang Language Server:

```bash
cook lsp
```

Configure your editor to use it for `.cook` files and you get syntax highlighting, error underlining, and autocomplete as you write recipes. The setup varies by editor — [the docs at /docs/](/docs/) have editor-specific instructions for VS Code, Neovim, and others.

## Quick Reference

| Command | What it does |
|---|---|
| `cook recipe file.cook` | Parse and display a recipe |
| `cook recipe file.cook:4` | Display scaled to 4 servings |
| `cook shopping-list *.cook` | Combined shopping list |
| `cook shopping-list a.cook:2 b.cook:6` | Shopping list with per-recipe scaling |
| `cook shopping-list -a aisle.conf *.cook` | Shopping list grouped by aisle |
| `cook shopping-list -p pantry.conf *.cook` | Shopping list excluding pantry items |
| `cook server my-recipes/` | Start recipe browser on port 9080 |
| `cook server my-recipes/ --port 8080` | Use a different port |
| `cook search garlic` | Find recipes by ingredient or name |
| `cook search chicken lemon` | Find recipes matching multiple terms |
| `cook import <URL>` | Import recipe from website (needs OPENAI_API_KEY) |
| `cook pantry depleted` | Show low-stock pantry items |
| `cook pantry expiring` | Show expiring pantry items |
| `cook pantry recipes` | Show what you can cook now |
| `cook pantry plan` | Plan meals from pantry |
| `cook doctor validate file.cook` | Check recipe for errors |
| `cook doctor validate --strict *.cook` | Strict validation (CI-friendly) |
| `cook seed my-recipes` | Create example recipes to explore |
| `cook lsp` | Start the Language Server |

## Getting Productive

The workflow that works best day-to-day: recipes live as `.cook` files in a folder, the recipe server runs when you're in the kitchen, and shopping lists get generated before each grocery run.

Start with `cook seed` to see real examples, write a few of your own recipes, then run `cook server` to see how it looks as a browseable collection. From there, `cook shopping-list` for the week's meal plan becomes a natural habit.

The [CookCLI documentation at /cli/](/cli/) covers every flag and option in detail. The [spec at /docs/spec/](/docs/spec/) has the full Cooklang syntax reference if you want to go deeper on the recipe format itself.

[Get started with Cooklang →](/docs/getting-started/)

-Alex
