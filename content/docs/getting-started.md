---
title: 'Getting Started'
date: 2022-02-15T19:30:08+10:00
draft: false
weight: 1
summary: All you need to get started with Cooklang
---

## Table of Contents
- [How It Works](#how-it-works)
  - [A Simple Example](#a-simple-example)
- [Setting Up on Desktop](#setting-up-on-desktop)
  - [Syntax Highlighting](#1-syntax-highlighting)
  - [CookCLI (Command-Line Interface)](#2-cookcli-command-line-interface)
    - [Installation](#installation)
    - [Usage](#usage)
  - [Desktop App for Syncing Recipes](#3-desktop-app-for-syncing-recipes)
- [Setting Up on Mobile](#setting-up-on-mobile)
- [Growing Your Recipe Collection](#growing-your-recipe-collection)
  - [Build Your Recipe Collection](#1-build-your-recipe-collection)
  - [Discover Awesome Cooklang Recipes](#2-discover-awesome-cooklang-recipes)
  - [Use `cook.md` for Notes](#3-use-cookmd-for-notes)
  - [Configure `aisle.conf` for Shopping Convenience](#4-configure-aisleconf-for-shopping-convenience)
- [Automate Your Workflow](#automate-your-workflow)
- [What's Next?](#whats-next)

Cooklang is a lightweight, open-source format for writing and managing recipes in a structured, human-readable way. Your recipes are just text files, meaning you can store, edit, and sync them across all your devices without being locked into a specific app or service.

## How It Works

Cooklang recipes are plain text files that you can use on any device. You can write and manage them on a desktop, then access them on your phone when cooking. This flexibility makes it easy to grow your recipe collection over time. Recipes are stored in `.cook` files, and Cooklang tools help process these files for various use cases such as meal planning, shopping lists, and sharing.

### A Simple Example

Here's what a basic recipe looks like in Cooklang:
```cooklang
@flour{200%g}
@milk{300%ml}
@egg{2}
Mix everything and cook on a pan.
```
When processed using CookCLI, this recipe will extract ingredients while keeping the instructions readable.

## Setting Up on Desktop
To get the best experience with Cooklang on desktop, consider setting up:

### 1. Syntax Highlighting

If you prefer writing recipes in a text editor, enabling syntax highlighting for Cooklang makes editing easier. Many editors support custom syntax highlighting:
- **VS Code**: Install the [Cooklang extension](https://marketplace.visualstudio.com/items?itemName=Cooklang.cooklang) from the marketplace.
- **Vim/Neovim**: Add a [Cooklang syntax file](https://github.com/cooklang/cook.vim) for highlighting.
- **Sublime Text**: Use a [Cooklang syntax package](https://github.com/cooklang/sublime-cooklang).
- **More options**: See [syntax highlighting documentation](https://cooklang.org/docs/syntax-highlighting/).

### 2. CookCLI (Command-Line Interface)
The CookCLI allows you to parse, convert, and interact with your Cooklang recipes from the terminal.

#### Installation
```sh
# Install via Homebrew
brew install cooklang/cook/cook

# Or install via Cargo
cargo install cook-cli
```
More details on installation can be found in the [CookCLI documentation](https://docs.cooklang.org/tools/cook-cli/).

#### Usage
Run a simple test to parse a recipe:
```sh
cook parse my-recipe.cook
```
This command will extract ingredients and display a structured output.

For more automation options, check out the [CLI help page](https://cooklang.org/cli/help/).

### 3. Desktop App for Syncing Recipes
The **Cooklang Desktop App** provides a graphical interface for managing and syncing your recipes across devices. Features include:
- **Recipe organization**: Categorize and tag recipes.
- **Cloud sync**: Automatically sync recipes between desktop and mobile.
- **Shopping list generation**: Convert recipes into shopping lists.

Download the desktop app from the [official website](https://cooklang.org/download/).

## Setting Up on Mobile

Getting started on mobile is simple:
- Download the **Cooklang App** from the [Google Play Store](https://play.google.com/store/apps/details?id=org.cooklang.app) or [Apple App Store](https://apps.apple.com/app/cooklang/id1597589817).
- Open the app, and sign in if you're using a sync service.
- Access your saved recipes, add new ones, and generate shopping lists on the go.

## Growing Your Recipe Collection
Once you're set up, it's time to expand your collection:

### 1. Build Your Recipe Collection
Start writing your own recipes or importing from existing sources. The best practice is to keep recipes organized by folders (e.g., `breakfast/`, `dinner/`, `desserts/`).

Explore the [Cooklang syntax guide](https://cooklang.org/docs/spec/) to learn how to structure your recipes effectively.

### 2. Discover Awesome Cooklang Recipes
Find curated Cooklang recipes from the community. Some resources include:
- The **[Awesome Cooklang](https://github.com/cooklang/awesome-cooklang)** repository
- The **[Cooklang Community Recipe Hub](https://github.com/cooklang/recipes)**
- Community [forums](https://community.cooklang.org) and [Discord channel](https://discord.com/invite/cooklang)

### 3. Use `cook.md` for Notes
A `cook.md` file can be used for general cooking notes, techniques, or reference material. Example:
```md
# Cooking Notes
- Sear meat before slow cooking for better flavor.
- Store fresh herbs in a damp paper towel.
```
If you want to save a random recipe from a webpage in Cooklang format, simply add `cook.md/` before the full URL in your browser's address bar (e.g., `https://cook.md/https://bbcgoodfood.com/`).

### 4. Configure `aisle.conf` for Shopping Convenience
Set up `aisle.conf` to categorize ingredients by shopping aisle, making grocery shopping more efficient. Example configuration:
```conf
Dairy: milk, cheese, butter
grains: flour, rice, pasta
```
More on configuring `aisle.conf` can be found [here](https://docs.cooklang.org/tools/cook-cli/shopping-lists/).

## Automate Your Workflow
Cooklang provides automation tools that can streamline your recipe management. Install the CLI and explore the [automation documentation](https://cooklang.org/cli/help/) for ideas.

## What's Next?
- **Add your own recipes**: Dive into the Cooklang ecosystem and experiment with writing recipes in Cooklang. Use the [Playground](https://cooklang.github.io/cooklang-rs/?mode=render) to test syntax interactively.
- **Learn tips and tricks**: Check out the [best practices guide](https://cooklang.org/docs/best-practices/).
- **Join the community**: Share ideas, ask for help, or contribute to Cooklang's development in the [GitHub discussions](https://github.com/cooklang/cooklang-app-android/discussions) or via [email](mailto:hello@cooklang.org).
- **Report bugs or suggest features**: Open an issue in the [Cooklang GitHub repository](https://github.com/cooklang/cooklang-app-android).

---
Now you're all set! Start writing, cooking, and enjoying the simplicity of Cooklang. For more details, visit the [official documentation](https://cooklang.org).

