---
title: "How to Save Recipes from Social Media and Keep Them Forever"
date: 2026-02-25
weight: 60
summary: "Recipes you save on Instagram, TikTok, and Facebook disappear when creators delete posts or platforms change. Here's a workflow to capture social media recipes and store them permanently as plain text files you control."
---

You find a recipe on Instagram Reels. You save it. A month later you go looking for it and the post is gone — the creator deleted it, the account went private, or the platform's algorithm just won't surface it again.

This happens constantly. Social media platforms are designed for discovery, not storage. Your saved posts are not a recipe collection. They're bookmarks to someone else's content that can disappear at any time.

Here's how to fix that.

## The Problem

Recipes on social media are ephemeral by design:

- **Posts get deleted.** Creators remove content, rebrand, or switch platforms.
- **Accounts go private or get banned.** Your saved post becomes inaccessible.
- **Algorithms bury old saves.** Finding a recipe you saved six months ago in your Instagram saves folder is an exercise in scrolling.
- **No search.** You can't search your saved posts by ingredient. You have to remember what the video thumbnail looked like.
- **No structure.** A recipe in a video caption isn't a recipe — it's a paragraph of text with no quantities, no steps, and no consistency.
- **Platform lock-in.** Saved posts on Instagram can't be accessed from TikTok or a different app. Your recipes are scattered across platforms.

## The Workflow

The goal is simple: get the recipe out of the platform and into a file you control.

### Step 1: Capture the Recipe

When you find a recipe on social media, extract the actual recipe text. You have a few options:

**From video captions:** Copy the caption text directly. Most recipe videos include an ingredient list and brief instructions in the caption or comments.

**From video content:** If the recipe is only shown in the video (no written version), watch it and write down the ingredients and steps. This takes 5–10 minutes but gives you a recipe you actually understand.

**Using CookCLI import:** If the recipe is also on a website (many creators link to their blog), use [CookCLI](/cli/) to import it:

```bash
cook import "https://example.com/the-recipe"
```

This downloads the recipe and converts it to Cooklang format automatically.

### Step 2: Write It in Cooklang

Convert the recipe into a [Cooklang](/docs/spec/) file — a plain text format where ingredients, cookware, and timers are annotated inline:

```cooklang
>> source: https://www.instagram.com/p/example123/
>> author: @chefhandle
>> tags: quick, weeknight, chicken

Season @chicken thighs{4} with @salt{1%tsp} and @paprika{1%tsp}.

Heat @olive oil{2%tbsp} in a #cast iron skillet{} over medium-high heat.

Sear chicken for ~{5%minutes} per side until golden brown.

Add @garlic{3%cloves}, minced, and @cherry tomatoes{200%g}. Cook for ~{3%minutes}.

Deglaze with @chicken broth{120%ml} and simmer until the sauce thickens, about ~{5%minutes}.
```

Save it as `chicken-thighs-cherry-tomatoes.cook` in your recipe folder.

### Step 3: Organize and Sync

Keep your `.cook` files in a folder structure that makes sense to you:

```
Recipes/
├── Social Media Finds/
│   ├── chicken-thighs-cherry-tomatoes.cook
│   ├── one-pot-pasta.cook
│   └── 15-minute-salmon.cook
├── Family Recipes/
├── Weeknight/
└── Meal Prep/
```

Sync the folder with whatever you already use — iCloud, Dropbox, Google Drive, or Git. If you use Git, you get version history: you can see how your recipe evolved as you adjusted it.

### Step 4: Use Your Collection

Once recipes are in Cooklang format, you can:

- **Search by ingredient:** `cook search --ingredients "chicken"` finds every recipe that uses chicken.
- **Generate shopping lists:** `cook shopping-list recipe1.cook recipe2.cook` combines ingredients from multiple recipes.
- **Browse from your phone:** `cook server ~/Recipes --host` starts a web server accessible from any device on your network.
- **Scale recipes:** The server UI lets you adjust serving sizes and ingredient quantities update automatically.
- **Edit in Obsidian:** The [Cooklang Obsidian plugin](/blog/how-to-manage-recipes-in-obsidian-with-cooklang/) adds syntax highlighting, preview mode, and interactive timers.

## Why Plain Text Wins for Recipe Storage

Social media platforms will come and go. File formats tied to specific apps will become obsolete. Plain text files will be readable forever — on any device, with any editor, decades from now.

By converting recipes to Cooklang format, you get:

- **Permanence.** Text files don't depend on any service.
- **Searchability.** Grep, file search, or CookCLI's search command.
- **Portability.** Copy the folder to any device.
- **No lock-in.** Switch tools anytime. The recipes are yours.

The investment is 5–10 minutes per recipe to write it down properly. In return, you never lose a recipe to a deleted post again.

[Get started with Cooklang →](/docs/getting-started/)

-Alex
