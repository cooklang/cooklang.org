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

Check out some interesting use cases [here](https://cooklang.org/docs/use-cases/).

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

### Desktop App for Syncing Recipes (optional, only for Android)

<!-- TODO: iOS -->

The **Cook Desktop App** is an agent for syncing your recipes across devices.

Download the desktop app from the [official website](https://cook.md/download).

![Cook Desktop Screen](/guide/desktop-app-demo.png)

It will ask you to select folder where you store recipes and sign in/sign up.

## 2. Setting Up on Mobile

Getting started on mobile is simple:

- Download the **Cooklang App** from the [Google Play Store](https://play.google.com/store/apps/details?id=md.cook.android) or [Apple App Store](https://apps.apple.com/us/app/cooklangapp/id1598799259#?platform=iphone).
- Open the app, and sign in if you're using a sync service on Android or it will use iCloud on iOS. If you're using iOS app it will create a folder in iCloud drive called `CooklangApp` where it expects to see recipes. In the future version we will add support for **Cook Desktop App** as well and then you can use any folder on your computer.
- Access your saved recipes, and generate shopping lists on the go.

## 3. Growing Your Recipe Collection

Once you're set up, it's time to expand your collection:

### Build Your Recipe Collection

Start writing your own recipes or importing from existing sources. The best practice is to keep recipes organized by folders (e.g., `breakfast/`, `dinner/`, `desserts/`). You can use multiple nested folders if you have many recipes.

If you want to save a random recipe from a webpage in Cooklang format, simply add `cook.md/` before the full URL in your browser's address bar (e.g., `https://cook.md/https://bbcgoodfood.com/recipes/easy-pancakes/`).

![Cook.md Demo](/guide/cookmd-demo.gif)

### Use the playground to test syntax interactively

If you have some problems and your recipe doesn't render as you want, you can checkout [Playground](https://cooklang.github.io/cooklang-rs/?mode=render).

![Cooklang Parser Playground](/guide/playground-demo.png)

### Be part of the community

Find curated Cooklang recipes from the community, share your thoughts or ask for help. Some resources include:

- The [Awesome Cooklang](https://github.com/cooklang/awesome-cooklang-recipes) repository
- The [Cooklang Recipe Hub](https://cook.md) (coming soon!)
- Community language [discussions](https://github.com/cooklang/spec/discussions) and [Discord channel](https://discord.gg/fUVVvUzEEK)


### Configure `aisle.conf` for Shopping Convenience

Add `config/aisle.conf` into your recipes folder to categorize ingredients by shopping aisle, making grocery shopping more efficient.

This is best used if you are interested in using Cooklang to assist with your shopping lists. Learn more about this very practical use-case [here](https://cooklang.org/docs/use-cases/shopping/).

```toml
[produce]
potatoes

[dairy]
milk
butter
```

## 4. Command-Line Interface (CookCLI)

CookCLI is a powerful command-line tool that brings automation and advanced functionality to your recipe workflow. It follows UNIX philosophy - each command does one thing well and can be combined with other tools.

### Installation

**Download Pre-built Binaries (Recommended):**

Download the latest release for your platform from [GitHub Releases](https://github.com/cooklang/cookcli/releases/latest):

```bash
# macOS (Apple Silicon)
wget https://github.com/cooklang/cookcli/releases/latest/download/cook-aarch64-apple-darwin.tar.gz
tar -xzf cook-aarch64-apple-darwin.tar.gz
sudo mv cook /usr/local/bin/

# macOS (Intel)
wget https://github.com/cooklang/cookcli/releases/latest/download/cook-x86_64-apple-darwin.tar.gz
tar -xzf cook-x86_64-apple-darwin.tar.gz
sudo mv cook /usr/local/bin/

# Linux (x86_64)
wget https://github.com/cooklang/cookcli/releases/latest/download/cook-x86_64-unknown-linux-gnu.tar.gz
tar -xzf cook-x86_64-unknown-linux-gnu.tar.gz
sudo mv cook /usr/local/bin/

# Windows (x86_64)
# Download cook-x86_64-pc-windows-msvc.zip from releases page
# Extract and add to PATH
```

**macOS (Homebrew):**
```bash
brew install cookcli
```

**Build from Source:**
```bash
git clone https://github.com/cooklang/cookcli.git
cd cookcli
cargo build --release
sudo cp target/release/cook /usr/local/bin/
```

### Core Commands

CookCLI provides a comprehensive set of commands for managing your recipes:

#### **Recipe Management**
- `cook recipe` - Parse and display recipe files in various formats (human-readable, JSON, YAML)
- `cook doctor` - Validate recipes and check for syntax errors
- `cook search` - Search through recipes by ingredient or text
- `cook import` - Import recipes from websites and convert to Cooklang

#### **Meal Planning & Shopping**
- `cook shopping-list` - Generate shopping lists from multiple recipes with scaling support
- `cook pantry` - Track your pantry inventory, find what's low on stock or expiring
  - `pantry depleted` - Show items that need restocking
  - `pantry expiring` - Find items expiring soon
  - `pantry recipes` - Discover what you can cook with available ingredients

#### **Visualization & Sharing**
- `cook server` - Launch a web server to browse your recipe collection visually
- `cook report` - Generate custom reports using templates (PDFs, summaries, meal plans)

{{< server-carousel >}}

#### **Getting Started**
- `cook seed` - Initialize a directory with example recipes
- `cook update` - Update CookCLI to the latest version

### Quick Examples

```bash
# Start with sample recipes
cook seed

# View a recipe
cook recipe "Neapolitan Pizza.cook"

# Scale a recipe to serve 6
cook recipe "Pasta.cook:3"

# Create a shopping list for the week
cook shopping-list "Monday Dinner.cook" "Tuesday Lunch.cook:2"

# Check what's low in your pantry
cook pantry depleted

# Find recipes you can make right now
cook pantry recipes

# Search for all chicken recipes
cook search chicken

# Start the web interface
cook server
```

### Integration with UNIX Tools

CookCLI outputs can be piped and processed with standard tools:

```bash
# Export recipe to JSON for processing
cook recipe "Pizza.cook" -f json | jq '.ingredients'

# Find top 5 most used ingredients
cook search --all | grep "@" | sort | uniq -c | sort -rn | head -5

# Create shopping list for all pasta recipes
cook shopping-list $(ls *Pasta*.cook)
```

### Advanced Workflow Automation

Cooklang provides automation tools that can streamline your recipe management. Explore the [full CLI documentation](/cli/commands/) for more ideas. There's also a community alternative [cooklang-chef](https://github.com/Zheoni/cooklang-chef).

## What's Next?

- Dive into the Cooklang ecosystem and experiment with writing recipes in Cooklang.
- Check out the [best practices guide](/docs/best-practices/).
- Share ideas, ask for help, or contribute to Cooklang's development.
- Open an issue in the [Cooklang GitHub repository](https://github.com/cooklang).
- Participate in voting for the next feature.
- Spread the word.
- Subscribe to the newsletter or follow on social media.

Now you're all set! Start writing, cooking, and enjoying the simplicity of Cooklang. For more details, visit the [official documentation](/docs).

