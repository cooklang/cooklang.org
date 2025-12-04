---
title: 'Getting Started'
date: 2022-02-15T19:30:08+10:00
draft: false
weight: 1
summary: All you need to get started with Cooklang
---


Cooklang is a lightweight, open-source format for writing and managing recipes in a structured, human-readable way. Your recipes are just text files, meaning you can store, edit, share and sync them across all your devices without being locked into a specific app or service.

## How It Works

Cooklang recipes are plain text files that you can use on any device. You can write and manage them on a desktop, then access them on your phone when cooking. This flexibility makes it easy to grow your recipe collection over time. Recipes are stored in `.cook` files, and Cooklang tools help process these files for various use cases such as meal planning, shopping and cooking.

The syntax and specifications are simple and easy to learn. The @ names ingredients (ending with {} for multi-word names, {} around quantities, and % before units of measurement), # marks cookware, ~ sets timers (optionally named), -- or [- -] add comments. If you want to learn more about the Cooklang specifications, [follow this link](https://cooklang.org/docs/spec/).

To learn more about some of the exciting and useful ways that Cooklang can improve your cooking, recipe crafting and saving, or even shopping, [check out this page](https://cooklang.org/docs/use-cases/)!

### A Simple Example

Here's what a basic recipe looks like in Cooklang:

```cooklang
Crack the @eggs{3} into a #blender, then add the @plain flour{125%g},
@milk{250%ml} and @sea salt{1%pinch}, and blitz until smooth.
```

When processed using apps, this recipe will extract ingredients while keeping the instructions readable.

![Android Screens](/guide/app-screens-demo.jpg)

## 1. Setting Up on Desktop

To get the best experience with Cooklang on desktop, consider setting up:

### Syntax Highlighting

<!-- TODO: Update syntax highlighting to support all features -->

If you prefer writing recipes in a text editor, enabling syntax highlighting for Cooklang makes editing easier. Many editors support custom syntax highlighting:

- **VS Code** (Recommended): Install the [Cooklang extension](https://marketplace.visualstudio.com/items?itemName=dubadub.cook\&ssr=false#overview) from the marketplace.
- **Vim/Neovim**: Add a [Cooklang syntax file](https://github.com/luizribeiro/vim-cooklang) for highlighting.
- **Sublime Text**: Use a [Cooklang syntax package](https://packagecontrol.io/packages/CookLang).
- **More options**: See [syntax highlighting documentation](/docs/syntax-highlighting/).

![Sublime Screen](/guide/sublime-demo.png)

### (Optional) Obsidian plugin

<!-- TODO: Fix Obsidian plugin edit -->

As an option you can manage your recipes along with your notes in Obsidian with
[Cooklang Editor](https://github.com/cooklang/cooklang-obsidian) plugin.

### Desktop App for Syncing Recipes

The **Cook Desktop App** is an agent for syncing your recipes across devices.

Download the desktop app from the [official website](https://cook.md/download).

![Cook Desktop Screen](/guide/desktop-app-demo.png)

It will ask you to select folder where you store recipes and sign in/sign up.

## 2. Setting Up on Mobile

Getting started on mobile is simple:

- Download the **Cooklang App** from the [Google Play Store](https://play.google.com/store/apps/details?id=md.cook.android) or [Apple App Store](https://apps.apple.com/us/app/cooklangapp/id1598799259#?platform=iphone).
- Open the app and choose to sync recipes with either CookCloud, iCloud, or the local folder. Sign in if you're using a sync service via Desktop App. If you're using the iOS app with iCloud sync, it will create a folder in iCloud drive called `CooklangApp` where it expects to see recipes. The way to sync can be changed later by switching in the app settings menu.
- Access your saved recipes, and generate shopping lists on the go.

### A Note on Cook Cloud

Cook Cloud is a native sync service that works across all major operating systems and helps prevent dependence on third-party syncing. It improves upon the convenience of using your own desktop or cloud service (such as iCloud or Google drive) by handling that for you, making it easy to ensure that all of your recipes and lists are available in one convenient place.

It supports MacOS, Windows, Linux, iOS, and Android.

## 3. Growing Your Recipe Collection

Once you're set up, it's time to expand your collection:

### Build Your Recipe Collection

Start writing your own recipes or importing from existing sources. The best practice is to keep recipes organized by folders (e.g., `breakfast/`, `dinner/`, `desserts/`). You can use multiple nested folders if you have many recipes.

If you want to save a random recipe from a webpage in Cooklang format, simply add `cook.md/` before the full URL in your browser's address bar (e.g., `https://cook.md/https://bbcgoodfood.com/recipes/easy-pancakes/`).

![Cook.md Demo](/guide/cookmd-demo.gif)

### Use the playground to test syntax interactively

If you have some problems and your recipe doesn't render as you want, you can check out [Playground](https://cooklang.github.io/cooklang-rs/?mode=render).

![Cooklang Parser Playground](/guide/playground-demo.png)

### Be part of the community

Find curated Cooklang recipes from the community, share your thoughts or ask for help. Some resources include:

- The [Cooklang Recipe Hub](https://recipes.cooklang.org)
- The [Awesome Cooklang](https://github.com/cooklang/awesome-cooklang-recipes) repository
- Community language [discussions](https://github.com/cooklang/spec/discussions) and [Discord channel](https://discord.gg/fUVVvUzEEK)


### Configure `aisle.conf` for Shopping Convenience

For shopping lists (denoted by brackets for the category name), you can add `config/aisle.conf` into your recipes folder to categorize ingredients by shopping aisle, making grocery shopping more efficient.

This is best used if you are interested in using Cooklang to assist with your shopping lists. Learn more about this very practical use-case [here](https://cooklang.org/docs/use-cases/shopping/).

```toml
[produce]
potatoes

[dairy]
milk
butter
```

## 4. Command-Line Interface (CookCLI)

CookCLI is a powerful command-line tool that brings automation and advanced functionality to your recipe workflow. It follows the UNIX philosophy — each command does one thing well and can be combined with other tools. Not only this, but it also integrates standard UNIX tools for easy interaction.

Here are some short UNIX based commands for example:
```bash
cook recipe "Pizza.cook" -f json | jq '.ingredients'
cook search --all | grep "@" | sort | uniq -c | sort -rn | head -5
cook shopping-list $(ls *Pasta*.cook)
```

For more information, see this article on [how to get started with CookCLI](https://cooklang.org/docs/getting-started-commands/).

### Installation (The Quick Way In)

Grab the latest CookCLI build from [GitHub Releases](https://github.com/cooklang/cookcli/releases/latest), unpack it for your platform, and drop the `cook` binary into your PATH—whether you’re on macOS (Apple Silicon or Intel), Linux, or Windows. Prefer one-liners? macOS folks can simply `brew install cookcli`. If you like compiling from source, clone the repo, run `cargo build --release`, and copy `target/release/cook` wherever you keep your CLI tools.

### Core Commands You’ll Actually Use

- **Daily recipe flow**: `cook recipe` to render any `.cook` file, `cook doctor` to catch syntax slips, `cook search` to find recipes by ingredient, and `cook import` when a blog recipe wins your heart.
- **Plan and shop smarter**: `cook shopping-list` combines multiple recipes (with scaling) into one list, while `cook pantry` keeps tabs on what’s low or expiring.
- **Kickstart or stay current**: `cook seed` drops sample recipes into a folder, and `cook update` keeps everything fresh.
- **Share or show off**: Spin up `cook server` for a browsable collection, and `cook report` turns templated PDFs or summaries into reality.

  {{< server-carousel >}}

### Quick Commands in Action

Whether you’re scripting a workflow or just tossing cook recipes into your favorite storage location, the CLI stays lightweight but surprisingly powerful.

Check out some of the most important commands here:

```bash
cook seed                                 # load demo recipes
cook recipe "Neapolitan Pizza.cook"       # read a recipe
cook recipe "Pasta.cook:3"                # scale servings
cook shopping-list Monday.cook Tuesday.cook:2
cook pantry depleted                      # see what’s running low
cook pantry recipes                       # find dishes you can make now
cook search chicken                       # hunt by ingredient
cook server                               # browse in your browser
```

### Advanced Workflow Automation

Cooklang provides automation tools that can streamline your recipe management. Explore the [full CLI documentation](/cli/commands/) for more ideas. There's also a community alternative [cooklang-chef](https://github.com/Zheoni/cooklang-chef).

## What's Next?

- Dive into the Cooklang ecosystem and experiment with writing recipes in Cooklang.
- Check out the [best practices guide](/docs/best-practices/).
- Share ideas, ask for help, or contribute to Cooklang's development.
- Open an issue in the [Cooklang GitHub repository](https://github.com/cooklang).
- Participate in voting for the next feature.
- Join us on [Reddit](https://www.reddit.com/r/cooklang/), [Discord](https://discord.gg/fUVVvUzEEK), and [Twitter](https://x.com/cooklangorg).
- Spread the word.
- Subscribe to the newsletter!

Now you're all set! Start writing, cooking, and enjoying the simplicity of Cooklang. For more details, visit the [official documentation](/docs).

