---
title: "Plain Text Recipes: A Beginner's Guide to the Cooklang Format"
date: 2026-03-11
weight: 50
summary: "A step-by-step introduction to writing recipes in Cooklang — the plain text format that turns your recipes into structured data. Convert your first recipe in five minutes."
---

You have recipes everywhere. Screenshots on your phone. Bookmarks you'll never revisit. A notes app with 40 entries and no organization. Maybe a recipe app that stopped syncing last year.

Here's a different approach: write recipes as plain text files. Not in a database. Not in someone else's app. Just text files on your computer, phone, or wherever you keep files.

This guide shows you how.

## What a Plain Text Recipe Looks Like

A Cooklang recipe is a `.cook` file that reads like a normal recipe but with a few annotations that make it machine-readable:

```cooklang
---
servings: 2
---

Bring a #pot of @water{2%L} to a boil with @salt{1%tsp}.

Cook @spaghetti{200%g} for ~{10%minutes} until al dente. Reserve @pasta water{1/2%cup} before draining.

Meanwhile, heat @olive oil{2%tbsp} in a #pan over medium heat. Add @garlic{3%cloves}, thinly sliced, and cook until golden.

Toss the drained pasta with the garlic oil and reserved pasta water. Finish with @parmesan{30%g}, freshly grated.
```

That's it. You can read it like a recipe. But a computer can also parse it — extracting ingredients, generating a shopping list, scaling quantities, running timers.

## The Three Annotations

Cooklang uses three symbols to mark up recipe text:

**`@` for ingredients.** Anything after `@` is an ingredient. Put the quantity and unit in curly braces:

```cooklang
@chicken breast{500%g}
@salt{1%tsp}
@olive oil{2%tbsp}
@garlic{3%cloves}
```

The `%` separates the quantity from the unit. `500%g` means 500 grams. `3%cloves` means 3 cloves.

If an ingredient has no quantity — say, "salt to taste" — just write `@salt{}` or `@salt`.

**`#` for cookware.** Mark pots, pans, and tools the same way:

```cooklang
#pot
#frying pan{}
#oven
```

**`~` for timers.** Mark durations so tools can run countdown timers:

```cooklang
~{10%minutes}
~{30%seconds}
~{1%hour}
```

That's the entire syntax. Three symbols.

## Convert Your First Recipe

Take any recipe you have. Here's a typical one from a website:

> **Simple Tomato Soup** (Serves 4)
>
> Heat 2 tablespoons olive oil in a large pot. Add 1 diced onion and 3 cloves garlic, cook 5 minutes until soft. Add two 400g cans crushed tomatoes, 1 cup vegetable broth, 1 teaspoon sugar, salt and pepper to taste. Simmer 20 minutes. Blend until smooth.

Now convert it to Cooklang:

```cooklang
---
servings: 4
---

Heat @olive oil{2%tbsp} in a large #pot. Add @onion{1}, diced, and @garlic{3%cloves}, cook ~{5%minutes} until soft.

Add @crushed tomatoes{800%g} (two cans), @vegetable broth{1%cup}, @sugar{1%tsp}, @salt{} and @pepper{} to taste.

Simmer ~{20%minutes}. Blend with an #immersion blender until smooth.
```

It took about two minutes. The recipe still reads naturally, but now software can extract a shopping list, scale it to 8 servings, or run a 20-minute timer for you.

## What You Can Do With It

Once a recipe is a `.cook` file, tools can work with it:

**Generate a shopping list** from one recipe or a whole week of dinners:

```bash
cook shopping-list "Tomato Soup" "Pasta Aglio e Olio" "Roast Chicken"
```

**Scale servings** — double, halve, or set any number:

```bash
cook recipe "Tomato Soup" --servings 8
```

**Serve your recipes** on your local network for kitchen use:

```bash
cook server --open
```

**Search your collection:**

```bash
cook search "tomato"
```

All of these come from [CookCLI](/cli/), a free command-line tool.

## How to Organize Your Files

Cooklang recipes are just files, so organize them however you want. Most people use folders:

```
recipes/
├── breakfasts/
│   ├── pancakes.cook
│   └── scrambled-eggs.cook
├── mains/
│   ├── pasta-aglio-e-olio.cook
│   ├── roast-chicken.cook
│   └── tomato-soup.cook
├── sides/
│   └── garlic-bread.cook
└── desserts/
    └── chocolate-mousse.cook
```

Add a photo? Put it next to the recipe with the same name:

```
mains/
├── roast-chicken.cook
└── roast-chicken.jpg
```

Cooklang tools will pick it up automatically.

## Metadata

Add recipe metadata — servings, prep time, tags, source — in YAML frontmatter at the top of the file:

```cooklang
---
servings: 4
prep_time: 10 minutes
cook_time: 30 minutes
source: https://example.com/recipe
tags: [italian, vegetarian, quick]
---
```

This metadata is used by tools for filtering, scaling, and display.

## Sections

Use `==` to break a recipe into named sections — useful for recipes with distinct parts like a sauce and a base:

```cooklang
== Dough ==

Mix @flour{500%g} and @water{300%ml} in a #bowl. Knead ~{10%minutes}.

== Sauce ==

Simmer @crushed tomatoes{400%g} with @basil{5%leaves} for ~{20%minutes}.

== Assembly ==

Roll out the dough, spread sauce, add @mozzarella{200%g}. Bake in the #oven at 250°C for ~{8%minutes}.
```

## Sync and Edit Anywhere

Since recipes are files, sync them however you sync files:

- **iCloud Drive** — works with the [iOS app](/app/)
- **Google Drive or Dropbox** — any sync service works
- **Git** — version control your cookbook, see what changed, collaborate with others

Edit with any text editor. There are syntax highlighting plugins for [VS Code](https://marketplace.visualstudio.com/items?itemName=nicholasglazer.cooklang-support), [Obsidian](/blog/15-cooklang-obsidian-guide/), and [others](/docs/syntax-highlighting/).

## Next Steps

- [Try Cooklang in the browser](/blog/30-cooklang-playground-walkthrough/) — no install needed
- [Install CookCLI](/cli/download/) — the command-line tool
- [Get the mobile app](/app/) — cook and shop from your phone
- [Language specification](/docs/spec/) — the full syntax reference

Start with one recipe. The one you make most often. Convert it, save it as a `.cook` file, and see if you like working this way. Most people convert their whole collection within a week.

-Alexey
