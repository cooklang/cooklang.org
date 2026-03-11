---
title: "Cooklang Mobile App: Read, Cook, and Shop from Your Phone"
date: 2026-03-11
weight: 50
summary: "A walkthrough of the Cooklang mobile app for iOS and Android — how to set up your recipe collection, cook from your phone, and generate shopping lists on the go."
---

Your recipes live on your computer. You cook in your kitchen. These are different rooms.

The Cooklang mobile app bridges that gap. It reads your `.cook` files, displays them cleanly on your phone, and generates shopping lists you can check off at the store. It's free on both iOS and Android.

Here's how it works.

## Setup

### iOS

The iOS app syncs through iCloud Drive.

1. Create a folder in iCloud Drive — call it `Recipes` or whatever you like.
2. Put your `.cook` files in that folder. Subfolders work too.
3. Open the Cooklang app and point it at the folder.

Your recipes appear immediately. Edit a file on your Mac, and it shows up on your phone within seconds.

If you want photos, add an image file with the same name as the recipe — `carbonara.cook` and `carbonara.jpg` in the same folder. The app picks it up automatically.

[Download on the App Store](https://apps.apple.com/us/app/cooklangapp/id1598799259#?platform=iphone).

### Android

The Android app works with any folder on your device.

1. Create a folder for your recipes.
2. Copy your `.cook` files into it — use subfolders to organize by category.
3. Open the app and select the folder.

For syncing between your computer and phone, install the [Desktop Sync app](https://cook.md/download) on your computer. It keeps your recipe folder in sync across devices.

[Download on Google Play](https://play.google.com/store/apps/details?id=md.cook.android).

## Cooking Mode

Open any recipe and you get a clean reading view — ingredients listed at the top, steps below, no ads, no pop-ups, no scrolling past someone's life story.

Ingredients are highlighted in the step text so you can see at a glance what goes in next. Timers are tappable — tap a time like "simmer for 20 minutes" and the app starts a countdown.

This is the advantage of structured recipes. Because the app knows which text is an ingredient, which is a timer, and which is a step, it can present each one appropriately instead of dumping everything as undifferentiated text.

## Shopping Lists

This is where the app earns its keep.

Select the recipes you plan to cook this week. The app generates a combined shopping list with ingredients grouped by department — produce, dairy, meat, pantry. Duplicate ingredients are merged: if two recipes need olive oil, you see one entry with the total amount.

Check items off as you shop. Share the list with someone else if you're not the one going to the store.

Compare this to the alternative: opening three recipe bookmarks, scrolling past ads on each one, mentally combining the ingredients, typing them into a notes app. The app does all of that in two taps.

## Organizing Your Collection

The app mirrors your folder structure. So organizing recipes is just organizing files:

```
Recipes/
├── Weeknight/
│   ├── pasta-aglio-e-olio.cook
│   ├── stir-fry.cook
│   └── tacos.cook
├── Weekend/
│   ├── beef-bourguignon.cook
│   └── homemade-pizza.cook
└── Baking/
    ├── sourdough.cook
    └── chocolate-chip-cookies.cook
```

Want to reorganize? Move files and folders on your computer. The app reflects the change.

No proprietary categories, no tags that only exist inside one app, no "collections" that disappear when you switch platforms. Just folders.

## Photos

Add a photo to any recipe by placing an image file next to the `.cook` file with the same base name:

```
pasta-aglio-e-olio.cook
pasta-aglio-e-olio.jpg
```

The app displays the photo at the top of the recipe. Take a photo of the finished dish, drop it in the folder, done.

## Why Not Just Use a Recipe App?

Recipe apps store your recipes in their database. The Cooklang app reads your files. The difference matters:

- **Switch phones?** Your recipes are files on a cloud drive. Nothing to migrate.
- **App discontinued?** Your `.cook` files still work in any text editor, in CookCLI, in other Cooklang tools.
- **Want to edit?** Open the file in any text editor on any device. No app-specific editor with its own quirks.
- **Want to share?** Send the file. The recipient can read it as plain text even without the app.

The app is a viewer and a shopping tool. Your recipes don't live inside it — they live in your file system, where they belong.

## Getting Started

1. Write a few recipes in [Cooklang format](/docs/spec/) — it takes about two minutes per recipe
2. Put them in a synced folder (iCloud Drive, Google Drive, or use the Desktop Sync app)
3. Install the app ([iOS](https://apps.apple.com/us/app/cooklangapp/id1598799259#?platform=iphone) / [Android](https://play.google.com/store/apps/details?id=md.cook.android))
4. Cook from your phone

If you're new to Cooklang, start with the [beginner's guide](/blog/33-plain-text-recipes-beginners-guide/) to learn the format.

-Alexey
