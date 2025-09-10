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

- **VS Code**: Install the [Cooklang extension](https://marketplace.visualstudio.com/items?itemName=dubadub.cook\&ssr=false#overview) from the marketplace.
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

- The [Awesome Cooklang](https://github.com/cooklang/awesome-cooklang) repository
- The [Cooklang Recipe Hub](https://cook.md) (coming soon!)
- Community language [discussions](https://github.com/cooklang/spec/discussions) and [Discord channel](https://discord.gg/fUVVvUzEEK)


### Configure `aisle.conf` for Shopping Convenience

Add `config/aisle.conf` into your recipes folder to categorize ingredients by shopping aisle, making grocery shopping more efficient.

```toml
[produce]
potatoes

[dairy]
milk
butter
```

## 4. Automate Your Workflow

Cooklang provides automation tools that can streamline your recipe management. Install the CLI and explore the [automation documentation](/cli/help/) for ideas. There's a community alternative [cooklang-chef](https://github.com/Zheoni/cooklang-chef).

## What's Next?

- Dive into the Cooklang ecosystem and experiment with writing recipes in Cooklang.
- Check out the [best practices guide](/docs/best-practices/).
- Share ideas, ask for help, or contribute to Cooklang's development.
- Open an issue in the [Cooklang GitHub repository](https://github.com/cooklang).
- Participate in voting for the next feature.
- Spread the word.
- Subscribe to the newsletter or follow on social media.

Now you're all set! Start writing, cooking, and enjoying the simplicity of Cooklang. For more details, visit the [official documentation](/docs).

