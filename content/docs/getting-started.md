---
title: 'Getting Started'
date: 2022-02-15T19:30:08+10:00
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

## 1. Try It Right Now

No installation needed — try Cooklang instantly:

- **Convert any recipe from the web**: add `cook.md/` before a recipe URL in your browser's address bar (e.g., `https://cook.md/https://bbcgoodfood.com/recipes/easy-pancakes/`).

![Cook.md Demo](/guide/cookmd-demo.gif)

- **Experiment with the syntax**: open the [Playground](https://cooklang.github.io/cooklang-rs/?mode=render) to write and preview Cooklang recipes interactively.

![Cooklang Parser Playground](/guide/playground-demo.png)

## 2. Start Cooking With the App

Download the **Cooklang App** from the [Google Play Store](https://play.google.com/store/apps/details?id=md.cook.android) or [Apple App Store](https://apps.apple.com/us/app/cooklangapp/id1598799259#?platform=iphone). Open the app and choose to sync recipes with CookCloud, iCloud, or a local folder.

If you're using the iOS app with iCloud sync, it will create a folder in iCloud Drive called `CooklangApp` where it expects to see recipes. The sync method can be changed later in the app settings.

### Syncing Across Devices

To keep recipes in sync between your phone and computer, install the [Cook Desktop App](https://cook.md/download) — a lightweight sync agent that runs in the background. Point it at your recipes folder and sign in.

![Cook Desktop Screen](/guide/desktop-app-demo.png)

**Cook Cloud** is a built-in sync service that works across macOS, Windows, Linux, iOS, and Android — no third-party cloud setup required.

## 3. Write Your Own Recipes

Cooklang recipes are plain `.cook` text files. The syntax is simple: `@` names ingredients, `#` marks cookware, `~` sets timers, and `--` adds comments. Multi-word ingredients end with `{}`, quantities go inside `{}`, and units follow `%`.

For the full syntax reference, see the [Cooklang specification](/docs/spec/). To learn about practical use cases like meal planning and shopping, see [use cases](/docs/use-cases/).

### Editor Setup

Syntax highlighting makes writing recipes easier. Set up your preferred editor:

- **VS Code** (Recommended): Install the [Cooklang extension](https://marketplace.visualstudio.com/items?itemName=dubadub.cook\&ssr=false#overview) from the marketplace.

![VSCode autocomplete with CookCLI](/guide/vscode.png)

- **Vim/Neovim**: Add a [Cooklang syntax file](https://github.com/luizribeiro/vim-cooklang) for highlighting.
- **Sublime Text**: Use a [Cooklang syntax package](https://packagecontrol.io/packages/CookLang).
- **More options**: See [syntax highlighting documentation](/docs/syntax-highlighting/).

![Sublime Screen](/guide/sublime-demo.png)

### Obsidian Plugin

You can also manage recipes alongside your notes in Obsidian with the [Cooklang Editor](https://github.com/cooklang/cooklang-obsidian) plugin.

## 4. Grow Your Collection

### Organize Your Recipes

Keep recipes organized by folders (e.g., `breakfast/`, `dinner/`, `desserts/`). You can use multiple nested folders if you have many recipes.

### Configure `aisle.conf` for Shopping

Add `config/aisle.conf` to your recipes folder to categorize ingredients by shopping aisle, making grocery trips more efficient. Learn more about this [here](/docs/use-cases/shopping/).

```text
[produce]
potatoes

[dairy]
milk
butter
```

### Join the Community

Find curated recipes, share your thoughts, or ask for help:

- The [Cooklang Recipe Hub](https://recipes.cooklang.org)
- The [Awesome Cooklang](https://github.com/cooklang/awesome-cooklang-recipes) repository
- Community [discussions](https://github.com/cooklang/spec/discussions) and [Discord](https://discord.gg/fUVVvUzEEK)

## 5. Power Tools

### Command-Line Interface (CookCLI)

CookCLI is a command-line tool for automating your recipe workflow. It follows the UNIX philosophy — each command does one thing well and can be combined with other tools.

```bash
cook seed                                 # load demo recipes
cook recipe "Neapolitan Pizza.cook"       # read a recipe
cook recipe "Pasta.cook:3"                # scale servings
cook shopping-list Monday.cook Tuesday.cook:2
cook search chicken                       # hunt by ingredient
cook server                               # browse in your browser
```

**See the `cook server` web UI in action at [demo.cooklang.org](https://demo.cooklang.org)!**

{{< server-carousel >}}

Install from [GitHub Releases](https://github.com/cooklang/cookcli/releases/latest), or on macOS: `brew install cookcli`. For the full CLI reference, see the [CLI documentation](/docs/getting-started-commands/).

### AI-Powered Recipe Management

If you use an AI coding assistant like Claude Code or Codex CLI, you can supercharge your workflow with **Cooklang Skills** — AI skills that let you create, convert, validate, and manage recipes using natural language.

Some skills work standalone (`create-recipe`, `convert-recipe`, `organize-collection`), while others benefit from having CookCLI installed.

If you don't use these tools, try [Cookbot](https://cooklang.org/app/#:~:text=Cookbot,-New) — built specifically for working with Cooklang recipes and plans.

## What's Next?

- Check out the [best practices guide](/docs/best-practices/).
- Open an issue in the [Cooklang GitHub repository](https://github.com/cooklang).
- Join us on [Reddit](https://www.reddit.com/r/cooklang/), [Discord](https://discord.gg/fUVVvUzEEK), and [Twitter](https://x.com/cooklangorg).
- Subscribe to the newsletter!
