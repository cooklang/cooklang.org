---
title: 'Getting Started'
date: 2026-09-29
draft: false
weight: 1
summary: All you need to get started with Cooklang
---

Cooklang is a lightweight, open-source format for writing and managing recipes in a structured, human-readable way. Your recipes are just text files, meaning you can store, edit, share and sync them across all your devices without being locked into a specific app or service.

Here's what a basic recipe looks like in Cooklang:

```cooklang
Crack the @eggs{3} into a #blender, then add the @plain flour{125%g},
@milk{250%ml} and @sea salt{1%pinch}, and blitz until smooth.
```

When processed using apps, this recipe extracts ingredients while keeping the instructions readable.

![Android Screens](/guide/app-screens-demo.jpg)

{{< quickstart-callout >}}

{{< gs-chooser >}}

{{% for "phone" %}}
## Cook from your phone

Download the free **Cooklang App** from the [Google Play Store](https://play.google.com/store/apps/details?id=md.cook.android) or [Apple App Store](https://apps.apple.com/us/app/cooklangapp/id1598799259#?platform=iphone). Open a recipe, scale it, start timers straight from the steps, and tick ingredients off a shopping list grouped by aisle.

When you first open the app, choose where your recipes live. You can change it later in the app settings:

- **iOS:** iCloud Drive (the app creates a `CooklangApp` folder there), a local folder on the phone (On My iPhone › CooklangApp), or Cook Cloud.
- **Android:** the app's internal folder, any folder on the phone you pick, or Cook Cloud.

Want the same recipes on your computer too? See [Sync across devices](#sync-across-devices).
{{% /for %}}

{{% for "import" %}}
## Import recipes you already have

- **Any recipe on the web:** put `cook.md/` in front of its address in your browser's address bar, e.g. `https://cook.md/https://bbcgoodfood.com/recipes/easy-pancakes/`. No account needed.

![Cook.md Demo](/guide/cookmd-demo.gif)

- **Pasted text, cookbook photos, handwritten cards, YouTube and Instagram:** use the [converter on cook.md](https://cook.md/cookifies/new). Pasted text needs a free account; photos and social videos come with Cook Basic.
- **Your whole library from Paprika, Mela, Mealie and other apps:** batch import with [Cook Basic](https://cook.md/pricing) brings everything across as `.cook` files.
- **From a script:** [`cook import`](/cli/commands/import/) in CookCLI.

The [importing guide](/guides/importing-recipes/) walks through each method.
{{% /for %}}

{{% for "write" %}}
## Write your own recipes

Cooklang recipes are plain `.cook` text files. The syntax is simple: `@` names ingredients, `#` marks cookware, `~` sets timers, and `--` adds comments. Multi-word ingredients end with `{}`, quantities go inside `{}`, and units follow `%`.

Try it without installing anything: the [Playground](https://cooklang.github.io/cooklang-rs/?mode=render) lets you write and preview recipes in your browser.

![Cooklang Parser Playground](/guide/playground-demo.png)

For the full syntax reference, see the [Cooklang specification](/docs/spec/). For habits that keep a collection easy to work with, see [best practices](/docs/best-practices/).

### Editor Setup

Syntax highlighting makes writing recipes easier. Pick the editor you like:

- **Cook Editor**: a free, open-source [desktop app](/editor/) for macOS, Windows and Linux, with highlighting, live preview, shopping lists and meal plans.
- **VS Code**: install the [Cooklang extension](https://marketplace.visualstudio.com/items?itemName=dubadub.cook&ssr=false#overview) from the marketplace.

![VSCode autocomplete with CookCLI](/guide/vscode.png)

- **Vim/Neovim**: add a [Cooklang syntax file](https://github.com/luizribeiro/vim-cooklang).
- **Sublime Text**: use a [Cooklang syntax package](https://packagecontrol.io/packages/CookLang).
- **More options**: see the [syntax highlighting documentation](/docs/syntax-highlighting/).
{{% /for %}}

{{% for "sync" %}}
## Sync across devices

Recipes are plain files, so anything that syncs a folder can sync your recipes. There are two routes.

### Free: the storage you already use

- **iPhone, iPad and Mac:** keep recipes in iCloud Drive. The iOS app reads the `CooklangApp` folder, and your Mac sees the same folder in Finder.
- **Android, or a mix of devices:** point the Android app at a folder and keep it in sync with a folder-sync tool such as [Syncthing](https://syncthing.net/). On a computer, Dropbox, Nextcloud, Git or any similar tool works too, because every Cooklang tool just reads the folder.

### Cook Cloud: one setup on every device

Cook Cloud keeps one folder of `.cook` files in sync across macOS, Windows, Linux, iOS and Android, with no third-party cloud to set up. Install the [Cook Sync Agent](https://cook.md/download) on your computer, point it at your recipes folder, and sign in to the same account in the apps. Sync is part of Cook Basic (€4.99/month); accounts created before the paywall keep syncing free. [Compare plans](https://cook.md/pricing).
{{% /for %}}

{{% for "write,plan" %}}
## Organize your recipes

Keep recipes in folders (e.g., `breakfast/`, `dinner/`, `desserts/`). You can nest folders as deep as you like; every Cooklang app and CookCLI understands them.
{{% /for %}}

{{% for "plan" %}}
## Plan meals and shopping lists

### Configure `aisle.conf` for Shopping

Add `config/aisle.conf` to your recipes folder to group ingredients by shopping aisle, making grocery trips more efficient. Learn more in the [shopping guide](/guides/shopping/).

```text
[produce]
potatoes

[dairy]
milk
butter
```

### Plan Your Week with Menu Files

A `.menu` file describes what you're cooking on which day, referencing recipes from your collection.

```cooklang
== Monday ==

Dinner: @./dinner/Spaghetti Bolognese{2%servings}

== Tuesday ==

Dinner: @./dinner/Chicken Curry{2%servings} with @rice{1%cup}
```

One CookCLI command turns the whole plan into a shopping list:

```bash
cook shopping-list "Plans/This Week.menu"
```

The [Cook Editor](/editor/) renders `.menu` files as a week view with the combined shopping list built in, and the mobile apps add recipes to the shopping list with one tap. See the [meal planning guide](/guides/meal-planning/) for a full example.

Want the week drafted for you? CookBot in the Cook Editor drafts a plan from your own recipes against a target like more protein or a smaller shop, and shows every change as a diff you approve. It's part of [Cook Pro](https://cook.md/pricing).
{{% /for %}}

{{% for "notes" %}}
## Keep recipes in Obsidian

Manage recipes alongside your notes with the [Cooklang plugin for Obsidian](https://github.com/cooklang/cooklang-obsidian). Recipes stay `.cook` files in your vault, so the same folder also works with the mobile apps, the Cook Editor and CookCLI.
{{% /for %}}

{{% for "ai" %}}
## Use with AI tools

- **CookBot** in the [Cook Editor](/editor/) imports recipes and drafts meal plans from your own collection, with every change shown as a diff you approve. It comes with [Cook Pro](https://cook.md/pricing) (€12.99/month, 7-day free trial).
- **Cooklang Skills:** if you use an AI coding assistant like Claude Code or Codex CLI, [Cooklang Skills](https://github.com/cooklang/cooklang-skills) let you create, convert, validate and organize recipes in natural language. Some skills work standalone; others work best with CookCLI installed.
- **MCP:** Cook Cloud's [MCP server](https://cook.md/help/nutrition-mcp) lets Cursor, ChatGPT or any agent you already use read your recipes with nutrition attached.
{{% /for %}}

{{% for "cli,selfhost,plan" %}}
## Command-Line Interface (CookCLI)

[CookCLI](/cli/) is a command-line tool for automating your recipe workflow. It follows the UNIX philosophy: each command does one thing well and can be combined with other tools.

Install from [GitHub Releases](https://github.com/cooklang/cookcli/releases/latest), or on macOS: `brew install cookcli`.

```bash
mkdir my-recipes && cd my-recipes         # cook seed fills its target directory, so use a dedicated one
cook seed ./                              # load demo recipes
cook recipe "Neapolitan Pizza.cook"       # read a recipe
cook recipe "Pasta.cook:3"                # scale servings
cook shopping-list Monday.cook Tuesday.cook:2
cook search chicken                       # hunt by ingredient
cook server                               # browse in your browser
```

For the full CLI reference, see the [CLI documentation](/docs/getting-started-commands/). Because recipes are plain text, Git works well for tracking changes and sharing a collection.
{{% /for %}}

{{% for "selfhost" %}}
## Self-host a recipe server

`cook server` turns your recipes folder into a web app: browse and search recipes, scale them, build a shopping list and keep a pantry. Add `--host` to reach it from other devices on your network:

```bash
cook server ~/recipes --host
```

**See the web UI in action at [demo.cooklang.org](https://demo.cooklang.org).**

![Recipes in the cook server web UI](/server/recipe-list.png)

- **Always on:** run it on a [Raspberry Pi](/guides/raspberry-pi/) for the whole household.
- **No server at all:** [publish your recipes as a static website](/guides/static-website/) on GitHub Pages or Netlify.
- **All options:** see the [`cook server` reference](/cli/commands/server/).
{{% /for %}}

{{% for "dev" %}}
## Build on the format

- **Specification:** the [Cooklang spec](/docs/spec/) defines the syntax; the [conventions](/docs/conventions/) cover shared metadata.
- **Parsers and libraries:** see [For Developers](/docs/for-developers/) for the reference Rust parser and community parsers in Go, JavaScript, Python and more.
- **Try the parser:** the [Playground](https://cooklang.github.io/cooklang-rs/) shows the parsed output of any recipe.
- **Discuss changes:** proposals and questions live in [spec discussions](https://github.com/cooklang/spec/discussions).
{{% /for %}}

## Join the Community

Find curated recipes, share your thoughts, or ask for help:

- The [Cooklang Recipe Hub](https://recipes.cooklang.org)
- The [Awesome Cooklang](https://github.com/cooklang/awesome-cooklang-recipes) repository
- Community [discussions](https://github.com/cooklang/spec/discussions) and [Discord](https://discord.gg/fUVVvUzEEK)

## What's Next?

- Check out the [best practices guide](/docs/best-practices/).
- Open an issue in the [Cooklang GitHub repository](https://github.com/cooklang).
- Join us on [Reddit](https://www.reddit.com/r/cooklang/), [Discord](https://discord.gg/fUVVvUzEEK), and [Twitter](https://x.com/cooklangorg).
- Subscribe to the newsletter!
