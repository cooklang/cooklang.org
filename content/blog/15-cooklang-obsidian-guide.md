---
title: "How to Manage Recipes in Obsidian with Cooklang"
date: 2026-02-25
weight: 60
summary: "A step-by-step guide to using the Cooklang plugin for Obsidian. Turn your vault into a recipe manager with syntax highlighting, interactive timers, shopping lists, and a beautiful preview mode."
description: "Use the Cooklang plugin to manage recipes in Obsidian. Get syntax highlighting, interactive cooking timers, shopping lists, and recipe preview in your vault."
howto:
  - name: "Install the Cooklang plugin"
    text: "Open Obsidian Settings, go to Community Plugins, search for Cooklang Editor, and install it."
  - name: "Create your first recipe"
    text: "Create a .cook file in your vault and write a recipe using Cooklang syntax with @ingredients, #cookware, and ~timers."
  - name: "Use preview mode"
    text: "Switch to preview mode to see your recipe rendered with highlighted ingredients, cookware, and interactive timers."
  - name: "Run interactive timers"
    text: "Click any timer in preview mode to start a countdown with sound notifications."
  - name: "Organize your recipe vault"
    text: "Structure recipes in folders by cuisine, meal type, or season for easy browsing."
---

If you already use Obsidian for notes, it makes sense to keep your recipes there too. The [Cooklang Editor plugin](https://github.com/cooklang/cooklang-obsidian) adds native support for the Cooklang recipe format — [syntax highlighting](/docs/syntax-highlighting/), a recipe preview mode, interactive cooking timers, and ingredient checklists, all inside your vault.

This guide walks through setup and daily use.

## Install the Plugin

1. Open Obsidian **Settings → Community Plugins**
2. Click **Browse** and search for "Cooklang Editor"
3. Click **Install**, then **Enable**

That's it. Obsidian now recognizes `.cook` files.

## Create Your First Recipe

Right-click any folder in your vault and select **Create Recipe**. This creates a new `.cook` file. Write a recipe using Cooklang syntax:

```
>> servings: 2
>> time: 30 minutes

Preheat the #oven to 200°C.

Dice @onion{1} and @garlic{2%cloves}. Sauté in @olive oil{1%tbsp} for ~{5%minutes}.

Add @canned tomatoes{400%g} and @dried oregano{1%tsp}. Simmer for ~{15%minutes}.

Season with @salt{} and @pepper{} to taste.

Serve over @pasta{200%g}, cooked according to package directions.
```

The editor highlights ingredients in blue, cookware in green, and timers in pink as you type.

## Preview Mode

Press `Cmd+E` (or `Ctrl+E` on Windows/Linux) to switch to preview mode. Your recipe transforms into a formatted view with:

- **Metadata** displayed at the top (servings, time, tags)
- **Ingredients list** with quantities, organized in two columns
- **Cookware list** showing what tools you need
- **Numbered method steps** with inline ingredient and cookware references
- **Total time** calculated from all timers in the recipe

Toggle back to source mode with the same shortcut.

## Interactive Timers

In preview mode, click any timer duration in the recipe steps. A countdown starts right inside Obsidian — no need to switch to a separate timer app. When the timer finishes, you get a notification sound and a popup.

You can enable or disable ticking sounds and alarm sounds in the plugin settings.

## Ingredient Checklist

In preview mode, click any ingredient in the ingredients list to mark it as purchased. The item gets a strikethrough, making it easy to use as a shopping checklist while you're at the store.

## Organize Your Recipe Vault

A simple folder structure works well:

```
📁 Recipes/
├── 📁 Breakfast/
├── 📁 Lunch/
├── 📁 Dinner/
├── 📁 Desserts/
├── 📁 Meal Plans/
│   ├── 📁 Week 1/
│   └── 📁 Week 2/
└── 📁 Reference/
```

Because `.cook` files are plain text, they work with everything Obsidian already does — backlinks, tags, search, graph view. Tag your recipes with metadata:

```
>> tags: italian, quick, weeknight
>> source: https://example.com/recipe
>> author: Nonna
```

The plugin renders tags with `#` prefixes and URLs as clickable links.

## Use Markdown Files as Recipes

You don't have to use `.cook` files exclusively. Add `recipe: true` to the frontmatter of any `.md` file and the plugin will auto-detect it as a recipe:

```markdown
---
recipe: true
---

Your Cooklang recipe here...
```

You can also right-click any `.md` file and select **Open as Recipe** to view it in recipe mode, or use the command palette to convert between `.md` and `.cook` extensions.

## Customize the Display

Open **Settings → Cooklang Editor** to configure what the preview shows:

- Toggle ingredients list, cookware list, timer summary, and total time
- Show or hide inline quantities in method steps
- Enable/disable timer sounds
- Customize section labels (useful for non-English recipes)

## Pair with CookCLI

The Obsidian plugin handles editing and viewing. For shopping lists and recipe serving, pair it with [CookCLI](/cli/). Point CookCLI at your vault's recipe folder:

```bash
cook shopping-list Recipes/Dinner/*.cook
cook server Recipes/
```

The first command generates a combined shopping list. The second starts a local web server for browsing your recipes from any device on your network — useful for a tablet in the kitchen.

## Why Obsidian + Cooklang Works

Your recipes live as plain text files in your vault. No database, no subscription, no export needed. They sync through whatever you already use — iCloud, Dropbox, Obsidian Sync, Git. They're searchable, linkable, and version-controlled.

The plugin is open source and actively maintained. Install it from Community Plugins and try converting one recipe — it takes about two minutes.

[Get started with Cooklang syntax →](/docs/spec/)

-Alex
