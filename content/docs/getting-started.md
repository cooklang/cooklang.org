---
title: "Getting Started"
date: 2026-07-23
draft: false
weight: 1
summary: All you need to get started with Cooklang
---

Ready to level up your cooking with an ecosystem of technologies designed to make it easy to build and maintain a world-class personal recipe book? You've come to the right place.

Cooklang is a lightweight, open-source, [Markdown](https://en.wikipedia.org/wiki/Markdown/)-based text format for writing and managing recipes.

The Cook app is a free mobile app for iOS and Android devices that presents your Cooklang-formatted recipes for you while you cook.

Ready to get started? Install the app, _tout de suite_!

_an example recipe snippet in cooklang_

```cooklang
Crack the @eggs{3} into a #blender, then add the @plain flour{125%g},
@milk{250%ml} and @sea salt{1%pinch}, and blitz until smooth.
```

# 1. Install the Cook App

Download the **Cooklang App** from the [Google Play Store](https://play.google.com/store/apps/details?id=md.cook.android) or [Apple App Store](https://apps.apple.com/us/app/cooklangapp/id1598799259#?platform=iphone).

![Android Screens](/guide/app-screens-demo.jpg)

When you open the app for the first time, we'll walk you through the setup process, get your preferences (like imperial vs. metric units), and find you some starter recipes to experiment with.

# 2. Get More Recipes

If you're ready to add more recipes, we've got a few ways you can easily add more Cooklang recipes to your collection, often without writing any Cooklang!

## Kickstart Wizard

If you'd like some more personalized recipes, check out our [Kickstart](https://cook.md/kickstart) wizard. It will ask you questions about your dietary and cullinary preferences, and then send you a pack of 50 recipes. It takes about 5 minutes.

## Import and Convert Tool

You can convert any recipe from the web into Cooklang by simply adding `cook.md/` before the URL. For example: `https://cook.md/https://bbcgoodfood.com/recipes/easy-pancakes/`

![Cook.md Demo](/guide/cookmd-demo.gif)

## Browse Community Recipebooks

Cooklang hosts an index of community recipebooks at [recipes.cooklang.org](https://recipes.cooklang.org/browse).

# 3. Sync Your Recipes Across Devices

Because all your recipes are plain text files stored on your device(s), you can easily sync those recipes between your phone, laptop, and/or desktop.

// If you'd like to use someone else's computer _and_ you want to support the project, **Cook Cloud** is a built-in subscription sync service that works across macOS, Windows, Linux, iOS, and Android.

# 4. Modify Recipes in the Desktop Editor

The best recipes are those that have been tried, tested, revised, and tried again for a long time. When you want to change a recipe in Cooklang, you can use any application that edits text files...

Or you can use the [Desktop Editor](https://cook.md/editor) built for exactly that purpose! Just make sure you keep the [Cooklang specification](/docs/spec/) nearby.

If you'd rather use your existing editor, we've got a few options:

- **VS Code** (Recommended): Install the [Cooklang extension](https://marketplace.visualstudio.com/items?itemName=dubadub.cook&ssr=false#overview) from the marketplace.
  ![VSCode autocomplete with CookCLI](/guide/vscode.png)
- **Vim/Neovim**: Add a [Cooklang syntax file](https://github.com/luizribeiro/vim-cooklang) for highlighting.
- **Sublime Text**: Use a [Cooklang syntax package](https://packagecontrol.io/packages/CookLang).
- **More options**: See [syntax highlighting documentation](/docs/syntax-highlighting/).
- **Obsidian Plugin** See [Cooklang Editor](https://github.com/cooklang/cooklang-obsidian)

# 5. Join the Community

Find curated recipes, share your thoughts, or ask for help:

- The [Cooklang Recipe Hub](https://recipes.cooklang.org)
- The [Awesome Cooklang](https://github.com/cooklang/awesome-cooklang-recipes) repository
- Community [discussions](https://github.com/cooklang/spec/discussions) and [Discord](https://discord.gg/fUVVvUzEEK)
